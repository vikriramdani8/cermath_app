class ModelResult{
  String quizId;
  String userId;
  String quizName;
  int score;
  int correctAnswer;
  int wrongAnswer;
  int notAnswer;

  ModelResult({
    required this.quizId,
    required this.userId,
    required this.quizName,
    required this.score,
    required this.correctAnswer,
    required this.wrongAnswer,
    required this.notAnswer
  });
}