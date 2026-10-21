import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_installment_management/features/auth/data/model/user_model.dart';

class GoogleSignInServices {
  GoogleSignInServices._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static bool _isInitialized = false;

  static Future<void> _initializeGoogleSignIn() async {
    if (_isInitialized) {
      return;
    }

    await GoogleSignIn.instance.initialize();
    _isInitialized = true;
  }

  static Future<UserModel?> signIn() async {
    await _initializeGoogleSignIn();

    final GoogleSignInAccount googleUser;

    try {
      googleUser = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }

    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Unable to sign in with Google.',
      );
    }

    final userRef = _firestore
        .collection(UserModel.collectionName)
        .doc(firebaseUser.uid);

    final document = await userRef.get();

    if (document.exists && document.data() != null) {
      return UserModel.fromMap(document.data()!);
    }

    final user = UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? googleUser.displayName ?? 'Google User',
      email: firebaseUser.email ?? googleUser.email,
      phoneNumber: firebaseUser.phoneNumber ?? '',
      image: firebaseUser.photoURL,
      createdAt: DateTime.now(),
    );

    await userRef.set(user.toMap());

    return user;
  }

  static Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}
