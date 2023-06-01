// to parse JSON

class User {
  final String password;
  final String email;

  User(this.password, this.email);
}
class UserModel{
  late String first_name;
  late String other_names;
  late String last_name;
  late String email;
  late String phone_number;
  late String institution_code;
  late bool is_active;
  late String pid;
  UserModel({required this.first_name,required this.other_names,
  required this.last_name,required this.email, required this.phone_number,
   required this.institution_code,required this.is_active,required this.pid
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      first_name:json['first_name'] , 
    other_names:json['other_names'] , 
    last_name: json['last_name'] , 
    email: json['email'], 
    phone_number:json['phone_number'] ,
     institution_code: json['institution_code'], 
     is_active: json['is_active'],
     pid:json['pid']
     );
  }
}
class AuthToken {
late String access;
late String refresh;
AuthToken({required this.access, required this.refresh});
factory AuthToken.fromJson(Map<String, dynamic>json){
  return  AuthToken(access: json['access'], refresh: json['refresh']);
}
}
class Profile{
  late String first_name;
  late String  last_name;
  late String email;
  late String phone_number;
  late String regNo;
  late int classes_registered;
  late int classes_scanned;
  late int sessions_registered;

  Profile({required this.first_name,required this.last_name,
  required this.email,required this.phone_number,
  required this.regNo,required this.classes_registered,
  required this.classes_scanned, required this.sessions_registered
  });

  factory Profile.fromJson(Map<String, dynamic> json){
    return Profile(
          first_name:json['first_name'] , 
          last_name:json['last_name'] , 
          email:json['email'] , 
          regNo:json['student_number'] , 
          phone_number:json['phone_number'] , 
          classes_registered:json['classes_registered'] , 
          classes_scanned:json['classes_scanned'] , 
          sessions_registered:json['sessions_registered'] , 
    );
  }
}

class Institution {
  String id;
  String name;

  Institution({required this.id, required this.name});

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      id: json['id'],
      name: json['institution_name'],
    );
  }
}
class ClassModel{
    late String class_id;
    late String unit_id;
    late String lec_id;
    late String class_sem;
    late String class_year;
    late String class_start;
    late String date_start;
    late String time_start;
    late String class_stop;
    late String date_stop;
    late String time_stop;
    late String status;
    late String class_code;
    late String unit_name;
    late String unit_code;
    late String lec_name;
    ClassModel({ 
      required this.class_id, 
      required this.unit_id,
      required this.lec_id,
      required this.class_sem, 
      required this.class_year, 
      required this.class_start,
      required this.date_start,
      required this.time_start,
      required this.class_stop,
      required this.date_stop,
      required this.time_stop,
      required this.status,
      required this.class_code,
      required this.unit_code,
      required this.unit_name,
      required this.lec_name

     });
    factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      class_id: json['class_id'],
      unit_id: json['unit_id'],
      lec_id: json['lec_id'],
      class_sem: json['class_sem'],
      class_year: json['class_year'],
      class_start: json['class_start'],
      date_start: json['date_start'],
      time_start: json['time_start'],
      class_stop: json['class_stop'],
      date_stop: json['date_stop'],
      class_code: json['class_code'],
      status: json['status'],
      unit_code: json['unit_code'],
      unit_name: json['unit_name'],
      lec_name: json['lec_name'],
      time_stop: json['time_stop'],

    );
  }
}
class ScannedClass{
  late String attendance_id;
  late String student_id;
  late String class_id;
  late String class_date;
  late String class_time;
  late String lec_name;
  late String unit_code;
  late String unit_name;
  late String unit_id;
   
  ScannedClass({
    required this.attendance_id,
    required this.student_id,
    required this.class_id,
    required this.class_date,
    required this.class_time,
    required this.lec_name,
    required this.unit_name,
    required this.unit_code,
    required this.unit_id
  }
  );
  factory ScannedClass.fromJson(Map<String, dynamic> json) {
       return ScannedClass(
        attendance_id: json['attendance_id'], 
       student_id: json['student_id'],
        class_id: json['class_id'], 
        class_date: json['class_date'], 
        class_time: json['class_time'], 
        lec_name: json['lec_name'], 
        unit_code: json['unit_code'], 
        unit_name: json['unit_name'], 
        unit_id: json['unit_id']
        );
  }
  
}

class RegisteredClass{
  late int id;
  late String student_id;
  late String class_id;
  late int unit_id;
  late String date_reg;
  late String lec_name;
  late String unit_code;
  late String unit_name;

  RegisteredClass({
    required this.id,
    required this.student_id,
    required this.class_id,
    required this.unit_id,
    required this.date_reg,
    required this.lec_name,
    required this.unit_code,
    required this.unit_name,
  }
  );
   factory RegisteredClass.fromJson(Map<String, dynamic> json) {
       return RegisteredClass(
        id: json['id'], 
       student_id: json['student_id'],
        class_id: json['class_id'], 
        unit_id: json['unit_id'], 
        date_reg: json['date_reg'], 
        lec_name: json['lec_name'], 
        unit_code: json['unit_code'], 
        unit_name: json['unit_name']
        );
  }
}
