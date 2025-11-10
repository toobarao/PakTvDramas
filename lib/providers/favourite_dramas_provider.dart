import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/drama_info.dart';
import '../models/favourite_dramas.dart';
import '../services/apiservice.dart';
import '../services/favourite_service.dart';

class FavoriteDramaProvider with ChangeNotifier {
  final _userId = FirebaseAuth.instance.currentUser?.uid;
  List<FavouriteDramas> _favourites = [];
  List<DramaInfo> _dramas = [];

  List<FavouriteDramas> get favourites => _favourites;
  List<DramaInfo> get dramas => _dramas;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    final service = FavouriteService(userId: _userId!);
    final favs = await service.getFavouriteDramas();
    List<DramaInfo> loaded = [];

    for (var fav in favs) {
      try {
        final drama = await ApiService.instance.fetchDramaDetails(fav.dramaId, fav.channelId);
        loaded.add(drama);
      } catch (e) {
        debugPrint("Error fetching favorite ${fav.dramaId}: $e");
      }
    }

    _favourites = favs;
    _dramas = loaded;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeFromFavorites(String playlistId) async {
    if (_userId == null) return;

    final service = FavouriteService(userId: _userId!);
    await service.removeFromFavourites(playlistId);
    await loadFavorites();
  }
  Future<void> addToFavorites(FavouriteDramas drama, DramaInfo dramaInfo) async {
    if (_userId == null) return;

    final service = FavouriteService(userId: _userId!);
    await service.addToFavourites(drama);

    _favourites.add(drama);
    _dramas.add(dramaInfo);

    notifyListeners(); // So UI gets updated
  }

}
