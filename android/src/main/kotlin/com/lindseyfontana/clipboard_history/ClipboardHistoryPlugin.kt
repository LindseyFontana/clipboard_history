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
import java.util.Collections.emptyList

class ClipboardHistoryPlugin :
    FlutterPlugin,
    MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var sharedPreferences: SharedPreferences? = null

    companion object {
        private const val HISTORY_KEY = "history"
        private const val SEPARATOR = "\u0000"
        private const val PREFS_NAME = "clipboard_cache"
        private const val CHANNEL_NAME = "clipboard_history"

        fun returnError(result: Result, message: String?) {
            return result.error("500", message, null)
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)

        context = flutterPluginBinding.applicationContext

        sharedPreferences = context?.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
        sharedPreferences = null
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "captureClipboard" -> {
                val manager = getClipboardManager()
                val clip = manager.primaryClip
                var data: String? = clip?.getItemAt(0)?.coerceToText(context).toString()

                if (data != null) {
                    saveInCache(data)
                }

                val cachedValues = getFromCache()

                result.success(cachedValues)
            }

            "getHistory" -> {
                val data = getFromCache()

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
                        val data = deleteItem(item)
                        result.success(data)
                    } else {
                        returnError(result, "Error deleting item.")
                    }

                } catch (e: Exception) {
                    returnError(result, e.message)
                }
            }

            "addToClipboard" -> {
                val valueCopied = call.arguments as? String
                if(valueCopied != null) {
                    val clip = ClipData.newPlainText(valueCopied, valueCopied)
                    getClipboardManager().setPrimaryClip(clip)

                    val data = if (valueCopied != null)
                        saveInCache(valueCopied) else emptyList<String>()

                    result.success(data)
                } else {
                    returnError(result, "Null value")
                }
            }

            else -> result.notImplemented()
        }
    }



    private fun getClipboardManager() : ClipboardManager {
        return  context?.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    }



    private fun saveInCache(data: String): MutableList<String> {
        val cachedHistory = getFromCache().toMutableList()
        if (cachedHistory.contains(data))  return emptyList<String>()

        cachedHistory.add(data)

        sharedPreferences?.edit()?.putString(HISTORY_KEY, joinOrNull(cachedHistory))
            ?.apply()

        return cachedHistory;
    }

    private fun getFromCache(): List<String> {
        val cachedHistory =  sharedPreferences?.getString(HISTORY_KEY, null)

        return cachedHistory?.split(SEPARATOR) ?: emptyList()
    }

    private fun clear() {
        sharedPreferences?.edit()?.remove(HISTORY_KEY)?.apply()
    }

    private fun deleteItem(item: String): MutableList<String> {
        val list = getFromCache().toMutableList()
        if(list.isNotEmpty()) list.remove(item)
        updateCache(list)
        return list.toMutableList()
    }

    private fun updateCache(list:  List<String>) {
        val editor = sharedPreferences?.edit()
        editor?.putString(HISTORY_KEY, joinOrNull(list))?.apply()
    }

    private fun joinOrNull(list: List<String>) : String? {
        return if(list.isNotEmpty())  list.joinToString(SEPARATOR) else null
    }
}