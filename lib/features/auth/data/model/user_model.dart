import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const String collectionName = 'users';

  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
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
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      createdAt: date,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
