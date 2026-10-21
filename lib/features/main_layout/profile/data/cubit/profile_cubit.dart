import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/firebase_auth_services.dart';
import 'package:smart_installment_management/features/auth/data/model/user_model.dart';
import 'package:smart_installment_management/features/main_layout/profile/data/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _profileSubscription;

  void listenProfile() {
    emit(ProfileLoadingState());

    final currentUser = FirebaseAuthServices.currentFirebaseUser;

    if (currentUser == null) {
      emit(ProfileErrorState('No authenticated user was found.'));
      return;
    }

    _profileSubscription?.cancel();
    _profileSubscription = FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(currentUser.uid)
        .snapshots()
        .listen(
          (document) {
        if (document.exists && document.data() != null) {
          final user = UserModel.fromMap(document.data()!);
          emit(ProfileLoadedState(user));
        } else {
          emit(ProfileErrorState('User profile was not found.'));
        }
      },
      onError: (error) {
        emit(ProfileErrorState('Unable to load profile. Please try again.'));
      },
    );
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    emit(ProfileLogoutLoadingState());

    try {
      await _profileSubscription?.cancel();
      await FirebaseAuthServices.logout();
      emit(ProfileLogoutSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(ProfileLogoutErrorState(_getErrorMessage(e)));
    } catch (_) {
      emit(ProfileLogoutErrorState('Unable to log out. Please try again.'));
    }
  }

  String _getErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'network-request-failed':
        return 'Please check your internet connection.';
      case 'user-not-found':
        return 'No authenticated user was found.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}