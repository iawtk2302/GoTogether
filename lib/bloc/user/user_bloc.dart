import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_together/model/custom_user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        if (value.exists) {
          final user = CustomUser(
            idUser: value.get('idUser').toString(),
            fullName: value.get('fullName').toString(),
            image: value.get('image').toString(),
            gender: value.get('gender').toString(),
            phone: value.get('phone').toString(),
            email: value.get('email').toString(),
            address: value.get('address'),
            dateOfBirth: value.get('dateOfBirth').toString(),
          ); 
          emit(UserExist(user));  
        } else {
          emit(UserNotExist());
        }
      });
    });
  }
}
