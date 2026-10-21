import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const String collectionName = 'users';

  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final DateTime? createdAt;
  final String? jobTitle;
  final String? birthday;
  final String? gender;
  final String? image;
  final bool biometricEnabled;

  const UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.createdAt,
    this.jobTitle,
    this.birthday,
    this.gender,
    this.image,
    this.biometricEnabled = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'jobTitle': jobTitle,
      'birthday': birthday,
      'gender': gender,
      'image': image,
      'biometricEnabled': biometricEnabled,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final createdAtValue = map['createdAt'];
    DateTime? date;

    if (createdAtValue is Timestamp) {
      date = createdAtValue.toDate();
    } else if (createdAtValue is String) {
      date = DateTime.tryParse(createdAtValue);
    }

    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? map['phone'] ?? '',
      email: map['email'] ?? '',
      createdAt: date,
      jobTitle: map['jobTitle'],
      birthday: map['birthday'],
      gender: map['gender'],
      image: map['image'],
      biometricEnabled: map['biometricEnabled'] == true,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    DateTime? createdAt,
    String? jobTitle,
    String? birthday,
    String? gender,
    String? image,
    bool? biometricEnabled,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      jobTitle: jobTitle ?? this.jobTitle,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}
