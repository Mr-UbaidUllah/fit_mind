import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../data/models/chat_message.dart';
import '../data/services/database_helper.dart';

class AICoachProvider with ChangeNotifier {
  // TODO: Replace with your actual Gemini API Key
  static const String _apiKey = 'YOUR_API_KEY_HERE';

  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  List<ChatMessage> _messages = []; // Local list
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  AICoachProvider() {
    _initModel();
    _loadMessages(); // Load history when app starts
  }

  void _initModel() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
      systemInstruction: Content.text(
          "You are a helpful, motivating, and friendly Fitness & Mental Health Coach named 'Fit Mind AI'. "
              "Keep answers concise, encouraging, and focused on wellness."
      ),
    );
    _chatSession = _model.startChat();
  }

  // Load from Local DB
  Future<void> _loadMessages() async {
    _messages = await DatabaseHelper.instance.fetchMessages();

    // If empty, show welcome message
    if (_messages.isEmpty) {
      final welcome = ChatMessage(
        text: "Hi! I'm your Fit Mind coach. Ask me about workouts, diet, or stress relief!",
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(welcome);
      await DatabaseHelper.instance.insertMessage(welcome);
    }

    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // 1. Update UI & DB immediately
    _messages.add(userMsg);
    await DatabaseHelper.instance.insertMessage(userMsg);
    _isLoading = true;
    notifyListeners();

    try {
      // 2. Call Gemini
      final response = await _chatSession.sendMessage(Content.text(text));
      final responseText = response.text ?? "I'm having trouble thinking. Try again?";

      final aiMsg = ChatMessage(
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      // 3. Save AI response
      _messages.add(aiMsg);
      await DatabaseHelper.instance.insertMessage(aiMsg);

    } catch (e) {
      final errorMsg = ChatMessage(
        text: "Error: Unable to connect. Check your internet or API Key.",
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMsg);
      await DatabaseHelper.instance.insertMessage(errorMsg);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}