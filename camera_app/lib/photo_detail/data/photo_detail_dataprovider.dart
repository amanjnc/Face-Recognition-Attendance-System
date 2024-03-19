
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_app/classroom_detail/domain/image_model.dart';
import 'package:camera_app/photo_detail/domain/photo_detail_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:camera_app/classrooms/domain/classroom_model.dart';
import 'package:path_provider/path_provider.dart';


class PhotoDetailDataProvider {
  final String? baseUrl = dotenv.env["base_url"];
  final String? port = dotenv.env["port"];

  Future<PhotoDetail> getAttendanceFromPhoto(int classId, File photo) async {
      print('Image path => ${photo.path}');
      print('class id => $classId');

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('$baseUrl:$port/takeAttendance?classId=$classId'),
      );

      request.headers['Content-Type'] = 'multipart/form-data';

      request.files.add(
        await http.MultipartFile.fromPath('image', photo.path),
      );

      print("Sending Request");
      var response = await request.send(); 
      print("Response is sent $response");
      var responseData = await response.stream.toBytes();
      print("response data $responseData");
      var responseString = String.fromCharCodes(responseData);
      print("response string $responseString");
      var responseJson = jsonDecode(responseString);
      return (PhotoDetail(imageModel: ImageModel.fromJson(responseJson["image"]), attendees: responseJson["attendees"]));
    } catch (e) {
      rethrow;
    }
  } 
}