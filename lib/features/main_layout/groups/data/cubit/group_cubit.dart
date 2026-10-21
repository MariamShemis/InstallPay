import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/cubit/group_state.dart';

import '../../../../../core/services/cloudinary_services.dart';
import '../model/group_model.dart';

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit() : super(GroupsInitial());

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _groupsSubscription;

  List<GroupModel> _groups = [];

  List<GroupModel> get groups => List.unmodifiable(_groups);

  void loadGroups() {
    _groupsSubscription?.cancel();

    emit(GroupsLoading());

    try {
      _groupsSubscription =
          TaqseetFirestoreServices.recordsStream(type: 'group').listen(
            (snapshot) {
              _groups = [];

              for (final document in snapshot.docs) {
                _groups.add(
                  GroupModel.fromMap(document.data(), id: document.id),
                );
              }

              if (isClosed) return;

              emit(GroupsLoaded(List.unmodifiable(_groups)));
            },
            onError: (error) {
              if (isClosed) return;

              emit(GroupsError('Failed to load groups: $error'));
            },
          );
    } catch (error) {
      if (isClosed) return;

      emit(GroupsError('Failed to load groups: $error'));
    }
  }

  Future<bool> addGroup({
    required String groupTitle,
    required String collectorName,
    required String collectorPhone,
    required String address,
    File? image,
  }) async {
    try {
      emit(GroupsSaving());

      String? imageUrl;

      if (image != null) {
        imageUrl = await CloudinaryServices.uploadImage(image);
      }

      final group = GroupModel(
        groupTitle: groupTitle.trim(),
        collectorName: collectorName.trim(),
        collectorPhone: collectorPhone.trim(),
        address: address.trim(),
        imageUrl: imageUrl,
      );

      await TaqseetFirestoreServices.saveRecord(
        type: 'group',
        data: group.toMap(),
      );

      emit(GroupsSaveSuccess());
      return true;
    } catch (error) {
      emit(GroupsSaveError('Failed to save group: $error'));
      return false;
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      await TaqseetFirestoreServices.deleteRecord(documentId: groupId);
    } catch (error) {
      emit(GroupsError('Failed to delete group: $error'));
    }
  }

  @override
  Future<void> close() async {
    await _groupsSubscription?.cancel();
    return super.close();
  }
}
