import 'package:flutter/material.dart';
import '../models/recommendations.dart';
import '../models/tv_rating.dart';
import '../services/apiservice.dart';

class SocialMediaProvider extends ChangeNotifier {
  List<TvRating> _ratings = [];
  String _currentDate = ''; // YYYY-MM-DD
  bool _isLoading = false;

  List<TvRating> get ratings => _ratings;
  bool get isLoading => _isLoading;
  String get currentDate => _currentDate;

  Future<void> fetchInitialRatings() async {
    DateTime date = DateTime.now().subtract(Duration(days: 10));
    String formatted = date.toIso8601String().split('T')[0];
    await fetchRatingsForDate(formatted);
  }

  Future<void> fetchRatingsForDate(String date) async {
    if (_currentDate == date && _ratings.isNotEmpty) return; // Cached

    _isLoading = true;
    notifyListeners();

    try {
      _currentDate = date;
      _ratings = await ApiService.instance.fetchSocialMediaDramas(date);
      print(_ratings[0].name);

    } catch (e) {
      print("Error fetching ratings: $e");
      _ratings = [];
    }

    _isLoading = false;
    notifyListeners();
  }
// in TvRatingProvider
// void cacheToHive() {
//   var json = _ratings.map((e) => e.toJson()).toList();
//   Hive.box('tvRatingCache').put(_currentDate, json);
// }

}

