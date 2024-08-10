import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Mengelola tema aplikasi dan menyediakan metode untuk mengganti tema.
class ThemeController extends GetxController {
  /// Menyimpan tema saat ini yang diterapkan pada aplikasi.
  ///
  /// Variabel ini menggunakan observasi dari `ThemeData`, dengan tema default
  /// diatur ke tema gelap (`ThemeData.dark()`).
  Rx<ThemeData> currentTheme = ThemeData.dark().obs;

  /// Mengganti tema aplikasi antara tema gelap dan tema terang.
  ///
  /// Jika tema saat ini adalah tema gelap, maka akan diubah menjadi tema terang.
  /// Sebaliknya, jika tema saat ini adalah tema terang, maka akan diubah menjadi
  /// tema gelap.
  void toggleTheme() {
    if (currentTheme.value.brightness == Brightness.dark) {
      currentTheme.value = ThemeData.light();
    } else {
      currentTheme.value = ThemeData.dark();
    }
  }
}
