import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../controllers/chat_controller.dart';
import '../../helpers/hooks.dart';
import '../../providers/ai_provider_interface.dart';
import '../../style.dart';
import 'attachment_view.dart';

enum _InputState {
  disabled,
  enabled,
  sending;

  bool get isSending => this == sending;
  bool get isEnabled => this == enabled;
  bool get isDisabled => this == disabled;
}

class ChatInput extends HookWidget {
  const ChatInput({
    required ChatController controller,
    super.key,
  }) : _controller = controller;

  final ChatController _controller;

  @override
  Widget build(BuildContext context) {
    final controller = useListenable(_controller);
    final focusNode = useFocusNode();
    final attachments = useState(<Attachment>[]);

    useEffect(() {
      if (!controller.isProcessing) {
        focusNode.requestFocus();
      }
    }, [controller.isProcessing]);

    final isMobile = UniversalPlatform.isAndroid || UniversalPlatform.isIOS;

    final inputState = useMemoized(
      () {
        final editingController = controller.editingController;
        if (controller.isProcessing) return _InputState.sending;
        if (editingController.text.isNotEmpty) return _InputState.enabled;
        assert(!controller.isProcessing && editingController.text.isEmpty);
        return _InputState.disabled;
      },
      [controller.isProcessing],
    );

    useEffectUpdate(() {
      if (!inputState.isSending) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNode.requestFocus();
        });
      }
    }, [inputState]);

    final handleSend = useCallback((String prompt) {
      if (controller.editingController.text.isEmpty) return;

      controller.send(
        prompt,
        attachments: List.from(attachments.value),
      );
      attachments.value.clear();
      _controller.editingController.clear();

      focusNode.requestFocus();
    }, [attachments.value, inputState]);

    final handleOnCancel = useCallback(() {
      controller.cancel();

      attachments.value.clear();
      focusNode.requestFocus();
    });

    final onAttachment = useCallback(
      (Attachment attachment) => attachments.value.add(attachment),
    );

    final onRemoveAttachment = useCallback(
      (Attachment attachment) => attachments.value.remove(attachment),
    );

    final textStyle = chatTheme.textStyle.copyWith(
      color: chatTheme.onAccentColor,
      fontSize: 22,
    );

    return Column(
      children: [
        Container(
          height: attachments.value.isNotEmpty ? 104 : 0,
          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12),
          child: attachments.value.isNotEmpty
              ? ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final a in attachments.value)
                      _RemoveableAttachment(
                        attachment: a,
                        onRemove: onRemoveAttachment,
                      ),
                  ],
                )
              : const SizedBox(),
        ),
        const Gap(6),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  enabled: !inputState.isSending,
                  minLines: 1,
                  autofillHints: null,
                  maxLines: 1024,
                  controller: _controller.editingController,
                  // focusNode: focusNode,
                  textInputAction:
                      isMobile ? TextInputAction.newline : TextInputAction.done,
                  onSubmitted: (value) => handleSend(value),
                  style: textStyle,
                  decoration: InputDecoration(
                    hintText: inputState.isSending ? '' : 'What do you need?',
                    hintStyle: textStyle,
                    filled: true,
                    fillColor: chatTheme.accentColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: _SubmitButton(
                      text: _controller.editingController.text,
                      inputState: inputState,
                      onSubmit: handleSend,
                      onCancel: handleOnCancel,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AttachmentActionBar extends StatefulWidget {
  const _AttachmentActionBar({required this.onAttachment});
  final Function(Attachment attachment) onAttachment;

  @override
  State<_AttachmentActionBar> createState() => _AttachmentActionBarState();
}

class _AttachmentActionBarState extends State<_AttachmentActionBar> {
  var expanded = false;
  late final bool canCamera;
  late final bool canFile;

  @override
  void initState() {
    super.initState();
    canCamera = ImagePicker().supportsImageSource(ImageSource.camera);

    // _canFile is a work around for this bug:
    // https://github.com/csells/flutter_ai_toolkit/issues/18
    canFile = !kIsWeb;
  }

  @override
  Widget build(BuildContext context) => expanded
      ? Row(children: [
          IconButton(
            onPressed: onToggleMenu,
            icon: const Icon(Icons.close),
          ),
          if (canCamera)
            IconButton(
              onPressed: onCamera,
              icon: const Icon(Icons.camera_alt),
            ),
          IconButton(
            onPressed: onGallery,
            icon: const Icon(Icons.image),
          ),
          if (canFile)
            IconButton(
              onPressed: onFile,
              icon: const Icon(Icons.attach_file),
            ),
        ])
      : IconButton(
          onPressed: onToggleMenu,
          icon: const Icon(Icons.add),
        );

  void onToggleMenu() => setState(() => expanded = !expanded);
  void onCamera() => pickImage(ImageSource.camera);
  void onGallery() => pickImage(ImageSource.gallery);

  void pickImage(ImageSource source) async {
    onToggleMenu(); // close the menu

    final picker = ImagePicker();
    try {
      final pic = await picker.pickImage(source: source);
      if (pic == null) return;
      widget.onAttachment(await ImageAttachment.fromFile(pic));
    } on Exception catch (ex) {
      final context = this.context;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to pick an image: $ex')),
      );
    }
  }

  void onFile() async {
    onToggleMenu(); // close the menu

    try {
      final file = await openFile();
      if (file == null) return;
      widget.onAttachment(await FileAttachment.fromFile(file));
    } on Exception catch (ex) {
      final context = this.context;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to pick a file: $ex')),
      );
    }
  }
}

class _RemoveableAttachment extends StatelessWidget {
  const _RemoveableAttachment({
    required this.attachment,
    required this.onRemove,
  });

  final Attachment attachment;
  final Function(Attachment) onRemove;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 12),
            height: 80,
            child: AttachmentView(attachment),
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              size: 20,
            ),
            onPressed: () => onRemove(attachment),
          ),
        ],
      );
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.text,
    required this.inputState,
    required this.onSubmit,
    required this.onCancel,
  });

  final String text;
  final _InputState inputState;
  final void Function(String) onSubmit;
  final void Function() onCancel;

  @override
  Widget build(BuildContext context) {
    final isSubmitting = inputState == _InputState.sending;
    return AnimatedScale(
      duration: Durations.short3,
      scale: inputState == _InputState.disabled ? 0.0 : 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: chatTheme.onAccentColor,
                  shape: BoxShape.circle,
                ),
                child: switch (inputState) {
                  _InputState.sending => SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: IconButton(
                          onPressed: onCancel,
                          color: chatTheme.accentColor,
                          icon: const Icon(Icons.stop),
                        ),
                      ),
                    ),
                  _InputState.enabled => IconButton(
                      onPressed: () => onSubmit(text),
                      color: chatTheme.accentColor,
                      icon: const Icon(Icons.play_arrow),
                    ),
                  _InputState.disabled => const SizedBox(),
                }),
            SizedBox(
              height: 40,
              width: 40,
              child: isSubmitting
                  ? CircularProgressIndicator(
                      strokeWidth: 5,
                      strokeAlign: BorderSide.strokeAlignInside,
                      color: chatTheme.accentColor.withOpacity(0.3),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
