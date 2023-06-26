import 'package:checkin/screens/student_home.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ndialog/ndialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../utils/apis_list.dart';
import 'class_instance.dart';

class ClassScanII extends StatefulWidget {
  const ClassScanII({super.key});

  @override
  State<ClassScanII> createState() => _ClassScanIIState();
}

class _ClassScanIIState extends State<ClassScanII> {
   @override
  void initState() {
    super.initState();
    // Disable screenshots on this page.
    FlutterWindowManager.FLAG_SECURE;
  }
  Barcode? result;
  QRViewController?controller;
   String _errorMessage = "";
   bool isFlashon= false;
   late String lecturecode;
  bool isFrontCamera=false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'Qr');

  share_scan(){
      NAlertDialog(
              dialogStyle: DialogStyle(titleDivider: true),
              
              content: Container(
    width: MediaQuery.of(context).size.width * 0.8,
    height: MediaQuery.of(context).size.height * 0.5,
    child: Center(
      child:QrImageView(
               data:lecturecode,
              version: QrVersions.auto,
              size: 200,
              gapless: false,
            )
    ),
  ),
              actions: <Widget>[
                TextButton(
                    child: Text("Okay"),
                    onPressed: () =>  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentHomeScreen()),
                  )),
                TextButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentHomeScreen()),
                  )),
              ],
            ).show(context);
  }
 
 submit(Code){
 
    var data={"lecture_code":Code,"verification_type":"QRCODE"};
    var url="api/v1/platform/lecture_attendances";
      setState(() {
      _errorMessage = "";
      lecturecode=Code;
    });
postScan(data, url, (result, error) => {
              if (result == null)
                {
                  setState(() {
                }),
                  setState(() {
                    _errorMessage = error;
                  })
                }
                else if(result=="2"){
               
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassInstance(model:error["model"])),
                  )
              
                }
              else
                {
                    setState(() {
                }),
               
             share_scan()
                }
            });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        actions: [
           IconButton(onPressed: (){
            setState(() {
              isFlashon=!isFlashon;
             controller?.toggleFlash();
            });
          }, icon: Icon(Icons.flash_on,color:isFlashon?Colors.blue: Colors.white,)),
            IconButton(onPressed: (){
        setState(() {
              isFrontCamera=!isFrontCamera;
             controller?.flipCamera();
            });

          }, 
          icon: Icon(Icons.camera_front,color:isFrontCamera?Colors.blue: Colors.white,))
        ],
         centerTitle: true,
        title: const Text(
          "Scan Class",
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
        ),
        backgroundColor: const Color(0xff008346),
      ),
      body: Container(
          width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
               Expanded(
                flex: 1,
                 child: SizedBox(
                           width: double.infinity,
                           child: Card(
                             shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                             child: Container(
                  
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow:  [
                        BoxShadow(
                            color: Theme.of(context).primaryColor,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3))
                      ]),
                  child: const Image(
                    height:120,
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain,
                  ),
                             ),
                           ),
                         ),
               ),
                 Expanded(
                  flex: 1,
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                  _errorMessage != ""
                  ? Container(
                      height: 20,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : Container(height: 1),
           const Text("Place the QR code in the area",
           style: TextStyle(
             color: Colors.black87,
             fontSize: 18,
             fontWeight: FontWeight.bold,
             letterSpacing: 1
           ),
           ),
           const SizedBox(
             height: 10,
           ),
            const Text("Scanning will be started automatically",
           style: TextStyle(
             color: Colors.black54,
             fontSize: 16,
             fontWeight: FontWeight.bold,
             letterSpacing: 1
           ),)
              ],
            )),
          Expanded(
            flex: 4,
            child: _buildQrView(context)),
             Expanded(
              flex: 1,
              child: Container(
            alignment: Alignment.center,
            child:  const Text("powered by Javan informatics",
           style: TextStyle(
             color: Colors.black54,
             fontSize: 14,
             fontWeight: FontWeight.bold,
             letterSpacing: 1
           ),),
          ))
          ],
        ),
      ),
    );
  }
  Widget _buildQrView(BuildContext context){
var scanArea =(MediaQuery.of(context).size.width<400||MediaQuery.of(context).size.height<400)?150:300;

  return QRView(key: qrKey, onQRViewCreated: _onQRViewCreated,overlay: QrScannerOverlayShape(
    borderColor: Colors.red,
    borderRadius: 10,
    borderLength: 30,
    borderWidth: 10,
    cutOutSize: scanArea.toDouble()),);
}



void _onQRViewCreated(QRViewController controller){
    setState(() {
      this.controller=controller;
    });
    controller.scannedDataStream.listen((scanData) {
        if (mounted) {
      controller.dispose();
        submit(scanData.code);
      
    }
     
     });
}
}
