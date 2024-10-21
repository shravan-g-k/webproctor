import 'dart:math';

import 'package:flutter/material.dart';
import 'package:webproctor/backend/backend.dart';
import 'package:webproctor/utils/color_constants.dart';

class CreateExamPage extends StatefulWidget {
  const CreateExamPage({super.key});

  @override
  State<CreateExamPage> createState() => _CreateExamPageState();
}

class _CreateExamPageState extends State<CreateExamPage> {
  final formKey = GlobalKey<FormState>();
  final questionAnswerKey = GlobalKey<FormState>();
  final Map<String, List> questionAnswers = {};
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  List<Map<String, dynamic>> editingOptions = [];
  bool isRight = false;
  late String roomCode;

  @override
  void initState() {
    var rng = Random();
    roomCode = (1000 + rng.nextInt(9000)).toString();
    super.initState();
  }

  void publishExam() {
    Backend()
        .publishExam(
      roomCode: roomCode,
      name: nameController.text,
      questionAndAnswers: questionAnswers,
    )
        .then((value) {
      if (value) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text(
                    "Exam Published",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Ok"),
                    ),
                  ]);
            });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Error",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  const Text(
                    "Create Exam",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "# $roomCode",
                    style: const TextStyle(fontSize: 30),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  "Publish Exam?",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                content: const Text(
                                  "Are you sure you want to publish this exam?",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      publishExam();
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            });
                      }
                    },
                    child: const Text("Publish"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Exam Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Add questions",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: questionAnswerKey,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: questionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Question',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: answerController,
                          decoration: InputDecoration(
                            prefix: IconButton(
                              onPressed: () {
                                setState(() {
                                  isRight = !isRight;
                                });
                              },
                              icon: Icon(
                                isRight ? Icons.close : Icons.check,
                                color: ColorConst.darkPurple,
                                fill: 1,
                              ),
                            ),
                            suffix: IconButton(
                              onPressed: () {
                                if (questionAnswerKey.currentState!
                                    .validate()) {
                                  editingOptions.add({
                                    'option': answerController.text,
                                    'isRight': isRight
                                  });
                                  setState(() {
                                    answerController.clear();
                                    isRight = false;
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.add,
                                color: ColorConst.darkPurple,
                                fill: 1,
                              ),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: const Color.fromARGB(50, 255, 255, 255),
                            labelText: 'Option',
                          ),
                          validator: (value) {
                            if (editingOptions.isNotEmpty) {
                              return null;
                            }
                            if (value == null || value.isEmpty) {
                              return 'Please enter some Option';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (answerController.text.isNotEmpty) {
                            editingOptions.add({
                              'option': answerController.text,
                              'isRight': isRight
                            });
                          }
                          if (questionAnswerKey.currentState!.validate()) {
                            questionAnswers[questionController.text] =
                                editingOptions;
                            setState(() {
                              questionController.clear();
                              answerController.clear();
                              editingOptions = [];
                              isRight = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50),
                        ),
                        child: const Text("Submit"),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: editingOptions.length,
                itemBuilder: (context, index) {
                  return Text(
                    "${index + 1}. ${editingOptions[index]['option']} ${editingOptions[index]['isRight'] ? 'right' : ''}",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  );
                },
              ),
              const Text(
                "Questions and Answers",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: questionAnswers.keys.length,
                itemBuilder: (context, index) {
                  String question = questionAnswers.keys.elementAt(index);
                  List options = questionAnswers[question]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}.$question",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: options.length,
                        itemBuilder: (context, optionIndex) {
                          Map option = options[optionIndex];
                          return Text(
                            "${optionIndex + 1}. ${option['option']}",
                            style: TextStyle(
                              fontSize: 15,
                              color: option['isRight']
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
