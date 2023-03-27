import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField(
      {super.key,
      this.title,
      this.textEditingController,
      this.textInputType,
      this.hint,
      this.validate,
      this.obscureText,
      this.suffixIcon,
      this.enabled,
      this.readOnly,
      this.maxLength,
      this.height,
      this.minLines,
      this.maxLines});
  String? title;
  TextEditingController? textEditingController;
  Function(String?)? validate;
  TextInputType? textInputType;
  String? hint;
  bool? obscureText;
  Widget? suffixIcon;
  bool? readOnly;
  bool? enabled;
  int? maxLength;
  double? height;
  int? minLines;
  int? maxLines;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isHiddenPassword = false;
  bool readOnly=false;
  @override
  void initState() {
    isHiddenPassword = widget.obscureText??false;
    readOnly=widget.readOnly??false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.title!,
            style: TextStyle(
                 fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: widget.height??75,
              child: TextFormField(
                validator: widget.validate!=null?(text) => widget.validate!(text):null,
                minLines: widget.minLines??1,
                maxLines: widget.maxLines??1,
                controller: widget.textEditingController,
                // style: TextStyle(color: Colors.white),
                obscureText: isHiddenPassword,
                readOnly: readOnly,
                maxLength: widget.maxLength,
                enabled: widget.enabled,
                obscuringCharacter: '●',
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: widget.hint,
                    hintStyle: TextStyle(color: CustomColor.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFFBDC1C6), width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: CustomColor.green, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    suffixIcon: widget.obscureText == true
                        ? InkWell(
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
                          )
                        : widget.suffixIcon,
                    errorStyle: TextStyle(fontSize: 14)),
              )),
        ],
      ),
    );
  }
}
