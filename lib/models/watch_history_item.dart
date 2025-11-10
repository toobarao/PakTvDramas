class WatchHistoryItem {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final DateTime watchedAt;
  final double timeWatched;
  final double totalDuration;
  final String dramaUrl;

  WatchHistoryItem({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.watchedAt,
    required this.timeWatched,
    required this.totalDuration,
    required this.dramaUrl
  });

  Map<String, dynamic> toJson() => {
    'videoId': videoId,
    'title': title,
    'thumbnailUrl': thumbnailUrl,
    'watchedAt': watchedAt.toIso8601String(),
    'timeWatched': timeWatched,  // Already a double, no need to call toDouble()
    'totalDuration': totalDuration,
    'dramaUrl':dramaUrl,
  };

  factory WatchHistoryItem.fromJson(Map<String, dynamic> json) {
    try {
      return WatchHistoryItem(
          videoId: json['videoId'] as String,
          title: json['title'] as String,
          thumbnailUrl: json['thumbnailUrl'] as String,
          watchedAt: DateTime.parse(json['watchedAt'] as String),
          timeWatched: json['timeWatched'] is double
              ? json['timeWatched']
              : (json['timeWatched'] as num).toDouble(),
          totalDuration: (json['totalDuration'] as num).toDouble(),// Ensure it's a double
          dramaUrl: json['dramaUrl'] as String
      );
    } catch (e) {
      // If there is an issue with parsing, log the error and return a default object or null
      print("Error parsing WatchHistoryItem: $e");
      rethrow; // Optional, can also return a default object or null
    }
  }
}