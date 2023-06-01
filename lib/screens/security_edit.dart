import 'package:checkin/screens/login_page.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/apis_list.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
   TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool validatePassword() {
    if (_password == _confirmPassowrd) {
      return true;
    } else {
      return false;
    }
  }
bool _isPassword = false;
bool _loading=false;
final bool _isCurrentPassword = false;
final bool _isConfirmPassword = false;
late String _password = "",
_currentPassword="", 
_confirmPassowrd="";
  Profile? _profile; 
  String _errorMessage = "";
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

  submit(){
   setState(() {
      _errorMessage = "";
     _loading=true;
    });
        var data= {"new_password":_password,"account":"2","shared_id":_profile!.classes_registered};
    var url= 'update_password.php';
    if(_currentPassword!=_profile!.classes_registered){
          setState(() {
                  _loading=false;
                  _errorMessage = "Invalid current password";
                });
          }else{
         Patch(data, url, (result,error)=>{
    
       if (result == null)
          {
                  setState(() {
                  _loading=false;
                  _errorMessage = error;
                }),
              }
              else
                {

                  setState(() {
                  _loading=false;
                  
                }),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()),
                  )
                }
    });
}

    
  
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: const Text(
          "Security",
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
        ),
        backgroundColor: const Color(0xff008346),
      ),
       body: Form(
          key: _formKey,
         child: SingleChildScrollView(
           child: Column(children:<Widget> [
                        SizedBox(
                    
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: TextFormField(
                        controller: currentPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Currently Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            gapPadding: 5.0,
                          ),
                        ),
                        validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter current password';
                        } else {
                           setState(() {
                          _currentPassword = value;
                      });
                        }
                        return null;
                      },
                      onSaved: (value) => _currentPassword = value!,
                       onChanged: (value) {
                  setState(() {
                    _currentPassword = value;
                  });
                },
                      ),
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: TextFormField(
                          controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            gapPadding: 5.0,
                          ),
                                    ),
                  validator: (value) {
                  if (value!.isEmpty) {
                    setState(() {
                      _isPassword = false;
                    });
                    return 'Please enter a password';
                  } else {
                    setState(() {
                      _isPassword = true;
                    });
                    if(isPasswordValid(value)!=""){
                      return isPasswordValid(value);
                    }else{
                      return null;
                    }
                  }
                },
                onSaved: (value) => _password = value!,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                                  ),
                      ),
                    ),
                
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: TextFormField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                            labelText: 'confirm password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              gapPadding: 10.0,
                            )),
                        obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter confirm password';
                  } else {
                    if (value != _password) {
                      return 'password does not match';
                    }
                  }
                
                  return null;
                },
                onEditingComplete: () {
                  _confirmPassowrd= confirmPasswordController.text;
                  if (!validatePassword()) {
                    // Show an error message or perform some other action
                  }
                },
                onSaved: (value) => _confirmPassowrd = value!,
                      ),
                    ),
                  ),
                      ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff008346),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                     if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  submit();
                }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Change Password'),
                  ),
                ),
                        _loading?  const Center(
               child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff008346)), 
              ), 
              SizedBox(height: 8),
              Text(
                'Loading...',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
               ),
             ):Container()  
                  ]),
         ),
         
       )
       
    );
  }
}