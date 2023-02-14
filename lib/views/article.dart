import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
  final String link;
  const WebViewApp({super.key, required this.link,});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.link),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // ),
      body: Container(
        color: const Color.fromARGB(255, 76, 201, 51),
        child: SafeArea(
          child: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
      floatingActionButton: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
        ],
      ),
    );
  }
}
