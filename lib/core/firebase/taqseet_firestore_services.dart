import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaqseetFirestoreServices {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>>
  _taqseetCollection(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('taqseet');
  }

  static String get _currentUid {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    return user.uid;
  }

  /// Save any record: group, customer, tracker, or partner.
  static Future<String> saveRecord({
    required String type,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    final collection = _taqseetCollection(_currentUid);
    final document = documentId == null
        ? collection.doc()
        : collection.doc(documentId);

    await document.set({
      ...data,
      'type': type,
      'updatedAt': FieldValue.serverTimestamp(),
      if (documentId == null)
        'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return document.id;
  }

  /// Get records of one type.
  static Stream<QuerySnapshot<Map<String, dynamic>>> recordsStream({
    required String type,
  }) {
    return _taqseetCollection(_currentUid)
        .where('type', isEqualTo: type)
        .snapshots();
  }

  /// Get one record by its ID.
  static Future<DocumentSnapshot<Map<String, dynamic>>> getRecord({
    required String documentId,
  }) {
    return _taqseetCollection(_currentUid)
        .doc(documentId)
        .get();
  }

  /// Delete one record by its ID.
  static Future<void> deleteRecord({
    required String documentId,
  }) async {
    await _taqseetCollection(_currentUid)
        .doc(documentId)
        .delete();
  }
}