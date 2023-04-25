import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, warning, error }

class Toasty {
  static void show(
    String message, {
    ToastType type = ToastType.success,
    bool isLongToast = false,
  }) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: isLongToast ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: type == ToastType.success
          ? Colors.green
          : (type == ToastType.warning ? Colors.orange : Colors.green[700]),
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }
}
