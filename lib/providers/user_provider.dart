import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/app_user.dart';

class UserProvider with ChangeNotifier {
  AppUser? _userData;
  bool _isLoading = false;

  AppUser? get userData => _userData;
  bool get isLoading => _isLoading;

  Future<void> fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (doc.exists) {
        _userData = AppUser.fromMap(currentUser.uid, doc.data()!);
      } else {
        _userData = AppUser(
          uid: currentUser.uid,
          email: currentUser.email ?? '',
          name: currentUser.displayName ?? '',
          phone: '',
          gender: '',
          dob: DateTime(2000),
        );
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserData(AppUser user) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await docRef.set(user.toMap(), SetOptions(merge: true));
      _userData = user;
      notifyListeners();
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  // 👇 Add this to manually set user data
  void setUser(AppUser user) {
    _userData = user;
    notifyListeners();
  }

  // 👇 Alias for fetchUserData if needed
  Future<void> loadUser() async {
    await fetchUserData();
  }
}
