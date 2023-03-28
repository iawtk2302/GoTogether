import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ConnectChat>((event, emit) async{
      emit(ChatLoading());
     final client = StreamChatClient(
    'b67pax5b2wdq',
    logLevel: Level.INFO,
    );
    await client.connectUser(
    User(id: 'tutorial-flutter'),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.S-MJpoSwDiqyXpUURgO5wVqJ4vKlIVFLSEyrFYCOE1c',
  );
  final channel = client.channel('messaging', id: 'flutterdevs');
  await channel.watch();
  emit(ChatLoaded(channel, client));
    });
  }
}
