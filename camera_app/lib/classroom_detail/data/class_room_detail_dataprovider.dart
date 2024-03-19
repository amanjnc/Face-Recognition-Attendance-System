import 'dart:convert';

import 'package:camera_app/classroom_detail/domain/image_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:camera_app/classrooms/domain/classroom_model.dart';
// dotenv.env['VAR_NAME']


class ClassRoomDetailDataProvider {
  final String? baseUrl = dotenv.env["base_url"];
  final String? port = dotenv.env["port"];

  Future<ClassRoom> getClassDetail(int classId) async {
    final response = await http.get(Uri.parse("${baseUrl!}:$port/class/$classId"));
    print("Making request for class detail.");

    try {
      if (response.statusCode == 200) {
        print("here I am ${response.body}");
        final classRoom = ClassRoom.fromJson(jsonDecode(response.body));
        return classRoom;
      } else {
        throw Exception("There was a problem loading classrooms");
      }
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<ImageModel>> getPhotos (int classId) async {
    final response =
        await http.get(Uri.parse("${baseUrl!}:$port/images?class_id=$classId"));
    if (response.statusCode == 200) {
      final images = (jsonDecode(response.body)["images"] as List).map((image) => ImageModel.fromJson(image)).toList();
      return images;
    } else {
      throw Exception("There was a problem creating the classroom");
    }
  }

  Future<List<String>> getAttendees (int classId) async {
    final response =
        await http.get(Uri.parse("${baseUrl!}:$port/attendees?class_id=$classId"));

    if (response.statusCode == 200) {
      final attendees = (jsonDecode(response.body)["attendees"] as List).map((attendee) => attendee["name"] as String).toList();

      return attendees;
    } else {
      throw Exception("There was a problem creating the classroom");
    }
    }
}