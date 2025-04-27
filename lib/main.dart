import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paper_gen/screens/authorisation_screen.dart';
import 'package:paper_gen/screens/screen1.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'data.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
        create: (BuildContext context) {
          return Data();
        },
        child: MaterialApp(
          home: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.grey[900],
              body: AuthorisationScreen() //WelcomeScreen()
              ,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      ' PaperGen',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
