import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatsState {}

class ChatsInitial extends ChatsState {}

class ChatsLoading extends ChatsState {}
class SendingMessageLoading extends ChatsState {}
class MessageSent extends ChatsState {}
class MessageSentFailed extends ChatsState {
  final String error;

  MessageSentFailed(this.error);
}

class ChatsLoaded extends ChatsState {
  final List<QueryDocumentSnapshot> messages;

  ChatsLoaded(this.messages);
}


class ChatsFailure extends ChatsState {
  final String error;

  ChatsFailure(this.error);
}
