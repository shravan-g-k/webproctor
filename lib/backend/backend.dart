import 'package:cloud_firestore/cloud_firestore.dart';

class Backend {
  Future<bool> publishExam({
    required String roomCode,
    required String name,
    required Map<String, dynamic> questionAndAnswers,
  }) async {
    final CollectionReference<Map<String, dynamic>> examsRef =
        FirebaseFirestore.instance.collection('exams');

    try {
      await examsRef
          .doc(roomCode)
          .set({'name': name, 'questionAndAnswers': questionAndAnswers});
          //Quaetions and answers are in this way : { 'name' : [{'isRight' : 'true', 'option' : 'option'}] }
      return true;
    } catch (e) {
      return false;
    }
  }

    Future<Map<String, dynamic>?> getExam(String roomCode) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> examDoc = 
          await FirebaseFirestore.instance.collection('exams').doc(roomCode).get();
      
      if (examDoc.exists) {
        return examDoc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

