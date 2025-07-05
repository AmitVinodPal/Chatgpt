// lib/bloc/chat_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chatgpt_flutter/bloc/chat_event.dart';
import 'package:chatgpt_flutter/bloc/chat_state.dart';
import 'package:chatgpt_flutter/models/chat_message_model.dart';
import 'package:chatgpt_flutter/utils/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // A list to hold the chat history
  List<ChatMessageModel> messages = [];

  // The generative model instance
  late final GenerativeModel _model;

  ChatBloc() : super(ChatInitial()) {
    // Initialize the GenerativeModel with the API key
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest', // The model to use
      apiKey: geminiApiKey,
    );

    // Register the event handler
    on<ChatGenerateNewTextMessageEvent>(_onGenerateText);
  }

  FutureOr<void> _onGenerateText(
      ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {
    // Add the user's message to the list and emit a loading state
    messages.add(ChatMessageModel(
        isUser: true, message: event.inputMessage, time: DateTime.now()));
    emit(ChatLoadingState());
    
    try {
      // Send the user's message to the Gemini API
      final response = await _model.generateContent([
        Content.text(event.inputMessage),
      ]);

      // Check if the response is not null and has text
      if (response.text != null && response.text!.isNotEmpty) {
        // Add the AI's response to the list
        messages.add(ChatMessageModel(
            isUser: false, message: response.text!, time: DateTime.now()));
        // Emit a success state with the updated messages list
        emit(ChatSuccessState(messages: messages));
      } else {
        // Handle cases where the response is empty
        _emitError(emit, "Received an empty response from the AI.");
      }
    } catch (e) {
      // Handle API errors or other exceptions
      _emitError(emit, "An error occurred: ${e.toString()}");
    }
  }

  // Helper function to emit an error state with a message
  void _emitError(Emitter<ChatState> emit, String errorMessage) {
    messages.add(ChatMessageModel(
        isUser: false, message: errorMessage, time: DateTime.now()));
    emit(ChatSuccessState(messages: messages));
  }
}