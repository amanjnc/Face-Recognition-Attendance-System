// import 'package:camera_app/classroom.dart';
import 'package:camera_app/classroom_detail/page/class_room_details_screen.dart';
import 'package:camera_app/classrooms/domain/classroom_model.dart';
import 'package:camera_app/classrooms/bloc/class_rooms_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassRoomsScreen extends StatelessWidget {
  const ClassRoomsScreen({Key? key}) : super(key: key);
  // Function to display the dialog form
  void _showDialogForm(BuildContext context) {
    TextEditingController field1Controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a new Class'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: field1Controller,
                  decoration: const InputDecoration(labelText: 'Class Title'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                context.read<ClassRoomsBloc>().add(ClassRoomAddEvent(classRoomTitle: field1Controller.text));
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ClassRoomsBloc>();
    bloc.add(ClassRoomsLoad());

    return Scaffold(
      appBar: AppBar(
          title: const Text('Classrooms'),
          leading: Center(
              child:Icon(Icons.home_filled)
          ),
          elevation: 2.4,
        actions: [
          TextButton(
            onPressed: () { context.read<ClassRoomsBloc>().add(ClassRoomsLoad()); },
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
            ),
            child: const Center(child: Icon(Icons.refresh)),
          ),
        ],
      ),
      body: BlocConsumer<ClassRoomsBloc, ClassRoomsState>(
      listener: (context, state) {
        if (state is ClassRoomsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Check you internet connection"),
              dismissDirection: DismissDirection.endToStart,
            ),
          );
        } else if (state is ClassRoomsInitial) {
          bloc.add(ClassRoomsLoad());
        }
      },
      builder: ((context, state) {

        if (state is ClassRoomsInitial) {
          bloc.add(ClassRoomsLoad());
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClassRoomsEmpty) {
          return 
          const Center(
                child: Text("No Classes, perhaps start by adding one."));
          ;
          } else if (state is ClassRoomsLoading) {
            return const Center (child: CircularProgressIndicator());
          } else if (state is ClassRoomsLoaded) {
            return ClassRoomsListWidget(classRooms: state.classRooms);
          } else {
            print(state);
            return Row(
              children: [
                const Text("Some thing went wrong"),
                ElevatedButton(
                    onPressed: () {
                      bloc.add(ClassRoomsLoad());
                    },
                    child: const Icon(Icons.refresh))
              ],
            );
          }
        }),
      ),
      floatingActionButton:
          (bloc.state is ClassRoomsEmpty || bloc.state is ClassRoomsLoaded)
              ? FloatingActionButton(
              onPressed: () {
                _showDialogForm(context);
              },
              backgroundColor: Colors.indigoAccent,
              child: const Icon(Icons.add, size: 25, fill: 0.6, color: Colors.white),
            )
              : Container(),
    )
        ;
    
  }
}



class ClassRoomsListWidget extends StatelessWidget {
  final List<ClassRoom> classRooms;

  const ClassRoomsListWidget({super.key, required this.classRooms});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: classRooms.length,
      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDetailsScreen(classId: classRooms[index].id)));
            },
            child: Container(
                width: 100,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(
                      'images/${classRooms[index].color}.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                child: Text(
                  classRooms[index].title,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.start,
                )),
          ),
        );
      },
    );
  }
}
