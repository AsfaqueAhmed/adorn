import 'package:adorn/base/model/adorn_theme.dart';
import 'package:adorn/base/widget/themed_app.dart';
import 'package:flutter/material.dart';

import 'adorn_statefull_widget.dart';

abstract class AdornState<T extends AdornStatefulWidget> extends State<T> {
  /// Helper to get the [TextTheme].
  TextTheme get textTheme => Theme.of(context).textTheme;

  /// Helper to get the [Theme].
  AdornTheme get currentTheme => ThemedApp.of(context)?.getCurrentTheme();

  /// Helper to get the [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(context);

  @override
  void initState() {
    super.initState();
    afterInitialise();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  /// Initialize your widget in [afterInitialise].
  ///
  /// * [afterInitialise] is called after the [initState] method.
  afterInitialise() async {}
}
