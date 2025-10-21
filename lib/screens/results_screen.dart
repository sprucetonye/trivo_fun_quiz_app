import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final int score;
  final int total;
  final int answered;
  final VoidCallback onReview;
  final VoidCallback onRestart;

  const ResultsScreen({
    Key? key,
    required this.score,
    required this.total,
    required this.answered,
    required this.onReview,
    required this.onRestart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (score / total * 100).round();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Quiz Completed!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            'Your Score: $score / $total ($percentage%)',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Questions Answered: $answered / $total',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: onReview,
                child: const Text('Review Answers'),
              ),
              ElevatedButton(
                onPressed: onRestart,
                child: const Text('Restart Quiz'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
