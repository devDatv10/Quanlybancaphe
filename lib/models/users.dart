import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String email;
  final String userName;
  final String address;
  final double phoneNumber;
  final String passWord;
  final String confirmPasword;

  Users({
    required this.userName,
    required this.address,
    required this.phoneNumber,
    required this.passWord,
    required this.confirmPasword,
    required this.email,
  });

  // Add a factory method to create a Users instance from a Firestore document
  factory Users.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Users(
      email: data['email'],
      userName: data['userName'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: (data['phoneNumber'] as num?)?.toDouble() ?? 0.0,
      passWord: data['passWord'] ?? '',
      confirmPasword: data['confirmPasword'] ?? '',
    );
  }
}
