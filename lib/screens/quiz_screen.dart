import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuizScreen extends StatefulWidget {
  final QuestionModel question;
  final int questionIndex;
  final int totalQuestions;
  final String? existingSelectedOption;
  final Function(String? selectedOption, int timeTaken) onAnswer;
  final Function(int index) onNavigate;

  const QuizScreen({
    Key? key,
    required this.question,
    required this.questionIndex,
    required this.totalQuestions,
    this.existingSelectedOption,
    required this.onAnswer,
    required this.onNavigate,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? _selectedOption;
  late int _startTime;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.existingSelectedOption;
    _startTime = DateTime.now().millisecondsSinceEpoch;
  }

  void _submitAnswer() {
    final timeTaken = DateTime.now().millisecondsSinceEpoch - _startTime;
    widget.onAnswer(_selectedOption, timeTaken);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${widget.questionIndex + 1} of ${widget.totalQuestions}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          Text(
            widget.question.text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ...widget.question.options.map(
            (option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: widget.questionIndex > 0
                    ? () => widget.onNavigate(widget.questionIndex - 1)
                    : null,
                child: const Text('Previous'),
              ),
              ElevatedButton(
                onPressed: _selectedOption != null ? _submitAnswer : null,
                child: Text(
                  widget.questionIndex < widget.totalQuestions - 1
                      ? 'Next'
                      : 'Finish',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
