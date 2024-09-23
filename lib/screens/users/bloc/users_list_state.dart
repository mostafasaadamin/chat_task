import 'package:equatable/equatable.dart';

import '../../../models/user.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}
class LoadUsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserInfoModel> users;

  const UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object> get props => [message];
}

class ChangeOnlineStatusError extends UsersState {
  final String message;

  const ChangeOnlineStatusError(this.message);

  @override
  List<Object> get props => [message];
}
