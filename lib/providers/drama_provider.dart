import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../models/channel_drama.dart';
import '../models/channel_info.dart';
import '../models/latest_dramas.dart';
import '../models/recommendations.dart';
import '../models/tv_rating.dart';
import '../services/apiservice.dart';
import '../models/drama_response.dart';
import 'network_provider.dart';

class DramaProvider with ChangeNotifier {
  DramaResponse? _dramas;
  bool _isLoading = false;
   bool _noInternet = false;
  // Map<ChannelInfo, List<ChannelDrama>> _channelDramas = {};
  bool _isChannelLoading = false;

  DramaResponse? get dramas => _dramas;
  bool get isLoading => _isLoading;
   bool get noInternet => _noInternet;
  // Map<ChannelInfo, List<ChannelDrama>>? get channelDramas => _channelDramas;

  DramaProvider() {
    fetchData(); //  Always force refresh on startup
    //fetchChannelDramas();
  }

  // Future<void> fetchChannelDramas({bool forceRefresh = false}) async {
  //   final box = Hive.box('dramaCache');
  //
  //
  //   if (_channelDramas.isNotEmpty && !forceRefresh) return;
  //
  //   _isChannelLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     final cachedJson = box.get('channelResponse');
  //
  //     if (cachedJson != null && !forceRefresh) {
  //       final decodedMap = jsonDecode(cachedJson) as Map<String, dynamic>;
  //
  //
  //       // Reconstruct _channelDramas from cached JSON
  //       _channelDramas = decodedMap.map((key, value) {
  //
  //         try {
  //
  //           final channelMap = jsonDecode(key);
  //
  //
  //           if (channelMap is! Map<String, dynamic>) {
  //             print("Key did not decode to Map: $channelMap");
  //           }
  //
  //           final channelInfo = ChannelInfo.fromJson(channelMap);
  //
  //
  //           final dramas = (value as List).map((item) {
  //
  //             return ChannelDrama.fromJson(item);
  //           }).toList();
  //
  //           return MapEntry(channelInfo, dramas);
  //         } catch (e, stack) {
  //           print("Error parsing entry:\nKey: $key\nValue: $value\nError: $e\n$stack");
  //           return MapEntry(
  //             ChannelInfo(id: -1, name: "ERROR", iconUrl: "", bannerUrl: ""),
  //             [],
  //           );
  //         }
  //       });
  //
  //       _isChannelLoading = false;
  //       notifyListeners();
  //       return;
  //     }
  //
  //     // If no cache or forceRefresh, fetch from API
  //     _channelDramas = await ApiService.instance.fetchChannelsDramas();
  //     print("total dramas");
  //     print(_channelDramas.length);
  //
  //     // Prepare _channelDramas to be saved in JSON-friendly format
  //     final cacheMap = _channelDramas.map((key, value) {
  //       final encodedKey = jsonEncode(key.toJson());
  //
  //
  //       final encodedValue = value.map((drama) {
  //         final dramaJson = drama.toJson();
  //
  //         return dramaJson;
  //       }).toList();
  //
  //       return MapEntry(encodedKey, encodedValue);
  //
  //     });
  //
  //     box.put('channelResponse', jsonEncode(cacheMap));
  //
  //   } catch (e) {
  //     print("Error fetching channel dramas: $e");
  //   }
  //
  //   _isChannelLoading = false;
  //   notifyListeners();
  // }


  Future<void> fetchData({bool forceRefresh = false}) async {


    final box = Hive.box('dramaCache');
    //  Skip if data is already loaded and no force refresh is requested
    if (_dramas != null && !forceRefresh) return;

    _isLoading = true;
    notifyListeners();

    try {
      final cachedJson = box.get('dramaResponse');


      //  Load from cache if available and not forcing refresh
      if (cachedJson != null && !forceRefresh) {
        final decodedMap = jsonDecode(cachedJson);
        _dramas = DramaResponse.fromJson(decodedMap);
        _isLoading = false;
        notifyListeners();
        return;
      }
      var jsonResponse = await ApiService.instance.fetchLatestDramas();

      _dramas = DramaResponse(
        latestDramas: (jsonResponse['latestDramas']?.values.map((recipeJson) {
          return LatestDramas.fromJson(recipeJson);
        }).toList().cast<LatestDramas>()) ??
            [],
        yourRecommendations:
        (jsonResponse['your_recommendation']?.values.map((recipeJson) {
          return Recommendations.fromJson(recipeJson);
        }).toList().cast<Recommendations>()) ??
            [],
        ourRecommendations:
        (jsonResponse['our_recommendation']?.values.map((recipeJson) {
          return Recommendations.fromJson(recipeJson);
        }).toList().cast<Recommendations>()) ??
            [],
        tvRatings: (jsonResponse['tv_rating']?.values.map((recipeJson) {
          return TvRating.fromJson(recipeJson);
        }).toList().cast<TvRating>()) ??
            [],
        socialRatings: (jsonResponse['social_rating']?.values.map((recipeJson) {
          return TvRating.fromJson(recipeJson);
        }).toList().cast<TvRating>()) ??
            [],
      );



      box.put('dramaResponse', jsonEncode(dramasToMap(_dramas!)));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching data: $e");
      _isLoading = false;
      notifyListeners();
    }
  }


  void clearData() {
    _dramas = null;
    // _channelDramas.clear();
    notifyListeners();
  }
  Map<String, dynamic> dramasToMap(DramaResponse response) {
    return {
      'latestDramas': response.latestDramas.map((e) => {
        'dc_id': e.dcId,
        'id': e.id,
        'thumbnail': e.thumbnail,
        'channelId': e.channelId,
        'name': e.name,
      }).toList(),
      'your_recommendation': response.yourRecommendations.map((e) => {
        'name': e.name,
        'thumbnail': e.thumbnail,
        'ratings': e.ratings,
        'rank_date': e.rank_date,
        'dramaID': e.dramaID,
        'channelId': e.channelId,
      }).toList(),
      'our_recommendation': response.ourRecommendations.map((e) => {
        'name': e.name,
        'thumbnail': e.thumbnail,
        'ratings': e.ratings,
        'rank_date': e.rank_date,
        'dramaID': e.dramaID,
        'channelId': e.channelId,
      }).toList(),
      'tv_rating': response.tvRatings.map((e) => {
        'name': e.name,
        'thumbnail': e.thumbnail,
        'ml_ratings': e.ml_ratings,
        'rank_date': e.rank_date,
        'dramaID': e.dramaID,
        'channelId': e.channelId,
      }).toList(),
      'social_rating': response.socialRatings.map((e) => {
        'name': e.name,
        'thumbnail': e.thumbnail,
        'ml_ratings': e.ml_ratings,
        'rank_date': e.rank_date,
        'dramaID': e.dramaID,
        'channelId': e.channelId,
      }).toList(),
    };
  }

}
