import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  borderColor: Theme.of(context).primaryColor,
                  borderRadius: 10,
                  borderLength: 20,
                  borderWidth: 10,
                  cutOutSize: MediaQuery.of(context).size.width * 0.7),
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
        await showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 500,
              child: Center(
                child: ElevatedButton(child: Text("Yêu Cầu"), onPressed: ()async{
                  final data= jsonDecode(result!.code!);
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
              ),
            );
          },
        );
        isFirst = true;
        
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
