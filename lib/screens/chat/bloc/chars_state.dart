abstract class ChatsState {}

class ChatsInitial extends ChatsState {}

class ChatsLoading extends ChatsState {}
class SendingMessageLoading extends ChatsState {}
class MessageSent extends ChatsState {}
class MessageSentFailed extends ChatsState {
  final String error;

  MessageSentFailed(this.error);
}

class ChatsLoaded extends ChatsState {}


class ChatsFailure extends ChatsState {
  final String error;

  ChatsFailure(this.error);
}
