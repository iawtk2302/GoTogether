import 'package:flutter/material.dart';

import '../common/custom_color.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050406),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email",style: TextStyle(color: Colors.white),),
      Container(
                  height: 55,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    // obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      // labelText: 'Password',
                      hintText: "Email",
                      hintStyle: TextStyle(color: Color(0xFFBDC1C6)),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Color(0xFFBDC1C6), width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                             BorderSide(color: CustomColor.green, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
