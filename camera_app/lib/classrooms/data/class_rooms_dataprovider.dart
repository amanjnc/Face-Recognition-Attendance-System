
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:camera_app/classrooms/domain/classroom_model.dart';
// dotenv.env['VAR_NAME']


class ClassRoomsDataProvider {
  final String? baseUrl = dotenv.env["base_url"];
  final String? port = dotenv.env["port"];

  Future<List<ClassRoom>?> getClassRooms() async {

    try {
      final response = await http.get(Uri.parse("${baseUrl!}:$port/class"));
      if (response.statusCode == 200) {
        final classRooms = (jsonDecode(response.body)['classes'] as List)
            .map((_class) => ClassRoom.fromJson(_class))
            .toList();

        return classRooms;
      } else {
        throw Exception("There was a problem cdloading classrooms");
      }
    } catch (e) {
      print('${e.toString()} here is the error');
      rethrow;
      
    }
  }

  Future<ClassRoom?> createClassRoom (String title) async {
    final response =
        await http.post(Uri.parse("${baseUrl!}:$port/class?title=$title"));

    if (response.statusCode == 200) {
      final newClassRoom = ClassRoom.fromJson(jsonDecode(response.body));

      return newClassRoom;
    } else {
      throw Exception("There was a problem creating the classroom");
    }
  }
}