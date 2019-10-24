package com.dan.flutter_app;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    registerCustomPlugin(this);
  }
  private static void registerCustomPlugin(PluginRegistry registrar) {
    FlutterBluePlugin.registerWith(registrar.registrarFor(FlutterBluePlugin.CHANNEL));
  }
}
