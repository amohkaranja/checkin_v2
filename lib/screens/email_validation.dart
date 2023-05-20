import 'package:checkin/screens/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/apis_list.dart';
import 'forgot_otp.dart';

class EmailValidation extends StatefulWidget {
  const EmailValidation({super.key});

  @override
  State<EmailValidation> createState() => _EmailValidationState();
}

class _EmailValidationState extends State<EmailValidation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = true;
    bool _loading=false;
  bool _validateEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }
  late String email = "",_errorMessage = "";
   submit() {
     _loading=true;
    setState(() {
      _errorMessage = "";
    });
    var data = {
      "email": email,
    };
  
      post(
          data,
          "forgot_password.php",
          (result, error) => {
                if (result == null)
                  {
                    setState(() {
                      _errorMessage = error;
                      _loading=false;
                    }),
                    
              
                  }
                else{
                  saveEmail(),
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotOtpPage()),
                )
                }
              });
    
  }
  saveEmail() async{
     setState(() {
                     
                      _loading=false;
                    });
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('email', email);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          "Email Validation",
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
        ),
        backgroundColor: const Color(0xff008346),
      ),
      body: Column(
        children: [
                 Container(
             
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0,),
                child: Container(
                  height: 140,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xff008346),width: 2.0),
                      ),
                  child: const Image(
                    image: AssetImage("assets/images/logo_jpg.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(key: _formKey,child: Column(
          children: [
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
          
                const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Email',
                  errorText:
                      _isEmailValid ? null : 'Please enter a valid email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    gapPadding: 5.0,
                  )),
              controller: _emailController,
              onChanged: (text) {
                setState(() {
                  _isEmailValid = _validateEmail(text);
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
              onSaved: (value) => email = value!,
            ),
               const SizedBox(
              height: 10.0,
            ),
             ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff008346),
              ),
              onPressed: () {
                
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  submit();
                  // Use _username and _password to log in
                }
              },
              child: const Text('Submit'),
            ),
                  _loading?  Center(
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
        ),),
      )
        ],
      ),
    );
  }
}