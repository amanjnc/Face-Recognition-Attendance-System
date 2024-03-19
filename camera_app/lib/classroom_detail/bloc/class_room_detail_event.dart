part of 'class_room_detail_bloc.dart';

@immutable
sealed class ClassRoomDetailEvent extends Equatable {}

class ClassRoomDetailLoad extends ClassRoomDetailEvent {

  final int classId;

  ClassRoomDetailLoad({required this.classId});

  @override
  List<Object?> get props => [classId];
}

