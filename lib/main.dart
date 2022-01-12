import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TextSelectionTheme(
        data: const TextSelectionThemeData(
          selectionColor: Colors.red,
          cursorColor: Colors.yellow,
          selectionHandleColor: Colors.red,
        ),
        child: Builder(
          builder: (ctx) {
            return const MyHomePage(title: 'Flutter Demo Home Page');
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    //    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView(); also crash
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (_focusNode.hasFocus) {
            _focusNode.unfocus();
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'SelectableText bugs: selectionHandleColor not work and line height not same',
              ),
              TextSelectionTheme(
                data: const TextSelectionThemeData(
                    cursorColor: Colors.red, selectionColor: Colors.yellow, selectionHandleColor: Colors.green),
                child: SelectableText(
                  'aaYY*E¥%选择区域counter is $_counter 中文😊',
                  focusNode: _focusNode,
                  style: Theme.of(context).textTheme.bodyText2,
                  selectionControls: MaterialTextSelectionControls(),
                ),
              ),
              const Text(
                'WebView bugs: toggle dark off/on -> off/on -> off/on, app crashed',
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const WebView(
                          initialUrl: 'https://flutter.dev',
                        );
                      },
                    ),
                  );
                },
                child: const Text('open https://flutter.dev in WebView'),
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return InAppWebView(
              //             initialUrlRequest: URLRequest(
              //               url: Uri.tryParse('https://flutter.dev'),
              //             ),
              //           );
              //           // return const WebView(
              //           //   initialUrl: 'https://flutter.dev',
              //           // );
              //         },
              //       ),
              //     );
              //   },
              //   child: const Text('open https://flutter.dev in InAppWebView'),
              // )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
