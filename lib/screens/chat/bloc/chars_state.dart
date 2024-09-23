abstract class ChatsState {}

class ChatsInitial extends ChatsState {}

class ChatsLoading extends ChatsState {}

class ChatsLoaded extends ChatsState {}

class ChatsFailure extends ChatsState {
  final String error;

  ChatsFailure(this.error);
}
