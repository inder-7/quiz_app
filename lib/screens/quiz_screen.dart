import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz_question.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion> questions;

  const QuizScreen({Key? key, required this.questions}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  int? selectedAnswerIndex;
  late Timer _timer;
  int _timeLeft = 15; // 15 seconds per question
  bool _isTimeUp = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timeLeft = 15;
    _isTimeUp = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else if (!isAnswered) {
        setState(() {
          _isTimeUp = true;
          isAnswered = true;
        });
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          if (currentQuestionIndex < widget.questions.length - 1) {
            currentQuestionIndex++;
            isAnswered = false;
            selectedAnswerIndex = null;
            _startTimer();
          } else {
            _showResults();
          }
        });
      }
    });
  }

  void _handleAnswer(int selectedIndex) {
    if (isAnswered) return;

    _timer.cancel();
    setState(() {
      isAnswered = true;
      selectedAnswerIndex = selectedIndex;
      if (selectedIndex == widget.questions[currentQuestionIndex].correctAnswerIndex) {
        // Award points based on time left (more points for faster answers)
        int timeBonus = (_timeLeft / 5).round(); // Up to 3 bonus points
        score += 10 + timeBonus;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          if (currentQuestionIndex < widget.questions.length - 1) {
            currentQuestionIndex++;
            isAnswered = false;
            selectedAnswerIndex = null;
            _startTimer();
          } else {
            _showResults();
          }
        });
      }
    });
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: score,
          totalQuestions: widget.questions.length,
        ),
      ),
    );
  }

  Color _getOptionColor(int optionIndex) {
    if (!isAnswered && !_isTimeUp) return Colors.white;
    
    if (optionIndex == widget.questions[currentQuestionIndex].correctAnswerIndex) {
      return Colors.green.shade100;
    }
    if (optionIndex == selectedAnswerIndex) {
      return Colors.red.shade100;
    }
    return Colors.white;
  }

  Color _getTimerColor() {
    if (_timeLeft <= 5) {
      return Colors.red.shade400;
    } else {
      return Colors.purple.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestionIndex];

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade800,
              Colors.purple.shade500,
              Colors.purple.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${currentQuestionIndex + 1}/${widget.questions.length}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getTimerColor().withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getTimerColor(),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 20,
                                color: _timeLeft <= 5 ? Colors.red.shade400 : Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_timeLeft s',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: _timeLeft <= 5 ? Colors.red.shade400 : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        question.question,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...List.generate(
                    question.options.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getOptionColor(index),
                          foregroundColor: Colors.purple.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                        ),
                        onPressed: (isAnswered || _isTimeUp) ? null : () => _handleAnswer(index),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    color: Colors.purple.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            if (isAnswered || _isTimeUp)
                              Icon(
                                index == question.correctAnswerIndex
                                    ? Icons.check_circle
                                    : (index == selectedAnswerIndex
                                        ? Icons.cancel
                                        : null),
                                color: index == question.correctAnswerIndex
                                    ? Colors.green
                                    : Colors.red,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}