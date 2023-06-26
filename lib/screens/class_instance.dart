import 'package:checkin/screens/student_home.dart';
import 'package:flutter/material.dart';
import 'package:checkin/models/user_model.dart';

import '../utils/apis_list.dart';
class ClassInstance extends StatefulWidget {
  const ClassInstance
  ({
    Key? key,
    required this.model
  }) : super(key: key);

  final ClassModel model;
  @override
  _ClassInstanceState createState() => _ClassInstanceState();
}

class _ClassInstanceState extends State<ClassInstance> {

  String _errorMessage = "";
  bool registered=false;

  void home(){
    Navigator.push
    ( 
      context,MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
      );
  }              
  void submit() {
    
    var url = "api/v1/platform/lecture_attendances/register_and_sign";
    var data={
      "class_id":widget.model.class_id,
      "lecture_class_id": widget.model.lecture_class_id,
      "lecture_code": widget.model.lecture_code,
      "lecture_id": widget.model.lecture_id,
      "lecturer_first_name": widget.model.lecturer_first_name,
      "lecturer_last_name":widget.model.lecturer_last_name,
      "session_id": widget.model.session_id,
      "student_id":widget.model.student_id,
      "student_session_id":widget.model.student_session_id,
      "student_session_unit_id": widget.model.student_session_unit_id,
      "unit_id": widget.model.unit_id,
      "unit_name":widget.model.unit_name,
      "verification_type":widget.model.verification_type,
      "semester":widget.model.semester
    };
    setState(() 
    {
      _errorMessage = "";
    });
    // call the postScan method and handle the result
    postScan(data, url, (result, error) {
        if (result == null)
         {
          setState(() {
            _errorMessage = error ?? "Unknown error occurred.";
          });
        } else 
        {
          setState(() {
            registered=true;
            _errorMessage = error ?? "Class registered successfully!";
          });
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register this class",
          style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.w400
              ),
        ),
        backgroundColor: const Color(0xff008346),
      ),
      body: Container(
          width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(children: [
           Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: Card(
              
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow:  [
                      BoxShadow(
                         color: Theme.of(context).primaryColor,
                         spreadRadius: 0.5,
                         blurRadius: 3,
                          // offset: Offset(0, 3)
                          )
                    ]),
                child:Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    
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
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(height: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      
                        children: [
                          const Expanded(child: Text("Lecturer")),

                          Expanded(child: Text(widget.model.lecturer_first_name+" "+widget.model.lecturer_last_name,style:
                           const TextStyle( fontSize: 14,
                           fontWeight: FontWeight.bold,

                           ),))
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: Text("Unit")),
                          Expanded(child: Text(widget.model.unit_name,style: const TextStyle( fontSize: 14,
                           fontWeight: FontWeight.bold,
                           
                           ),))
                        ],
                      ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      //  Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Expanded(child: Text("Unit Code")),
                      //     Expanded(child: Text(widget.model.unit_id,style: const TextStyle( fontSize: 14,
                      //      fontWeight: FontWeight.bold,
                           
                      //      ),))
                      //   ],
                      // ),
                      const SizedBox(
                        height: 15,
                      ),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: Text("Semester")),
                          Expanded(child: Text(widget.model.semester,style: const TextStyle( fontSize: 14,
                           fontWeight: FontWeight.bold,
                           
                           ),))
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Expanded(child: Text("Year")),
                      //     Expanded(child: Text(widget.model.semester,style: const TextStyle( fontSize: 14,
                      //      fontWeight: FontWeight.bold,
                           
                      //      ),))
                      //   ],
                        
                      // ),
                      //  const SizedBox(
                      //   height: 50,
                      // ),
                      Row(
                        children: [
                          Expanded(child: !registered? ElevatedButton(onPressed: () {
                                  submit();
                                  
                                },style: ElevatedButton.styleFrom(
        
                            backgroundColor: Colors.green, 
                            elevation: 5, 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                          ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // button padding
                ),child: const Text("Register",style: TextStyle( fontSize: 10)),
                   ):ElevatedButton(onPressed: () {
                            home();
                            
                          },style: ElevatedButton.styleFrom(
  
                      backgroundColor: Colors.green, 
                      elevation: 5, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                    ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // button padding
                ),child: const Text("Ok"),
              )
              ),
              const Spacer(),
                        !registered? Expanded(child: ElevatedButton(onPressed: () {
                                Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudentHomeScreen()),
                    );
                            
                          },style: ElevatedButton.styleFrom(
  
                      backgroundColor: Colors.red, 
                      elevation: 5, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                    ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // button padding
                ),child: const Text("Cancel",style: TextStyle( fontSize: 10)),)):Container(height: 1),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}