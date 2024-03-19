import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_app/classrooms/domain/classroom_model.dart';
import 'package:camera_app/classroom_detail/bloc/class_room_detail_bloc.dart';
import 'package:camera_app/classroom_detail/domain/classroom_detail_model.dart';
import 'package:camera_app/classroom_detail/domain/image_model.dart';
// import 'package:camera_app/classroom.dart';
import 'package:camera_app/main.dart';
import 'package:camera_app/photo_detail/page/photo_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class ClassRoomDetailsScreen extends StatelessWidget {
  const ClassRoomDetailsScreen({
    super.key,
    required this.classId,
  });

  final int classId;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ClassRoomDetailBloc>();

    bloc.add(ClassRoomDetailLoad(classId: classId));

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.grey[800],
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Classroom Detail'),
      ),
      body: BlocBuilder<ClassRoomDetailBloc, ClassRoomDetailState>(
          builder: (context, state) {
            print("This is the current state $state");
        if (state is ClassRoomDetailInitial) {
          bloc.add(ClassRoomDetailLoad(classId: classId));
          return const ClassRoomDetailLoadingAsynchronousSuspension();
        } else if (state is ClassRoomDetailLoading) {
          return const ClassRoomDetailLoadingAsynchronousSuspension();
        } else if (state is ClassRoomDetailLoaded) {
          return ClassRoomDetailPageWidget(
              classRoomDetail: state.classRoomDetail);
        } else {
          return ElevatedButton(
              onPressed: () {
                bloc.add(ClassRoomDetailLoad(classId: classId));
              },
              child: const Icon(Icons.refresh));
        }
      }),
      floatingActionButton:
          BlocBuilder<ClassRoomDetailBloc, ClassRoomDetailState>(
              builder: (context, state) {
        if (state is ClassRoomDetailLoaded) {
          return FloatingActionButton(
            backgroundColor: Colors.indigoAccent,
            onPressed: () async {
              // XFile? photo = await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const CameraApp(),
              //   ),
              // );
              final imagePicker = ImagePicker();
              final image = await imagePicker.pickImage(source: ImageSource.camera);

              var image_selected = File(image!.path);

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PhotoDetailsScreen(classId: classId, photo: image_selected)
                  ),
                );
            },
            hoverElevation: 2.3,
              child: const Icon(Icons.camera_alt, size: 25, fill: 0.6, color: Colors.white),
          );
        } else {
          // show snack bar
          return Container();
        }
        },
      ),
    );
  }
}

class ClassRoomDetailLoadingAsynchronousSuspension extends StatelessWidget {
  const ClassRoomDetailLoadingAsynchronousSuspension({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

class ClassRoomDetailPageWidget extends StatelessWidget {
  final ClassRoomDetailModel classRoomDetail;

  const ClassRoomDetailPageWidget({super.key, required this.classRoomDetail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // the poster
          ClassPoster(classRoom: classRoomDetail.classRoom),

          // scrollable images
          ScrollableImages(images: classRoomDetail.images),

          // list of attendees
          Text(
            "Attendees : ${classRoomDetail.attendees.length}",
            style: const TextStyle(fontSize: 36),
          ),
          AttendeesList(attendees: classRoomDetail.attendees),
        ],
      ),
    );
  }
}

class ClassPoster extends StatelessWidget {
  final ClassRoom classRoom;

  const ClassPoster({super.key, required this.classRoom});

  @override
  Widget build(BuildContext context) {
    final bgImageColor = classRoom.color;
    final classRoomTitle = classRoom.title;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage('images/$bgImageColor.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: Text(
        classRoomTitle,
        style: const TextStyle(fontSize: 24),
        textAlign: TextAlign.start,
      ),
    );
  }
}

class ScrollableImages extends StatelessWidget {
  final List<ImageModel> images;
  final String? baseUrl = dotenv.env["base_url"];
  final String? port = dotenv.env["port"];

  ScrollableImages({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return images.isNotEmpty ?
    Container(
      height: 220,
      // color: Colors.blue,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${baseUrl!}:$port/image/${images[index].fileName}',
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
          )
        : const SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.no_flash),
                SizedBox(width: 3),
                Text("No Photos Taken")
              ],
          
              ),
        )
    ;
  }
}

class AttendeesList extends StatelessWidget {
  final List<String> attendees;

  const AttendeesList({super.key, required this.attendees});

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var attendee in attendees)
            ListTile(
              title: Text(attendee),
              leading: const Icon(Icons.person),
            ),
        ]);
  }
}
