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
    var reg= prefs.getString('regNo');
    if(reg!.isEmpty){
      Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()),
                  );
    }else{
     
         Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()),
                  );
        
    }
        
         }
    void fetchData() async {
    
    setState(() {
      _loading = false;
      callMain();
    });
   
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Stack(
        
        children: <Widget>[
              Positioned(
                left: 0,
              bottom: 15,
              right: 0,
                child: Column(children:  <Widget>[
                  const Image(
                          image: AssetImage("assets/images/logo_jpg.png"),
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