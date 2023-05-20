import 'dart:async';

import 'package:checkin/screens/reset_password.dart';
import 'package:checkin/utils/apis_list.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotOtpPage extends StatefulWidget {
  const ForgotOtpPage({super.key});
  @override
  State<ForgotOtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<ForgotOtpPage> {
  OtpFieldController otpController = OtpFieldController();
  String otp ="";
  String email="";
  String _errorMessage="";
  bool loading=false;
  @override
  void initState() {
    super.initState();
    loaduserdata();
 
  }
  Future <void> loaduserdata() async{
      final prefs = await SharedPreferences.getInstance();
       setState(() {
      email= prefs.getString("email")!;
      });
  }

 
  submit(pin){
     setState(() {
      });
      loading=true;
     var data={"email":email,"account":"2","otp":pin};
     var url="forgot_password_validate_otp.php";
      post(data, url, (result,error)=>{
        loading=false,
          if(result==null)
          {
          
           setState((){
             _errorMessage="Invalid OTP";
           })
         
          }else{
               Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPassword()),
                  )
          }
      });
    
  }
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          "OTP screen",
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
        ),
        backgroundColor: const Color(0xff008346),
      ),
      body: 
      SingleChildScrollView(
        child: Column(
          children: [
              Container(
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
                  image: AssetImage("assets/images/logo_jpg.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Text("Email Validation",style: TextStyle(fontWeight: FontWeight.bold)),
                Image(
                  height:120,
                  image: AssetImage("assets/images/email.png"),
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60,vertical: 20),
                  child: Text("An email was sent to your address to confirm on its validity and" 
                  "ownership. Please enter the 6-digit code sent to validate your account",style: TextStyle(fontStyle: FontStyle.italic)),
                ),
              ],
            ),
          ),

          _errorMessage != ""
                  ? Container(
                      height: 20,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        "$_errorMessage",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : Container(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Text(email,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue))),
            Center(
              child: OTPTextField(
                  controller: otpController,
                  length: 6,

                  width: MediaQuery.of(context).size.width,
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldWidth: 45,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 15,
                  style: TextStyle(fontSize: 17),
                  onChanged: (pin) {
                    //  setState(() {
                    //       error="";
                    //     });
                  },
                  onCompleted: (pin) {
                    submit(pin);
                  }),
            ),
      
                     loading?  Center(
               child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0xff008346)), 
              ), 
              SizedBox(height: 8),
              Text(
                'Loading...',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
               ),
             ):Container()  
                  
          ],
        ),
      ),
    );
  }
}