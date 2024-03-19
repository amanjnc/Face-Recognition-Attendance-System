import 'package:bloc/bloc.dart';
import 'package:camera_app/classrooms/data/class_rooms_dataprovider.dart';
import 'package:camera_app/classrooms/domain/classroom_model.dart';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'class_rooms_event.dart';
part 'class_rooms_state.dart';

class ClassRoomsBloc extends Bloc<ClassRoomsEvent, ClassRoomsState> {
  ClassRoomsBloc() : super(ClassRoomsInitial()) {
    
    ClassRoomsDataProvider classRoomsDataProvider = ClassRoomsDataProvider();

    on<ClassRoomsLoad>((event, emit) async {
      // try to load the classrooms and send it
      emit(ClassRoomsLoading());

      try {
        final List<ClassRoom>? classRooms = await classRoomsDataProvider.getClassRooms();
        emit(classRooms!.isNotEmpty
            ? ClassRoomsLoaded(classRooms: classRooms)
            : ClassRoomsEmpty());
      } catch (e){
        emit(ClassRoomsError());
      }
    });


    on<ClassRoomAddEvent>((event, emit) async {
      try {
        final ClassRoom? classroom = await classRoomsDataProvider.createClassRoom(event.classRoomTitle);
        final List<ClassRoom>? classRooms = await classRoomsDataProvider.getClassRooms();
        emit(classRooms!.isNotEmpty
            ? ClassRoomsLoaded(classRooms: classRooms)
            : ClassRoomsEmpty());
      } catch (e) {
        emit(ClassRoomsError());
      }
    });
  }
}
