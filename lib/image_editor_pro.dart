import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor_pro/modules/sliders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_pro/modules/emoji.dart';
import 'package:image_editor_pro/modules/text.dart';
import 'package:image_editor_pro/modules/textview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';
import 'dart:math' as math;

import 'modules/color_filter_generator.dart';
import 'modules/colors_picker.dart'; // import this

List<Map> widgetJson = [];
//List fontsize = [];
//List<Color> colorList = [];
var howmuchwidgetis = 0;
//List multiwidget = [];
Color currentcolors = Colors.white;
var opicity = 0.0;
var width = 300;
var height = 300;
SignatureController _controller =
    SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class ImageEditorPro extends StatefulWidget {
  final Directory? pathSave;
  final double? pixelRatio;
  //final Uint8List? imageData;
  final Uint8List? imageData;

  ImageEditorPro(
      {required this.pathSave,
      required this.pixelRatio,
      required this.imageData});

  @override
  _ImageEditorProState createState() => _ImageEditorProState();
}

var slider = 0.0;

class _ImageEditorProState extends State<ImageEditorPro> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  TextEditingController heightcontroler = TextEditingController();
  TextEditingController widthcontroler = TextEditingController();

  late Image _myImage;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller =
        SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset?> _points = <Offset>[];
  List type = [];
  List aligment = [];

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = GlobalKey();
  File? _image;
  ScreenshotController screenshotController = ScreenshotController();
  late Timer timeprediction;

  void timers() {
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  @override
  void dispose() {
    timeprediction.cancel();
    _controller.clear();
    widgetJson.clear();
    heightcontroler.clear();
    widthcontroler.clear();
    super.dispose();
  }

  @override
  void initState() {
    timers();
    _controller.clear();
    type.clear();
    //  fontsize.clear();
    offsets.clear();
    //  multiwidget.clear();
    howmuchwidgetis = 0;

    _loadImage();
    super.initState();
  }

  double flipValue = 0;
  int rotateValue = 0;
  double blurValue = 0;
  double opacityValue = 0;
  Color colorValue = Colors.transparent;

  double hueValue = 0;
  double brightnessValue = 0;
  double saturationValue = 0;

  void _loadImage() async {
    try {
      if (widget.imageData != null) {
        final directory = await getApplicationDocumentsDirectory();
        final image = await File('${directory.path}/edit_image.png').create();
        final imageFile = await image.writeAsBytes(widget.imageData!);
        print('path: ${imageFile.path}');

        var decodedImage =
            await decodeImageFromList(imageFile.readAsBytesSync());

        setState(() {
          height = decodedImage.height;
          width = decodedImage.width;
          _image = imageFile;
        });
      }
    } catch (err) {
      print('error convert image to file: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
              onPressed: () {
                _controller.points.clear();
                var imageDataMap = <String, dynamic>{
                  'image_data': null,
                  'should_delete': true
                };

                Navigator.pop(context, imageDataMap);
              },
              icon: Icon(Icons.delete_outline)),
          // IconButton(
          //     onPressed: () {
          //       bottomsheets();
          //     },
          //     icon: Icon(Icons.camera_alt)),
          IconButton(
              onPressed: () => _addText(), icon: Icon(Icons.text_fields)),
          IconButton(
              onPressed: () => _displayBrushDialog(),
              icon: Icon(Icons.edit_outlined)),
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Icon(
                  Icons.rotate_left,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Icon(
                  Icons.rotate_right,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              // PopupMenuItem<int>(
              //   value: 2,
              //   child: Icon(
              //     Icons.flip,
              //     color: Colors.white,
              //     size: 30,
              //   ),
              // ),
              PopupMenuItem<int>(
                value: 3,
                child: Icon(
                  FontAwesomeIcons.boxes,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Icon(
                  FontAwesomeIcons.eraser,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              PopupMenuItem<int>(
                value: 5,
                child: Icon(
                  Icons.filter,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              PopupMenuItem<int>(
                value: 6,
                child: Icon(
                  Icons.blur_on,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
            iconSize: 30.0,
            color: Colors.black87,
            onSelected: (int val) => onMenuItemSelected(val),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveChanges(),
        backgroundColor: Color(0xFF0078BF),
        child: Icon(
          FontAwesomeIcons.check,
          color: Colors.white,
        ),
      ),
      body:
          // Image(
          //   image: MemoryImage(widget.imageData!),
          // )
          Screenshot(
        controller: screenshotController,
        child: RotatedBox(
          quarterTurns: rotateValue,
          child: imageFilterLatest(
            hue: hueValue,
            brightness: brightnessValue,
            saturation: saturationValue,
            child: Container(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              width: width.toDouble(),
              height: height.toDouble(),
              child: RepaintBoundary(
                key: globalKey,
                child: Stack(
                  children: [
                    _image != null
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(flipValue),
                            child: ClipRect(
                              // <-- clips to the 200x200 [Container] below

                              child: Container(
                                padding: EdgeInsets.zero,
                                // alignment: Alignment.center,
                                width: width.toDouble(),
                                height: height.toDouble(),

                                decoration: _image == null
                                    ? null
                                    : BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(
                                              File(_image!.path),
                                            ),
                                            fit: BoxFit.cover)),

                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: blurValue,
                                    sigmaY: blurValue,
                                  ),
                                  child: Container(
                                    color: colorValue.withOpacity(opacityValue),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                      padding: EdgeInsets.all(0.0),
                      child: GestureDetector(
                          onPanUpdate: (DragUpdateDetails details) {
                            setState(() {
                              var object =
                                  context.findRenderObject() as RenderBox?;
                              var _localPosition =
                                  object?.globalToLocal(details.globalPosition);
                              _points = List.from(_points)..add(_localPosition);
                            });
                          },
                          onPanEnd: (DragEndDetails details) {
                            _points.add(null);
                          },
                          child: Signat()),
                    ),
                    Stack(
                      children: widgetJson.asMap().entries.map((f) {
                        return type[f.key] == 1
                            ? EmojiView(
                                left: offsets[f.key].dx,
                                top: offsets[f.key].dy,
                                ontap: () {
                                  scaf.currentState?.showBottomSheet((context) {
                                    return Sliders(
                                      index: f.key,
                                      mapValue: f.value,
                                    );
                                  });
                                },
                                onpanupdate: (details) {
                                  setState(() {
                                    offsets[f.key] = Offset(
                                        offsets[f.key].dx + details.delta.dx,
                                        offsets[f.key].dy + details.delta.dy);
                                  });
                                },
                                mapJson: f.value,
                              )
                            : type[f.key] == 2
                                ? TextView(
                                    left: offsets[f.key].dx,
                                    top: offsets[f.key].dy,
                                    ontap: () {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Sliders(
                                              index: f.key,
                                              mapValue: f.value,
                                            );
                                          });
                                    },
                                    onpanupdate: (details) {
                                      setState(() {
                                        offsets[f.key] = Offset(
                                            offsets[f.key].dx +
                                                details.delta.dx,
                                            offsets[f.key].dy +
                                                details.delta.dy);
                                      });
                                    },
                                    mapJson: f.value,
                                  )
                                : Container();
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();

  void _closeModal(void value) {
    openbottomsheet = false;
    setState(() {});
  }

  void onMenuItemSelected(int val) {
    switch (val) {
      case 0:
        setState(() {
          rotateValue--;
        });
        break;

      case 1:
        setState(() {
          rotateValue++;
        });
        break;

      case 2:
        setState(() {
          flipValue = flipValue == 0 ? math.pi : 0;
        });
        break;

      case 3:
        _displayResizeDialog();
        break;

      case 4:
        _eraseDrawing();
        break;

      case 5:
        _displayFilterDialog();

        break;

      case 6:
        _displayBlurDialog();
        break;

      default:
    }
  }

  void _displayResizeDialog() async {
    await showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Height Width'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  var mHeight = int.tryParse(heightcontroler.text);
                  var mWidth = int.tryParse(widthcontroler.text);
                  if (mWidth == null || mHeight == null) {
                    Navigator.pop(context);
                    return;
                  }
                  setState(() {
                    height = int.parse(heightcontroler.text);
                    width = int.parse(widthcontroler.text);
                  });
                  heightcontroler.clear();
                  widthcontroler.clear();
                  Navigator.pop(context);
                },
                child: Text('Done'),
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Define Height'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                      controller: heightcontroler,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                          hintText: 'Height',
                          contentPadding: EdgeInsets.only(left: 10),
                          border: OutlineInputBorder())),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text('Define Width'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                      controller: widthcontroler,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                          hintText: 'Width',
                          contentPadding: EdgeInsets.only(left: 10),
                          border: OutlineInputBorder())),
                ],
              ),
            ),
          );
        });
  }

  void _displayBrushDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.pop(context);
              },
              child: Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  void _addText() async {
    var value = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TextEditorImage()));
    if (value == null || value['name'] == null) {
      print('true');
    } else {
      type.add(2);
      widgetJson.add(value);
      // fontsize.add(20);
      offsets.add(Offset.zero);
      //  colorList.add(value['color']);
      //    multiwidget.add(value['name']);
      howmuchwidgetis++;
    }
  }

  void _eraseDrawing() {
    _controller.clear();
    //  type.clear();
    // // fontsize.clear();
    //  offsets.clear();
    // // multiwidget.clear();
    howmuchwidgetis = 0;
  }

  void _saveChanges() {
    screenshotController
        .capture(pixelRatio: widget.pixelRatio ?? 1.5)
        .then((binaryIntList) async {
      var imageDataMap = <String, dynamic>{
        'image_data': binaryIntList,
        'should_delete': false
      };

      Navigator.pop(context, imageDataMap);
    }).catchError((onError) {
      print(onError);
    });
  }

  void _displayFilterDialog() async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              color: Colors.black87,
            ),
            child: StatefulBuilder(
              builder: (context, setS) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Slider Hue'.toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                              value: hueValue,
                              min: -10.0,
                              max: 10.0,
                              onChanged: (v) {
                                setS(() {
                                  setState(() {
                                    hueValue = v;
                                  });
                                });
                              }),
                        ),
                        TextButton(
                          onPressed: () {
                            setS(() {
                              setState(() {
                                blurValue = 0.0;
                              });
                            });
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Slider Saturation',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                              value: saturationValue,
                              min: -10.0,
                              max: 10.0,
                              onChanged: (v) {
                                setS(() {
                                  setState(() {
                                    saturationValue = v;
                                  });
                                });
                              }),
                        ),
                        TextButton(
                          onPressed: () {
                            setS(() {
                              setState(() {
                                saturationValue = 0.0;
                              });
                            });
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Slider Brightness',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                              value: brightnessValue,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (v) {
                                setS(() {
                                  setState(() {
                                    brightnessValue = v;
                                  });
                                });
                              }),
                        ),
                        TextButton(
                          onPressed: () {
                            setS(() {
                              setState(() {
                                brightnessValue = 0.0;
                              });
                            });
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  void _displayBlurDialog() async {
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setS) {
            return Container(
              padding: EdgeInsets.all(20),
              height: 400,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Slider Filter Color'.toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Divider(

                      // height: 1,
                      ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Slider Color'.toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
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
                              setS(() {
                                setState(() {
                                  colorValue = Color(value);
                                });
                              });
                            }),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            setS(() {
                              colorValue = Colors.transparent;
                            });
                          });
                        },
                        child: Text(
                          'Reset',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Slider Blur'.toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                            value: blurValue,
                            min: 0.0,
                            max: 10.0,
                            onChanged: (v) {
                              setS(() {
                                setState(() {
                                  blurValue = v;
                                });
                              });
                            }),
                      ),
                      TextButton(
                        onPressed: () {
                          setS(() {
                            setState(() {
                              blurValue = 0.0;
                            });
                          });
                        },
                        child: Text(
                          'Reset'.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Slider Opacity',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                            value: opacityValue,
                            min: 0.00,
                            max: 1.0,
                            onChanged: (v) {
                              setS(() {
                                setState(() {
                                  opacityValue = v;
                                });
                              });
                            }),
                      ),
                      TextButton(
                        onPressed: () {
                          setS(() {
                            setState(() {
                              opacityValue = 0.0;
                            });
                          });
                        },
                        child: Text(
                          'Reset'.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Signature(
            controller: _controller,
            height: height.toDouble(),
            width: width.toDouble(),
            backgroundColor: Colors.transparent),
      ],
    );
  }
}

Widget imageFilterLatest({brightness, saturation, hue, child}) {
  return ColorFiltered(
      colorFilter:
          ColorFilter.matrix(ColorFilterGenerator.brightnessAdjustMatrix(
        value: brightness,
      )),
      child: ColorFiltered(
          colorFilter:
              ColorFilter.matrix(ColorFilterGenerator.saturationAdjustMatrix(
            value: saturation,
          )),
          child: ColorFiltered(
            colorFilter:
                ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(
              value: hue,
            )),
            child: child,
          )));
}
