import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class AppLocale extends _$AppLocale {
  @override
  Locale build() {
    // Default to Vietnamese per user request
    return const Locale('vi');
  }

  void setLocale(Locale locale) {
    state = locale;
  }

  void toggleLocale() {
    if (state.languageCode == 'vi') {
      state = const Locale('en');
    } else {
      state = const Locale('vi');
    }
  }
}
