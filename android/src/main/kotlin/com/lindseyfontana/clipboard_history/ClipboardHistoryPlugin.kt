package com.lindseyfontana.clipboard_history

import android.content.ClipboardManager
import android.content.Context
import android.content.SharedPreferences
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ClipboardHistoryPlugin :
    FlutterPlugin,
    MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context


    val historyKey = "history";

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "clipboard_history")
        channel.setMethodCallHandler(this)

        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "captureClipboard" -> {
                val manager = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                val clip = manager.primaryClip
                var data: String? = null
                if (clip != null && clip.itemCount > 0 && clip.getItemAt(0).text != null)
                    data = clip.getItemAt(0).coerceToText(context).toString()

                if (data != null) {
                    saveInCache(data)
                }

                result.success(data)
            }
            "getHistory" -> {
                val data = getFromCache()?.toList()

                result.success(data)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    fun getPrefs(): SharedPreferences {
        return context.getSharedPreferences("clipboard_cache", Context.MODE_PRIVATE);
    }

    fun saveInCache(data: String) {
        val prefs = getPrefs();
        val set = HashSet(getFromCache())
        set.add(data)
        prefs.edit().putStringSet(historyKey, set).apply()
    }

    fun getFromCache(): MutableSet<String>? { val prefs = getPrefs();
       return prefs.getStringSet(historyKey, emptySet())
    }
}