import 'package:flutter/material.dart';

mixin OnAppearAction<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    onAppear();
  }

  void onAppear();
}
