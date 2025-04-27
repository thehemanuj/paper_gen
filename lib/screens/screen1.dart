import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:paper_gen/screens/past_paper.dart';
import 'package:paper_gen/screens/subjectscreen.dart';
import 'package:provider/provider.dart';
import '../assets/listtile.dart';
import '../data.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${Provider.of<Data>(context, listen: false).fn}',
              style: TextStyle(color: Colors.white, fontSize: 40.0),
              textAlign: TextAlign.start,
            ),
            MyListTile(null, 'Past Papers', 'Access previous question papers',
                () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuestionPaperListScreen()));
            }, false),
            MyListTile(null, 'Question Bank', 'Explore Questions', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectScreen(),
                ),
              );
            }, false),
            MyListTile(null, 'Exam Notifications',
                'Check dates of Upcoming Exams', () {}, false),
          ],
        ),
      ),
    );
  }
}
