part of 'class_room_detail_bloc.dart';

@immutable
sealed class ClassRoomDetailState extends Equatable {}

final class ClassRoomDetailInitial extends ClassRoomDetailState {
  @override
  List<Object?> get props => [];
}

final class ClassRoomDetailLoading extends ClassRoomDetailState {
  @override
  List<Object?> get props => [];
}

final class ClassRoomDetailLoaded extends ClassRoomDetailState {
  final ClassRoomDetailModel classRoomDetail;
  ClassRoomDetailLoaded({required this.classRoomDetail});
  
  @override
  List<Object?> get props => [classRoomDetail];
}

final class ClassRoomDetailError extends ClassRoomDetailState {
  @override
  List<Object?> get props => [];
}
