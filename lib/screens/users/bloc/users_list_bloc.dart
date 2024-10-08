import 'package:bloc/bloc.dart';
import 'package:chat/repository/remote/chat_repository.dart';
import 'package:chat/screens/login/login_screen.dart';
import 'package:chat/screens/users/bloc/users_list_event.dart';
import 'package:chat/screens/users/bloc/users_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../helper/shared_prefes.dart';
import '../../../main.dart';
import '../../../repository/remote/auth_repository.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final AuthRepository authRepository;
  final ChatRepository chatRepository;
  String? userId;
  String? userName;

  UsersBloc({required this.authRepository, required this.chatRepository})
      : super(LoadUsersInitial()) {
    on<LoadUsersEvent>(_loadUsersGroupAsync);
    on<SetUserAsOnlineEvent>(_changeOnlineStatus);
    on<LogoutEvent>(_logoutStatus);
    _initializeUserId();
  }

  void _loadUsersGroupAsync(
      LoadUsersEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
      var users = await authRepository.loadAllUsersGroup();
      users.removeWhere((element) => element.uuid == userId);
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  void _changeOnlineStatus(
      SetUserAsOnlineEvent event, Emitter<UsersState> emit) async {
    try {
      await chatRepository.updateUserOnlineStatus(userId.toString(), true);
    } catch (e) {
      emit(ChangeOnlineStatusError(e.toString()));
    }
  }

  void _logoutStatus(LogoutEvent event, Emitter<UsersState> emit) async {
    await chatRepository.updateUserOnlineStatus(userId.toString(), false);
    await Preference.instance.clearAll();
    await authRepository.signOut();
    Get.offAll(LoginScreen());
  }



  void _initializeUserId() async {
    userId = await Preference.instance.getData("userId");
    userName = await Preference.instance.getData("userName");
  }
}
