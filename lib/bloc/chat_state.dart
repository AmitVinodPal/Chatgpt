// lib/bloc/chat_state.dart
import 'package:chatgpt_flutter/models/chat_message_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatSuccessState extends ChatState {
  final List<ChatMessageModel> messages;
  const ChatSuccessState({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatLoadingState extends ChatState {}