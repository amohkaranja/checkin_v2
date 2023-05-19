import 'package:checkin2/models/user_model.dart';
import 'package:flutter/material.dart';

class RegisteredClasses extends StatefulWidget {
   const RegisteredClasses({
    Key? key,
    required this.registeredClasses,
  }) : super(key: key);
final List<RegisteredClass> registeredClasses;
  @override
  State<RegisteredClasses> createState() => _RegisteredClassesState();
}

class _RegisteredClassesState extends State<RegisteredClasses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          "Registered classes",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: const Color(0xff008346),
      ),
      body: 
        ListView.builder(
      itemCount: widget.registeredClasses.length,
      itemBuilder: (BuildContext context, int index) {
        RegisteredClass registeredClass= widget.registeredClasses[index];
          return Padding( 
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Card(
              child: Padding(padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                   const Image(
                        image: AssetImage("assets/images/chalk_board.png"),
                        height: 60,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(registeredClass.unit_code,style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(width: 100),
                              Text(registeredClass.date_reg,style: TextStyle(fontSize: 14),)
                            ],
                          ),
                          SizedBox(height: 5,),
                           Row(children: [Text(registeredClass.unit_name,style: TextStyle(fontStyle: FontStyle.italic),)],),
                            SizedBox(height: 10,),
                            Row(children: [Text(registeredClass.lec_name)],)
                        ],
                      ),
                      )
                ],
              ),
              ),
            )
          );}
        )
      
    );
  }
}