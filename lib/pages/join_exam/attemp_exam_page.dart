import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final Map<String, dynamic> examData;

  const QuizPage({super.key, required this.examData});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  late List<MapEntry<String, dynamic>> questions;
  late List<int?> selectedAnswers;
  String examName = '';
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    examName = widget.examData['name'] ?? 'Quiz';
    questions = (widget.examData['questionAndAnswers'] as Map<String, dynamic>)
        .entries
        .toList();
    selectedAnswers = List.filled(questions.length, null);
  }

  void _submitQuiz() {
    // Check if all questions are answered
    if (selectedAnswers.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
      return;
    }

    setState(() {
      _submitted = true;
    });

    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      final options = questions[i].value as List<dynamic>;
      if (options[selectedAnswers[i]!]['isRight'] == true) {
        score++;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Complete',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          content: Text(
            'Your score: $score out of ${questions.length}',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          actions: [
            TextButton(
              child: const Text('Exit Quiz'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(examName),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...questions.asMap().entries.map((entry) {
                    final questionIndex = entry.key;
                    final question = entry.value;
                    final options = question.value as List<dynamic>;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 24.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Question ${questionIndex + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              question.key,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...options.asMap().entries.map((option) {
                              final isSelected =
                                  selectedAnswers[questionIndex] == option.key;
                              final isCorrectAnswer =
                                  options[option.key]['isRight'] == true;

                              Color? backgroundColor;
                              if (_submitted) {
                                if (isCorrectAnswer) {
                                  backgroundColor = Colors.green[100];
                                } else if (isSelected && !isCorrectAnswer) {
                                  backgroundColor = Colors.red[100];
                                }
                              } else if (isSelected) {
                                backgroundColor = Colors.blue[100];
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Material(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  child: InkWell(
                                    onTap: _submitted
                                        ? null
                                        : () {
                                            setState(() {
                                              selectedAnswers[questionIndex] =
                                                  option.key;
                                            });
                                          },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.grey,
                                                width: 2,
                                              ),
                                            ),
                                            child: isSelected
                                                ? const Center(
                                                    child: Icon(
                                                      Icons.check,
                                                      size: 16,
                                                      color: Colors.blue,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              option.value['option'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                          if (_submitted && isCorrectAnswer)
                                            const Icon(Icons.check_circle,
                                                color: Colors.green),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _submitted ? null : _submitQuiz,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                _submitted ? 'Quiz Submitted' : 'Submit Quiz',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
