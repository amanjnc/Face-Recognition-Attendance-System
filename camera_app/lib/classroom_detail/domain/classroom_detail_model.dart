
import 'package:camera_app/classrooms/domain/classroom_model.dart';
import 'package:camera_app/classroom_detail/domain/image_model.dart';
import 'package:equatable/equatable.dart';

class ClassRoomDetailModel extends Equatable {
  final ClassRoom classRoom;
  final List<ImageModel> images;
  final List<String> attendees;

  const ClassRoomDetailModel( {required this.classRoom,required this.images, required this.attendees});

  @override
  List<Object> get props => [images, attendees];
}
