import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({super.key,this.title,this.textEditingController,this.textInputType,this.hint,this.validate,this.obscureText});
  String? title;
  TextEditingController? textEditingController;
  Function(String?)? validate;
  TextInputType? textInputType;
  String? hint;
  bool? obscureText;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isHiddenPassword=false;
  @override
  void initState() {
    isHiddenPassword=widget.obscureText!;
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(widget.title!,style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w600),),
        SizedBox(height: 10,),
        Container(
                    height: 75,
                    child: TextFormField(
                      validator: (text)=>widget.validate!(text),
                      controller: widget.textEditingController,
                      style: TextStyle(color: Colors.white),
                      obscureText: isHiddenPassword,
                      obscuringCharacter: '●',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: widget.hint,
                        hintStyle: TextStyle(color: Colors.white),
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
                        suffixIcon:widget.obscureText==true?InkWell(
                                        onTap: () {
                                          setState(() {
                                            isHiddenPassword = !isHiddenPassword;
                                          });
                                        },
                                        child: Icon(
                                          isHiddenPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                      ):null,
                                      errorStyle: TextStyle(fontSize: 14)
                                    
                      ),
                    )),
      ],
      ),
    );
  }
}