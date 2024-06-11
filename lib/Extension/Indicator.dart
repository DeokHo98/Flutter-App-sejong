import 'package:flutter/material.dart';

extension IndicatorControl on BuildContext {
  void startIndicator() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void stopIndicator() {
    Navigator.of(this, rootNavigator: true).pop();
  }
}