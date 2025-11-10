import 'channel_drama.dart';

class SearchDramaResult {
  final String thumbnail;
  final int channelId;
  final List<Drama> dramas;

  SearchDramaResult({
    required this.thumbnail,
    required this.channelId,
    required this.dramas,
  });

  factory SearchDramaResult.fromJson(Map<String, dynamic> json) {
    return SearchDramaResult(
      thumbnail: json['thumbnail'] as String,
      channelId: json['channelId'] as int,
      dramas: (json['Dramas'] as List)
          .map((e) => Drama.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
      'channelId': channelId,
      'Dramas': dramas.map((e) => e.toJson()).toList(),
    };
  }
}


