// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/quiz_view_model.dart';
import 'widgets/quiz_option_item.dart';
import 'widgets/quiz_progress_bar.dart';
import 'widgets/quiz_result_page.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizViewModel()..startQuiz(),
      child: const _QuizView(),
    );
  }
}

// ── View: listens to ViewModel state, delegates actions back ─────────────────

class _QuizView extends StatelessWidget {
  const _QuizView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizViewModel, QuizState>(
      builder: (context, state) {
        if (state.status == QuizStatus.initial || state.questions.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == QuizStatus.completed) {
          return QuizResultPage(
            score: state.score,
            total: state.questions.length,
            onRestart: () => context.read<QuizViewModel>().restartQuiz(),
          );
        }

        return _QuizQuestionView(state: state);
      },
    );
  }
}

class _QuizQuestionView extends StatelessWidget {
  final QuizState state;

  const _QuizQuestionView({required this.state});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<QuizViewModel>();
    final question = state.currentQuestion;
    final isAnswered = state.isCurrentAnswered;
    final selectedAnswer = state.currentSelectedAnswer;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الاختبار الديني اليومي',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Color(0xFF1F2937),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.close_rounded,
                  color: Color(0xFF6B7280), size: 20),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Progress bar
              QuizProgressBar(
                current: state.currentQuestionIndex,
                total: state.questions.length,
              ),
              const SizedBox(height: 24),

              // Question card with slide-in animation
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: Container(
                  key: ValueKey(state.currentQuestionIndex),
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xffD4AF37).withOpacity(0.5),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[500]!),
                          color: const Color(0xffD4AF37).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'سؤال ${state.currentQuestionIndex + 1}',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: Color(0xff8B6B2E),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// QUESTION
                      Center(
                        child: Text(
                          question.question,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff1F2937),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Options list
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: ListView.builder(
                    key: ValueKey('opts_${state.currentQuestionIndex}'),
                    itemCount: question.options.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, i) => QuizOptionItem(
                      text: question.options[i],
                      index: i,
                      isSelected: selectedAnswer == i,
                      isCorrect: i == question.correctAnswerIndex,
                      isRevealed: isAnswered,
                      onTap: () => vm.answerQuestion(i),
                    ),
                  ),
                ),
              ),

              // Explanation + Next — appear only after answering
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: isAnswered
                    ? Padding(
                        key: const ValueKey('bottom_answered'),
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            // Explanation
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                border: Border.all(
                                    color: const Color(0xFF86EFAC), width: 1.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('💡',
                                      style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      question.explanation,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 13,
                                        height: 1.7,
                                        color: Color(0xFF166534),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Next / Finish button
                            SizedBox(
                              width: double.infinity,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6366F1),
                                      Color(0xFF8B5CF6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6366F1)
                                          .withOpacity(0.35),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: vm.nextQuestion,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  ),
                                  child: Text(
                                    state.isLastQuestion
                                        ? 'عرض النتيجة 🎯'
                                        : 'السؤال التالي ←',
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('bottom_empty')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
