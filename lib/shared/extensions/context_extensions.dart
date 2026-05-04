import 'package:flutter/material.dart';
import '../../core/constants/breakpoints.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  Size get screenSize => MediaQuery.of(this).size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isMobile => Breakpoints.isMobile(screenWidth);

  bool get isTablet => Breakpoints.isTablet(screenWidth);

  bool get isDesktop => Breakpoints.isDesktop(screenWidth);

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<T?> showBottomSheet<T>(Widget child) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      builder: (context) => child,
    );
  }
}
