import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class MyListTile extends StatefulWidget {
  final IconData? leading;
  final String title;
  final String subtitle;
  final GestureTapCallback? function;
  var checkBox;
  MyListTile(
      this.leading, this.title, this.subtitle, this.function, this.checkBox);
  var padding = 8.0;
  var color = Colors.black;

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Material(
        color: Colors.transparent, // Set the background color
        child: widget.leading == null
            ? ListTile(
                onTap: widget.function,
                tileColor: widget.color, // Optional: same as the Material color
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                title: Text(
                  widget.title,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  widget.subtitle,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListTile(
                trailing: Checkbox(
                    activeColor: Colors.black,
                    checkColor: Color(0xff04cd03),
                    value: widget.checkBox,
                    onChanged: (value) {
                      setState(() {
                        widget.checkBox = !widget.checkBox;
                        if (widget.checkBox) {
                          Provider.of<Data>(context, listen: false)
                              .addSubject(widget.title);
                        } else {
                          Provider.of<Data>(context, listen: false)
                              .removeSubject(widget.title);
                        }
                      });
                    }),
                onTap: () {
                  setState(() {
                    widget.checkBox = !widget.checkBox;
                    if (widget.checkBox) {
                      Provider.of<Data>(context, listen: false)
                          .addSubject(widget.title);
                    } else {
                      Provider.of<Data>(context, listen: false)
                          .removeSubject(widget.title);
                    }
                  });
                },
                leading: Icon(
                  widget.leading,
                  color: Colors.white,
                ),
                tileColor: widget.color, // Optional: same as the Material color
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                title: Text(
                  widget.title,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  widget.subtitle,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
      ),
    );
  }
}
