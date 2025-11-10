import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uielem/services/apiservice.dart';

import 'keys.dart';

class YouTubeApiHelper {
  static const _apiKey = YOUTUBE_API_KEY;

  static Future<String?> fetchLatestVideoId(String playlistId) async {
    final latestVideoId = await ApiService.fetchLastVideoIdFromPlaylist(
        playlistId);
    print("Latest video ID from playlist: $latestVideoId");
    return latestVideoId;
  }
}