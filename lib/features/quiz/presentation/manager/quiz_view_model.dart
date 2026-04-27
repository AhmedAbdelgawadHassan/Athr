import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/quiz_question.dart';
import '../../data/quiz_questions_data.dart';

part 'quiz_state.dart';

class QuizViewModel extends Cubit<QuizState> {
  QuizViewModel() : super(QuizState.initial());

  void startQuiz() {
    final questions = QuizQuestionsData.getDailyQuestions();
    emit(QuizState(
      questions: questions,
      currentQuestionIndex: 0,
      selectedAnswers: List<int?>.filled(questions.length, null),
      status: QuizStatus.inProgress,
    ));
  }

  void answerQuestion(int selectedOptionIndex) {
    if (state.isCurrentAnswered) return;

    final updatedAnswers = List<int?>.from(state.selectedAnswers);
    updatedAnswers[state.currentQuestionIndex] = selectedOptionIndex;

    emit(state.copyWith(
      selectedAnswers: updatedAnswers,
      status: QuizStatus.answered,
    ));
  }

  void nextQuestion() {
    if (state.isLastQuestion) {
      emit(state.copyWith(status: QuizStatus.completed));
      return;
    }
    emit(state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
      status: QuizStatus.inProgress,
    ));
  }

  void restartQuiz() => startQuiz();
}
