import 'dart:async';
import 'package:flutter/material.dart';
import 'models/question_model.dart';
import 'data/quiz_data.dart';
import 'screens/quiz_screen.dart';
import 'screens/results_screen.dart';
import 'screens/review_screen.dart';


// import 'package:flutter_quiz_app/models/question_model.dart'; // Corrected import path
// import 'package:flutter_quiz_app/screens/quiz_screen.dart'; // Missing import
// import 'package:flutter_quiz_app/screens/results_screen.dart'; // Missing import
// import 'package:flutter_quiz_app/screens/review_screen.dart';
// import 'package:trivo_fun/models/question_model.dart'; // Missing import

// -----------------------------------------------------------------------------
// Global State Management Helpers
// -----------------------------------------------------------------------------

class UserAnswer {
  // Corrected type to 'Question' for consistency with our plan and other usage
  final QuestionModel question; 
  final String? selectedOption; 
  final int timeTaken; 

  UserAnswer({
    required this.question, 
    this.selectedOption,
    this.timeTaken = 0,
  });
  
  bool get isCorrect => selectedOption == question.correctAnswer;
}


// -------------------------------------------------------------------------------
// The InheritedWidget to provide state down the tree
// -------------------------------------------------------------------------------


class QuizController extends InheritedWidget {
  // Static quiz data
  // Corrected type to 'Question' and data source name to 'techQuizQuestions'
  final List<QuestionModel> questions = question;

  // State variable and setters managed by QuizAppState
  // Standardized to 'userResponses' (plural)
  final List<UserAnswer> userResponses;
  final Function(int index) goToQuestion;
  final Function(String? selectedOption, int timeTaken) recordAnswer;
  final Function() resetQuiz;
  final int currentQuestionIndex;
  final int totalQuestions;


  QuizController({
    // Corrected capitalization of 'Key' to 'key'
    Key? key,
    required Widget child,
    required this.currentQuestionIndex,
    required this.userResponses, // Standardized to plural
    required this.goToQuestion,
    required this.recordAnswer,
    required this.resetQuiz,
  }) : totalQuestions = question.length, super(key: key, child: child);

  static QuizController of(BuildContext context){ // Renamed 'content' to 'context' for clarity
    // Added missing parenthesis and semicolon
    final QuizController? result = context.dependOnInheritedWidgetOfExactType<QuizController>(); 
    assert(result != null, 'No QuizController found in context');
    return result!;
  }

  int get score => userResponses.where((r) => r.isCorrect).length; // Used plural 'userResponses'

  @override
  bool updateShouldNotify(QuizController oldWidget){
    return currentQuestionIndex != oldWidget.currentQuestionIndex || userResponses.length != oldWidget.userResponses.length; // Used plural 'userResponses'
  }
}


// -----------------------------------------------------------------------------------
// THe main Application State (Manages _currentQuestionIndex and _userResponses)
// -----------------------------------------------------------------------------------

class QuizAppState extends StatefulWidget {
  const QuizAppState({Key? key}) : super(key: key);


  @override
  // Added missing semicolon
  State<QuizAppState> createState() => _QuizAppStateState();
}

class _QuizAppStateState extends State<QuizAppState> {
  int _currentQuestionIndex = 0;
  // Standardized to '_userResponses' (plural) and removed the duplicate declaration
  final List<UserAnswer> _userResponses = [];
  // Corrected typo from 'techQuizQuiestions' to 'techQuizQuestions'
  final List<QuestionModel> _questions = question;
  int _remainingTime = 30;
  Timer? _timer;


  // Handles recording the answer and advancing to the next question

  void _recordAnswer(String? selectedOption, int timeTaken){
    // Standardized to use '_userResponses' (plural)
    final existingIndex = _userResponses.indexWhere((ua) => ua.question == _questions[_currentQuestionIndex]);

    final newAnswer = UserAnswer(
      question: _questions[_currentQuestionIndex],
      selectedOption: selectedOption,
      timeTaken: timeTaken,
    );

    setState(() {
      if(existingIndex != -1){
        // Update existing answer
        _userResponses[existingIndex] = newAnswer;
      }else{
        // Add new answer
        _userResponses.add(newAnswer);
      }
      // Move to the next question
      if(_currentQuestionIndex < _questions.length - 1){
        _currentQuestionIndex++;
        _remainingTime = 30; // Reset timer for next question
      }else if(_currentQuestionIndex == _questions.length - 1){
        // If it was the last question, setting index to length will trigger results/review
        _currentQuestionIndex++;
        _timer?.cancel();
      }
    });
  }

