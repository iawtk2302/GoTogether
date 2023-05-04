import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';

import '../model/notification.dart';
import '../utils/firebase_utils.dart';
import '../utils/toasty.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isFirst = true;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }
  void scanQRFromImage() async {
  try {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    String? result = await Scan.parse(pickedFile.path);
    final data=jsonDecode(result!);
    await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                color: Colors.white
              ),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(40)
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          // height: 100,
                          // width: 100,
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(30)
                          // ),
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(data['image'],height: 60, width: 60,fit: BoxFit.cover,),),
                      )),
                        Flexible(child: Text(data['title'],style: TextStyle(fontWeight: FontWeight.w600),),),
                  ],),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: CustomColor.blue
                        ),
                        child: Center(child: Text("Yêu cầu tham gia",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                      ),
                    ), 
                  onTap: ()async{
                    MyNotification notification = MyNotification(
                      idNoti: '',
                      idReceiver: data['idCreator'],
                      idSender: FirebaseUtil.currentUser!.uid,
                      idTrip: data['idTrip'],
                      fullName: FirebaseUtil.currentUser!.displayName ?? "",
                      imgAva: FirebaseUtil.currentUser!.photoURL ?? "",
                      title: data['title'],
                      type: 'tripRequest',
                      status: 'pending',
                      createAt: Timestamp.fromDate(DateTime.now())
                      );

                  final count = await FirebaseFirestore.instance
                      .collection('Notification')
                      .where("idSender", isEqualTo: FirebaseUtil.currentUser!.uid)
                      .where("idTrip", isEqualTo: data['idTrip'])
                      .get();

                  if (count.docs.isEmpty) {
                    await FirebaseFirestore.instance
                        .collection('Notification')
                        .add(notification.toJson())
                        .then((value) async {
                      await FirebaseFirestore.instance
                          .collection('Notification')
                          .doc(value.id)
                          .update({"idNoti": value.id});
                    });
                  } else {
                    Toasty.show('Bạn đã yêu cầu tham gia rồi',
                        type: ToastType.warning);
                  }
                  },),
                ],
              ),
            );
          },
        );
    // Đọc mã QR từ ảnh
    // final imageBytes = await pickedFile.readAsBytes();
    // final bc = Barcode.qrCode();
    // final result = bc.decode(imageBytes);
    // final qrCodeData = result?.payload;

    // Xử lý dữ liệu mã QR (qrCodeData)
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('QR Code data: $qrCodeData')));
  } catch (e) {
    // Xử lý lỗi
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  borderColor: Theme.of(context).primaryColor,
                  borderRadius: 10,
                  borderLength: 20,
                  borderWidth: 10,
                  cutOutSize: MediaQuery.of(context).size.width * 0.65),
            ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  // color: Colors.white,
                  width: size.width,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    InkWell(
                      onTap: (){Navigator.pop(context);},
                      child: Icon(Icons.chevron_left,color: Colors.white,)),
                    Text("Quét", style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white, fontSize: 16),),
                    InkWell(
                      onTap: (){
                        scanQRFromImage();
                      },
                      child: Text("Ảnh",style: TextStyle(color: Colors.white),)),
                  ],),
                ),
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: Center(
            //     child: (result != null)
            //         ? Text(
            //             'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
            //         : Text('Scan a code'),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async{
      setState(() {
        result = scanData;
      });
      if (isFirst) {
        if (isFirst) {
          isFirst = false;
        }
        final data= jsonDecode(result!.code!);
        await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                color: Colors.white
              ),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(40)
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          // height: 100,
                          // width: 100,
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(30)
                          // ),
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(data['image'],height: 60, width: 60,fit: BoxFit.cover,),),
                      )),
                        Flexible(child: Text(data['title'],style: TextStyle(fontWeight: FontWeight.w600),),),
                  ],),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: CustomColor.blue
                        ),
                        child: Center(child: Text("Yêu cầu tham gia",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                      ),
                    ), 
                  onTap: ()async{
                    MyNotification notification = MyNotification(
                      idNoti: '',
                      idReceiver: data['idCreator'],
                      idSender: FirebaseUtil.currentUser!.uid,
                      idTrip: data['idTrip'],
                      fullName: FirebaseUtil.currentUser!.displayName ?? "",
                      imgAva: FirebaseUtil.currentUser!.photoURL ?? "",
                      title: data['title'],
                      type: 'tripRequest',
                      status: 'pending',
                      createAt: Timestamp.fromDate(DateTime.now())
                      );

                  final count = await FirebaseFirestore.instance
                      .collection('Notification')
                      .where("idSender", isEqualTo: FirebaseUtil.currentUser!.uid)
                      .where("idTrip", isEqualTo: data['idTrip'])
                      .get();

                  if (count.docs.isEmpty) {
                    await FirebaseFirestore.instance
                        .collection('Notification')
                        .add(notification.toJson())
                        .then((value) async {
                      await FirebaseFirestore.instance
                          .collection('Notification')
                          .doc(value.id)
                          .update({"idNoti": value.id});
                    });
                  } else {
                    Toasty.show('Bạn đã yêu cầu tham gia rồi',
                        type: ToastType.warning);
                  }
                  },),
                ],
              ),
            );
          },
        );
        isFirst = true;
        
      }
    });

  

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}}
