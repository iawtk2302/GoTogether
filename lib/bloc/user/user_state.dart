part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserExist extends UserState {
  final CustomUser user;
  const UserExist(this.user);

  @override
  List<Object> get props => [user];
}

class UserNotExist extends UserState {}
