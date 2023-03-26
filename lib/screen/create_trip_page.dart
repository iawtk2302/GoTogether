import 'dart:convert';
import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/widget/custom_button.dart';
import 'package:go_together/widget/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  List<DateTime?> _dates=[];
  File? _file;
  int quantity=1;
  final storage = FirebaseStorage.instance.ref();
  var formatter = DateFormat('dd-MM-yyyy');
  final _titleController=TextEditingController();
  final _descriptionController=TextEditingController();
  bool isLoading=true;
  List<String> items = [];
  String? selectedValue;
  Future<void> getProvince()async{
    // List<String> temp=[];
    final encoding = Encoding.getByName('utf-8');
    var url = Uri.parse("https://provinces.open-api.vn/api/?depth=1");
    var response = await http.get(url);
    var x= jsonDecode(utf8.decode(response.bodyBytes));
    x.forEach((e){
      items.add(e["name"]);
    });
    setState(() {
      isLoading=false;
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
      body:isLoading?CircularProgressIndicator(): SafeArea(
        child: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("My trip photo",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text("Pick photo for my trip",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: CustomColor.grey),),
            SizedBox(height: 10,),
            InkWell(
              onTap: _chooseImage,
              child:_file==null? Container(
                height: 250,  
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CustomColor.grey,
                ),
                child: Center(child: Icon(Icons.add_circle,size: 30,color: Colors.white,),),
              ):ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.file(_file!,height: 250,fit: BoxFit.cover,width: double.infinity,)),
            ),
            SizedBox(height: 10,),
            Text("Destination",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Container(
              height: 60,
              child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                                    'Select Destination',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                        ),
                      ),
                      items: items
                    .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
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
                      buttonStyleData:  ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: CustomColor.grey,width: 2
              ),
                        ),
                        
              height: 50,
              width: double.infinity,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
              height: 50,

                      ),
                    ),
                  ),
            ),
            SizedBox(height: 10,),
            CustomTextFormField(
              textEditingController: _titleController,
              title: "Titile",
              hint: "Your trip title",
            ),
            // SizedBox(height: 10,),
            
            SizedBox(height: 10,),
            Text(
            "Date",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: () async{
                var results = await showCalendarDatePicker2Dialog(
  context: context,
  config: CalendarDatePicker2WithActionButtonsConfig(
    calendarType: CalendarDatePicker2Type.range,
    firstDate:DateTime.now()
  ),
  
  dialogSize: const Size(325, 400),
  value: _dates,
  borderRadius: BorderRadius.circular(15),
);

setState(() {
  _dates=results!;
});
// setState(() {
//   _dates.addAll(results!);
// });
              },
              child: Row(children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Date start",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                    SizedBox(height: 5,),
                    Text(_dates.length==0?"--|--":formatter.format(_dates[0]!),style: TextStyle(fontSize: 16),)
                ],)),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Date end",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                    SizedBox(height: 5,),
                    Text(_dates.length==0?"--|--":formatter.format(_dates[_dates.length-1]!),style: TextStyle(fontSize: 16),)
                ],)),
              ],),
            ),
            SizedBox(height: 10,),
            Text(
            "Quantity",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              IconButton(onPressed: () {
                setState(() {
                  if(quantity>1){
                  quantity-=1;
                }
                });
              }, icon: Icon(Icons.remove,color: Colors.white)),
              Text(quantity.toString()),
              IconButton(onPressed: () {
                setState(() {
                  quantity+=1;
                });
              }, icon: Icon(Icons.add,color: Colors.white,))
            ],),
            CustomTextFormField(
              textEditingController: _descriptionController,
              height: 130,
              minLines: 6,
              maxLines: 8,
              title: "Description",
              hint: "Descripe your trip",
            ),
            SizedBox(height: 30,),
            CustomButton(onPressed: CreateTrip, text: "Create"),
            SizedBox(height: 30,),
          ],),
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,color: Colors.white),
                  ),
                  const Text("Choose Your Trip Picture",style: TextStyle(color: Colors.white),),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: "Take Photo",
                    onPressed: _getImageCamera,
                  ),
                  SizedBox(height: 15,),
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
  CreateTrip()async{
    final trips = FirebaseFirestore.instance.collection('Trip');
    // final task = await storage.child("$id.jpg").putFile(_file!);
    // final linkImage = await task.ref.getDownloadURL();
    await trips.add({
      "destination":selectedValue,
      "title":_titleController.text.trim(),
      "dateStart":_dates[0],
      "dateEnd":_dates[1],
      "quantity":quantity,
      "description":_descriptionController.text.trim(),
      "isActive":true
    }).then((value) async{
      final task = await storage.child("${value.id}.jpg").putFile(_file!);
      final linkImage = await task.ref.getDownloadURL();
      trips.doc(value.id).update({
        "idTrip":value.id,
        "image":linkImage
      });
    });
  }
}