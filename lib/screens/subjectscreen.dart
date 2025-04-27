import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paper_gen/screens/question_number_screen.dart';
import 'package:provider/provider.dart';

import '../assets/listtile.dart';
import '../data.dart';

class SubjectScreen extends StatelessWidget {
  SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Provider.of<Data>(context, listen: false).emptyList();
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, color: Colors.white),
            Text(
              'Subject Selection',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Container(
        child: Column(
          children: [
            MyListTile(
              FontAwesomeIcons.calculator,
              'Mathematics',
              'Enhance your problem solving and numerical skills',
              () {},
              false,
            ),
            MyListTile(
              FontAwesomeIcons.brain,
              'Aptitude & Reasoning',
              'Sharpen your logical and analytical reasoning & solve complex problems',
              () {},
              false,
            ),
            MyListTile(
              FontAwesomeIcons.earthAsia,
              'General Knowledge',
              'Stay informed on global events',
              () {},
              false,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 8.0,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff04cd03),
        child: Container(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Ensure visibility
          ),
          color: Color(0xff04cd03),
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              if (Provider.of<Data>(context, listen: false).getCount() == 0) {
                // Ensure the SnackBar context belongs to the Scaffold
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    elevation: 10.0, // Adjust elevation for better visibility
                    content: Text(
                      'Please select at least one subject',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior
                        .floating, // Avoid overlapping with BottomAppBar
                    margin: EdgeInsets.all(
                        10.0), // Add margin for floating SnackBar
                  ),
                );
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SliderPage()));
              }
            },
            child: Text(
              'Next',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
        ),
      ),
    );
  }
}
