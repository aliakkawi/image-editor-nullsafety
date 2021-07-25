import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_editor_pro/image_editor_pro.dart';
import 'package:http/http.dart' as http;

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
  Uint8List? _image;
  int counter = 0;
  List<String> urls = [
    'https://fdr-cover-images.imgix.net/2020/04/2poRcBXr-free-office-macbook-pro-mockup-Designrepos-090420.jpg?auto=format&ixlib=php-3.3.0&s=08852a4122c2c4b87ca814f621ddcccf',
    'https://previews.123rf.com/images/aquir/aquir1311/aquir131100316/23569861-sample-grunge-red-round-stamp.jpg'
  ];

  Future<void> _getimageditor() async {
    if (counter >= urls.length) {
      print('no more images');
      return;
    }
    try {
      var currentUrl = urls[counter];
      var response = await http.get(
        Uri.parse(currentUrl),
      );

      final uint8List = response.bodyBytes;

      return Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImageEditorPro(
          pathSave: null,
          pixelRatio: null,
          imageData: uint8List,
        );
      })).then((imageDataMap) {
        counter = counter + 1;
        if (imageDataMap != null) {
          final Uint8List? imageData = imageDataMap['image_data'];
          final bool? shouldDelete = imageDataMap['should_delete'];
          if (imageData != null) {
            setState(() {
              _image = imageData;
            });
          } else if (shouldDelete != null) {
            print('should delete: $shouldDelete');
          }
        }
      }).catchError((er) {
        print(er);
      });
    } catch (err) {
      print('error convert: $err');
    }
  }

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
          onPressed: () => _getimageditor(),
          backgroundColor: Colors.red,
          child: Icon(Icons.add),
        ),
        body: _image == null
            ? Container()
            : Center(
                child: Image.memory(_image!),
              ));
  }
}

Widget condition(
    {required bool condtion, required Widget isTrue, required Widget isFalse}) {
  return condtion ? isTrue : isFalse;
}
