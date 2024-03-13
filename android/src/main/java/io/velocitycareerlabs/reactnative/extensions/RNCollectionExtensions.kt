/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package io.velocitycareerlabs.reactnative.extensions

import com.facebook.react.bridge.*

fun Map<String, Any>.toWritableMap(): WritableMap {
  val writableMap = Arguments.createMap()
  val keys: Set<String> = this.keys
  keys.forEach{ key ->
    var value: Any? = this[key]
    if (value is List<*>) {
      value = (value as? List<Any>)?.toWritableArray()
    } else if (value is Map<*,*>) {
      value = (value as? Map<String, Any>)?.toWritableMap()
    }
    when (value) {
      is Boolean -> writableMap.putBoolean(key, value)
      is Double -> writableMap.putDouble(key, value)
      is Int -> writableMap.putInt(key, value)
      is String -> writableMap.putString(key, value)
      is WritableMap -> writableMap.putMap(key, value)
      is WritableArray -> writableMap.putArray(key, value)
      else -> {
        value?.let { throw IllegalArgumentException("Unsupported value type ${value::class.java.name} for key [$key]") }
          ?: throw IllegalArgumentException("Unsupported value type NULL for key [$key]")
      }
    }
  }
  return writableMap
}

fun Map<String, Any>.toReadableMap(): ReadableMap = toWritableMap()

fun List<Any>.toWritableArray(): WritableArray {
  val writableArray = Arguments.createArray()
  for (element in this) {
    var value: Any? = element
    if (value is List<*>) {
      value = (value as? List<Any>)?.toWritableArray()
    } else if (value is Map<*,*>) {
      value = (value as? Map<String, Any>)?.toWritableMap()
    }
    when (value) {
      is Boolean -> writableArray.pushBoolean(value)
      is Double -> writableArray.pushDouble(value)
      is Int -> writableArray.pushInt(value)
      is String -> writableArray.pushString(value)
      is WritableArray -> writableArray.pushArray(value)
      is WritableMap -> writableArray.pushMap(value)
      else -> {
        value?.let { throw IllegalArgumentException("Unsupported type ${value::class.java.name}")  }
          ?: throw IllegalArgumentException("Unsupported type NULL")
      }
    }
  }
  return writableArray
}

fun List<Any>.toReadableArray(): ReadableArray = toWritableArray()
