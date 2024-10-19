import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../functions_calculations/video_view_count.dart';

class VideoModel with ChangeNotifier {
  final String _apiKey = 'AIzaSyA39bgCv4n1DDMZZcSxxXRytlKqNZu5hb0';
  bool isloading = false;
  bool hasError = false;
  List videos = [];
  String? _selectedVideoId;
  String? get selectedVideoId => _selectedVideoId;
  double downloadProgress = 0.0;
  bool isDownloading = false;

  Future<void> fetchVideos({String? query}) async {
    isloading = true;
    hasError = false;
    notifyListeners();

    final String url = query == null || query.isEmpty
        ? 'https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&chart=mostPopular&maxResults=15&regionCode=US&key=$_apiKey'
        : 'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=15&q=$query&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (query != null && query.isNotEmpty) {
          // Fetch statistics separately for search results
          final videoIds =
              data['items'].map((item) => item['id']['videoId']).join(',');
          await fetchVideoStatistics(videoIds);
        } else {
          videos = data['items'];
          sortVideosByViewCount(videos);
        }
        isloading = false;
      } else {
        hasError = true;
      }
    } catch (e) {
      hasError = true;
      notifyListeners();
    }
  }

  Future<void> fetchVideoStatistics(String videoIds) async {
    final String statisticsUrl =
        'https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&id=$videoIds&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(statisticsUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        videos = data['items'];
        sortVideosByViewCount(
            videos); // Sort by view count after fetching statistics
        isloading = false;
      } else {
        hasError = true;
      }
    } catch (e) {
      hasError = true;
    }
    notifyListeners();
  }

  void onSearchSubmitted(String query) {
    fetchVideos(query: query);
  }

  // New method to set selected video ID
  void setSelectedVideoId(String videoId) {
    _selectedVideoId = videoId;
    notifyListeners();
  }

  Future<void> downloadYouTubeVideo(String videoId) async {
    var yt = YoutubeExplode();
    var video = await yt.videos.get(videoId);
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var streamInfo = manifest.muxed.withHighestBitrate();

    // var status = await Permission.storage.request();
    var externalstorage = await Permission.manageExternalStorage.request();
    if (!externalstorage.isGranted) {
      print("Storage permission denied");
      return;
    }

    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      print("Failed to get storage directory");
      return;
    }

    final filePath = "${directory.path}/${video.title}.mp4";
    final dio = Dio();

    try {
      await dio.download(streamInfo.url.toString(), filePath,
          onReceiveProgress: (received, total) {
        isDownloading = true;
        if (total != -1) {
          downloadProgress = received / total;
          notifyListeners();
          print(
              "Downloading: ${((received / total) * 100).toStringAsFixed(0)}%");
        }
      });
      Fluttertoast.showToast(
          msg: "Download completed! File saved at: $filePath");
      print("Download completed!");
      print("downloaded to $filePath");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error downloading video: $e");
      print("Error downloading video: $e");
    }

    yt.close();
    isDownloading = false;
    notifyListeners();
  }
}
