// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:video_trimmer/video_trimmer.dart';

// class VideoTrimmingScreen extends StatefulWidget {
//   final String videoPath;

//   const VideoTrimmingScreen({Key? key, required this.videoPath}) : super(key: key);

//   @override
//   _VideoTrimmingScreenState createState() => _VideoTrimmingScreenState();
// }

// class _VideoTrimmingScreenState extends State<VideoTrimmingScreen> {
//   final Trimmer _trimmer = Trimmer();
//   bool _isLoading = false;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadVideo();
//   }

//   void _loadVideo() async {
//     setState(() {
//       _isLoading = true;
//     });
//     await _trimmer.loadVideo(videoFile: File(widget.videoPath));
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _saveTrimmedVideo() async {
//     setState(() {
//       _isLoading = true;
//     });
//     await _trimmer.saveTrimmedVideo(
//       startValue: _trimmer.startValue ?? 0.0,
//       endValue: _trimmer.endValue ?? 0.0,
//       onSave: (String? outputPath) {
//         setState(() {
//           _isLoading = false;
//         });
//         if (outputPath != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Video saved at: $outputPath')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to save video')),
//           );
//         }
//       },
//     );
//   }

//   void _togglePlayback() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//     });
//     _trimmer.videPlaybackControl(
//       startValue: _trimmer.startValue ?? 0.0,
//       endValue: _trimmer.endValue ?? 0.0,
//     ).then((value) {
//       setState(() {
//         _isPlaying = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trim Video'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _saveTrimmedVideo,
//           )
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Expanded(
//                     child: VideoViewer(trimmer: _trimmer),
//                   ),
//                   TrimEditor(
//                     trimmer: _trimmer,
//                     viewerHeight: 50.0,
//                     viewerWidth: MediaQuery.of(context).size.width,
//                     maxVideoLength: const Duration(seconds: 30),
//                     onChangeStart: (value) => setState(() {}),
//                     onChangeEnd: (value) => setState(() {}),
//                     onChangePlaybackState: (value) {
//                       setState(() {});
//                     },
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: _togglePlayback,
//                         child: Text(_isPlaying ? 'Pause' : 'Play'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
