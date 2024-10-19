import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../functions_calculations/video_view_count.dart';
import '../provider/video_model.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key,});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<VideoModel>(context, listen: false);
    _controller = YoutubePlayerController(
      initialVideoId: provider.selectedVideoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    _controller.setPlaybackRate(speed);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VideoModel>(context);
    final video = provider.videos.firstWhere(
      (video) => video['id'] == provider.selectedVideoId,
      orElse: () => null,
    );

    final viewCount = video?['statistics']?['viewCount'] ?? '0';
    final likeCount = video?['statistics']?['likeCount'] ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          onReady: () {
            _controller.addListener(() {
              setState(() {});
            });
          },
        ),
        builder: (context, player) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player
                player,

                // Playback Controls
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Playback Speed
                      DropdownButton<double>(
                        value: _playbackSpeed,
                        items: [0.5, 1.0, 1.5, 2.0]
                            .map((speed) => DropdownMenuItem(
                                  value: speed,
                                  child: Text('${speed}x'),
                                ))
                            .toList(),
                        onChanged: (speed) {
                          if (speed != null) _changePlaybackSpeed(speed);
                        },
                      ),

                      // Fullscreen Toggle
                      IconButton(
                        icon: const Icon(Icons.fullscreen),
                        onPressed: () {
                          _controller.toggleFullScreenMode();
                        },
                      ),

                      // Quality Selection (pseudo-options)
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          // Implement quality selection, if needed
                        },
                      ),
                    ],
                  ),
                ),

                // View Count, Likes, and Dislikes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '${formatViewCount(viewCount)} views',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 23, 23, 23),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.thumb_up, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${formatViewCount(likeCount)} views',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),

                // Video Details (Title, Description, etc.)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    video?['snippet']['title'] ?? 'Video Title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    video?['snippet']['channelTitle'] ?? 'Channel Name',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Video Description
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    video?['snippet']['description'] ?? 'Video description...',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await provider.downloadYouTubeVideo(provider.selectedVideoId!);
                      },
                      child:provider.isDownloading? CircularProgressIndicator(value: provider.downloadProgress): const Text('Download'),
                    ))
              ],
            ),
          );
        },
      ),
    );
  }
}
