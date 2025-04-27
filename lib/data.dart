import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Data extends ChangeNotifier {
  var isLoading = false;
  var fn = "";

  setFN(String name) {
    fn = name;
    notifyListeners();
  }

  setLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void addMath(Widget maths) {
    questionMaths.add(maths);
    notifyListeners();
  }

  void addQuestion(String question) {
    questionSet.add(question);
    notifyListeners();
  }

  List<String> _subjects = [];
  var aptitude = 0;
  var maths = 0;
  var gk = 0;
  List<String> questionSet = [];
  List<Widget> questionMaths = [];
  void setMaths(int value) {
    maths = value;
    notifyListeners();
  }

  void setAptitude(int value) {
    aptitude = value;
    notifyListeners();
  }

  onQuestionScreenBack() {
    questionSet = [];
    notifyListeners();
  }

  void setGK(int value) {
    gk = value;
    notifyListeners();
  }

  int getCount() {
    return _subjects.length;
  }

  getList() {
    return _subjects;
  }

  emptyList() {
    _subjects = [];
    notifyListeners();
  }

  addSubject(String subject) {
    _subjects.add(subject);
    notifyListeners();
  }

  removeSubject(String subject) {
    _subjects.remove(subject);
    notifyListeners();
  }
}
