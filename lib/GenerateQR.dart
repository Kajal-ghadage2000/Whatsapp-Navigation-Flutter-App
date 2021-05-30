import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

class GenerateQR extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => GenerateQRState();
}

class GenerateQRState extends State<GenerateQR> {

  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  final TextEditingController _textController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _captureAndSharePng,
          )
        ],*/
        backgroundColor: Colors.green,
      ),
      body: _contentWidget(),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');

    } catch(e) {
      print(e.toString());
    }
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            child:  Container(
              height: _topSectionHeight,
              child:  Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child:  TextField(
                      keyboardType: TextInputType.number,
                      controller: _textController,
                      decoration:  InputDecoration(
                        hintText: "Enter a Phone Number",
                        errorText: _inputErrorText,
                        hintStyle:
                        TextStyle(fontSize: 16, letterSpacing: 2),
                      ),
                    ),
                  ),
                  SizedBox(
                    width:30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child:  FlatButton(
                      child:  Text("SUBMIT",
                        style: TextStyle(
                        color: Colors.green,),),
                      onPressed: () {
                        setState((){
                          if(_textController.text.length == 10){
                            _dataString = _textController.text;
                            _inputErrorText = null;
                          }
                          else{
                            Toast.show("Enter valid phone number", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          }
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: _dataString,
                  size: 0.5 * bodyHeight,
                  /*onError: (ex) {
                    print("[QR] ERROR - $ex");
                    setState((){
                      _inputErrorText = "Error! Maybe your input value is too long?";
                    });
                  },*/
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}