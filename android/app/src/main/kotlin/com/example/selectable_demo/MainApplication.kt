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
