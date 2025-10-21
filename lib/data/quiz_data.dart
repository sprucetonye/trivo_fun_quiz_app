import 'package:flutter/material.dart';

import '../models/question_model.dart';

final List<QuestionModel> question = [
  QuestionModel(
    text:
        "Which programming language was developed by James Gosling at Sun Microsystems?",
    options: ["Python", "Java", "C++", "Swift"],
    correctAnswer: "Java",
  ),

  QuestionModel(
    text: "What does HTTP stands for?",
    options: [
      "Hyper Text Transfer Protocol",
      "High Tech Transmission Project",
      "Home Tool Time Protocol",
      "Hyperlink & Text Tool Platform",
    ],
    correctAnswer: "Hyper Text Transfer Protocol",
  ),

  QuestionModel(
    text: "In the context of Flutter, what widget is used to apply padding?",
    options: ["Container", "Padding", "SizedBox", "Margin"],
    correctAnswer: "Padding",
  ),
  QuestionModel(
    text: "Which company created the popular JavaScript library, React?",
    options: ["Google", "Microsoft", "Facebook", "Amazon"],
    correctAnswer: "Facebook",
  ),
  QuestionModel(
    text: "What is the primary function of the 'git pull' command?",
    options: [
      "To push local commits to a remote repository",
      "To download content from a remote repository and integrate it",
      "To create a new branch",
      "To view the commit history",
    ],
    correctAnswer:
        "To download content from a remote repository and integrate it",
  ),
  QuestionModel(
    text: "What year was the first iPhone released?",
    options: ["2005", "2007", "2009", "2010"],
    correctAnswer: "2007",
  ),
  QuestionModel(
    text: "The term 'API' stands for?",
    options: [
      "Application Performance Interface",
      "Automated Program Integration",
      "Application Programming Interface",
      "Advanced Protocol Interpreter",
    ],
    correctAnswer: "Application Programming Interface",
  ),
  QuestionModel(
    text: "Which type of database stores data in rows and columns?",
    options: [
      "NoSQL",
      "Graph Database",
      "Relational Database",
      "Key-Value Store",
    ],
    correctAnswer: "Relational Database",
  ),
  QuestionModel(
    text:
        "What is the CSS property used to change the text color of an element?",
    options: ["background-color", "font-color", "color", "text-style"],
    correctAnswer: "color",
  ),
  QuestionModel(
    text:
        "Which data structure operates on a Last-In, First-Out (LIFO) principle?",
    options: ["Queue", "List", "Stack", "Tree"],
    correctAnswer: "Stack",
  ),
];
