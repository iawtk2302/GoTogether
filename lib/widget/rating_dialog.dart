import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/widget/custom_button.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text("Give trip feedback", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: EmojiFeedback(
              animDuration: const Duration(milliseconds: 300),
              curve: Curves.bounceIn,
              inactiveElementScale: .7,
              showLabel: false,
              onChanged: (value) {
                print(value);
              },
            ),
          ),
        TextField(
        decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide.none
        ),
        filled: true,
        hintStyle: TextStyle(color: CustomColor.grey),
        hintText: "Tell us more...",
        fillColor: CustomColor.blue1),
        maxLines: 7,
        ),
        SizedBox(height: 10,),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(onPressed: (){}, child: Text("Submit")))
        ]),
      ),
    );
  }
}
