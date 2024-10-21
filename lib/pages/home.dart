import 'package:flutter/material.dart';
import 'package:webproctor/pages/create_exam/create_exam_page.dart';
import 'package:webproctor/pages/join_exam/join_exam_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/2.png',
                  width: 350,
                ),
                Image.asset(
                  'assets/1.png',
                  width: 350,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(150, 75)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JoinExamPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                  label: const Text(
                    "Join Exam",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      const Size(150, 75),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateExamPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_box_rounded),
                  label: const Text(
                    "Create Exam",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
