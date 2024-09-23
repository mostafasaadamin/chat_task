import 'package:bloc/bloc.dart';
import 'package:chat/screens/users/bloc/users_list_event.dart';
import 'package:chat/screens/users/bloc/users_list_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../helper/shared_prefes.dart';
import '../../../repository/remote/auth_repository.dart';


class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final AuthRepository authRepository;
   int? userId;
  UsersBloc({required this.authRepository}) : super(LoadUsersInitial()) {
    on<LoadUsersEvent>(_loadUsersGroupAsync);
    on<SetUserAsOnlineEvent>(_changeOnlineStatus);
    _initializeUserId();

  }

  void _loadUsersGroupAsync(LoadUsersEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
     var users= await authRepository.loadAllUsersGroup();
     emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  void _changeOnlineStatus(SetUserAsOnlineEvent event, Emitter<UsersState> emit) async {
    try {
     var users= await authRepository.loadAllUsersGroup();
    } catch (e) {
      emit(ChangeOnlineStatusError(e.toString()));
    }
  }

  void _initializeUserId() async {
      userId= await Preference.instance.getData("userId");
  }
}
