part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ConnectChat extends ChatEvent {
  const ConnectChat();

  @override
  List<Object> get props => [];
}
