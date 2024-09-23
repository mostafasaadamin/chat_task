import 'package:bloc/bloc.dart';
import 'package:chat/screens/chat/bloc/chars_event.dart';
import 'package:chat/screens/chat/bloc/chars_state.dart';
import 'package:equatable/equatable.dart';

import '../../../const/const_strings.dart';
import '../../../repository/remote/chat_repository.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository chatRepository;
  final String userId;
  final String userTargetId;
  final String userName;
  ChatsBloc({required this.chatRepository,required this.userId,required this.userName,required this.userTargetId}) : super(ChatsInitial()) {
    on<ChatsLoadingEvent>(_loadChattingAsync);
    on<SendChatEvent>(_sendChattingAsync);
    on<TypingEvent>(_typingEvent);
    on<DeleteTypingEvent>(_deleteTypingEvent);
  }

  Future<void> _loadChattingAsync(
      ChatsLoadingEvent event, Emitter<ChatsState> emit) async {
    emit(ChatsLoading());
    try {

      final chatsCollections =  await chatRepository.loadAllChats(
        userUuid: userId,
        userTargetId: userTargetId
      );

      await for (final snapshot in chatsCollections.orderBy('timestamp', descending: true).snapshots()) {
        emit(ChatsLoaded(snapshot.docs));
      }

    } catch (e) {
      emit(ChatsFailure(e.toString()));
    }
  }

  void _sendChattingAsync(
      SendChatEvent event, Emitter<ChatsState> emit) async {
    emit(SendingMessageLoading());
    try {
     add(DeleteTypingEvent(typingMessageCode));

    await chatRepository.sendChatMessage(
       userTargetId: userTargetId,
        userUuid: userId,
        userName: userName,
        message: event.message,
      );
      emit(MessageSent());
    } catch (e) {
      emit(MessageSentFailed(e.toString()));
    }
  }
  void _typingEvent(
      TypingEvent event, Emitter<ChatsState> emit) async {
    try {
          await chatRepository.sendTypingMessage(
          userTargetId: userTargetId,
        typingMessageCode: event.typingMessageCode,
        userUuid: userId,
      );
    } catch (e) {
      emit(MessageSentFailed(e.toString()));
    }
  }

  Future<void> _deleteTypingEvent(
      DeleteTypingEvent event, Emitter<ChatsState> emit) async {
    try {
          await chatRepository.deleteTypingMessage(
          userTargetId: userTargetId,
        typingMessageCode: event.typingMessageCode,
        userUuid: userId,
      );
    } catch (e) {
      emit(MessageSentFailed(e.toString()));
    }
  }
}
