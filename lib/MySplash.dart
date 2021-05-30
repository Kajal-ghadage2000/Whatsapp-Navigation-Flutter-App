import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'MyHomePage.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {

    Timer(
        Duration(seconds: 5),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(title: 'Flutter Demo Home Page'))));

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.green[50]),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 80.0,
                    ),
                    Text(
                      "Whatsapp Navigation",
                      style: GoogleFonts.inter(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          color: Colors.grey[600]),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Image.asset("images/logowhatsappnav.png",width: 264.0,height: 360.0),
                    SizedBox(
                      height: 135.0,
                    ),
                    CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor : AlwaysStoppedAnimation(Colors.lightBlue[400]),
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                      "Message on whatsapp without saving number by scanning QR Code",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          color: Colors.grey[600]),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}