import 'dart:async';

import 'package:checkin/screens/reset_password.dart';
import 'package:checkin/screens/student_home.dart';
import 'package:checkin/utils/apis_list.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key,required this.origin});
final String origin;
  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  OtpFieldController otpController = OtpFieldController();
  String studentId="";
  String otp ="";
  String email="";
  String error="";
  bool errorStat=false;
  bool loading=false;
 var _timer;
  bool _isRequestingOTP = false;
  int _countdown = 60;
  @override
  void initState() {
    super.initState();
    loaduserdata();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    if (_countdown > 0) {
      setState(() {
        _countdown--;
      });
    } else {
      _timer.cancel();
      _isRequestingOTP = false;
    }
  });
  }
  Future <void> loaduserdata() async{
      final prefs = await SharedPreferences.getInstance();
       setState(() {
      studentId= prefs.getString("student_id")!;
      otp= prefs.getString("email_validation")!;
      email= prefs.getString("email")!;
      });
  }
  clearUser() async{
 final prefs = await SharedPreferences.getInstance();
     prefs.setString('password',""); 
    prefs.setString('student_id', "");
    prefs.setString('firstname', "");
    prefs.setString('lastname', "");
    prefs.setString('email', "");
    prefs.setString('phone', "");
    prefs.setString('regNo', "");
    prefs.setString('student_profile', "");
    prefs.setString('email_validation',"");
        Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen()),
                  );
  }
  resendOtp(){
     var data={"student_id":studentId};
     var url="resend_student_email.php";
      post(data, url, (result,error)=>{
    
        loading=false,
          if(result==null){
          error="Request failed due to server error. Please try again later",
            errorStat=true
          }
      });
       _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    if (_countdown > 0) {
      setState(() {
        _countdown--;
      });
    } else {
      _timer.cancel();
      _isRequestingOTP = false;
    }
  });
  }
  submit(pin){
     setState(() {
       errorStat=false;
      });
    if(pin==otp){
      loading=true;
     var data={"student_id":studentId};
     var url="validate_student_account.php";
      post(data, url, (result,error)=>{
        loading=false,
          if(result==null){
          error="Request failed due to server error. Please try again later",
            errorStat=true
          }else{
            if(widget.origin=="reset"){
               Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPassword()),
                  )
            }else{
               Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentHomeScreen()),
                  )
            }
             
          }
      });
    }else{
      setState(() {
        error="Invalid OTP. Please try again later";
        errorStat=true;
      });
    }
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
                  "ownership. Please enter the 6-digit code sent to validate your account$otp",style: TextStyle(fontStyle: FontStyle.italic)),
                ),
              ],
            ),
          ),

         errorStat? Padding(padding:EdgeInsets.symmetric(horizontal: 8),child: Text(error,style: TextStyle(color: Colors.red),), ):Container(height: 1),
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
                    print("Changed: " + pin);
                  }),
            ),
            SizedBox(height: 20),
               ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff008346),
              ),
              onPressed: () {
                   if (!_isRequestingOTP) {
                    setState(() {
                       _isRequestingOTP = true;
                       _countdown=60;
                     });
                  resendOtp();
        } },
              child:  Text( _countdown > 0 ? '$_countdown seconds' : 'Request OTP',),
            ),
            Padding(
              child: Column(
                children: [
                  Text("Not your email?",style: TextStyle(color: Colors.red),),
                   GestureDetector(
                    onTap: (){
                      clearUser();
                    },
                    child: Text("Click here to change account",style: TextStyle(color: Colors.red),))
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10,
            
            )

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