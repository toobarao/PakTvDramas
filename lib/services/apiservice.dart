import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:uielem/models/search_drama.dart';

import 'package:uielem/utilities/keys.dart';
import 'package:http/http.dart' as http;

import '../models/channel_drama.dart';
import '../models/channel_info.dart';
import '../models/drama_info.dart';

import '../models/tv_rating.dart';
import '../models/video.dart';

class ApiService {
  ApiService._instantiate();

  static final ApiService instance = ApiService._instantiate();

  final String _baseUrl = 'www.paktvdramas.pk:3050';



  Future<dynamic> fetchLatestDramas() async {

    Uri uri = Uri.https(_baseUrl, '/api/home');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'API_ACCESS_KEY': API_KEY,
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // Decode the JSON response
        var jsonResponse = json.decode(response.body);

        return jsonResponse;


      } else {
        // Handle unsuccessful response, returning an empty list
        throw Exception('Failed to load latest dramas');
      }
    } catch (e) {
      print('Error: $e');
      // Return an empty list in case of an exception
      throw Exception('Failed to load latest dramas');
    }
  }
  Future<List<TvRating>> fetchTvRatingDramas(String date)async{
    Uri uri = Uri.https(_baseUrl, '/api/ratings/tv');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'API_ACCESS_KEY': API_KEY,
    };
    Map<String, String> body = {
      'date': date,
    };

    try {
      var response = await http.post(uri, headers: headers, body: jsonEncode(body),);

      if (response.statusCode == 200) {
        // Decode the JSON response
        var jsonResponse = json.decode(response.body);
List<TvRating> tvRatings=(jsonResponse[0]?.values.map((recipeJson) {
          return TvRating.fromJson(recipeJson);
        }).toList().cast<TvRating>()) ??
            [];

        return tvRatings;


      } else {
        // Handle unsuccessful response, returning an empty list
        throw Exception('Failed to load tvrating dramas');
      }
    } catch (e) {
      print('Error: $e');
      // Return an empty list in case of an exception
      throw Exception('Failed to load tvrating dramas');
    }
  }
  Future<List<TvRating>> fetchSocialMediaDramas(String date)async{
    Uri uri = Uri.https(_baseUrl, '/api/ratings/social');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'API_ACCESS_KEY': API_KEY,
    };
    Map<String, String> body = {
      'date': date,
    };

    try {
      var response = await http.post(uri, headers: headers, body: jsonEncode(body),);

      if (response.statusCode == 200) {
        // Decode the JSON response
        var jsonResponse = json.decode(response.body);
        List<TvRating> socialMediaRatings=(jsonResponse[0]?.values.map((recipeJson) {
          return TvRating.fromJson(recipeJson);
        }).toList().cast<TvRating>()) ??
            [];

        return socialMediaRatings;


      } else {
        // Handle unsuccessful response, returning an empty list
        throw Exception('Failed to load social media dramas');
      }
    } catch (e) {
      print('Error: $e');
      // Return an empty list in case of an exception
      throw Exception('Failed to load social dramas');
    }
  }
  Future<DramaInfo> fetchDramaDetails(int dramaId,int channelId) async {
    Uri uri = Uri.https(_baseUrl, '/api/drama/$dramaId/channel/$channelId');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'API_ACCESS_KEY': API_KEY,
    };

    try {
      var response = await http.post(uri, headers: headers);


      if (response.statusCode == 200) {

        // Decode the JSON response
        var jsonResponse = json.decode(response.body);

        var drama_details=DramaInfo.fromJson(jsonResponse["dramaInfo"]["0"]);
      //  print(drama_details);




        return drama_details;


      } else {
        // Handle unsuccessful response, returning an empty list
        throw Exception('Failed to load latest dramas');
      }
    } catch (e) {
      print('Error: $e');
      // Return an empty list in case of an exception
      throw Exception('Failed to load latest dramas');
    }
  }
  Future<List<Video>> fetchPlayList(String playlistId) async {
    const String apiKey = YOUTUBE_API_KEY;
    List<Video> allVideos = [];
    String? nextPageToken;

    try {
      do {
        final String playlistUrl =
            'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&key=$apiKey${nextPageToken != null ? '&pageToken=$nextPageToken' : ''}';

        final response = await http.get(Uri.parse(playlistUrl));

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          final items = data['items'];


          if (items != null && items is List) {
            for (var item in items) {
              if (item['snippet'] != null) {
                allVideos.add(Video.fromMap(item['snippet']));
              }
            }
          } else {
            print("Warning: 'items' is null or not a list in response.");
          }

          nextPageToken = data['nextPageToken'];
        } else {
          print("Failed to load playlist, statusCode: ${response.statusCode}");
          throw Exception('Failed to load playlist');
        }
      } while (nextPageToken != null);
print(allVideos[0].id);
      return allVideos.toList(); // reverse for most recent first (optional)
    } catch (e) {
      print("Exception in fetchPlaylistVideos: $e");
      throw Exception(e.toString());
    }
  }
  static Future<String?> fetchLastVideoIdFromPlaylist(String playlistId) async {
    const String apiKey = YOUTUBE_API_KEY;
    String? nextPageToken;
    String? lastVideoId;
    int maxResults = 50; // Max allowed by API

    do {
      final url = Uri.parse(
        'https://www.googleapis.com/youtube/v3/playlistItems'
            '?part=snippet'
            '&maxResults=$maxResults'
            '&playlistId=$playlistId'
            '&key=$apiKey'
            '${nextPageToken != null ? '&pageToken=$nextPageToken' : ''}',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return null;
      }

      final data = json.decode(response.body);
      final items = data['items'];
      nextPageToken = data['nextPageToken'];

      if (items != null && items.isNotEmpty) {
        final lastItem = items.last;
        lastVideoId = lastItem['snippet']['resourceId']['videoId'];
      }

    } while (nextPageToken != null);

    return lastVideoId;
  }
  Future<Map<int, ChannelInfo>> loadChannelInfo() async {
    final jsonString = await rootBundle.loadString('assets/channels.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    Map<int, ChannelInfo> channelMap = {};
    data.forEach((key, value) {
      final channel = ChannelInfo.fromJson(value);
      channelMap[channel.id] = channel;
    });

    return channelMap;

  }
  Future<List<ChannelDramaGroup>> fetchDramasByChannelId(int channelId) async {

    Uri uri = Uri.https(_baseUrl, '/api/drama/channel/$channelId');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'API_ACCESS_KEY': API_KEY,
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final groups = jsonData
            .map((groupJson) => ChannelDramaGroup.fromJson(groupJson as Map<String, dynamic>))
            .toList();

        return groups; //
      } else {
        throw Exception('Failed to load channel dramas');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load channel dramas');
    }
  }
  Future<Map<int, List<ChannelDramaGroup>>> fetchChannelsDramas() async {
    final Map<int, List<ChannelDramaGroup>> result = {};
    final Map<int, ChannelInfo> channelMap = await loadChannelInfo();

    for (var entry in channelMap.entries) {
      final channelId = entry.key;
      final channelInfo = entry.value;

      try {
        final dramaGroups = await fetchDramasByChannelId(channelId);
     print(dramaGroups[0].thumbnail);
     print(dramaGroups[0].dramas[0].id);
        // Flatten all groups into a single list of ChannelDrama
        // final dramas = dramaGroups.expand((group) => group.).toList();

        result[channelInfo.id] = dramaGroups;
      } catch (e) {
        print('Failed to load dramas for channel ${channelInfo.name}: $e');
      }
    }
    print('Saved ${result.length} dramas length');
    print(result[210]!.first);

    return result;
  }
  Future<List<SearchDramaResult>> fetchSearchDrama(String searchString) async {
    Uri uri = Uri.https(_baseUrl, '/api/drama/searchdrama/$searchString');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'API_ACCESS_KEY': API_KEY,
    };


    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((e) => SearchDramaResult.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load search dramas');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load search dramas');
    }
  }

}



