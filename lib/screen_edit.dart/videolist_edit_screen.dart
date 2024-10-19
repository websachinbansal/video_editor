import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_app/screen_edit.dart/video_edit_player.dart';
import 'package:path_provider/path_provider.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  VideoListScreenState createState() => VideoListScreenState();
}

class VideoListScreenState extends State<VideoListScreen> {
  List<FileSystemEntity> _files = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _listVideoFiles();
  // }

  Future<void> _listVideoFiles() async {
    print("in a listVideoFiles Method");
    final directory = await getExternalStorageDirectory();
    final List<FileSystemEntity> videos = directory!
        .listSync()
        .where((item) => item.path.endsWith('.mp4'))
        .toList();
    setState(() {
      _files = videos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          
          children: [
          Center(
            child: TextButton(
                child: Text("Load Videos"),
                onPressed: ()async {
                 await _listVideoFiles();
                }),
          )
        ]),
      ),
      body: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.video_library),
            title: Text(_files[index].path.split('/').last),
            onTap: () {
              //              Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => VideoEditorScreen(videoPath: _files[index].path),
              // ));
              //             print("Tapped on ${_files[index].path}");
            },
          );
        },
      ),
    );
  }
}
