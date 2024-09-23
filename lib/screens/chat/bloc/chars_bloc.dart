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

  void _loadChattingAsync(
      ChatsLoadingEvent event, Emitter<ChatsState> emit) async {
    emit(ChatsLoading());
    try {
      // final user = await chatRepository.logInWithEmailAndPassword(
      //   event.email,
      //   event.password,
      // );

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
        message: event.message
      );
      emit(MessageSent());
    } catch (e) {
      emit(MessageSentFailed(e.toString()));
    }
  }
}
