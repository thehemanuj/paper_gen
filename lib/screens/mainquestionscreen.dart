import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data.dart';

class MainQuestionScreen extends StatelessWidget {
  const MainQuestionScreen({super.key});

  void saveQuestionPaper(BuildContext context) async {
    final box = await Hive.openBox('questionPaperBox');
    try {
      final questionSet = Provider.of<Data>(context, listen: false).questionSet;

      // Get the existing list or create a new one
      List<List<dynamic>> existingPapers =
          box.get('questionPapers', defaultValue: [[]])!;
      existingPapers.add(questionSet);

      await box.put('questionPapers', existingPapers);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Provider.of<Data>(context, listen: false).onQuestionScreenBack();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.green,
            )),
        backgroundColor: Colors.black,
        title: const Text(
          'Questions',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Consumer<Data>(
        builder: (context, data, child) {
          return data.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    return Text(
                      "${index + 1}) ${data.questionSet[index]}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    );
                  },
                  itemCount: data.questionSet.length,
                );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xff04cd03),
        child: Container(
          color: const Color(0xff04cd03),
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              saveQuestionPaper(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Question Paper Saved')));
            },
            child: const Text(
              'SAVE PAPER',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
        ),
      ),
    );
  }
}
