import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/utils/chatUtils.dart';
import 'package:go_together/widget/custom_app_bar.dart';
import 'package:go_together/widget/custom_textfield.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../bloc/user/user_bloc.dart';
import '../../model/custom_user.dart';
import '../../widget/custom_button.dart';




class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key, required this.customUser});
  final CustomUser customUser;
  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

const List<String> gender = <String>['Male', 'Female'];

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  String dropdownValue = gender.first;
  File? _file;
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final storage = FirebaseStorage.instance.ref();
  final id = FirebaseAuth.instance.currentUser!.uid;
  final firestore = FirebaseFirestore.instance;
  String dateOfbirth="Date Of Birth";
  String? _selectedGender="Male";
  @override
  void initState() {
    _fullNameController.text=widget.customUser.fullName!;
    _addressController.text=widget.customUser.address!;
    _emailController.text=widget.customUser.email!;
    _phoneController.text=widget.customUser.phone!;
    dateOfbirth=widget.customUser.dateOfBirth!;
    _selectedGender=widget.customUser.gender!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Cập nhật hồ sơ"),
      body: Container(
        color: CustomColor.bg,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 50,
                          backgroundImage: _file == null
                              ? NetworkImage(widget.customUser.image!)
                              : Image.file(
                                  _file!,
                                  fit: BoxFit.cover,
                                ).image,
                        ),
                      ),
                      Positioned(
                          right: 25,
                          bottom: 30,
                          child: InkWell(
                            onTap: _editAvatar,
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Center(
                                child: Icon(Icons.edit,
                                    color: Colors.white, size: 20),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ))
                    ],
                  ),
                  CustomTextFormField(
                    hint: "Họ và tên",
                    title: "Họ và tên",
                    textEditingController: _fullNameController,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Bắt buộc";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15,),
                  // InfoInput(
                  //   hintText: "First Name",
                  //   controller: _firstNameController,
                  //   readOnly: false,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Required";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // InfoInput(
                  //   hintText: "Last Name",
                  //   controller: _lastNameController,
                  //   readOnly: false,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Required";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  
                  // InfoInput(
                  //   hintText: dateOfbirth,
                  //   suffixIcon: IconButton(
                  //     icon: const Icon(Icons.calendar_month),
                  //     onPressed: _getDateOfBirth,
                  //   ),
                  //   enabled: true,
                  //   readOnly: true,
                  // ),
                  CustomTextFormField(
                    hint: "Email",
                    title: "Email",
                    textInputType: TextInputType.emailAddress,
                    suffixIcon: const IconButton(
                      icon: Icon(Icons.email),
                      onPressed: null,
                    ),
                    readOnly: false,
                    textEditingController: _emailController,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return "Invalid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15,),
                  CustomTextFormField(
                    hint: "Số điện thoại",
                    title: "Số điện thoại",
                    readOnly: false,
                    suffixIcon: const IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: null,
                    ),
                    textInputType: TextInputType.phone,
                    textEditingController: _phoneController,
                    // maxLength: 10,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return "Bắt buộc";
                      }
                      if (!RegExp(r"(84|0[3|5|7|8|9])+([0-9]{8})")
                          .hasMatch(value)) {
                        return "Số điện thoại không hợp lệ!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15,),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10),
                  //   child: Container(
                  //       width: size.width * 0.85,
                  //       decoration: BoxDecoration(
                  //           color: const Color(0xFFFAFAFA),
                  //           borderRadius: BorderRadius.circular(10)),
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 2),
                  //         child: DropdownButtonHideUnderline(
                  //           child: DropdownButton<String>(
                  //             iconSize: 32,
                  //             icon: const Padding(
                  //               padding: EdgeInsets.only(right: 8),
                  //               child: Icon(Icons.keyboard_arrow_down),
                  //             ),
                  //             isExpanded: true,
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 dropdownValue = value!;
                  //               });
                  //             },
                  //             value: dropdownValue,
                  //             items: gender
                  //                 .map<DropdownMenuItem<String>>((String value) {
                  //               return DropdownMenuItem<String>(
                  //                 value: value,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(left: 20),
                  //                   child: Text(value),
                  //                 ),
                  //               );
                  //             }).toList(),
                  //           ),
                  //         ),
                  //       )),
                  // ),
                  CustomTextFormField(
                    title: "Ngày sinh",
                    hint: dateOfbirth,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: _getDateOfBirth,
                    ),
                    enabled: true,
                    readOnly: true,
                  ),
                  SizedBox(height: 15,),
                  CustomTextFormField(
                    hint: "Địa chỉ",
                    title: "Địa chỉ",
                    textEditingController: _addressController,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Bắt buộc";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GenderSelection(),
                  ),
                  SizedBox(height: 10,),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    text: "Cập nhật",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submit();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editAvatar() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: CustomColor.bg,
          height: 230,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                      height: 6,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Tải Hình Ảnh",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const Text("Chọn ảnh hồ sơ của bạn",),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: "Chụp ảnh",
                    onPressed: _getImageCamera,
                  ),
                  SizedBox(height: 15,),
                  CustomButton(
                    text: "Chọn từ thư viện",
                    onPressed: _getImageGallery,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future _getImageCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    final imageTempory = File(image.path);
    setState(() {
      _file = imageTempory;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Future _getImageGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTempory = File(image.path);
    setState(() {
      _file = imageTempory;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Future _getDateOfBirth() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: CustomColor.blue,
                  ),
            ),
            child: child!);
      },
    );
    if (date == null) {
      return;
    } else {
      setState(() {
        dateOfbirth = '${date.day}/${date.month}/${date.year}';
      });
    }
  }

  Future _submit() async {
    if(_file!=null){
      try {
      final task = await storage.child("$id.jpg").putFile(_file!);
      final linkImage = await task.ref.getDownloadURL();
      await firestore.collection('User').doc(id).update({
          "dateOfBirth": dateOfbirth,
          "email": _emailController.text.trim(),
          "fullName": _fullNameController.text.trim(),
          "gender": _selectedGender,
          "image": linkImage,
          "address": _addressController.text.trim(),
          "phone": _phoneController.text
      });
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(linkImage);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(_fullNameController.text.trim());
      await FirebaseAuth.instance.currentUser!.updateEmail(_emailController.text.trim());
      await ChatUtil.client.updateUser(ChatUtil.client.state.currentUser!.copyWith(
    extraData: {
      'name': _fullNameController.text.trim().toString(),
      'image': linkImage,
    },
  ),);
      BlocProvider.of<UserBloc>(context).add(LoadUser());
    } on FirebaseException catch (e) {
      print(e);
    }
    }
    else{
      await firestore.collection('User').doc(id).update({
          "dateOfBirth": dateOfbirth,
          "email": _emailController.text.trim(),
          "fullName": _fullNameController.text.trim(),
          "gender": _selectedGender,
          "address": _addressController.text.trim(),
          "phone": _phoneController.text
      });
      await FirebaseAuth.instance.currentUser!.updateDisplayName(_fullNameController.text.trim());
      await FirebaseAuth.instance.currentUser!.updateEmail(_emailController.text.trim());
      await ChatUtil.client.updateUser(ChatUtil.client.state.currentUser!.copyWith(
    extraData: {
      'name': _fullNameController.text.trim().toString(),
    },
  ),);
    }
    
  }
  Widget GenderSelection(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Giới tính",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: CustomColor.grey),),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Nam",style: TextStyle(fontSize: 16)),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedGender="Male";
                });
              },
              child: Icon(_selectedGender=="Male"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Male"?CustomColor.blue:CustomColor.grey ,),
            ),
            SizedBox(width: 20,),
            Text("Nữ",style: TextStyle(fontSize: 16),),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedGender="Female";
                });
              },
              child: Icon(_selectedGender=="Female"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Female"?CustomColor.blue:CustomColor.grey ,),
            ),
            SizedBox(width: 20,),
            Text("Khác",style: TextStyle(fontSize: 16),),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedGender="Other";
                });
              },
              child: Icon(_selectedGender=="Other"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Other"?CustomColor.blue:CustomColor.grey ,),
            ),
          ],
        ),
      ],
    );
  }
}

// class GenderSelection extends StatefulWidget {
//   GenderSelection({super.key,required this.selectedGender});

//   @override
//   _GenderSelectionState createState() => _GenderSelectionState();
//   String selectedGender;
// }

// class _GenderSelectionState extends State<GenderSelection> {
//   String? _selectedGender="Male";

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Gender",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
//           SizedBox(height: 10,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text("Male",style: TextStyle(color: Colors.white,fontSize: 16)),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     _selectedGender="Male";
//                   });
//                 },
//                 child: Icon(_selectedGender=="Male"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Male"?CustomColor.green:Colors.white ,),
//               ),
//               SizedBox(width: 20,),
//               Text("Female",style: TextStyle(color: Colors.white,fontSize: 16),),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     _selectedGender="Female";
//                   });
//                 },
//                 child: Icon(_selectedGender=="Female"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Female"?CustomColor.green:Colors.white ,),
//               ),
//               SizedBox(width: 20,),
//               Text("Other",style: TextStyle(color: Colors.white,fontSize: 16),),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     _selectedGender="Other";
//                   });
//                 },
//                 child: Icon(_selectedGender=="Other"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Other"?CustomColor.green:Colors.white ,),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }