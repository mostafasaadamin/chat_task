import 'package:bloc/bloc.dart';
import 'package:chat/screens/chat/chat_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/remote/auth_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc({required this.authRepository}) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_signupAction);
  }

  void _signupAction(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      await authRepository.signUp(email: event.email, password: event.password);
      var user= await authRepository.logInWithEmailAndPassword(event.email, event.password);
      if(user==null){
         emit(SignUpFailure(error: "Email already exists"));
         return;
      }
      await authRepository.uploadProfileImage(event.image!,user.uid.toString(),event.email,event.email.split("@")[0]);

      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(error: e.toString()));
    }
  }
}
