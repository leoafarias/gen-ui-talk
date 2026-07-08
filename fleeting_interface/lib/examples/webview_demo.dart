import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewDemo extends StatefulWidget {
  const WebViewDemo({super.key, required this.url});

  final String url;

  @override
  State<WebViewDemo> createState() => _WebViewDemoState();
}

class _WebViewDemoState extends State<WebViewDemo>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;

  var _progress = 0;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: _setProgress,
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _error = null;
              _progress = 0;
            });
          },
          onPageFinished: (_) => _setProgress(100),
          onWebResourceError: (error) {
            if (error.isForMainFrame == false || !mounted) return;
            setState(() {
              _error = error.description;
              _progress = 100;
            });
          },
        ),
      );

    _load();
  }

  @override
  void didUpdateWidget(WebViewDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) _load();
  }

  void _setProgress(int progress) {
    if (!mounted) return;
    setState(() {
      _progress = progress;
    });
  }

  Future<void> _load() async {
    final uri = Uri.tryParse(widget.url);
    if (uri == null || !uri.hasScheme) {
      if (!mounted) return;
      setState(() {
        _error = 'Invalid webview URL: ${widget.url}';
        _progress = 100;
      });
      return;
    }

    await _controller.loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ColoredBox(
        color: Colors.black,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: WebViewWidget(controller: _controller),
                  ),
                  if (_error case final error?)
                    Positioned.fill(child: _WebViewError(message: error)),
                  if (_progress < 100)
                    Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      child: LinearProgressIndicator(value: _progress / 100),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WebViewError extends StatelessWidget {
  const _WebViewError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
