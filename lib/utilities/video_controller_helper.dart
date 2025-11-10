import 'package:uielem/models/drama_response.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/watch_history_item.dart';
class VideoControllerHelper {
  YoutubePlayerController? _controller;


  VideoControllerHelper();




  void initController(String videoId, String title, String thumbnailUrl, double? startTime) {

    print("Initializing controller for: $videoId");

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        enableCaption: false,
        controlsVisibleAtStart: true,
        hideControls: false,
        forceHD: true,

      ),
    );


  }

  void addToWatchHistory(WatchHistoryItem item, String uid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('watchhistory')
        .doc(item.videoId)
        .set(item.toJson());
  }
  void skipForward() {
    final position = _controller?.value.position;
    _controller?.seekTo(position! + const Duration(seconds: 5));
  }

  void skipBackward() {
    final position = _controller!.value.position;
    _controller!.seekTo(position - const Duration(seconds: 5));
  }

  void togglePlayPause() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }
  YoutubePlayerController? getController() {
    return _controller;
  }

  YoutubePlayerController? get controller => _controller;
}
