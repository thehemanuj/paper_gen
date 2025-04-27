import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class MyListTile2 extends StatelessWidget {
  final String leading;
  final String title;
  final String subtitle;
  final GestureTapCallback? function;
  MyListTile2(this.leading, this.title, this.subtitle, this.function);
  var padding = 8.0;
  var color = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Material(
        color: Colors.transparent, // Set the background color
        child: ListTile(
          onTap: function,
          leading: Text(leading,
              style: TextStyle(color: Color(0xff04cd03), fontSize: 32)),
          tileColor: color, // Optional: same as the Material color
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
