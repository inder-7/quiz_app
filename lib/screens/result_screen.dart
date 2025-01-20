import 'package:flutter/material.dart';
import 'package:quiz_app/screens/home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
  }) : super(key: key);

  String _getFeedback(double percentage) {
    if (percentage >= 90) {
      return 'Outstanding! You\'re a Flutter Master! 🏆👑';
    } else if (percentage >= 80) {
      return 'Excellent! You\'re a Flutter Expert! 🌟';
    } else if (percentage >= 70) {
      return 'Great job! Almost there! 🚀';
    } else if (percentage >= 60) {
      return 'Good work! Keep learning! 📚';
    } else if (percentage >= 40) {
      return 'Nice try! Practice more! 💪';
    } else {
      return 'Keep studying! You can do better! 📝';
    }
  }

  String _getAchievement(double percentage) {
    if (percentage >= 90) {
      return 'Flutter Master';
    } else if (percentage >= 80) {
      return 'Flutter Expert';
    } else if (percentage >= 70) {
      return 'Flutter Pro';
    } else if (percentage >= 60) {
      return 'Flutter Developer';
    } else if (percentage >= 40) {
      return 'Flutter Apprentice';
    } else {
      return 'Flutter Beginner';
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = ((score / totalQuestions) / 16) * 100;
    final feedback = _getFeedback(percentage);
    final achievement = _getAchievement(percentage);
    final baseScore = (score ~/ 16) * 10; // Calculate base score without bonuses
    final timeBonus = score - baseScore; // Calculate time bonuses

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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 160,
                      color: Colors.amber.shade300,
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.purple.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade300,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(
                        achievement,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.purple.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  feedback,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildScoreRow(
                        context,
                        'Total Questions:',
                        totalQuestions.toString(),
                      ),
                      const SizedBox(height: 12),
                      _buildScoreRow(
                        context,
                        'Correct Answers:',
                        '${score ~/ 16}',
                      ),
                      const SizedBox(height: 12),
                      _buildScoreRow(
                        context,
                        'Base Score:',
                        '$baseScore points',
                      ),
                      const SizedBox(height: 12),
                      _buildScoreRow(
                        context,
                        'Time Bonus:',
                        '+$timeBonus points',
                        color: Colors.amber.shade300,
                      ),
                      const Divider(color: Colors.white24, height: 24),
                      _buildScoreRow(
                        context,
                        'Total Score:',
                        '$score points',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Colors.purple.shade900.withOpacity(0.5),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  icon: const Icon(Icons.replay_rounded),
                  label: Text(
                    'Play Again',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRow(
    BuildContext context,
    String label,
    String value, {
    Color? color,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color ?? Colors.white,
                fontWeight: isBold ? FontWeight.bold : null,
              ),
        ),
      ],
    );
  }
}
