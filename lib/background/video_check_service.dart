import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/notification_service.dart';
import '../utilities/youtube_api_helper.dart';

class VideoCheckService {
  Future<void> checkForNewVideos(String userId) async {
    print("check for new videos called");

    final favoritesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .get();

    final tasks = favoritesSnapshot.docs.map((doc) async {
      final data = doc.data();
      final lastVideoId = data['lastVideo'];
      final dramaName = data['dramaName'];
      final playlistId = doc.id;

      print("Checking playlist: $playlistId");

      final latestVideoId = await YouTubeApiHelper.fetchLatestVideoId(playlistId);
      print("Latest video: $latestVideoId");

      if (latestVideoId == null || latestVideoId == lastVideoId) {
        print("No new video for $playlistId");
        return;
      }

      // Update Firestore
      await doc.reference.update({'lastVideo': latestVideoId});
      print("Notification sending...");

      // Trigger notification
      await NotificationService.showNotification(
        title: "New Episode Alert 📺",
        body: "A new video has been uploaded in $dramaName!",
      );
    });

    await Future.wait(tasks); // ⚡ Run all tasks in parallel
  }

}
