
import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  final int id;
  final String createdAt;
  final String fileName;

  const ImageModel({
    required this.id,
    required this.createdAt,
    required this.fileName,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    final int id = int.parse(json['id']);
    final String createdAt = json['created_at'] as String;
    final String fileName = json['file_name'] as String;

    return ImageModel(
      id: id,
      createdAt: createdAt,
      fileName: fileName,
    );
  }

  @override
  List<Object> get props => [id, createdAt, fileName];
}
