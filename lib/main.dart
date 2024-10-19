import 'package:flutter/material.dart';
import 'package:flutter_video_app/provider/video_model.dart';
import 'package:provider/provider.dart';

import 'screen_navigation.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => VideoModel(),
      //..fetchVideos(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:const HomePage()
      //  const ViralVideoSearchApp (),
    );
  }
}

