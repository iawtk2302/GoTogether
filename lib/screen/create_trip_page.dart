import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/repository/chat_repository.dart';
import 'package:go_together/utils/firebase_utils.dart';
import 'package:go_together/widget/custom_app_bar.dart';
import 'package:go_together/widget/custom_button.dart';
import 'package:go_together/widget/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../widget/loading.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final activities = {
    "Bơi": "🏊‍♀️",
    "Cắm trại": "🏕️",
    'Leo núi': "🧗",
    "Quay phim": "🎥",
    "Chụp ảnh": "📷",
    "Câu cá": "🪝",
    "Nhảy dù": "🪂",
    "Nấu ăn": "🍚",
    "Lặn": "🤿",
    "Tình nguyện": "🫶",
    "Lễ hội âm nhạc": "🎶",
    "Trải nghiệm văn hóa địa phương": "🏘️",
  };
  List<DateTime?> _dates = [];
  File? _file;
  int quantity = 1;
  final storage = FirebaseStorage.instance.ref();
  var formatter = DateFormat('dd-MM-yyyy');
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool isLoading = true;
  List<String> items = [];
  String? selectedValue;
  List<int> activitiesChoose = [];
  void clear() {
    quantity = 1;
    _dates.clear();
    _file = null;
    _titleController.clear();
    _descriptionController.clear();
    selectedValue = null;
    setState(() {});
  }

  Future<void> getProvince() async {
    // List<String> temp=[];
    final encoding = Encoding.getByName('utf-8');
    var url = Uri.parse("https://provinces.open-api.vn/api/?depth=1");
    var response = await http.get(url);
    var x = jsonDecode(utf8.decode(response.bodyBytes));
    x.forEach((e) {
      items.add(e["name"]);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getProvince();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.bg,
      appBar: CustomAppBar(title: "Tạo chuyến đi"),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "Create Your Trip",
                    //   style:
                    //       TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: _chooseImage,
                      child: _file == null
                          ? DottedBorder(
                              dashPattern: [4, 5, 4, 5],
                              color: CustomColor.grey,
                              strokeWidth: 2,
                              borderType: BorderType.RRect,
                              padding: EdgeInsets.all(6),
                              radius: Radius.circular(15),
                              child: Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: CustomColor.blue1,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_circle,
                                    size: 30,
                                    color: CustomColor.grey,
                                  ),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.file(
                                _file!,
                                height: 250,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: CustomColor.blue1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Stack(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: Text(
                                    'Chọn nơi đến',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColor.grey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  items: items
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value as String;
                                    });
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: CustomColor.bg,
                                    ),
                                  ),
                                  buttonStyleData: ButtonStyleData(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: CustomColor.blue1),
                                    height: 50,
                                    width: double.infinity,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 50,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                left: 0,
                                top: 10,
                                child: Text(
                                  "Nơi đến",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: CustomColor.grey),
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      textEditingController: _titleController,
                      title: "Tiêu đề",
                      hint: "Tiêu đề chuyến đi",
                    ),
                    // SizedBox(height: 10,),

                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        var results = await showCalendarDatePicker2Dialog(
                          context: context,
                          config: CalendarDatePicker2WithActionButtonsConfig(
                              calendarType: CalendarDatePicker2Type.range,
                              firstDate: DateTime.now()),
                          dialogSize: const Size(325, 400),
                          value: _dates,
                          borderRadius: BorderRadius.circular(15),
                        );

                        setState(() {
                          _dates = results!;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    color: CustomColor.blue1,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Ngày bắt đầu",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: CustomColor.grey),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        _dates.length == 0
                                            ? "--/--/----"
                                            : formatter.format(_dates[0]!),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: _dates.length == 0
                                                ? CustomColor.grey
                                                : Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    color: CustomColor.blue1,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Ngày kết thúc",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: CustomColor.grey)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        _dates.length == 0
                                            ? "--/--/----"
                                            : formatter.format(
                                                _dates[_dates.length - 1]!),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: _dates.length == 0
                                                ? CustomColor.grey
                                                : Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: CustomColor.blue1,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Số thành viên",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: CustomColor.grey),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text("$quantity người",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (quantity > 1) {
                                          quantity -= 1;
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.remove,
                                        color: Colors.black)),
                                Text(quantity.toString()),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        quantity += 1;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildActivities(),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                      textEditingController: _descriptionController,
                      height: 130,
                      minLines: 6,
                      maxLines: 8,
                      title: "Mô tả",
                      hint: "Thêm mô tả cho chuyến đi của bạn",
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomButton(onPressed: CreateTrip, text: "Tạo"),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )),
            ),
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
  }

  void _chooseImage() {
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
                    "Upload Photo",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    "Choose Your Trip Picture",
                    style: TextStyle(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: "Take Photo",
                    onPressed: _getImageCamera,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                    text: "Choose From Library",
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

  Future<bool> isTripDateValid(Timestamp startDate, Timestamp endDate) async {
    final trips = FirebaseUtil.trips;

    // Query documents where 'dateStart' is less than or equal to the endDate of the new trip
    final query1 = trips.where('dateStart', isLessThan: endDate);

    // Query documents where 'dateEnd' is greater than or equal to the startDate of the new trip
    final query2 = trips.where('dateEnd', isGreaterThan: startDate);

    // Get the results of both queries
    final snapshot1 = await query1.get();
    final snapshot2 = await query2.get();

    // Combine the results using Set to remove duplicate documents
    final overlappingTrips =
        <QueryDocumentSnapshot>{...snapshot1.docs, ...snapshot2.docs}.toList();

    // Check if there are overlapping trips
    bool isValid = true;
    for (final trip in overlappingTrips) {
      final tripStartDate = trip['dateStart'] as Timestamp;
      final tripEndDate = trip['dateEnd'] as Timestamp;
      if (startDate.compareTo(tripEndDate) <= 0 &&
          endDate.compareTo(tripStartDate) >= 0) {
        isValid = false;
        break;
      }
    }

    return isValid;
  }

  CreateTrip() async {
    FocusScope.of(context).unfocus();
    if (_file == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Lỗi ảnh',
        desc: 'Bạn chưa thêm ảnh cho chuyến đi',
        btnCancelOnPress: () {},
      ).show();
      return;
    }
    final dateStart =
        Timestamp.fromMillisecondsSinceEpoch(_dates[0]!.millisecondsSinceEpoch);
    final dateEnd =
        Timestamp.fromMillisecondsSinceEpoch(_dates[1]!.millisecondsSinceEpoch);
    final check = await isTripDateValid(dateStart, dateEnd);
    if (!check) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Lỗi thời gian',
        desc: 'Thời gian chuyến đi trùng với một chuyến đi khác của bạn',
        btnCancelOnPress: () {},
      ).show();
      return;
    }

    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.7),
        context: context,
        builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: MyLoading()));

    final listActivities = [];

    for (var e in activitiesChoose) {
      listActivities.add(activities.keys.elementAt(e));
    }

    final trips = FirebaseFirestore.instance.collection('Trip');
    await trips.add({
      "destination": selectedValue,
      "title": _titleController.text.trim(),
      "dateStart": _dates[0],
      "dateEnd": _dates[1],
      "quantity": quantity,
      "description": _descriptionController.text.trim(),
      "members": [
        {
          "idUser": FirebaseUtil.currentUser!.uid,
          "image": FirebaseUtil.currentUser!.photoURL,
          "lat": "",
          "lng": ""
        }
      ],
      "status": "pending",
      "activities": listActivities,
      "idCreator": FirebaseUtil.currentUser!.uid,
      "membersId": [FirebaseUtil.currentUser!.uid],
    }).then((value) async {
      final task = await storage.child("${value.id}.jpg").putFile(_file!);
      final linkImage = await task.ref.getDownloadURL();
      trips.doc(value.id).update({
        "idTrip": value.id,
        "image": linkImage,
      });
      Navigator.pop(context);

      await ChatRepository().CreateGroupChannel(
          context: context,
          idTrip: value.id,
          image: linkImage,
          title: _titleController.text.trim().toString());
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Tạo thành công!',
        desc: 'Chuyến đi của bạn đã được tạo thành công',
        btnOkOnPress: () {},
      ).show();
      clear();
    });
    // Navigator.pop(context);
  }

  Widget _buildActivities() {
    return SizedBox(
      height: 235,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Hoạt động',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Center(
                child: activities.isEmpty
                    ? const Text(
                        'Không có hoạt động nào',
                        style: TextStyle(color: Colors.black),
                      )
                    : Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: List.generate(
                          activities.keys.length,
                          (index) => _buttonActivity(
                              activities.keys.elementAt(index).toString(),
                              activities.values.elementAt(index).toString(),
                              index),
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonActivity(text, icon, index) {
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: () {
            if (!activitiesChoose.contains(index)) {
              activitiesChoose.add(index);
            } else {
              activitiesChoose.remove(index);
            }
            setState(() {});
          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: CustomColor.buttonActivityBgColor.withOpacity(.5),
                  border: Border.all(
                      color: activitiesChoose.contains(index)
                          ? CustomColor.blue
                          : Colors.transparent)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                children: [
                  Text(icon),
                  Text(' ${text}'),
                ],
              )),
        ),
      ),
      SizedBox(
        width: 6,
      ),
    ]);
  }
}
