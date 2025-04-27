import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../assets/slidertile.dart';
import '../data.dart';
import 'mainquestionscreen.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class SliderPage extends StatelessWidget {
  const SliderPage({super.key});

  @override
  Widget build(BuildContext context) {
    String _superscript(String input) {
      const superscripts = {
        '0': '⁰',
        '1': '¹',
        '2': '²',
        '3': '³',
        '4': '⁴',
        '5': '⁵',
        '6': '⁶',
        '7': '⁷',
        '8': '⁸',
        '9': '⁹',
        '+': '⁺',
        '-': '⁻',
      };
      return input.split('').map((c) => superscripts[c] ?? c).join();
    }

    String cleanLatex(String input) {
      String out = input;

      // Remove LaTeX dollar signs
      out = out.replaceAll(r'$', '');

      // Handle fractions
      out = out.replaceAllMapped(
          RegExp(r'\\frac{(.*?)}{(.*?)}'), (m) => '${m[1]}/${m[2]}');

      // Square roots
      out = out.replaceAllMapped(
          RegExp(r'\\sqrt\[(\d+)\]{(.*?)}'), (m) => '${m[1]}√${m[2]}');
      out = out.replaceAllMapped(RegExp(r'\\sqrt{(.*?)}'), (m) => '√${m[1]}');

      // Superscripts (x^2 → x²)
      out = out.replaceAllMapped(
          RegExp(r'(\w+)\^(\d+)'), (m) => '${m[1]}${_superscript(m[2]!)}');

      // Determinants (2x2 only for now)
      out = out.replaceAllMapped(
        RegExp(r'\\det\s*\\begin{bmatrix}(.*?)\\\\(.*?)\\end{bmatrix}'),
        (m) {
          final row1 = m[1]!.trim().replaceAll('&', ' ').trim();
          final row2 = m[2]!.trim().replaceAll('&', ' ').trim();
          return 'det | $row1 |\n    | $row2 |';
        },
      );

      // Common math symbols
      out = out.replaceAll(r'\cdot', '·');
      out = out.replaceAll(r'\pi', 'π');
      out = out.replaceAll(r'\pm', '±');
      out = out.replaceAll(r'\times', '×');
      out = out.replaceAll(r'\div', '÷');
      out = out.replaceAll(r'\%', '%');
      out = out.replaceAll(r'\angle', '∠');

      // Cleanup
      out = out.replaceAll(r'\text{', '');
      out = out.replaceAll(RegExp(r'[{}]'), '');

      // Replace multiple spaces with single
      out = out.replaceAll(RegExp(r'\s+'), ' ').trim();

      return out;
    }

    void fetchMaths(int maths) async {
      String url = 'https://ayush-math-api.onrender.com/generate-question';
      http.Response response;
      for (int i = 0; i < maths; i++) {
        response = await http.get(Uri.parse(url));
        Provider.of<Data>(context, listen: false)
            .addQuestion(cleanLatex(jsonDecode(response.body)['question']));
      }
    }

    void fetchGK(int gk) async {
      try {
        // Get provider instance
        var dataProvider = Provider.of<Data>(context, listen: false);

        // API URL
        String url = 'https://the-trivia-api.com/v2/questions';

        // Calculate number of API calls required (10 questions per call)
        int numCalls = (gk == 10) ? 1 : (gk / 10).ceil();

        for (int i = 0; i < numCalls; i++) {
          // Fetch data from the API
          http.Response response = await http.get(Uri.parse(url));

          if (response.statusCode == 200) {
            List<dynamic> data = jsonDecode(response.body);

            // Add questions to provider's questionSet
            for (int j = 0;
                j < 10 &&
                    dataProvider.questionSet.length < gk &&
                    j < data.length;
                j++) {
              dataProvider.addQuestion(data[j]['question']['text']);
            }

            // Stop fetching if enough questions are collected
            if (dataProvider.questionSet.length >= gk) {
              break;
            }
          } else {
            print(
                'Failed to fetch GK questions. Status Code: ${response.statusCode}');
            return;
          }
        }
      } catch (e) {
        print('Error fetching GK questions: $e');
      }
    }

    /// Fetching Aptitude Questions - Updated with Error Handling
    void fetchAptitude(int n) async {
      String url = 'https://aptitude-api.vercel.app/Random';

      try {
        for (int i = 1; i <= n; i++) {
          http.Response response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            Provider.of<Data>(context, listen: false)
                .addQuestion(data['question']);
          } else {
            print(
                'Failed to fetch Aptitude question. Status Code: ${response.statusCode}');
          }
        }
      } catch (e) {
        print('Error fetching Aptitude questions: $e');
      }
    }

    return SafeArea(
      child: Scaffold(
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
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.book, color: Colors.white),
              SizedBox(width: 5),
              Text(
                'Question Selection',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[900],
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              for (int i = 0;
                  i < Provider.of<Data>(context, listen: false).getCount();
                  i++)
                MySliderTile(i + 1,
                    Provider.of<Data>(context, listen: false).getList()[i])
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xff04cd03),
          child: Container(
            color: const Color(0xff04cd03),
            width: double.infinity,
            child: TextButton(
              onPressed: () async {
                // Start Loading Indicator
                Provider.of<Data>(context, listen: false).setLoading();

                fetchMaths(Provider.of<Data>(context, listen: false).maths);
                fetchAptitude(
                    Provider.of<Data>(context, listen: false).aptitude);
                fetchGK(Provider.of<Data>(context, listen: false).gk);
                //fetchMaths(Provider.of<Data>(context, listen: false).maths);

                // Navigate to MainQuestionScreen after fetching
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainQuestionScreen()),
                );

                // Stop Loading
                Provider.of<Data>(context, listen: false).setLoading();
              },
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
