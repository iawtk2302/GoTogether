import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/repository/auth_repository.dart';
import 'package:go_together/widget/custom_textfield.dart';

import '../../router/routes.dart';
import '../../widget/auth_button.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHiddenPassword = true;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool validateEmail = true;
  bool validatePass = true;
  bool isChecked = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
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
                        "Login To Your Account",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                hint: "Example@gmail.com",
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
                                height: 20,
                              ),
                              CustomTextFormField(
                                hint: "Your Password",
                                title: "Password",
                                obscureText: true,
                                textEditingController: _passController,
                                validate: (value) {
                                  if (value!.isEmpty || value.length < 8) {
                                    return "Password at least 8 characters";
                                  }
                                },
                                textInputType: TextInputType.text,
                              )
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            AuthRepository().signInWithEmailAndPassword(
                                _emailController.text.trim().toString(),
                                _passController.text.trim().toString());
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
                                child: Text("Sign In",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white))),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.forgot);
                        },
                        child: Text(
                          "Forgot the password?",
                          style: TextStyle(
                              color: CustomColor.blue,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 1,
                            width: 80,
                            color: Colors.black,
                          ),
                          const Text(
                            "Or continue with",
                            
                          ),
                          Container(
                            height: 1,
                            width: 80,
                            color: Colors.black,
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
                            "Don't have an account? ",
                         
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.register);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => const RegisterPage()),
                              // );
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color: CustomColor.blue,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ))
        : const CircularProgressIndicator();
  }
}