// lib/bloc/chat_event.dart
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class ChatGenerateNewTextMessageEvent extends ChatEvent {
  final String inputMessage;

  const ChatGenerateNewTextMessageEvent({required this.inputMessage});

  @override
  List<Object> get props => [inputMessage];
}