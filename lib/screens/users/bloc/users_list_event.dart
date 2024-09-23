import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class LoadUsersEvent extends UsersEvent {}
class SetUserAsOnlineEvent extends UsersEvent {}
class GetUserIdEvent extends UsersEvent {}
class LogoutEvent extends UsersEvent {}
class ChangeThemeEvent extends UsersEvent {}
