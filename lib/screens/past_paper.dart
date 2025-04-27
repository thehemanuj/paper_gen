import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:paper_gen/assets/list_tile2.dart';

class QuestionPaperListScreen extends StatefulWidget {
  const QuestionPaperListScreen({Key? key}) : super(key: key);

  @override
  _QuestionPaperListScreenState createState() =>
      _QuestionPaperListScreenState();
}

class _QuestionPaperListScreenState extends State<QuestionPaperListScreen> {
  List<List<String>>? questionPapers = [];
  @override
  void initState() {
    super.initState();
    loadQuestionPapers();
  }

  void loadQuestionPapers() async {
    try {
      final box = await Hive.openBox('questionPaperBox');
      final rawData = box.get('questionPapers');

      setState(() {
        if (rawData is List<List<dynamic>>) {
          // Each paper is already a list of questions
          questionPapers =
              rawData.map((paper) => paper.cast<String>()).toList();
        } else if (rawData is List<String>) {
          // Treat this whole list as ONE paper with multiple questions
          questionPapers = [rawData];
        } else {
          questionPapers = [
            ['No Question Papers Saved']
          ];
          print('Error: Unexpected data format!');
        }
      });
    } catch (e) {
      print('Hive Error: $e');
      setState(() {
        questionPapers = [
          ['Failed to load question papers']
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Question Papers',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black, //Color(0xff04cd03)
      ),
      body: ListView.builder(
        itemCount: questionPapers?.length,
        itemBuilder: (context, index) {
          return MyListTile2(
            (index + 1).toString(),
            'Question Paper ${index + 1}',
            'Click to Open This Paper',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QScreen(paper: questionPapers![index])));
            },
          );
        },
      ),
    );
  }
}

class QScreen extends StatelessWidget {
  final List<String> paper;

  const QScreen({Key? key, required this.paper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Questions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: paper.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              "${index + 1}.) ${paper[index]}",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
