import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('_MyHomePageState build');
    return Scaffold(
      appBar: CustomNaviBar(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('share'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Wrap(
                            children: [
                              TextButton(
                                onPressed: () {
                                  launch('https://flutter.dev');
                                },
                                child: const Text('safari'),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('share'),
            )
          ],
          bottom: const NaviBarDivider(),
        ),
      ),
      body: Container(
        key: const Key('key'),
        child: Column(
          children: [
            Container(
              height: 20,
              child: Text('padding 20'),
            ),
            const SizedBox(
              height: 300,
              child: WebView(
                initialUrl: 'https://flutter.dev',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNaviBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget appBar;
  const CustomNaviBar({Key? key, required this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return appBar;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}

class NaviBarDivider extends StatelessWidget with PreferredSizeWidget {
  const NaviBarDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1.0,
      color: Colors.black,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
