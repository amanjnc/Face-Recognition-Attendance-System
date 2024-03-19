part of 'class_rooms_bloc.dart';

@immutable
sealed class ClassRoomsEvent extends Equatable {
  const ClassRoomsEvent();
}

class ClassRoomsLoad extends ClassRoomsEvent {

  @override
  List<Object> get props => [];

}

class ClassRoomAddEvent extends ClassRoomsEvent {
  final String classRoomTitle;

  const ClassRoomAddEvent({required this.classRoomTitle});

  @override
  List<Object> get props => [classRoomTitle];
}
