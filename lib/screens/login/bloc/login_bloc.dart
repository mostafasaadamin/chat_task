import 'package:chat/repository/remote/auth_repository.dart';
import 'package:chat/screens/login/bloc/login_event.dart';
import 'package:chat/screens/login/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../chat/chat_screen.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authenticationRepository;

  LoginBloc({required this.authenticationRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  void _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await authenticationRepository.logInWithEmailAndPassword(
        event.email,
        event.password,
      );
      if (user != null) {
        Get.offAll(ChatScreen());

      } else {
        emit(LoginFailure("Unknown error occurred"));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
