abstract class ChatsEvent {}

class ChatsLoadingEvent extends ChatsEvent {}
class SendChatEvent extends ChatsEvent {}
class TypingEvent extends ChatsEvent {}
