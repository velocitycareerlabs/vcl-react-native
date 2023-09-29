/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

 package io.velocitycareerlabs.reactnative.extensions

import com.facebook.react.bridge.*
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

@Throws(JSONException::class)
fun JSONObject.toWritableMap(): WritableMap {
  val map = Arguments.createMap()
  val keysItr: Iterator<String> = this.keys()
  while (keysItr.hasNext()) {
    val key = keysItr.next()
    var value: Any = this.get(key)
    if (value is JSONArray) {
      value = value.toWritableArray()
    } else if (value is JSONObject) {
      value = value.toWritableMap()
    }
    when (value) {
      is Boolean -> map.putBoolean(key, value)
      is Double -> map.putDouble(key, value)
      is Int -> map.putInt(key, value)
      is String -> map.putString(key, value)
      is ReadableMap -> map.putMap(key, value)
      is WritableMap -> map.putMap(key, value)
      is ReadableArray -> map.putArray(key, value)
      is WritableArray -> map.putArray(key, value)
      else -> map.putNull(key)
    }
  }
  return map
}

fun JSONObject.toReadableMap(): ReadableMap = toWritableMap()

@Throws(JSONException::class)
fun JSONArray.toWritableArray(): WritableArray {
  val array = Arguments.createArray()
  for (i in 0 until this.length()) {
    var value: Any = this[i]
    if (value is JSONArray) {
      value = value.toWritableArray()
    } else if (value is JSONObject) {
      value = value.toWritableMap()
    }
    when (value) {
      is Boolean -> array.pushBoolean(value)
      is Double -> array.pushDouble(value)
      is Int -> array.pushInt(value)
      is String -> array.pushString(value)
      is ReadableArray -> array.pushArray(value)
      is WritableArray -> array.pushArray(value)
      is ReadableMap -> array.pushMap(value)
      is WritableMap -> array.pushMap(value)
      else -> array.pushNull()
    }
  }
  return array
}

fun JSONArray.toReadableArray(): ReadableArray = toWritableArray()
