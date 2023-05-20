import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../utils/apis_list.dart';

class ScannedClasses extends StatefulWidget {
  const ScannedClasses({
    Key? key,
    required this.scannedClassesList,
  }) : super(key: key);

  final List<ScannedClass> scannedClassesList;

  @override
  State<ScannedClasses> createState() => _ScannedClassesState();
}


class _ScannedClassesState extends State<ScannedClasses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scanned classes",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: const Color(0xff008346),
      ),
      body: ListView.builder(
        itemCount: widget.scannedClassesList.length,
        itemBuilder: (BuildContext context, int index) {
          ScannedClass scannedClass = widget.scannedClassesList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    const Image(
                      image: AssetImage("assets/images/blue_qr_code.png"),
                      height: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            scannedClass.class_date,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            scannedClass.unit_code,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            scannedClass.lec_name,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          scannedClass.class_time,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
