import 'package:flutter/material.dart';
import 'package:webproctor/pages/join_exam/get_exam_page.dart';

class JoinExamPage extends StatefulWidget {
  const JoinExamPage({super.key});

  @override
  State<JoinExamPage> createState() => _JoinExamPageState();
}

class _JoinExamPageState extends State<JoinExamPage> {
  final nameController = TextEditingController();
  final roomCodeController = TextEditingController();
  final rollNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left side image section
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(10)),
                child: Image.asset(
                  'assets/join_exam.png', // Replace with your image URL
                  width: 350,
                ),
              ),
            ),
            // Right side form section
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Join the Quiz/Exam',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      // Name field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),
                      // Roll No field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Roll No',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        controller: rollNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter roll number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Code field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Code',
                          border: OutlineInputBorder(),
                        ),
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        controller: roomCodeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter room code';
                          }
                          if (value.length != 4) {
                            return 'Please enter a valid room code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      // Join button
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GetExamPage(
                                  name: nameController.text,
                                  rollNo: rollNumberController.text,
                                  roomCode: roomCodeController.text,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Join'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
