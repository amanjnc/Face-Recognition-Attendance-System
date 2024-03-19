

import 'package:camera_app/classroom_detail/domain/image_model.dart';
import 'package:equatable/equatable.dart';


class PhotoDetail extends Equatable {
  final ImageModel imageModel;
  final List<String> attendees;

  const PhotoDetail({required this.imageModel, required this.attendees});

  factory PhotoDetail.fromJson(Map<String, dynamic> json) {
    print(json);
    final ImageModel imageModel = ImageModel.fromJson(json['image']!);
    final List<String> attendees = (json['attendees']!).map((attendee) => attendee['name'] as String).toList();

    return PhotoDetail(imageModel: imageModel, attendees: attendees);
  }

  @override
  List<Object> get props => [imageModel, attendees];
}
