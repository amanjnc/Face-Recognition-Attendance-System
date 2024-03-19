import 'dart:async';
import 'dart:convert';

// import 'package:camera_app/classroom.dart';
import 'package:camera_app/ClassRooms/domain/Classroom_model.dart';
import 'package:http/http.dart' as http;

class Data {
  final String baseUrl = "http:10.5.232.113";

  Future<List<ClassRoom>> fetchClasses() async {
    final response = await http.get(Uri.parse('$baseUrl/class'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> classListData = data['classes'] ?? [];

      // Map each class data to a ClassRoom object
      final List<ClassRoom> classes = classListData.map((classData) {
        return ClassRoom.fromJson(classData);
      }).toList();

      return classes;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createClass(String title) async {
    final Uri uri = Uri.parse('$baseUrl/class?title=$title');

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      // Successfully created the class
      print('Class created successfully');
    } else {
      // Failed to create the class
      throw Exception('Failed to create class');
    }
  }

  Future<List<String>> getAttendees(String classId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/class/$classId/attendees'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> attendeesData = data['attendees'] ?? [];

      final List<String> attendees = attendeesData.map((attendeeData) {
        return attendeeData as String;
      }).toList();

      return attendees;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
