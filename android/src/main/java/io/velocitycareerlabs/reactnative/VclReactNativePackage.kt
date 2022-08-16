package io.velocitycareerlabs.reactnative

import android.view.View
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ReactShadowNode
import com.facebook.react.uimanager.ViewManager

/**
 * Created by Michael Avoyan on 01/07/2021.
 */
class VclReactNativePackage: ReactPackage {
  override fun createNativeModules(reactContext: ReactApplicationContext): MutableList<NativeModule> =
    mutableListOf(VclReactNativeModule(reactContext))

  override fun createViewManagers(p0: ReactApplicationContext) =
    mutableListOf<ViewManager<View, ReactShadowNode<*>>>()
}
