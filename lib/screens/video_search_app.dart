import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../functions_calculations/video_view_count.dart'; // Ensure this function formats large numbers
import '../provider/video_model.dart';
import 'video_play_screen.dart';

class ViralVideoSearchApp extends StatefulWidget {
  const ViralVideoSearchApp({super.key});

  @override
  ViralVideoSearchAppState createState() => ViralVideoSearchAppState();
}

class ViralVideoSearchAppState extends State<ViralVideoSearchApp> {

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<VideoModel>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Viral Video Search"),
        ),
        body: Column(
          children: [
            // Search bar at the top
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search videos...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onSubmitted: provider.onSearchSubmitted,
              ),
            ),
            Expanded(
              child: provider.isloading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.hasError
                      ? const Center(
                          child: Text(
                            "Failed to load videos. Please try again later.",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: provider.videos.length,
                          itemBuilder: (context, index) {
                            final video = provider.videos[index];
                            final viewCount =
                                video['statistics']?['viewCount'] ?? '0';
                            final formattedViewCount =
                                formatViewCount(viewCount);

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8.0),
                                leading: Image.network(
                                  video['snippet']['thumbnails']['medium']
                                      ['url'],
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  video['snippet']['title'],
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${video['snippet']['channelTitle']} • $formattedViewCount views',
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                                onTap: () {
                                    provider.setSelectedVideoId(video['id']); 
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>const VideoPlayerScreen(),
                   
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
