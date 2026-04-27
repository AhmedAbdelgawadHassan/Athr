part of 'quiz_view_model.dart';

enum QuizStatus { initial, inProgress, answered, completed }

class QuizState {
  final List<QuizQuestion> questions;
  final int currentQuestionIndex;
  final List<int?> selectedAnswers;
  final QuizStatus status;

  const QuizState({
    required this.questions,
    required this.currentQuestionIndex,
    required this.selectedAnswers,
    required this.status,
  });

  factory QuizState.initial() => const QuizState(
        questions: [],
        currentQuestionIndex: 0,
        selectedAnswers: [],
        status: QuizStatus.initial,
      );

  QuizState copyWith({
    List<QuizQuestion>? questions,
    int? currentQuestionIndex,
    List<int?>? selectedAnswers,
    QuizStatus? status,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      status: status ?? this.status,
    );
  }

  // ── Computed properties (ViewModel exposes these to the View) ──

  QuizQuestion get currentQuestion => questions[currentQuestionIndex];

  int? get currentSelectedAnswer => selectedAnswers[currentQuestionIndex];

  bool get isCurrentAnswered => currentSelectedAnswer != null;

  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;

  int get score => selectedAnswers.asMap().entries.where((e) {
        final idx = e.key;
        final ans = e.value;
        if (ans == null || idx >= questions.length) return false;
        return ans == questions[idx].correctAnswerIndex;
      }).length;

  double get scorePercentage =>
      questions.isEmpty ? 0 : (score / questions.length) * 100;
}
