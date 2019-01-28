package com.anggach.flutterbranchiopluginexample

import android.os.Bundle
import com.anggach.flutterandroidlifecycle.FlutterAndroidLifecycleActivity
import com.anggach.flutterbranchioplugin.src.FlutterBranchIOActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterAndroidLifecycleActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }
}
