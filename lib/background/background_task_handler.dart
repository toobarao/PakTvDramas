import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:workmanager/workmanager.dart';
import '../firebase_options.dart';
import '../services/notification_service.dart';
import 'video_check_service.dart';
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("🎯 WorkManager triggered with task: $task and data: $inputData");

    // MUST initialize Firebase in isolate
    try {
      // Re-initialize dependencies
      WidgetsFlutterBinding.ensureInitialized(); // Required here
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await NotificationService.init(); // Must be static

      print("✅ Firebase initialized in background isolate");
    } catch (e) {
      print("❌ Firebase failed to initialize: $e");
      return Future.value(false);
    }

    try {
      if (task.startsWith('check_new_videos_')) {
        final userId = inputData?['userId'];
        if (userId == null) {
          print("❌ No userId in inputData");
          return Future.value(false);
        }

        await VideoCheckService().checkForNewVideos(userId);
        print("✅ Task completed successfully for user: $userId");
        return Future.value(true);
      }

      print("❌ Unknown task: $task");
      return Future.value(false);
    } catch (e, stack) {
      print("🔥 Exception in Workmanager task: $e\n$stack");
      return Future.value(false);
    }
  });
}
