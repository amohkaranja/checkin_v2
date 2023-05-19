import 'dart:convert';
import 'package:checkin2/models/user_model.dart';
import 'package:checkin2/screens/class_instance.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../screens/registered_classes.dart';
import '../screens/scanned_classes.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';



const api = "http://admin.check-in.co.ke:71/";
// ignore: non_constant_identifier_names
/// login function
/// @param {JSON} data
/// @param{(error:JSON,result:JSON)} callback
void login(data, callback) async {
  final prefs = await SharedPreferences.getInstance();
 
  var url = Uri.parse("${api}student_login.php");
  var response = await http.post(url, body: data);
  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;

  // ignore: avoid_print
  if (jsonResponse["success"] == "2") {
     prefs.setString('password',data["password"]); 
    prefs.setString('student_id', jsonResponse['login'][0]['student_id']);
    prefs.setString('firstname', jsonResponse['login'][0]['firstname']);
    prefs.setString('lastname', jsonResponse['login'][0]['lastname']);
    prefs.setString('email', jsonResponse['login'][0]['email']);
    prefs.setString('phone', jsonResponse['login'][0]['phone']);
    prefs.setString('regNo', jsonResponse['login'][0]['regNo']);
    prefs.setString('student_profile', jsonResponse['login'][0]['student_profile']);
    prefs.setString('email_validation', jsonResponse['login'][0]['email_validation']);
   
        // ignore: void_checks
    if(jsonResponse['login'][0]['email_validation'].length>1){
      return callback("2", null);
    }else{
       return callback(jsonResponse["message"], null);
    }
    
    
  } else{
    callback(null, jsonResponse["message"]);
  }
  
}

void logout() async{
   print("logout");
}


Future<Profile> profileData() async {
  var profile= Profile();
   final prefs = await SharedPreferences.getInstance();
  profile.id= prefs.getString('student_id')!;
  profile.first_name = prefs.getString('firstname')!;
  profile.last_name= prefs.getString('lastname')!;
 profile.email= prefs.getString('email')!;
  profile.phone_number = prefs.getString('phone')!;
  profile.regNo = prefs.getString('regNo')!;
  profile.student_profile = prefs.getString('student_profile')!;
  String? emailValidation = prefs.getString('email_validation');
  profile.password=prefs.getString('password')!;
    return profile;

}
Future<bool> fetchDataAndSaveToPrefs() async {
  bool loading = true;
  // obtain shared preferences
  final prefs = await SharedPreferences.getInstance();
  String url = '${api}api/v1/institution/institutions/'; 
  var response = await http.get(Uri.parse(url));
  var data = json.decode(response.body);
  // Convert data to List<String>
  List<String> schools = [];
  if (data is List) {
    schools = List.castFrom(data);
  } else if (data is Map) {
  if (data != null && data["items"] != null) {
  data["items"].forEach((item) {
    schools.add("${item['institution_name']}:${item['id']}");
  });


}

  }
  // set value
  await prefs.setStringList("schools", schools);
  loading = false;
  
  return loading;
}


void post(dynamic data, String url, Function callback) async {
 
  var apiUrl = Uri.parse(api + url);
  var response = await http.post(apiUrl,body: data);
  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  if (jsonResponse["success"] == "1"||jsonResponse["success"] == "2") {
    // ignore: void_checks
    return callback("success", null);
  }else{
    callback(null, jsonResponse["message"]);
  }
  
}
void postScan(dynamic data, String url, Function callback) async{
  
  var apiUrl = Uri.parse(api + url);
  var response = await http.post(apiUrl,body: data);
  
  var jsonResponse =  await convert.jsonDecode(response.body) as Map<String, dynamic>;
  switch(jsonResponse["success"]) {
  case '1':
    callback("success", null);
    break;
  case '2':
    callback("2", {"model":ClassModel.fromJson(jsonResponse["scans"][0]),"stdId":data["student_id"],"qrData":data["qr_code"]});
    break;
  case '3':
    callback(null, "Already Signed in!");
    break;
  case '4':
    callback(null, "Failed to sign in!. Please try again");
    break;
    case '5':
    callback(null, "Failed to register!. Please try again");
    break;
}

}


