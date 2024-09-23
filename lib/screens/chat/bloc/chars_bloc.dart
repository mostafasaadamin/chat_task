import 'package:bloc/bloc.dart';
import 'package:chat/screens/chat/bloc/chars_event.dart';
import 'package:chat/screens/chat/bloc/chars_state.dart';
import 'package:equatable/equatable.dart';

import '../../../repository/remote/chat_repository.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository chatRepository;
  final String userId;
  final String userTargetId;
  ChatsBloc({required this.chatRepository,required this.userId,required this.userTargetId}) : super(ChatsInitial()) {
    on<ChatsLoadingEvent>(_loadChattingAsync);
    on<SendChatEvent>(_sendChattingAsync);
  }

  Future<void> _loadChattingAsync(
      ChatsLoadingEvent event, Emitter<ChatsState> emit) async {
    emit(ChatsLoading());
    try {

      final chatsCollections =  chatRepository.loadAllChats(
      userUuid: userId,
        userTargetId: userTargetId
      );

      chatsCollections.orderBy('timestamp', descending: true).snapshots().listen((snapshot) {
        emit(ChatsLoaded(snapshot.docs));
      }, onError: (error) {
        emit(ChatsFailure('Error loading messages: $error'));
      });

    } catch (e) {
      emit(ChatsFailure(e.toString()));
    }
  }

  void _sendChattingAsync(
      SendChatEvent event, Emitter<ChatsState> emit) async {
    emit(SendingMessageLoading());
    try {
          await chatRepository.sendChatMessage(
       userTargetId: userTargetId,
        userUuid: userId,
        message: event.message,
      );
      emit(MessageSent());
    } catch (e) {
      emit(MessageSentFailed(e.toString()));
    }
  }
}
