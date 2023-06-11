// to parse JSON

class User {
  final String password;
  final String email;

  User(this.password, this.email);
}
class UserModel{
  late String id;
  late String first_name;
  late String other_names;
  late String last_name;
  late String email;
  late String phone_number;
  late String institution_code;
  late bool is_active;
  late String pid;
  UserModel({ 
    required this.id,
      required this.first_name,
      required this.other_names,
      required this.last_name,
      required this.email,
      required this.phone_number,
      required this.institution_code,
      required this.is_active,
      required this.pid
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
        id:json['id'] ,
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
    factory AuthToken.fromJson(Map<String, dynamic>json)
    {
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

  Profile({required this.first_name,
      required this.last_name,
      required this.email,
      required this.phone_number,
      required this.regNo,
      required this.classes_registered,
      required this.classes_scanned, 
      required this.sessions_registered
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

  factory Institution.fromJson(Map<String, dynamic> json) 
  {
    return Institution
    (
      id: json['id'],
      name: json['institution_name'],
    );
  }
}
class ClassModel{
    late String student_id;
    late String session_id;
    late String student_session_id;
    late String student_session_unit_id;
    late String class_id;
    late String lecture_id;
    late String lecture_class_id;
    late String lecture_code;
    late String lecturer_id;
    late String lecturer_first_name;
    late String lecturer_last_name;
    late String unit_id;
    late String unit_name;
    late String semester;
    late String verification_type;

    ClassModel({ 
      required this.student_id, 
      required this.session_id,
      required this.student_session_id,
      required this.student_session_unit_id, 
      required this.class_id, 
      required this.lecture_id,
      required this.lecture_class_id,
      required this.lecture_code,
      required this.lecturer_first_name,
      required this.lecturer_last_name,
      required this.unit_id,
      required this.unit_name,
      required this.semester,
      required this.verification_type,
     });

    factory ClassModel.fromJson(Map<String, dynamic> json) 
    {
      return ClassModel
      (
        student_id: json['student_id'],
        session_id: json['session_id'],
        student_session_id: json['student_session_id'],
        student_session_unit_id: json['student_session_unit_id'],
        class_id: json['class_id'],
        lecture_id: json['lecture_id'],
        lecture_class_id: json['lecture_class_id'],
        lecture_code: json['lecture_code'],
        lecturer_first_name: json['lecturer_first_name'],
        lecturer_last_name: json['lecturer_last_name'],
        unit_id: json['unit_id'],
        unit_name: json['unit_name'],
        semester: json['semester'],
        verification_type: json['verification_type']

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
  factory ScannedClass.fromJson(Map<String, dynamic> json) 
  {
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
       return RegisteredClass
       (
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
