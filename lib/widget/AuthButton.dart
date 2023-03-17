import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthButton extends StatelessWidget {
  final String image;
  final Function()? onTap;
  const AuthButton({super.key, required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 80,
        decoration: BoxDecoration(
        
        ),
        child: Center(
          child: Image.asset(image, height: 35, width: 35,)
          ),
      ),
    );
  }
}