void Patch(dynamic data, String url, Function callback) async {
  var apiUrl = Uri.parse(api + url);
  
  var response = await http.post(apiUrl,body: data);
   print(apiUrl); 
  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  if (jsonResponse["success"] == "2") {
    final prefs = await SharedPreferences.getInstance();
     prefs.setString('password',data["new_password"]);
    return callback("success", null);
  }
  callback(null, "An error occured during processing.Try later");
}

void get(String url,Function callback) async{
  var url = Uri.parse("${api}api/auth/users/me"); 
    var response=  await http.get(url,headers:  <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },);
  // print(response);
  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  // ignore: avoid_print
  if (response.statusCode == 200) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token",jsonResponse["access"]);
    // ignore: void_checks
    return callback(jsonResponse["message"], null);
  }
  callback(null, jsonResponse["message"]);
}
List<ScannedClass> parseResponseData(List<dynamic> response) {
  List<ScannedClass> attendances = [];

  for (var data in response) {
  
    ScannedClass attendance = ScannedClass.fromJson(data);
    attendances.add(attendance);
  }

  return attendances;
}
Future<dynamic> fetchScannedClasses() async {
    final prefs = await SharedPreferences.getInstance();
     var id= (prefs.getString("student_id"));
     var data ={"student_id":id};
       var url = Uri.parse("${api}load_history_scanned.php");
  var response = await http.post(url,body: data);
         

  if (response.statusCode == 200) {
  
  List<dynamic> responseData = json.decode(response.body);
 
   List<ScannedClass> scannedClassesList = parseResponseData(responseData);

   return ScannedClasses(scannedClassesList: scannedClassesList);
  } else {
    return "Error fetching scanned classes, try again later";
  }
}
Future<dynamic> fetch_Scanned_Registered() async{
   final prefs = await SharedPreferences.getInstance();
     var id= (prefs.getString("student_id"));
     var data ={"student_id":id};
     var url_scanned = Uri.parse("${api}load_history_scanned.php");
     var url_registred = Uri.parse("${api}load_registered_classes.php");
     var Scannedresponse = await http.post(url_scanned,body: data);
     List<dynamic> ScannedData = json.decode(Scannedresponse.body);
     var Registredresponse = await http.post(url_registred,body: data);
     List<dynamic> RegistredData = json.decode(Registredresponse.body);
     List<RegisteredClass> registeredClassesList = parseResponseJsonData(RegistredData);
     List<ScannedClass> scannedClassesList = parseResponseData(ScannedData);
     return ({"scan":scannedClassesList.length,"register":registeredClassesList.length});
}


List<RegisteredClass> parseResponseJsonData(List<dynamic> response) {
  List<RegisteredClass> registeredClasses = [];

  for (var data in response) {
  
    RegisteredClass classes = RegisteredClass.fromJson(data);
    registeredClasses.add(classes);
  }
  return registeredClasses;
}
Future<dynamic> fetchRegisteredClasses() async {
    final prefs = await SharedPreferences.getInstance();
     var id= (prefs.getString("student_id"));
     var data ={"student_id":id};
       var url = Uri.parse("${api}load_registered_classes.php");
  var response = await http.post(url,body: data);
         

  if (response.statusCode == 200) {
  
  List<dynamic> responseData = json.decode(response.body);
   List<RegisteredClass> registeredClassesList = parseResponseJsonData(responseData);
    return RegisteredClasses(registeredClasses: registeredClassesList);
  } else {
    return "Error fetching scanned classes, try again later";
  }
}


String  isPasswordValid(String password) {
    // Check if password is at least 8 characters long
    if (password.length < 8) {
      return "password must be at least 8 characters long";
    }

    // Check if password contains at least one special character
    RegExp specialCharRegex = RegExp(r'[!@#\$&\*~-]');
    if (!specialCharRegex.hasMatch(password)) {
      return "password must contains at least one special character";
    }

    // Check if password contains at least two digits
    RegExp digitRegex = RegExp(r'\d.*\d');
    if (!digitRegex.hasMatch(password)) {
      return "password must contains at least two digits";
    }

    // Check if password contains at least one uppercase letter
    RegExp upperCaseRegex = RegExp(r'[A-Z]');
    if (!upperCaseRegex.hasMatch(password)) {
      return "password must contains at least one uppercase letter";
    }

    // Check if password contains at least one lowercase letter
    RegExp lowerCaseRegex = RegExp(r'[a-z]');
    if (!lowerCaseRegex.hasMatch(password)) {
      return "password must contains at least one lowercase letter";
    }

    // If all conditions are met, return true
          return "";

  }
