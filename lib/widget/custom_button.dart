import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key, required this.onPressed, required this.text});
  String? text;
  Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: CustomColor.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: onPressed,
        child: Text(
          text!,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ));
  }
}
