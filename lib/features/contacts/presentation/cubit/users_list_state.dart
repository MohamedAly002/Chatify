class UsersListState {}

class UsersListInitial extends UsersListState {}

class UsersListLoading extends UsersListState {}

class UsersListLoaded extends UsersListState {
  final List<Map<String, dynamic>> users;

  UsersListLoaded({required this.users});
}

class UsersListError extends UsersListState {
  final String error;
  UsersListError(this.error);
}
