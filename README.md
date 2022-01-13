# selectable_demo

Webview crash after toggle dark mode off->on->off->on 

Steps to reprodcue
1. Create the custom cache engine, enable uiMode configChanges on Application
2. Open the https://flutter.dev
3. Click dark mode toggle three times

Result

the webview_flutter crashed


[env](./env.txt)
[crash_flutter_253](./crash_flutter_253.txt)
[crash_flutter_280](./crash_flutter_280.txt)

```
E/MainApplication( 6182): onConfigurationChanged
E/MainApplication( 6182): onConfigurationChanged
E/MainApplication( 6182): onConfigurationChanged
W/cr_ChildProcessConn( 6182): onServiceDisconnected (crash or killed by oom): pid=6341 bindings:W S state:3 counts:0,0,0,1,
E/chromium( 6182): [ERROR:aw_browser_terminator.cc(125)] Renderer process (6341) crash detected (code 11).
F/chromium( 6182): [FATAL:crashpad_client_linux.cc(561)] Render process (6341)'s crash wasn't handled by all associated  webviews, triggering application crash.
F/libc    ( 6182): Fatal signal 5 (SIGTRAP), code -6 (SI_TKILL) in tid 6182 (selectable_demo), pid 6182 (selectable_demo)
Softversion: PD2005_A_5.13.2
Time: 2022-01-12 10:27:35
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Build fingerprint: 'vivo/PD2005/PD2005:10/QP1A.190711.020/compiler11191656:user/release-keys'
Revision: '0'
ABI: 'arm64'
Timestamp: 2022-01-12 10:27:35+0800
pid: 6182, tid: 6182, name: selectable_demo  >>> com.example.selectable_demo <<<
uid: 10359
signal 5 (SIGTRAP), code -6 (SI_TKILL), fault addr --------
Abort message: '[FATAL:crashpad_client_linux.cc(561)] Render process (6341)'s crash wasn't handled by all associated  webviews, triggering application crash.
'
    x0  0000000000000000  x1  0000000000000081  x2  000000007fffffff  x3  0000000000000000
    x4  0000000000000000  x5  0000000000000000  x6  0000000000000000  x7  0000003c2b2dffff
    x8  0000000000000000  x9  0000000000000000  x10 0000000000000001  x11 0000000000000000
    x12 0000007e55c86120  x13 ffffffffffffffff  x14 0000000000000001  x15 ffffffffffffffff
    x16 0000007f37028878  x17 0000007f36fb53b0  x18 0000007f3a554000  x19 0000007fda3f38b0
    x20 0000007fda3f38b8  x21 0000007fda3f38c0  x22 000000000000008d  x23 0000007f37023508
    x24 0000007e5b28e000  x25 0000007f397e5020  x26 0000007e576d2fe5  x27 0000007fda3f3400
    x28 0000007e576b0462  x29 0000007fda3f3850
    sp  0000007fda3f33f0  lr  0000007e58c35194  pc  0000007e58c35394
backtrace:
      #00 pc 00000000018ab394  /system/product/app/WebViewGoogle/WebViewGoogle.apk!libmonochrome.so (offset 0x1a2000) (BuildId: 0800d6a7294fbda9e42e3546b22bd3c5f2a6ee06)
Lost connection to device.
Exited (sigterm)

```

<details>
<summary>
Demo Code
</summary>

```
package com.example.selectable_demo

import android.annotation.SuppressLint
import android.content.res.Configuration
import android.os.Build
import android.util.Log
import androidx.core.os.ConfigurationCompat
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.systemchannels.SettingsChannel.PlatformBrightness
import java.io.BufferedReader
import java.io.File
import java.io.FileReader
import java.io.IOException
import java.util.*

class MainApplication : FlutterApplication() {
    val TAG = "MainApplication"
    val engineId = "WebviewEngine"

    lateinit var flutterEngine: FlutterEngine

    override fun onCreate() {
        super.onCreate()
        flutterEngine = FlutterEngine(this, null, false)
        FlutterEngineCache.getInstance().put(engineId, flutterEngine)
        flutterEngine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        val isNightModeOn = (newConfig.uiMode and Configuration.UI_MODE_NIGHT_MASK
                == Configuration.UI_MODE_NIGHT_YES)
        val brightness = if (isNightModeOn) PlatformBrightness.dark else PlatformBrightness.light

        flutterEngine.localizationChannel.sendLocales(newConfig.localeList)
            flutterEngine.settingsChannel.startMessage()
                .setTextScaleFactor(newConfig.fontScale)
                .setUse24HourFormat(true)
                .setPlatformBrightness(brightness)
                .send()
        Log.e(TAG, "onConfigurationChanged")
    }

    private val Configuration.localeList: List<Locale>
        get() {
            val localeList = ConfigurationCompat.getLocales(this)
            return if (!localeList.isEmpty) {
                val locales = mutableListOf<Locale>()
                for (i in 0 until localeList.size()) {
                    locales.add(localeList[i])
                }
                locales
            } else {
                @Suppress("DEPRECATION")
                listOf(locale ?: Locale.getDefault())
            }
        }
}
```

```
package com.example.selectable_demo

import android.content.Context
import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        GeneratedPluginRegistrant.registerWith((applicationContext as MainApplication).flutterEngine)
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return (applicationContext as MainApplication).flutterEngine
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith((applicationContext as MainApplication).flutterEngine)
    }

    override fun getCachedEngineId(): String? {
        return (applicationContext as MainApplication).engineId
    }

    override fun getFlutterEngine(): FlutterEngine? {
        return (applicationContext as MainApplication).flutterEngine
    }

    override fun shouldDestroyEngineWithHost(): Boolean {
        return false
    }

    override fun onDestroy() {
        super.onDestroy()
    }
}
```

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.selectable_demo">
    <uses-permission android:name="android.permission.INTERNET"/>
   <application
        android:label="selectable_demo"
       android:usesCleartextTraffic="true"
       android:name=".MainApplication"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <!-- Displays an Android View that continues showing the launch screen
                 Drawable until Flutter paints its first frame, then this splash
                 screen fades out. A splash screen is useful to avoid any visual
                 gap between the end of Android's launch screen and the painting of
                 Flutter's first frame. -->
            <meta-data
              android:name="io.flutter.embedding.android.SplashScreenDrawable"
              android:resource="@drawable/launch_background"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

```
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
```
</details>
