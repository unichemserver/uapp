import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthWebviewWidget extends StatefulWidget {
  const AuthWebviewWidget({
    super.key,
    required this.url,
    required this.title,
  });

  final String url;
  final String title;

  @override
  State<AuthWebviewWidget> createState() => _AuthWebviewWidgetState();
}

class _AuthWebviewWidgetState extends State<AuthWebviewWidget> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
