import 'package:flutter/material.dart';
import 'package:paper_gen/data.dart';
import 'package:provider/provider.dart';

class MySliderTile extends StatefulWidget {
  MySliderTile(this.index, this.title);
  String title;
  int index;

  @override
  State<MySliderTile> createState() => _MySliderTileState();
}

class _MySliderTileState extends State<MySliderTile> {
  int sliderValue = 10;
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 26.0, top: 5.0),
            child: Text(
              'Section ${widget.index}:${widget.title}',
              style: TextStyle(color: Colors.white, fontSize: 26.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 26.0),
            child: Text('Number of questions: $sliderValue',
                style: TextStyle(color: Colors.white)),
          ),
          Slider(
            thumbColor: Color(0xff04cd03),
            activeColor: Color(0xff04cd03),
            value: sliderValue.toDouble(),
            onChanged: (value) {
              setState(() {
                sliderValue = value.toInt();
                if (widget.title == 'Mathematics') {
                  Provider.of<Data>(context, listen: false)
                      .setMaths(sliderValue);
                } else if (widget.title == 'Aptitude & Reasoning') {
                  Provider.of<Data>(context, listen: false)
                      .setAptitude(sliderValue);
                } else if (widget.title == 'General Knowledge') {
                  Provider.of<Data>(context, listen: false).setGK(sliderValue);
                }
              });
            },
            min: 10,
            max: 20,
            divisions: 10,
          )
        ],
      ),
    );
  }
}