  // Allows navigation via Previous/Next buttons

  void _goToQuestion(int index){
    setState(() {
      _currentQuestionIndex = index;
      _remainingTime = 30; // Reset timer when navigating
    });
  }

  void _resetQuiz(){
    setState(() {
      _currentQuestionIndex = 0;
      _userResponses.clear(); // Used plural
      _remainingTime = 30;
      _timer?.cancel();
      _startTimer();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _autoSubmit();
        }
      });
    });
  }

  void _autoSubmit() {
    _timer?.cancel();
    // Record unanswered question
    final currentQuestion = _questions[_currentQuestionIndex];
    final existingIndex = _userResponses.indexWhere((ua) => ua.question == currentQuestion);
    if (existingIndex == -1) {
      final newAnswer = UserAnswer(
        question: currentQuestion,
        selectedOption: null,
        timeTaken: 30000, // 30 seconds
      );
      _userResponses.add(newAnswer);
    }
    // Auto-advance
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _remainingTime = 30;
      _startTimer();
    } else {
      _currentQuestionIndex++;
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // -----------------------------------------------------------------------------------
  // Screen Builder Logic (The Navigator)
  // ----------------------------------------------------------------------------------

  Widget _buildCurrentScreen(){
    // If index is past the total number of questions, show the Review Screen.
    // This is triggered by the onReview callback from ResultsScreen.
    if(_currentQuestionIndex > _questions.length){
      return ReviewScreen(
        userResponses: _userResponses, // Corrected property name and variable name
        onRestart: _resetQuiz,
      );
    }

    // If index is exactly the length, all questions have been answered. Show Results.
    if(_currentQuestionIndex == _questions.length){
      final int finalScore = _userResponses.where((r) => r.isCorrect).length; // Used plural
      final int answered = _userResponses.length;
      return ResultsScreen(
        score: finalScore,
        total: _questions.length,
        answered: answered,
        onReview: (){
          // Set index to a value that triggers the ReviewScreen
          setState(() => _currentQuestionIndex++);
        },
        onRestart: _resetQuiz,
      );
    }
// Otherwise, show the current question
else{
  // Find existing answer for this question (if any) to pre-select
  final existingAnswer = _userResponses.firstWhere( // Used plural
    (ua) => ua.question == _questions[_currentQuestionIndex],
    orElse: () => UserAnswer(question: _questions[_currentQuestionIndex]),
  );

  return QuizScreen(
    key: ValueKey(_currentQuestionIndex),
    question: _questions[_currentQuestionIndex],
    questionIndex: _currentQuestionIndex,
    totalQuestions: _questions.length,
    existingSelectedOption: existingAnswer.selectedOption,
    onAnswer: _recordAnswer,
    onNavigate: _goToQuestion,
  );
}
  }


@override
// Renamed 'content' to 'context' and fixed the usage of QuizController constructor
Widget build (BuildContext context) { 
  // The QuizController wraps the screen to pass down all state
  return QuizController(
    currentQuestionIndex: _currentQuestionIndex, // Use state variable
    userResponses: _userResponses, // Use state variable
    goToQuestion: _goToQuestion, // Use state method
    recordAnswer: _recordAnswer, // Use state method
    resetQuiz: _resetQuiz, // Use state method
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Corrected capitalization
        title: const Text("Trivo Fun Quiz"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: _remainingTime <= 10 ? Colors.red : Colors.indigo.shade700,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '⏱️ ${_remainingTime}s',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            // Corrected 'maxHeight' to 'maxWidth'
            maxWidth: 600
          ), 
          child: _buildCurrentScreen(),
        ),
      ),
    )
    );
}

}

// ----------------------------------------------------------------------------------------
// Main Entry Point
// ----------------------------------------------------------------------------------------

void main(){
  // Added 'const' for best practice
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  // Added 'const' for best practice
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Corrected capitalization
      title: 'Tech Trivia Quiz', 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
        useMaterial3: true
      ),
      // Added 'const' for best practice
      home: const QuizAppState(), 
    );
  }
}
