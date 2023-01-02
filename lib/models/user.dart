import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? fullName;
  String? email;
  String? password;
  String? phoneNumber;
  String? profileImage;
  DateTime? lastLoggedIn;
  String? loginType;
  UserModel({
    this.uid,
    this.fullName,
    this.email,
    this.password,
    this.phoneNumber,
    this.profileImage,
    this.lastLoggedIn,
    this.loginType,
  });

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? password,
    String? phoneNumber,
    String? profileImage,
    DateTime? lastLoggedIn,
    String? loginType,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      lastLoggedIn: lastLoggedIn ?? this.lastLoggedIn,
      loginType: loginType ?? this.loginType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'lastLoggedIn': lastLoggedIn?.millisecondsSinceEpoch,
      'loginType': loginType,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      fullName: map['fullName'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
      profileImage: map['profileImage'],
      lastLoggedIn: map['lastLoggedIn'] != null
          ? (map['lastLoggedIn'] as Timestamp).toDate()
          : DateTime.now(),
      loginType: map['loginType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, fullName: $fullName, email: $email, password: $password, phoneNumber: $phoneNumber, profileImage: $profileImage, lastLoggedIn: $lastLoggedIn, loginType: $loginType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.fullName == fullName &&
        other.email == email &&
        other.password == password &&
        other.phoneNumber == phoneNumber &&
        other.profileImage == profileImage &&
        other.lastLoggedIn == lastLoggedIn &&
        other.loginType == loginType;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        password.hashCode ^
        phoneNumber.hashCode ^
        profileImage.hashCode ^
        lastLoggedIn.hashCode ^
        loginType.hashCode;
  }
}
