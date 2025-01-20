import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/quiz_question.dart';

class QuizService {
  static const String apiUrl = 'https://api.jsonserve.com/Uw5CrX';
  static const int timeoutDuration = 10; // Timeout after 10 seconds

  // Mock data to use when API is unavailable
  static final List<Map<String, dynamic>> mockQuizData = [
    {
      "question": "What is Flutter?",
      "options": [
        "A mobile development framework",
        "A database system",
        "A programming language",
        "An operating system"
      ],
      "correctAnswerIndex": 0
    },
    {
      "question": "Which programming language is used in Flutter?",
      "options": ["Java", "Kotlin", "Dart", "Swift"],
      "correctAnswerIndex": 2
    },
    {
      "question": "What is a Widget in Flutter?",
      "options": [
        "A UI component",
        "A database",
        "A programming language",
        "A testing framework"
      ],
      "correctAnswerIndex": 0
    },
    {
      "question": "What is the main advantage of Flutter?",
      "options": [
        "Native performance",
        "Cross-platform development",
        "Easy to learn",
        "All of the above"
      ],
      "correctAnswerIndex": 3
    },
    {
      "question": "Which company developed Flutter?",
      "options": ["Apple", "Google", "Microsoft", "Facebook"],
      "correctAnswerIndex": 1
    }
  ];

  Future<List<QuizQuestion>> fetchQuizQuestions() async {
    try {
      print('Fetching quiz questions from: $apiUrl');
      
      final response = await http
          .get(
            Uri.parse(apiUrl),
            headers: {
              'Accept': 'application/json',
              'Cache-Control': 'no-cache',
            },
          )
          .timeout(Duration(seconds: timeoutDuration));

      print('API Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        print('Decoded Data: $decodedData');

        if (decodedData is Map<String, dynamic> && decodedData.containsKey('questions')) {
          final List<dynamic> questionsData = decodedData['questions'] as List<dynamic>;
          final List<QuizQuestion> questions = [];

          for (var questionData in questionsData) {
            try {
              if (questionData is Map<String, dynamic> &&
                  questionData.containsKey('description') &&
                  questionData.containsKey('options')) {
                
                // Convert the API data format to our QuizQuestion format
                final Map<String, dynamic> formattedQuestion = {
                  'question': questionData['description'],
                  'options': questionData['options']
                      .map((option) => option['description'].toString())
                      .toList(),
                  'correctAnswerIndex': questionData['options']
                      .indexWhere((option) => option['is_correct'] == true),
                };

                questions.add(QuizQuestion.fromJson(formattedQuestion));
                print('Successfully parsed question: ${questionData['description']}');
              }
            } catch (e) {
              print('Error parsing question: $e');
            }
          }

          if (questions.isNotEmpty) {
            print('Successfully loaded ${questions.length} questions from API');
            return questions;
          }
        }
      }
      
      throw Exception('Failed to load questions from API');
      
    } catch (e) {
      print('Error fetching questions from API: $e');
      rethrow;
    }
  }

  List<QuizQuestion> _getMockQuestions() {
    return mockQuizData
        .map((questionData) => QuizQuestion.fromJson(questionData))
        .toList();
  }
}
