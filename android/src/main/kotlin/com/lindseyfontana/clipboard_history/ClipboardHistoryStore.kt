package com.lindseyfontana.clipboard_history

import android.content.SharedPreferences
import org.json.JSONArray

class ClipboardHistoryStore (private val sharedPreferences: SharedPreferences?) {

    fun getAll(): List<String> {
        val history = sharedPreferences?.getString(HISTORY_KEY, null) ?: return emptyList()
        return JSONArray(history).let { array -> (0 until array.length()).map(array::getString) }
    }

    fun add (item: String): List<String> {
        val list = getAll().toMutableList()
        if (item !in list) {
            list.add(item)
            save(list)
        }
        return list
    }

    fun remove (item: String): List<String> {
        val list = getAll().toMutableList()
        if (item in list) {
            list.remove(item)
            save(list)
        }
        return list
    }

    fun clear() {
        sharedPreferences?.edit()?.remove(HISTORY_KEY)?.apply()
    }

    private fun save(list: List<String>) {
        sharedPreferences?.edit()?.putString(HISTORY_KEY,  JSONArray(list).toString())?.apply()
    }

    companion object {
        private const val HISTORY_KEY = "history"
    }
}