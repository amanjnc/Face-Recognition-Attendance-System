import 'package:bloc/bloc.dart';
import 'package:camera_app/classroom_detail/data/class_room_detail_dataprovider.dart';
import 'package:camera_app/classrooms/data/class_rooms_dataprovider.dart';
import 'package:camera_app/classrooms/domain/classroom_model.dart';
import 'package:camera_app/classroom_detail/domain/classroom_detail_model.dart';
import 'package:camera_app/classroom_detail/domain/image_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'class_room_detail_event.dart';
part 'class_room_detail_state.dart';

class ClassRoomDetailBloc extends Bloc<ClassRoomDetailEvent, ClassRoomDetailState> {
  ClassRoomDetailBloc() : super(ClassRoomDetailInitial()) {
    
    final ClassRoomDetailDataProvider classRoomDetailDataProvider = ClassRoomDetailDataProvider();

    on<ClassRoomDetailLoad>((event, emit) async {
      emit(ClassRoomDetailLoading());

      try {
        final ClassRoom classRoom = await ClassRoomDetailDataProvider().getClassDetail(event.classId);
        final List<String> attendees = await ClassRoomDetailDataProvider().getAttendees(event.classId);
        final List<ImageModel> images = await ClassRoomDetailDataProvider().getPhotos(event.classId);
        final ClassRoomDetailModel classRoomDetail = ClassRoomDetailModel(classRoom: classRoom, images: images, attendees: attendees);
        emit(ClassRoomDetailLoaded(classRoomDetail: classRoomDetail));
      } catch (e) {
        emit(ClassRoomDetailError());
      }
    });
  }
}
