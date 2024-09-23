import 'package:bloc/bloc.dart';
import 'package:chat/screens/chat/bloc/chars_event.dart';
import 'package:chat/screens/chat/bloc/chars_state.dart';
import 'package:equatable/equatable.dart';

import '../../../repository/remote/chat_repository.dart';

class CharsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository chatRepository;

  CharsBloc({required this.chatRepository}) : super(ChatsInitial()) {
    on<ChatsLoadingEvent>(_loadChattingAsync);
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
}
