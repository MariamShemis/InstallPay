import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_installment_management/core/services/cloudinary_services.dart';
import 'package:smart_installment_management/features/auth/data/model/login_request.dart';
import 'package:smart_installment_management/features/auth/data/model/register_request.dart';
import 'package:smart_installment_management/features/auth/data/model/user_model.dart';

class FirebaseAuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static User? get currentFirebaseUser => _auth.currentUser;

  static Future<UserModel> register(RegisterRequest request) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: request.email.trim(),
      password: request.password,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Unable to create user account.',
      );
    }

    final user = UserModel(
      id: firebaseUser.uid,
      name: request.name.trim(),
      phoneNumber: request.phoneNumber.trim(),
      email: request.email.trim(),
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection(UserModel.collectionName)
        .doc(firebaseUser.uid)
        .set(user.toMap());
    try {
      await firebaseUser.sendEmailVerification();
    } catch (e) {
      print('Email verification error: $e');
    }

    return user;
  }

  static Future<UserModel> login(LoginRequest request) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: request.email.trim(),
      password: request.password,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Unable to sign in.',
      );
    }

    final document = await _firestore
        .collection(UserModel.collectionName)
        .doc(firebaseUser.uid)
        .get();

    if (!document.exists || document.data() == null) {
      throw FirebaseAuthException(
        code: 'user-data-not-found',
        message: 'User data was not found.',
      );
    }

    return UserModel.fromMap(document.data()!);
  }

  static Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    await firebaseUser.reload();

    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    final document = await _firestore
        .collection(UserModel.collectionName)
        .doc(currentUser.uid)
        .get();

    final data = document.data() ?? <String, dynamic>{};

    return UserModel(
      id: currentUser.uid,
      name: (data['name'] as String?)?.trim().isNotEmpty == true
          ? (data['name'] as String).trim()
          : currentUser.displayName ?? '',
      email: (data['email'] as String?)?.trim().isNotEmpty == true
          ? (data['email'] as String).trim()
          : currentUser.email ?? '',
      phoneNumber:
          (data['phoneNumber'] as String?) ??
          (data['phone'] as String?) ??
          currentUser.phoneNumber ??
          '',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      jobTitle: data['jobTitle'] as String?,
      birthday: data['birthday'] as String?,
      gender: data['gender'] as String?,
      image: data['image'] as String?,
      biometricEnabled: data['biometricEnabled'] == true,
    );
  }

  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user was found.',
      );
    }

    await user.reload();
    user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user was found.',
      );
    }

    if (user.emailVerified) {
      throw FirebaseAuthException(
        code: 'already-verified',
        message: 'Your email is already verified.',
      );
    }

    await user.sendEmailVerification();
  }

  static Future<bool> checkEmailVerified() async {
    User? user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    await user.reload();
    user = _auth.currentUser;

    return user?.emailVerified ?? false;
  }

  static Future<void> updateUserProfile(
    UserModel user, {
    File? imageFile,
  }) async {
    final firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user was found.',
      );
    }
    final userRef = _firestore
        .collection(UserModel.collectionName)
        .doc(firebaseUser.uid);

    final existingDocument = await userRef.get();

    if (!existingDocument.exists) {
      throw Exception('User profile was not found in Firestore.');
    }

    final existingData = existingDocument.data();
    String? imageUrl = existingData?['image'] as String?;

    if (imageFile != null) {
      imageUrl = await CloudinaryServices.uploadImage(imageFile);
    }

    await userRef.update({
      'name': user.name.trim(),
      'phoneNumber': user.phoneNumber.trim(),
      'jobTitle': user.jobTitle?.trim() ?? '',
      'birthday': user.birthday ?? '',
      'gender': user.gender ?? '',
      'image': imageUrl,
    });
  }

  static bool get isEmailPasswordAccount {
    final user = _auth.currentUser;

    return user != null &&
        user.providerData.any((provider) => provider.providerId == 'password');
  }

  static Future<void> reauthenticateWithPassword(String currentPassword) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      throw Exception('No email/password user is currently signed in.');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
  }

  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await reauthenticateWithPassword(currentPassword);

    final user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user was found.',
      );
    }

    await user.updatePassword(newPassword);
  }

  static Future<void> sendVerificationEmail() async {
    await sendEmailVerification();
  }

  static Future<bool> refreshEmailVerification() async {
    return checkEmailVerified();
  }

  static Future<void> deleteEmailPasswordAccount({
    required String currentPassword,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user was found.',
      );
    }

    await reauthenticateWithPassword(currentPassword);

    // Delete the Firestore profile before deleting the Firebase user.
    await _firestore
        .collection(UserModel.collectionName)
        .doc(user.uid)
        .delete();

    await user.delete();
  }

  static Future<bool> getBiometricEnabled() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return false;

    final document = await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(user.uid)
        .get();

    return document.data()?['biometricEnabled'] == true;
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(user.uid)
        .set({'biometricEnabled': enabled}, SetOptions(merge: true));
  }

  // static Future<bool> getBiometricEnabled() async {
  //   final user = _auth.currentUser;
  //
  //   if (user == null) {
  //     throw FirebaseAuthException(
  //       code: 'user-not-found',
  //       message: 'No authenticated user was found.',
  //     );
  //   }
  //
  //   final document = await _firestore
  //       .collection(UserModel.collectionName)
  //       .doc(user.uid)
  //       .get();
  //
  //   if (!document.exists || document.data() == null) {
  //     throw Exception('User profile was not found.');
  //   }
  //
  //   final userModel = UserModel.fromMap(document.data()!);
  //   return userModel.biometricEnabled;
  // }
  //
  // static Future<void> setBiometricEnabled(bool enabled) async {
  //   final user = _auth.currentUser;
  //
  //   if (user == null) {
  //     throw FirebaseAuthException(
  //       code: 'user-not-found',
  //       message: 'No authenticated user was found.',
  //     );
  //   }
  //
  //   await _firestore.collection(UserModel.collectionName).doc(user.uid).set({
  //     'biometricEnabled': enabled,
  //   }, SetOptions(merge: true));
  // }
}
