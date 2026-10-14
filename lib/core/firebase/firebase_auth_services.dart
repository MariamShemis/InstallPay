import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    final document = await _firestore
        .collection(UserModel.collectionName)
        .doc(firebaseUser.uid)
        .get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return UserModel.fromMap(document.data()!);
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
}
