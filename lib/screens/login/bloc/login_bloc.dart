import 'package:chat/repository/remote/auth_repository.dart';
import 'package:chat/screens/login/bloc/login_event.dart';
import 'package:chat/screens/login/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../helper/shared_prefes.dart';
import '../../chat/chat_screen.dart';
import '../../users/users_screen.dart';

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
        await Preference.instance.saveData("logged", true);
        await Preference.instance.saveData("userId", user.uid);
        await Preference.instance.saveData("userName", user.email?.split("@")[0]??"");
        Get.offAll(UsersListScreen());
      } else {
        emit(LoginFailure("Unknown error occurred"));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
