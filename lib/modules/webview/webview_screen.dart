import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  final String url;
  final String title;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  final box = Hive.box(HiveKeys.appBox);
  final webViewKey = GlobalKey();
  int progress = 0;
  bool isError = false;
  String url = '';
  bool isMobileView = true;

  String getErrorMessage(WebResourceErrorType? errorType) {
    switch (errorType) {
      case WebResourceErrorType.authentication:
        return 'User authentication failed on server.';
      case WebResourceErrorType.badUrl:
        return 'Malformed URL.';
      case WebResourceErrorType.connect:
        return 'Failed to connect to the server.';
      case WebResourceErrorType.failedSslHandshake:
        return 'Failed to perform SSL handshake.';
      case WebResourceErrorType.file:
        return 'Generic file error.';
      case WebResourceErrorType.fileNotFound:
        return 'File not found.';
      case WebResourceErrorType.hostLookup:
        return 'Server or proxy hostname lookup failed.';
      case WebResourceErrorType.io:
        return 'Failed to read or write to the server.';
      case WebResourceErrorType.proxyAuthentication:
        return 'User authentication failed on proxy.';
      case WebResourceErrorType.redirectLoop:
        return 'Too many redirects.';
      case WebResourceErrorType.timeout:
        return 'Connection timed out.';
      case WebResourceErrorType.tooManyRequests:
        return 'Too many requests during this load.';
      case WebResourceErrorType.unknown:
        return 'Generic error.';
      case WebResourceErrorType.unsafeResource:
        return 'Resource load was canceled by Safe Browsing.';
      case WebResourceErrorType.unsupportedAuthScheme:
        return 'Unsupported authentication scheme (not basic or digest).';
      case WebResourceErrorType.unsupportedScheme:
        return 'Unsupported URI scheme.';
      case WebResourceErrorType.webContentProcessTerminated:
        return 'The web content process was terminated.';
      case WebResourceErrorType.webViewInvalidated:
        return 'The web view was invalidated.';
      case WebResourceErrorType.javaScriptExceptionOccurred:
        return 'A JavaScript exception occurred.';
      case WebResourceErrorType.javaScriptResultTypeIsUnsupported:
        return 'The result of JavaScript execution could not be returned.';
      default:
        return 'Unknown error.';
    }
  }

  void initWebController() {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    String token = userData.token;
    String urlMenu = widget.url.replaceAll('amp;', '');
    String baseUrl = box.get(HiveKeys.baseURL);
    baseUrl = baseUrl.replaceAll('api/index.php', '');
    url = '${'${baseUrl}EDS/$urlMenu'}&mobile_token=$token';
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent(
        // "Mozilla/5.0 (Linux; Android 10; Mobile; rv:68.0) Gecko/68.0 Firefox/68.0",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36"
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress;
              isError = false;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isError = true;
            });
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(
                    getErrorMessage(error.errorType),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        controller.reload();
                        Navigator.pop(context);
                      },
                      child: const Text('Reload'),
                    ),
                  ],
                );
              },
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url != url) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  void initState() {
    super.initState();
    initWebController();
  }

  @override
  void dispose() {
    webViewKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Change view to ${isMobileView ? 'desktop' : 'mobile'}',
            onPressed: () {
              if (isMobileView) {
                controller
                    .runJavaScript(
                  'document.querySelector("meta[name=\'viewport\']").setAttribute("content", "width=1024, initial-scale=0")',
                )
                    .then((value) {
                  setState(() {
                    isMobileView = false;
                  });
                });
              } else {
                controller
                    .runJavaScript(
                  'document.querySelector("meta[name=\'viewport\']").setAttribute("content", "width=device-width, initial-scale=1")',
                )
                    .then((value) {
                  setState(() {
                    isMobileView = true;
                  });
                });
              }
            },
            icon: Icon(
              isMobileView ? Icons.desktop_windows : Icons.phone_android,
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              controller.reload();
              setState(() {
                isMobileView = true;
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            isError
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.blueAccent,
                        size: 50,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Terjadi kesalahan, silahkan coba lagi',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          controller.reload();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text('Reload'),
                      ),
                    ],
                  ))
                : RefreshIndicator(
                    onRefresh: () async {
                      controller.reload();
                    },
                    child: WebViewWidget(
                      key: webViewKey,
                      controller: controller,
                    ),
                  ),
            if (progress < 100)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: Colors.white,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
