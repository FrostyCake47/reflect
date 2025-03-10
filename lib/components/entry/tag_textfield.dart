import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TagTextField extends StatelessWidget {
  final ThemeData themeData;
  TagTextField({super.key, required this.themeData});
  final String selectedColor = '0xFF452659';
  final List<String> availableColors = [
    '0xd91139',
    '0xFF595635',
    '0xFF556889',
    '0xFF454569',
    '0xFF262635',
    '0xFF452365',
    '0xFF565632',
    '0xFF785623',
    '0xFFA45563',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Color(int.parse(selectedColor)),
          width: 2.0,
        ),
        boxShadow: const [
           BoxShadow(
              blurRadius: 5.0,
              spreadRadius: 2.0,
              color: Color(0x11000000)
            )
        ],
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Add a tag',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 15,
              backgroundColor: Color(int.parse(selectedColor)),
            ),
            onPressed: () {
              showColorPicker(context);
            },
          ),
        ],
      ),
    );
  }

  void showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              paletteType: PaletteType.hueWheel,
              pickerColor: const Color(0xff443a49),
              labelTypes: [],
              onColorChanged: (Color color) {
                print(color);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}