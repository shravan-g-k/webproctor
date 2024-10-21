import 'package:flutter/material.dart';
import 'package:webproctor/backend/backend.dart';
import 'package:webproctor/pages/join_exam/proctor_wrapper.dart';


class GetExamPage extends StatefulWidget {
  const GetExamPage(
      {super.key,
      required this.name,
      required this.rollNo,
      required this.roomCode});
  final String name;
  final String rollNo;
  final String roomCode;

  @override
  State<GetExamPage> createState() => _GetExamPageState();
}

class _GetExamPageState extends State<GetExamPage> {
  late Future<Map<String, dynamic>?> future;

  @override
  void initState() {
    future = Backend().getExam(widget.roomCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return ProctorWrapper(
            examData: snapshot.data as Map<String, dynamic>,
          );
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Name: ${widget.name}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Roll No: ${widget.rollNo}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Room Code: ${widget.roomCode}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(
                  "Invalid room code or quiz not found",
                  style: TextStyle(color: Colors.red[900]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
