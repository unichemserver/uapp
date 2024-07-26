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
                  content: const Text('Terjadi kesalahan, silahkan coba lagi'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
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
                controller.runJavaScript(
                  'document.querySelector("meta[name=\'viewport\']").setAttribute("content", "width=device-width, initial-scale=1")',
                ).then((value) {
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
            onPressed: () {
              controller.reload();
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
