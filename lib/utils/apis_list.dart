import 'dart:convert';
import 'package:checkin/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../screens/registered_classes.dart';
import '../screens/scanned_classes.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';



const api = "https://admin.check-in.co.ke:6700/";
// ignore: non_constant_identifier_names
/// login function
/// @param {JSON} data
/// @param{(error:JSON,result:JSON)} callback
void login(data, callback) async {
  final prefs = await SharedPreferences.getInstance();
 
  var url = Uri.parse("${api}api/auth/jwt/login/");
  print(data);
   var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data));
  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;

  // ignore: avoid_print
  if (jsonResponse["responseCode"] == 0) {
    
    AuthToken token = AuthToken.fromJson(jsonResponse['data']);
    var url = Uri.parse("${api}api/auth/users/me"); 
    var newresponse=  await http.get(url,headers:  <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'Bearer ${token.access}',
      },);
  // print(response);
  var newjsonResponse = convert.jsonDecode(newresponse.body) as Map<String, dynamic>;
  UserModel user = UserModel.fromJson(newjsonResponse['data']);
    prefs.setString('access',token.access); 
    prefs.setString('refresh',token.refresh); 
    prefs.setString('pid',user.pid);
    var newurl = Uri.parse("${api}api/v1/platform/students/?user_pid=${user.pid}"); 
    var newresponse2 =  await http.get(newurl,headers:  <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'Bearer ${token.access}',
      },); 
  var newjsonResponse2 = convert.jsonDecode(newresponse2.body) as Map<String, dynamic>;
  prefs.setString('student_id',newjsonResponse2['items'][0]['id']); 
        // ignore: void_check
     callback("Success", null);
  } else if(jsonResponse["responseCode"] == 1){
    callback(null, "Invalid User or password");
  }else{
    callback(null, "Error occured, Please try again later");
  }
  
}

void logout() async{
   print("logout");
}


Future<Profile> profileData() async {
   final prefs = await SharedPreferences.getInstance();
   var token= prefs.getString('access')!;
   var pid= prefs.getString('pid')!;
   var url = Uri.parse("${api}api/v1/platform/students/?user_pid=$pid"); 
    var response=  await http.get(url,headers:  <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'Bearer ${token}',
      },);
  var result = convert.jsonDecode(response.body) as Map<String, dynamic>;
  Profile profile = Profile.fromJson(result['items'][0]);
    return profile;

}
Future<bool> fetchDataAndSaveToPrefs() async {
  bool loading = true;
  // obtain shared preferences
  final prefs = await SharedPreferences.getInstance();
  String url = '${api}api/v1/institution/institutions'; 
  var response = await http.get(Uri.parse(url));
  var data = json.decode(response.body);
  // Convert data to List<String>
  List<String> schools = [];
  if (data is List) {
    schools = List.castFrom(data);
  } else if (data is Map) {
  if (data["items"] != null) {
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
   final prefs = await SharedPreferences.getInstance();
     var token= (prefs.getString("access"));
  var apiUrl = Uri.parse(api + url);
  var response = await http.post(apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'Bearer ${token!}',
      },
      body: jsonEncode(data));

  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  if (response.statusCode == 201) {
    // ignore: void_checks
    return callback("success", null);
  }
  callback(null, jsonResponse["message"]);
}
void register(dynamic data, String url, Function callback) async {
  var apiUrl = Uri.parse(api + url);
  var response = await http.post(apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(data));

  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  if (jsonResponse["responseCode"] == 0) {
    // ignore: void_checks
    return callback("success", null);
  }else if(jsonResponse["responseCode"] == 1){
    // ignore: void_checks
    return callback(null,jsonResponse["status_message"]);
  }else{
      callback(null, "Error!, Try again later");
  }
}
void postScan(dynamic data, String url, Function callback) async{
  
   final prefs = await SharedPreferences.getInstance();
     var token= (prefs.getString("access"));
      var id= (prefs.getString("student_id"));
      data["student_id"] = id;
   var apiUrl = Uri.parse(api + url);
  var response = await http.post(apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'Bearer ${token!}',
      },
      body: jsonEncode(data));

  var jsonResponse =  await convert.jsonDecode(response.body) as Map<String, dynamic>;
  switch(jsonResponse["responseCode"]) {
  case 0:
    callback("success", null);
    break;
  case 2:
    callback("2", {"model":ClassModel.fromJson(jsonResponse["data"])});
    break;
  case 3:
    callback(null, jsonResponse["status_message"]);
    break;
  case 4:
    callback(null, jsonResponse["status_message"]);
    break;
    case 5:
    callback(null, jsonResponse["status_message"]);
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
     var urlScanned = Uri.parse("${api}load_history_scanned.php");
     var urlRegistred = Uri.parse("${api}load_registered_classes.php");
     var Scannedresponse = await http.post(urlScanned,body: data);
     List<dynamic> ScannedData = json.decode(Scannedresponse.body);
     var Registredresponse = await http.post(urlRegistred,body: data);
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
