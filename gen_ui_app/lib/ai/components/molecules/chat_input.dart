import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../models/message.dart';
import '../../providers/llm_provider_interface.dart';
import '../../style.dart';
import 'attachment_view.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    required this.submitting,
    required this.onSubmit,
    required this.onCancel,
    this.initialMessage,
    super.key,
  });

  final bool submitting;

  final UserMessage? initialMessage;

  final void Function(String, {required Iterable<Attachment> attachments})
      onSubmit;

  final void Function() onCancel;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

enum _InputState { disabled, enabled, submitting }

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _attachments = <Attachment>[];
  final _isMobile = UniversalPlatform.isAndroid || UniversalPlatform.isIOS;

  @override
  void didUpdateWidget(covariant ChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMessage != null) {
      _controller.text = widget.initialMessage!.prompt;
      _attachments.addAll(widget.initialMessage!.attachments);
    }
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            height: _attachments.isNotEmpty ? 104 : 0,
            padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12),
            child: _attachments.isNotEmpty
                ? ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final a in _attachments)
                        _RemoveableAttachment(
                          attachment: a,
                          onRemove: _onRemoveAttachment,
                        ),
                    ],
                  )
                : const SizedBox(),
          ),
          const Gap(6),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) => Row(
              children: [
                _AttachmentActionBar(onAttachment: _onAttachment),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      enabled: _inputState != _InputState.submitting,
                      minLines: 1,
                      maxLines: 1024,
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      textInputAction: _isMobile
                          ? TextInputAction.newline
                          : TextInputAction.done,
                      onSubmitted: (value) => _onSubmit(value),
                      style: chatTheme.textStyle.copyWith(
                        color: chatTheme.onAccentColor,
                      ),
                      decoration: InputDecoration(
                        hintText: "Ask me anything...",
                        hintStyle: chatTheme.textStyle.copyWith(
                          color: chatTheme.onAccentColor,
                        ),
                        filled: true,
                        fillColor: chatTheme.accentColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _SubmitButton(
                          text: _controller.text,
                          inputState: _inputState,
                          onSubmit: _onSubmit,
                          onCancel: _onCancel,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  _InputState get _inputState {
    if (widget.submitting) return _InputState.submitting;
    if (_controller.text.isNotEmpty) return _InputState.enabled;
    assert(!widget.submitting && _controller.text.isEmpty);
    return _InputState.disabled;
  }

  void _onSubmit(String prompt) {
    // the mobile vkb can still cause a submission even if there is no text
    if (_controller.text.isEmpty) return;

    assert(_inputState == _InputState.enabled);
    widget.onSubmit(prompt, attachments: List.from(_attachments));
    _attachments.clear();
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _onCancel() {
    assert(_inputState == _InputState.submitting);
    widget.onCancel();
    _controller.clear();
    _attachments.clear();
    _focusNode.requestFocus();
  }

  void _onAttachment(Attachment attachment) =>
      setState(() => _attachments.add(attachment));

  _onRemoveAttachment(Attachment attachment) =>
      setState(() => _attachments.remove(attachment));
}

class _AttachmentActionBar extends StatefulWidget {
  const _AttachmentActionBar({required this.onAttachment});
  final Function(Attachment attachment) onAttachment;

  @override
  State<_AttachmentActionBar> createState() => _AttachmentActionBarState();
}

class _AttachmentActionBarState extends State<_AttachmentActionBar> {
  var _expanded = false;
  late final bool _canCamera;
  late final bool _canFile;

  @override
  void initState() {
    super.initState();
    _canCamera = ImagePicker().supportsImageSource(ImageSource.camera);

    // _canFile is a work around for this bug:
    // https://github.com/csells/flutter_ai_toolkit/issues/18
    _canFile = !kIsWeb;
  }

  @override
  Widget build(BuildContext context) => _expanded
      ? Row(children: [
          IconButton(
            onPressed: _onToggleMenu,
            icon: const Icon(Icons.close),
          ),
          if (_canCamera)
            IconButton(
              onPressed: _onCamera,
              icon: const Icon(Icons.camera_alt),
            ),
          IconButton(
            onPressed: _onGallery,
            icon: const Icon(Icons.image),
          ),
          if (_canFile)
            IconButton(
              onPressed: _onFile,
              icon: const Icon(Icons.attach_file),
            ),
        ])
      : IconButton(
          onPressed: _onToggleMenu,
          icon: const Icon(Icons.add),
        );

  void _onToggleMenu() => setState(() => _expanded = !_expanded);
  void _onCamera() => _pickImage(ImageSource.camera);
  void _onGallery() => _pickImage(ImageSource.gallery);

  void _pickImage(ImageSource source) async {
    _onToggleMenu(); // close the menu

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

  void _onFile() async {
    _onToggleMenu(); // close the menu

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
    final isSubmitting = inputState == _InputState.submitting;
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
                  _InputState.submitting => SizedBox(
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
