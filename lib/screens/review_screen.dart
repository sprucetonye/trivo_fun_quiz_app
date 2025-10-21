import 'package:flutter/material.dart';
import '../main.dart'; // Import for UserAnswer

class ReviewScreen extends StatelessWidget {
  final List<UserAnswer> userResponses;
  final VoidCallback onRestart;

  const ReviewScreen({
    Key? key,
    required this.userResponses,
    required this.onRestart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Answers'),
        actions: [
          TextButton(
            onPressed: onRestart,
            child: const Text(
              'Restart',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: userResponses.length,
        itemBuilder: (context, index) {
          final response = userResponses[index];
          final isCorrect = response.isCorrect;
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${index + 1}: ${response.question.text}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Answer: ${response.selectedOption ?? "Not answered"}',
                    style: TextStyle(
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                  if (!isCorrect)
                    Text(
                      'Correct Answer: ${response.question.correctAnswer}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  Text(
                    'Time Taken: ${response.timeTaken} ms',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
