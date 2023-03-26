import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';

import '../repository/auth_repository.dart';
import '../router/routes.dart';
import '../widget/auth_button.dart';

import '../widget/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool isHiddenPassword = true;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: CustomColor.bg,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 150,
                  width: 150,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    "Create Your Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
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
                        SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                          hint: "Password",
                          title: "Password",
                          obscureText: true,
                          textEditingController: _passController,
                          validate: (value) {
                            if (value!.isEmpty || value.length < 8) {
                              return "Password at least 8 characters";
                            }
                          },
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                          hint: "Confirm Password",
                          title: "Confirm Password",
                          obscureText: true,
                          textEditingController: _confirmPassController,
                          validate: (value) {
                            if (value!.isEmpty || value.length < 8) {
                              return "Password at least 8 characters";
                            } else if (value != _passController.text) {
                              return "The password confirmation does not match";
                            }
                          },
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await AuthRepository().createUserWithEmailAndPassword(_emailController.text.trim().toString(), _passController.text.trim().toString());
                        Navigator.pushNamed(context, Routes.main);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFFa1f781)),
                        child: const Center(
                            child: Text("Sign Up",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black))),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 1,
                        width: 80,
                        color: CustomColor.grey,
                      ),
                      Text(
                        "Or continue with",
                        style: TextStyle(color: CustomColor.grey),
                      ),
                      Container(
                        height: 1,
                        width: 80,
                        color: CustomColor.grey,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthButton(
                        image: "assets/images/logoGG.png",
                        onTap: () async =>
                            {await AuthRepository().signInWithGoogle()},
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      AuthButton(
                        image: "assets/images/logoFB.png",
                        onTap: () async =>
                            {await AuthRepository().signInWithFacebook()},
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.login);
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                              color: CustomColor.green,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
