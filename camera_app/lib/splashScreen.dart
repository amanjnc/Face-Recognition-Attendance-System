import 'package:camera_app/classrooms/page/class_rooms_screen.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
        const Duration(seconds: 1),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ClassRoomsScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 150),
              const Expanded(
                child: CircleAvatar(
                  radius: 200,
                  backgroundColor: Colors.transparent,
                  //make the background photo centered
                  child: Image(
                    image: AssetImage('images/logo.jpg'),
                    fit: BoxFit.cover,
                    width: 280,
                  ),
                ),
              ),

              Container(height: 50),

              // loading circle for ios
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              ),
              Container(height: 50)
            ],
          ),
        ));
  }
}
