import 'package:chatify/cubit/users_list_cubit/users_list_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersListCubit extends Cubit<UsersListState> {
  UsersListCubit() : super(UsersListInitial());
  void fetchUsers() async {
    emit(UsersListLoading());
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      FirebaseFirestore.instance
          .collection('users')
          .where('id', isNotEqualTo: currentUserId)
          .snapshots()
          .listen((event) {
        final users = event.docs.map((doc) => doc.data()).toList();
        emit(UsersListLoaded(users: users));
      });
    } catch (e) {
      emit(UsersListError(e.toString()));
    }
  }
}
