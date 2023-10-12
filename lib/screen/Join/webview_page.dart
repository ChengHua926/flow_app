// ignore_for_file: library_private_types_in_public_api, unused_local_variable, avoid_print, use_build_context_synchronously, sort_child_properties_last

import 'package:flow_app/providers/game_code.dart';
import 'package:flow_app/screen/login.dart';
import 'package:flow_app/screen/session_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

import '../../providers/firebase.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _controller;

  //late final AudioPlayer jplayer; // Create a player

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //jplayer.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    //await jplayer.stop();
    return true; // Allow the pop action to continue
  }

  @override
  Widget build(BuildContext context) {
    final joinGameCodeProvider =
        Provider.of<JoinGameCodeProvider>(context, listen: false);
    final gameCode = joinGameCodeProvider.code;
    return WillPopScope(
      onWillPop: _onWillPop,
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
            javascriptChannels: {
              JavascriptChannel(
                name: 'flutterApp',
                onMessageReceived: (JavascriptMessage message) {
                  // Handle messages received from JavaScript here, if needed
                },
              ),
            },
            onPageFinished: (String url) {
              // Send the game code to the WebView when the page finishes loading
              _controller
                  ?.evaluateJavascript('flutterApp.postMessage("$gameCode");');
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
          onPressed: () async {
            //await jplayer.stop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StartPage()),
            );
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
          backgroundColor: Colors.blue,
          mini: true, // Set to false if you want a regular sized FAB
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}

class WebViewPageObserver extends NavigatorObserver {
  final Function() onPagePopped;

  WebViewPageObserver({required this.onPagePopped});

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name == "/webViewPage") {
      onPagePopped();
    }
    super.didPop(route, previousRoute);
  }
}
