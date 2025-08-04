import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebView extends StatelessWidget {
  const ArticleWebView({super.key, required this.articleUrl});

  final String articleUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 84, 34),
        foregroundColor: Colors.white,
        toolbarHeight: 65,
        title: const Text(
          'News App',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Opacity(
              opacity: 0,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Icon(Icons.save)))
        ],
        elevation: 0.0,
      ),
      body: WebView(
        initialUrl: articleUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
