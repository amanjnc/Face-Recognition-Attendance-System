part of 'class_rooms_bloc.dart';

@immutable
sealed class ClassRoomsState {}

final class ClassRoomsInitial extends ClassRoomsState {}

final class ClassRoomsLoading extends ClassRoomsState{}

final class ClassRoomsError extends ClassRoomsState {}

final class ClassRoomsEmpty extends ClassRoomsState {}

final class ClassRoomsLoaded extends ClassRoomsState {
  final List<ClassRoom> classRooms;

  ClassRoomsLoaded({required this.classRooms});
}