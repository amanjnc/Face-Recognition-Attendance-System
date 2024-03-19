import 'dart:async';

import 'package:camera/camera.dart';
import 'package:camera_app/classrooms/bloc/class_rooms_bloc.dart';
import 'package:camera_app/classroom_detail/bloc/class_room_detail_bloc.dart';
import 'package:camera_app/photo_detail/bloc/photo_detail_bloc.dart';
import 'package:camera_app/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ClassRoomsBloc>(
              create: (BuildContext context) => ClassRoomsBloc()),
          BlocProvider<ClassRoomDetailBloc>(
              create: (BuildContext context) => ClassRoomDetailBloc()),
          BlocProvider<PhotoDetailBloc>(
              create: (BuildContext context) => PhotoDetailBloc())
        ],
        child: MaterialApp(
            title: 'Attedance Face Recognition System',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
        home: const SplashScreen(),
      ),
    );
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {return;}
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            debugPrint("The user has denied the access to the camera");
            break;
          default:
            debugPrint(e.description);
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                CameraPreview(controller),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: RawMaterialButton(
                      onPressed: () async {
                        if (!controller.value.isInitialized) {
                          return;
                        }
                        if (controller.value.isTakingPicture) {
                          return;
                        }

                        try {
                          await controller.setFlashMode(FlashMode.auto);
                          XFile file = await controller.takePicture();
                          Navigator.pop(context, file);
                        } on CameraException catch (_) {}
                      },
                      child: const Icon(
                        Icons.camera,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


