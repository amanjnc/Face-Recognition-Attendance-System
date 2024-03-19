part of 'photo_detail_bloc.dart';

@immutable
sealed class PhotoDetailEvent extends Equatable {}

class PhotoDetailLoad extends PhotoDetailEvent {
  final int classId;
  final File photo;

  PhotoDetailLoad(this.classId, {required this.photo});

  @override
  List<Object?> get props => [photo];
}
