import 'package:equatable/equatable.dart';


class ClassRoom extends Equatable {
  final int id;
  final String title;
  final String color;

  const ClassRoom({
    required this.id,
    required this.title,
    required this.color,
  });

  factory ClassRoom.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] as int;
    final String title = json['title'] as String;
    final String color = json['color'] as String;

    return ClassRoom(
      id: id,
      title: title,
      color: color,
    );
  }

  @override
  List<Object> get props => [id, title, color];
}
