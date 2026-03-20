import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Reactive — any Obx() watching this rebuilds on change
  final _isDark = false.obs;

  bool get isDark => _isDark.value;

  @override
  void onInit() {
    super.onInit();
    // Read system theme on startup
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    _isDark.value = brightness == Brightness.dark;
  }

  void toggleTheme() {
    _isDark.value = !_isDark.value;
    Get.changeThemeMode(_isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
}