import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:paper_gen/screens/screen1.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class AuthorisationScreen extends StatefulWidget {
  const AuthorisationScreen({super.key});

  @override
  State<AuthorisationScreen> createState() => _AuthorisationScreenState();
}

class _AuthorisationScreenState extends State<AuthorisationScreen> {
  @override
  void initState() {
    super.initState();
    checkPreSavedPassword();
  }

  checkPreSavedPassword() async {
    Box box = await Hive.openBox('user-credentials');
    if (box.isNotEmpty) {
      Provider.of<Data>(context, listen: false)
          .setFN(box.get('user-credentials')['fn'] ?? "Ayush");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    }
    box.close();
  }

  saveCredentials(var email, var fn, var password) async {
    Box box = await Hive.openBox('user-credentials');
    if (box.isNotEmpty) {
      box.clear();
    }
    var list = {'fn': fn, 'email': email, 'password': password};
    box.put('user-credentials', list);
    box.close();
  }

  var current = 0; //0 for login 1 for registration
  var colorRed1 = false;
  var colorRed2 = false;
  bool showSpinner = false;
  var email = '', password = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String fn = '';
  String ln = '';
  String pass2 = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  checkPassword() async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        setState(() {
          showSpinner = false;
        });
        final snapshot = await _firestore
            .collection('user_data')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        var data = snapshot.docs.first.data();
        Provider.of<Data>(context).setFN(data['first_name'] ?? 'Ayush');
        saveCredentials(email, fn, password);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        colorRed1 = true;
        showSpinner = false;
      });
    }
  }

  createUser() async {
    if (password == pass2) {
      try {
        var user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (user != null) {
          setState(() {
            showSpinner = false;
          });
          _firestore
              .collection('user_data')
              .add({'email': email, 'first_name': fn, 'last_name': ln});
          saveCredentials(email, fn, password);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()));
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          showSpinner = false;
          colorRed2 = true;
        });
        print(e);
      } catch (e) {
        print(e);
      }
    } else {
      setState(() {
        colorRed2 = true;
      });
    }
  }

  var colorLogin = Color(0xff04cd03);
  var colorRegister = Colors.grey[700];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff04cd03)),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.black54,
                  height: 50.0,
                  width: 400.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyExpanded(() {
                        setState(() {
                          colorLogin = Color(0xff04cd03);
                          colorRegister = Colors.grey[700]!;
                          current = 0;
                        });
                      }, colorLogin, "Login"),
                      MyExpanded(() {
                        setState(() {
                          colorRegister = Color(0xff04cd03);
                          colorLogin = Colors.grey[700]!;
                          current = 1;
                        });
                      }, colorRegister, "Register")
                    ],
                  ),
                ),
                if (current == 0)
                  Container(
                    height: 400,
                    width: 400,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            decoration:
                                InputDecoration(hintText: 'Fill Your Email'),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: 'Enter Your Password'),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff04cd03))),
                          onPressed: () {
                            showSpinner = true;
                            checkPassword();
                          },
                          child: Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Text(
                          'Couldn\'t Login!',
                          style: TextStyle(
                              color:
                                  colorRed1 ? Colors.red : Colors.transparent),
                        )
                      ],
                    ),
                  )
                else
                  Container(
                    height: 450,
                    width: 400,
                    child: Column(
                      children: [
                        MyPadding((value) {
                          setState(() {
                            fn = value;
                          });
                        }, "Enter your First name"),
                        SizedBox(
                          height: 10.0,
                        ),
                        MyPadding((value) {
                          setState(() {
                            ln = value;
                          });
                        }, "Enter your last name"),
                        SizedBox(
                          height: 15.0,
                        ),
                        MyPadding((value) {
                          setState(() {
                            email = value;
                          });
                        }, "Enter your email"),
                        SizedBox(
                          height: 15.0,
                        ),
                        MyPadding((value) {
                          setState(() {
                            password = value;
                          });
                        }, "Enter your password"),
                        SizedBox(
                          height: 15.0,
                        ),
                        MyPadding((value) {
                          setState(() {
                            pass2 = value;
                          });
                        }, "Confirm Your Password"),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff04cd03))),
                          onPressed: () {
                            showSpinner = true;
                            createUser();
                          },
                          child: Text(
                            "REGISTER",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Text(
                          'Could Not Register, try again!',
                          style: TextStyle(
                              color:
                                  colorRed2 ? Colors.red : Colors.transparent),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyExpanded extends StatelessWidget {
  MyExpanded(this.onTap, this.color, this.text);
  Color? color;
  GestureTapCallback onTap;
  String text;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Move Expanded outside GestureDetector
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center, // Center the text inside the container
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class MyPadding extends StatelessWidget {
  MyPadding(this.func, this.text);
  Function(String) func;
  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: TextStyle(color: Colors.white),
        onChanged: func,
        decoration: InputDecoration(hintText: text),
      ),
    );
  }
}
