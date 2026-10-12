package com.lindseyfontana.clipboard_history

import android.content.ClipData
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

                val cachedValues = getFromCache()?.toList()

                result.success(cachedValues)
            }

            "getHistory" -> {
                val data = getFromCache()?.toList()

                result.success(data)
            }

            "clearHistory" -> {
                try {
                    clear()
                    result.success(true)
                } catch (e: Exception) {
                    returnError(result, e.message)
                }
            }

            "deleteItem" -> {
                try {
                    val item = call.arguments as? String
                    if (item != null) {
                        val data = deleteItem(item);
                        result.success(data?.toList())
                    } else {
                        returnError(result, "Error deleting item.")
                    }

                } catch (e: Exception) {
                    returnError(result, e.message)
                }
            }

            "addToClipboard" -> {
                val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                val valueCopied = call.arguments as? String
                val clip = ClipData.newPlainText(valueCopied, valueCopied)
                clipboard.setPrimaryClip(clip)
                if (valueCopied != null) {
                    saveInCache(valueCopied)
                }

            }

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    fun returnError(result: Result, message: String?) {
        return result.error("500", message, null)
    }

    fun getPrefs(): SharedPreferences {
        return context.getSharedPreferences("clipboard_cache", Context.MODE_PRIVATE);
    }

    fun saveInCache(data: String) {
        val prefs = getPrefs();
        val list = getFromCache()
        if (list.contains(data)) {
            return
        }
        list.add(data)

        prefs.edit().putString(historyKey, list
            .joinToString("\u0000"))
            .apply()

        val data = prefs.getString(historyKey, null)
        println(data)
    }

    fun getFromCache(): MutableList<String> {
        val prefs = getPrefs();
        val cachedValues =  prefs.getString(historyKey, null)
        val splitValues = cachedValues?.split("\u0000") ?: emptyList()
        return splitValues.toMutableList()
    }

    fun clear() {
        val prefs = getPrefs();
        prefs.edit().remove(historyKey).commit()
    }

    fun deleteItem(item: String): List<String> {
        val prefs = getPrefs();
        val editor = prefs.edit()
        val list = getFromCache()
        list.remove(item)
        editor.putString(historyKey, if(list.isNotEmpty()) list.joinToString("\u0000") else null).apply()
        return list;
    }
}