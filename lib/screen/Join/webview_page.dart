import 'package:flow_app/providers/game_code.dart';
import 'package:flow_app/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    final joinGameCodeProvider =
        Provider.of<JoinGameCodeProvider>(context, listen: false);
    final gameCode = joinGameCodeProvider.code;

    return WillPopScope(
      onWillPop: () async => true, // Allow the pop action to continue
      child: Scaffold(
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            // Check if the swipe is a left swipe
            if (details.primaryVelocity! < 0) {
              // Navigate to StartPage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StartPage()),
              );
            }
          },
          child: WebView(
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
            javascriptChannels: <JavascriptChannel>{
              JavascriptChannel(
                name: 'FlutterApp',
                onMessageReceived: (JavascriptMessage message) {
                  // Handle received messages from JavaScript here
                },
              ),
            },
            onPageFinished: (String url) {
              // Send the game code to the WebView when the page finishes loading
              _controller?.evaluateJavascript('setGameCode("$gameCode");');
            },
            initialUrl: 'https://flow-43f6c.web.app/',
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://flow-43f6c.web.app/')) {
                return NavigationDecision.navigate;
              }
              return NavigationDecision.prevent;
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StartPage()),
            );
          },
          backgroundColor: Colors.blue,
          mini: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
