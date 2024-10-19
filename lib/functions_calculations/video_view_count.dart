  // Helper function to format the view count
  String formatViewCount(String viewCount) {
    int count = int.parse(viewCount);
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

    void sortVideosByViewCount(List videos) {
    videos.sort((a, b) {
      int viewCountA = int.tryParse(a['statistics']?['viewCount'] ?? '0') ?? 0;
      int viewCountB = int.tryParse(b['statistics']?['viewCount'] ?? '0') ?? 0;
      return viewCountB.compareTo(viewCountA); // Sort descending by view count
    });
  }
