import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:camera_app/classroom_detail/domain/image_model.dart';
import 'package:camera_app/photo_detail/data/photo_detail_dataprovider.dart';
import 'package:camera_app/photo_detail/domain/photo_detail_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'photo_detail_event.dart';
part 'photo_detail_state.dart';

class PhotoDetailBloc extends Bloc<PhotoDetailEvent, PhotoDetailState> {
  PhotoDetailBloc() : super(PhotoDetailInitial()) {

    PhotoDetailDataProvider photoDetailDataProvider = PhotoDetailDataProvider();

    on<PhotoDetailLoad>((event, emit) async {
      emit(PhotoDetailLoading());
      print('Image path => ${event.photo.path}');

      try {
        final File photo = event.photo;
        final int classId = event.classId;
 
        final PhotoDetail photoDetail = await photoDetailDataProvider.getAttendanceFromPhoto(classId, photo);
        emit(PhotoDetailLoaded(photoDetail: photoDetail));
      } catch (e) {
        print(e.toString());
        emit(PhotoDetailError());
      }
    });
  }
}
