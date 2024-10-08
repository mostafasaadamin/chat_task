import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  const SignUpEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}



class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String password;
  final File? image;
  const SignUpSubmitted(this.email, this.password, this.image);

  @override
  List<Object> get props => [email, password];
}
