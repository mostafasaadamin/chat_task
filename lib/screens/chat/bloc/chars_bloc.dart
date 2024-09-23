import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chars_event.dart';
part 'chars_state.dart';

class CharsBloc extends Bloc<CharsEvent, CharsState> {
  CharsBloc() : super(CharsInitial()) {
    on<CharsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
