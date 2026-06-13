import 'package:get/get.dart';

class ThemeController extends GetxController {
  final _isDark = true.obs;

  bool get isDark => _isDark.value;

  void toggleTheme() {
    _isDark.value = !_isDark.value;
  }
}