// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String fullName;
  final String email;
  final String pictureLarge;
  final String pictureThumbnail;
  final String location;
  final String phone;
  const User({
    required this.fullName,
    required this.email,
    required this.pictureLarge,
    required this.pictureThumbnail,
    required this.location,
    required this.phone,
  });

  User copyWith({
    String? fullName,
    String? email,
    String? pictureLarge,
    String? pictureThumbnail,
    String? location,
    String? phone,
  }) {
    return User(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      pictureLarge: pictureLarge ?? this.pictureLarge,
      pictureThumbnail: pictureThumbnail ?? this.pictureThumbnail,
      location: location ?? this.location,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'pictureLarge': pictureLarge,
      'pictureThumbnail': pictureThumbnail,
      'location': location,
      'phone': phone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      pictureLarge: map['pictureLarge'] as String,
      pictureThumbnail: map['pictureThumbnail'] as String,
      location: map['location'] as String,
      phone: map['phone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [fullName, email, pictureLarge, pictureThumbnail, location, phone];
  }
}
