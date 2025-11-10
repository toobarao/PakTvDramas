class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  Video(
      {required this.id,
        required this.title,
        required this.thumbnailUrl,
        required this.channelTitle});
  factory Video.fromMap(Map<String, dynamic> snippet) {
    return Video(
        id: snippet['resourceId']['videoId'],
        title: snippet['title'],
        thumbnailUrl: snippet['thumbnails']?['maxres']?['url'] ??
            snippet['thumbnails']?['standard']?['url'] ??
            snippet['thumbnails']?['high']?['url'] ??
            snippet['thumbnails']?['medium']?['url'] ??
            snippet['thumbnails']?['default']?['url'] ?? '',
        channelTitle: snippet['channelTitle']);
  }
}