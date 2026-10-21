
import '../model/group_model.dart';

abstract class GroupsState {}

class GroupsInitial extends GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final List<GroupModel> groups;

  GroupsLoaded(this.groups);
}

class GroupsError extends GroupsState {
  final String message;

  GroupsError(this.message);
}

class GroupsSaving extends GroupsState {}

class GroupsSaveSuccess extends GroupsState {}

class GroupsSaveError extends GroupsState {
  final String message;

  GroupsSaveError(this.message);
}
