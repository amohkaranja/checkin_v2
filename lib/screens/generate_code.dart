import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/apis_list.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateCode extends StatefulWidget {
  const GenerateCode({super.key});

  @override
  State<GenerateCode> createState() => _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> {
   Profile? _profile; 
     @override
void initState() {
  super.initState();
  loadProfileData();
  }
    Future<void> loadProfileData() async {
  final profile = await profileData();
   setState(() {
      _profile = profile; // assign the value of profile to _profile
    });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          "My QR Code",
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
        ),
        backgroundColor: const Color(0xff008346),
      ),
      body: Container(
          width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(children: [
            SizedBox(
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.white,
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
              Expanded(flex: 4, child: Container(
             child: QrImageView(
              data: _profile?.regNo??'',
              version: QrVersions.auto,
              size: 200,
              gapless: false,
            ),
          )),
        ]),
      ),
    );
  }
}