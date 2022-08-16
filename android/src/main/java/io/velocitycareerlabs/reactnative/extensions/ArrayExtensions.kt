package io.velocitycareerlabs.reactnative.extensions

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableArray
import java.lang.Exception

/**
 * Created by Michael Avoyan on 25/10/2021.
 */

fun ReadableArray.getBooleanOpt(index: Int): Boolean? {
  return try {
    this.getBoolean(index)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableArray.getBooleanOpt(index: Int): Boolean? {
  return (this as ReadableArray).getBooleanOpt(index)
}

fun ReadableArray.getDoubleOpt(index: Int): Double? {
  return try {
    this.getDouble(index)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableArray.getDoubleOpt(index: Int): Double? {
  return (this as ReadableArray).getDoubleOpt(index)
}

fun ReadableArray.getIntOpt(index: Int): Int? {
  return try {
    this.getInt(index)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableArray.getIntOpt(index: Int): Int? {
  return (this as ReadableArray).getIntOpt(index)
}

fun ReadableArray.getStringOpt(index: Int): String? {
  return try {
    this.getString(index)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableArray.getStringOpt(index: Int): String? {
  return (this as ReadableArray).getStringOpt(index)
}

fun ReadableArray.getArrayOpt(index: Int): ReadableArray? {
  return try {
    this.getArray(index)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableArray.getArrayOpt(index: Int): ReadableArray? {
  return (this as ReadableArray).getArrayOpt(index)
}

fun ReadableArray.getMapOpt(index: Int): ReadableMap? {
  return try {
    this.getMap(index)
  } catch (e: Exception) {
    e.printStackTrace()
    null
  }
}

fun WritableArray.getMapOpt(index: Int): ReadableMap? {
  return (this as ReadableArray).getMapOpt(index)
}
