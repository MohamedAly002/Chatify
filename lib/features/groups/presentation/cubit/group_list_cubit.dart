import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'group_list_state.dart';

class GroupListCubit extends Cubit<GroupListState> {
  GroupListCubit() : super(GroupListInitial());

  void getGroupList() async {
    emit(GroupListLoading());
    final groupRef = FirebaseFirestore.instance.collection('groups');
    groupRef.snapshots().listen((event) {
      if (event.docs.isEmpty) {
        emit(GroupListInitial());
        return;
      }
    });
    FirebaseFirestore.instance
        .collection('groups')
        .orderBy('CreatedAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) async {
        if (snapshot.docs.isEmpty) {
          emit(GroupListInitial());
          return;
        }
        final groups = snapshot.docs.map((doc) => doc.data()).toList();
        emit(GroupListLoaded(groups: groups));
      },
    );
  }
}
