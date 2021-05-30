import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'GenerateQR.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:toast/toast.dart';
import 'package:whatsapp_navigation/components/gradient_button.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final myController = TextEditingController();
  String qrCodeResult = "Not Yet Scanned";

  String phoneNumber;
  String phone_code;
  var confirmedNumber;

  Gradient gradient1 = LinearGradient(
    colors: [
      Colors.teal[600].withOpacity(0.8),
      Colors.green[500].withOpacity(0.8),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  _customLaunch(data) async {
    if(await canLaunch(data)) {
      await launch(data);
    } else {
      throw ("Sorry, could not launch!!");
    }
  }

  void launchWhatsApp({@required String phone, @required String message,}) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      }
      else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }
    _customLaunch(url());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 5.0,
        title: Center(
          child: Text(
            "Whatsapp Navigation",
            style:
            TextStyle(color: Colors.green[50], fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 60, 10),
              child: Row(
                children: <Widget>[
                  Expanded(child: Center(
                    child: CountryListPick(
                        theme: CountryTheme(
                            isShowFlag: true,
                            isShowTitle: false,
                            isShowCode: true,
                            isDownIcon: true,
                            showEnglishName: true),
                        initialSelection:
                        '+91', //inital selection, +672 for Antarctica,
                        onChanged: (CountryCode code) {
                          phone_code = code.code;
                          print(code.name);
                          print(code.code);
                          print(code.dialCode);
                          print(code.flagUri);
                        }),),
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        //border: InputBorder.none,
                        hintText: "Phone Number",
                        hintStyle:
                        TextStyle(fontSize: 16, letterSpacing: 2),
                      ),
                      onChanged: (value) {
                        // this.phoneNo=value;
                        print(value);
                      },
                      controller: myController,
                    ),
                  ),
                ],
              ),),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 30, 40, 10),
              child: GradientButton(
                  child: Text("Open Whatsapp",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),),
                  onPressed: () {
                    setState(() {
                      //phone_code = phone_code.replaceAll("+"," ");
                      //String phone = phone_code;
                      //phone = phone.substring(1, phone.length);
                      //print(phone);
                      if(myController.text.length == 10) {
                        String mytext = "91" + " " + myController.text;
                        launchWhatsApp(phone: mytext, message: "");
                      }
                      else{
                        Toast.show("Enter valid phone number", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                      }
                    });
                  },
                  gradient: gradient1
              ),),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
              child: Center(
                child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Divider(
                            color: Colors.black,
                            height: 36,
                          )
                      ),
                      SizedBox(width: 10),
                      Text("OR"),
                      SizedBox(width: 10),
                      Expanded(
                          child: Divider(
                            color: Colors.black,
                            height: 36,
                          )
                      ),
                    ]
                ),),),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Wrap(
                  spacing:20,
                  runSpacing: 20.0,
                  children: <Widget>[
                    SizedBox(
                      width:170.0,
                      height: 240.0,
                      child: GestureDetector(
                        onTap: () async {
                          String codeSanner = await BarcodeScanner.scan(); //barcode scnner
                          print(codeSanner);
                          Toast.show(codeSanner, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          setState(() {
                            if(codeSanner.length == 10 && _isNumeric(codeSanner) == true) {
                              qrCodeResult = "91" + " " + codeSanner;
                              launchWhatsApp(phone: qrCodeResult, message: "");
                            }
                            else
                              Toast.show("Not a valid phone number", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          });

                        },
                        child: Card(
                          color: Colors.orangeAccent[100],
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child:Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Image.asset("images/scanqr.png",width: 64.0,),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    Text(
                                      "Scan QR Code",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),),
                    ),
                    SizedBox(
                      width:170.0,
                      height: 240.0,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                              GenerateQR()));
                        },
                        child: Card(
                          color: Colors.pinkAccent[100],
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child:Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Image.asset("images/genrate.png",width: 64.0,),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    Text(
                                      "Generate QR Code for Phone number",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),),
                    ),
                  ],),),),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}