import 'package:flutter/material.dart';
import 'package:flutter_video_app/screen_edit.dart/videolist_edit_screen.dart';
import 'package:flutter_video_app/screens/video_search_app.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // This now directly gets children with Provider
  List<Widget> get _children => [
    const ViralVideoSearchApp(),
   const VideoListScreen (),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),
        ],
      ),
    );
  }
}
