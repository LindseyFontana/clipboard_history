package com.lindseyfontana.clipboard_history

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import java.util.Collections.emptyList

class ClipboardHistoryPlugin :
    FlutterPlugin,
    MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var context: Context? = null

    private var store: ClipboardHistoryStore? = null



    companion object {
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

        val sharedPreferences = context?.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        store = ClipboardHistoryStore(sharedPreferences)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
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
                    result.success( store?.add(data))
                } else {
                    result.success(emptyList<String>())
                }
            }

            "getHistory" -> {
                result.success(store?.getAll())
            }

            "clearHistory" -> {
                try {
                    store?.clear()
                    result.success(true)
                } catch (e: Exception) {
                    returnError(result, e.message)
                }
            }

            "deleteItem" -> {
                try {
                    val item = call.arguments as? String
                    if (item != null) {
                        result.success(store?.remove(item))
                    } else {
                        returnError(result, "Error deleting item.")
                    }
                } catch (e: Exception) {
                    returnError(result, e.message)
                }
            }

            "addToClipboard" -> {
                val copyValue = call.arguments as? String
                if(copyValue != null) {
                    val clip = ClipData.newPlainText(copyValue, copyValue)
                    getClipboardManager().setPrimaryClip(clip)
                    result.success(true)
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

}