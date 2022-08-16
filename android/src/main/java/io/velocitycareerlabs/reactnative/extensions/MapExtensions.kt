package io.velocitycareerlabs.reactnative.extensions

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import java.lang.Exception

/**
 * Created by Michael Avoyan on 25/10/2021.
 */

fun ReadableMap.getBooleanOpt(key: String): Boolean? {
  return try {
    this.getBoolean(key)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableMap.getBooleanOpt(key: String): Boolean? {
  return (this as ReadableMap).getBooleanOpt(key)
}

fun ReadableMap.getDoubleOpt(key: String): Double? {
  return try {
    this.getDouble(key)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableMap.getDoubleOpt(key: String): Double? {
  return (this as ReadableMap).getDoubleOpt(key)
}

fun ReadableMap.getIntOpt(key: String): Int? {
  return try {
    this.getInt(key)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableMap.getIntOpt(key: String): Int? {
  return (this as ReadableMap).getIntOpt(key)
}

fun ReadableMap.getStringOpt(key: String): String? {
  return try {
    this.getString(key)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableMap.getStringOpt(key: String): String? {
  return (this as ReadableMap).getStringOpt(key)
}

fun ReadableMap.getArrayOpt(key: String): ReadableArray? {
  return try {
    this.getArray(key)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableMap.getArrayOpt(key: String): ReadableArray? {
  return (this as ReadableMap).getArrayOpt(key)
}

fun ReadableMap.getMapOpt(key: String): ReadableMap? {
  return try {
    this.getMap(key)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableMap.getMapOpt(key: String): ReadableMap? {
  return (this as ReadableMap).getMapOpt(key)
}

