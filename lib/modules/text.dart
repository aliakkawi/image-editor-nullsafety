import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'colors_picker.dart';

class TextEditorImage extends StatefulWidget {
  const TextEditorImage({Key? key}) : super(key: key);

  @override
  _TextEditorImageState createState() => _TextEditorImageState();
}

class _TextEditorImageState extends State<TextEditorImage> {
  TextEditingController name = TextEditingController();
  Color currentColor = Colors.black;
  double slider = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              color: Colors.white,
              iconSize: align == TextAlign.left ? 30.0 : 25.0,
              onPressed: () {
                if (align == TextAlign.left) {
                  setState(() => align = null);
                } else {
                  setState(() => align = TextAlign.left);
                }
              },
              icon: Icon(FontAwesomeIcons.alignLeft)),
          IconButton(
              color: Colors.white,
              iconSize: align == TextAlign.center ? 30.0 : 25.0,
              onPressed: () {
                if (align == TextAlign.center) {
                  setState(() => align = null);
                } else {
                  setState(() => align = TextAlign.center);
                }
              },
              icon: Icon(FontAwesomeIcons.alignCenter)),
          IconButton(
              color: Colors.white,
              iconSize: align == TextAlign.right ? 30.0 : 25.0,
              onPressed: () {
                if (align == TextAlign.right) {
                  setState(() => align = null);
                } else {
                  setState(() => align = TextAlign.right);
                }
              },
              icon: Icon(FontAwesomeIcons.alignRight)),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: EdgeInsets.all(15),
          ),
          onPressed: () {
            Navigator.pop(context, {
              'name': name.text,
              'color': currentColor,
              'size': slider.toDouble(),
              'align': align
            });
          },
          child: Text(
            'Add Text',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22.0),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Insert Your Message',
                    hintStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                  ),
                  scrollPadding: EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 99999,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  autofocus: true,
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Slider Color'),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: BarColorPicker(
                                width: 300,
                                thumbColor: Colors.white,
                                cornerRadius: 10,
                                pickMode: PickMode.Color,
                                colorListener: (int value) {
                                  setState(() {
                                    currentColor = Color(value);
                                  });
                                })),
                        TextButton(
                          onPressed: () {},
                          child: Text('Reset'),
                        ),
                      ],
                    ),
                    Text('Slider White Black Color'),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: BarColorPicker(
                                width: 300,
                                thumbColor: Colors.white,
                                cornerRadius: 10,
                                pickMode: PickMode.Grey,
                                colorListener: (int value) {
                                  setState(() {
                                    currentColor = Color(value);
                                  });
                                })),
                        TextButton(
                          onPressed: () {},
                          child: Text('Reset'),
                        )
                      ],
                    ),
                    Container(
                      color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Size Adjust'.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Slider(
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                              value: slider,
                              min: 0.0,
                              max: 100.0,
                              onChangeEnd: (v) {
                                setState(() {
                                  slider = v;
                                });
                              },
                              onChanged: (v) {
                                setState(() {
                                  slider = v;
                                });
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextAlign? align;
}
