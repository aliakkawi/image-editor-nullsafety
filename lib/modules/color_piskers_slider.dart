import 'package:flutter/material.dart';

import 'colors_picker.dart';

class ColorPiskersSlider extends StatefulWidget {
  @override
  _ColorPiskersSliderState createState() => _ColorPiskersSliderState();
}

class _ColorPiskersSliderState extends State<ColorPiskersSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      ),
      child: Column(
        children: [
          Text(
            'Slider Filter Color'.toUpperCase(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20.0,
          ),
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
                          //  currentColor = Color(value);
                        });
                      })),
              TextButton(
                onPressed: () {},
                child: Text('Reset'),
              ),
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text('Slider Opicity'),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                child:
                    Slider(value: 0.1, min: 0.0, max: 1.0, onChanged: (v) {}),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
