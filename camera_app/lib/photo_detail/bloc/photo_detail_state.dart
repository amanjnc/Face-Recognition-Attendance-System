part of 'photo_detail_bloc.dart';

@immutable
sealed class PhotoDetailState extends Equatable {}

final class PhotoDetailInitial extends PhotoDetailState {
  @override
  List<Object?> get props => [];
}

final class PhotoDetailLoading extends PhotoDetailState {
  @override
  List<Object?> get props => [];
}

final class PhotoDetailLoaded extends PhotoDetailState {
  final PhotoDetail photoDetail;

  PhotoDetailLoaded({required this.photoDetail});
  
  @override
  List<Object?> get props => [photoDetail];
}

final class PhotoDetailError extends PhotoDetailState {
  @override
  List<Object?> get props => [];
}
