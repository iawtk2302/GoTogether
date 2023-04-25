import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/repository/auth_repository.dart';

import '../../widget/custom_textfield.dart';




class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColor.bg,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: InkWell(
      //     onTap: () {
      //       Navigator.pushReplacementNamed(context, Routes.login);
      //     },
      //     child: const Icon(Icons.chevron_left, color: Colors.black, size: 42),
      //   ),
      // ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Image.asset("assets/images/forgot_pass.png"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Forgot",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password",
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w700))),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Don't worry! It happen. Please enter the address associated with your account.",
                      style: TextStyle(fontSize: 16))),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextFormField(
                                hint: "Email",
                                title: "Email",
                                obscureText: false,
                                textEditingController: _emailController,
                                validate: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                    return "Invalid email";
                                  }
                                  return null;
                                },
                                textInputType: TextInputType.emailAddress,
                              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 25,
              ),
              child: InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => const Center(
                    //     child: CircularProgressIndicator(color: Colors.black),
                    //   ),
                    // );
                    await AuthRepository().resetPassword(_emailController.text.trim().toString());
                  }
                },
                child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: CustomColor.blue),
                            child: const Center(
                                child: Text("Reset Password",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white))),
                          ),
                        ),
                      ),
                    ),
          ]),
        ),
      ),
    );
  }
}
