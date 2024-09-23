import 'package:bloc/bloc.dart';
import 'package:chat/screens/users/bloc/users_list_event.dart';
import 'package:chat/screens/users/bloc/users_list_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../repository/remote/auth_repository.dart';


class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final AuthRepository authRepository;

  UsersBloc({required this.authRepository}) : super(LoadUsersInitial()) {
    on<LoadUsersEvent>(_loadUsersGroupAsync);

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
}
