import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_app/photo_detail/bloc/photo_detail_bloc.dart';
import 'package:camera_app/photo_detail/domain/photo_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PhotoDetailsScreen extends StatelessWidget {
  const PhotoDetailsScreen({
    super.key,
    required this.classId,
    required this.photo,
  });

  final int classId;
  final File photo;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PhotoDetailBloc>();

    bloc.add(PhotoDetailLoad(classId, photo: photo));

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.grey[800],
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Classroom Details'),
        ),
        body: BlocBuilder<PhotoDetailBloc, PhotoDetailState>(
            builder: (context, state) {
            print('The current state ${bloc.state}');
          if (state is PhotoDetailInitial) {
            bloc.add(PhotoDetailLoad(classId, photo: photo));
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PhotoDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PhotoDetailLoaded) {
            return _PhotoDetailPage(photoDetail: state.photoDetail);
          } else {
            Navigator.pop(context);
            return Container(
              color: Colors.indigoAccent,
              child: ElevatedButton(
                  onPressed: () {
                    bloc.add(PhotoDetailLoad(classId, photo: photo));
                  },
                  child: const Text("Refresh")),
            );
          }
        }));
  }
}

class _PhotoDetailPage extends StatelessWidget {
  final PhotoDetail photoDetail;
  final String? baseUrl = dotenv.env["base_url"];
  final String? port = dotenv.env["port"];

  _PhotoDetailPage({required this.photoDetail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.network(
              "${baseUrl!}$port/image/${photoDetail.imageModel.fileName}"),
        ],
      ),
    );
  }
}
