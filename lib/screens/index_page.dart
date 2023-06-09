import 'package:checkin/screens/login_page.dart';
import 'package:checkin/screens/student_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/apis_list.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool _loading=true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }
   void callMain() async{
    
   await fetchDataAndSaveToPrefs();
     final prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
    var password = prefs.getString('password');
    
    if(email != null && password != null){
      var data = {"email": email, "password": password};
            login(
        data,
        (result, error) => {
          _loading=false,
                if(result==null){
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                         builder: (context) => const HomeScreen()),
                  )
                }else{
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentHomeScreen()),
                  )
                }
                 
                
            });
    }else{
      _loading=false;
         // ignore: use_build_context_synchronously
         Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()),
                  );
        
    }
        
         }
    void fetchData() async {
    
    setState(() {
      callMain();
    });
   
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body:  Stack(
        
        children: <Widget>[
              Positioned(
                left: 0,
              bottom: 15,
              right: 0,
                child: Column(children:  <Widget>[
                  const Image(
                          image: AssetImage("assets/images/logo.png"),
                          height: 200,
                          width: 200,
                        ),
             const Text("v 2.0"),
             _loading?  const Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff008346)), 
      ), 
      SizedBox(height: 8),
     
    ],),
             ):Container()
                ]),
               ), 
        ],
      ),
    );
  }
}