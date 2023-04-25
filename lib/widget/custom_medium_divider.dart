import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomMediumDivider extends StatelessWidget {
  const CustomMediumDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey.withOpacity(.5),
      thickness: 8,
      height: 0,
    );
  }
}
