class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    // Debug print the incoming JSON
    print('Parsing JSON: $json');
    
    // Handle different possible formats for options
    List<String> parseOptions(dynamic optionsData) {
      if (optionsData is List) {
        return optionsData.map((option) => option.toString()).toList();
      } else if (optionsData is Map) {
        return optionsData.values.map((option) => option.toString()).toList();
      }
      return [];
    }

    // Get question text
    final questionText = json['question']?.toString() ?? '';
    
    // Get options
    final optionsData = json['options'];
    final options = parseOptions(optionsData);
    
    // Get correct answer index
    final correctAnswer = json['correctAnswerIndex'];
    final correctAnswerIndex = correctAnswer is int 
        ? correctAnswer 
        : int.tryParse(correctAnswer.toString()) ?? 0;

    return QuizQuestion(
      question: questionText,
      options: options,
      correctAnswerIndex: correctAnswerIndex,
    );
  }
}