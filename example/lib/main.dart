import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;

  Future<void> getimageditor() =>
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImageEditorPro(
          appBarColor: Colors.black87,
          bottomBarColor: Colors.black87,
          pathSave: null,
          pixelRatio: null,
        );
      })).then((geteditimage) {
        if (geteditimage != null) {
          setState(() {
            _image = geteditimage;
          });
        }
      }).catchError((er) {
        print(er);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Image Editor Pro example',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
      body: condition(
          condtion: _image == null,
          isTrue: Center(
              child: ElevatedButton(
            onPressed: () => getimageditor(),
            child: Text('Open Editor'),
          )),
          isFalse: _image == null
              ? Container()
              : Center(child: Image.file(_image!))),
    );
  }
}

Widget condition(
    {required bool condtion, required Widget isTrue, required Widget isFalse}) {
  return condtion ? isTrue : isFalse;
}
