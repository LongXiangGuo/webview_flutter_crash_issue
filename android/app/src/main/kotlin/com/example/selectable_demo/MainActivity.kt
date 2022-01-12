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
