import 'package:cloud_firestore/cloud_firestore.dart';




class AppUser {
  String uid;
  String email;
  String name;
  String phone;
  String gender;

  DateTime dob;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.gender,
    required this.dob,
  });

  Map<String, dynamic> toMap() =>
      {
        'email': email,
        'name': name,
        'phone': phone,
        'gender': gender,
        'dob': Timestamp.fromDate(dob)
      };

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      dob: (map['dob'] as Timestamp).toDate(),
    );
  }

}