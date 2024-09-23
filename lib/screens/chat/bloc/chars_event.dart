abstract class ChatsEvent {}

class ChatsLoadingEvent extends ChatsEvent {}
class SendChatEvent extends ChatsEvent {
  String message;
  SendChatEvent(this.message);
}
class TypingEvent extends ChatsEvent {}
