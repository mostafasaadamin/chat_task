part of 'chars_bloc.dart';

sealed class CharsState extends Equatable {
  const CharsState();
}

final class CharsInitial extends CharsState {
  @override
  List<Object> get props => [];
}
