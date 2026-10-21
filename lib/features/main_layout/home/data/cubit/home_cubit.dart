
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/firebase_auth_services.dart';
import 'package:smart_installment_management/features/auth/data/model/user_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  UserModel? user;

  Future<void> loadUser() async {
    emit(HomeLoading());

    try {
      final currentUser = await FirebaseAuthServices.getCurrentUser();

      if (currentUser == null) {
        user = null;
        emit(HomeError('User data not found.'));
        return;
      }

      user = currentUser;
      emit(HomeSuccess(currentUser));
    } catch (e) {
      emit(HomeError('Unable to load user data.'));
    }
  }

  Future<void> refreshUser() async {
    await loadUser();
  }
}
