import 'package:cached_network_image/cached_network_image.dart';
 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/video.dart';
import '../models/watch_history_item.dart';
import '../utilities/video_controller_helper.dart';


class PlayerPage extends StatefulWidget {
  final String videoId, title, thumbnailUrl,dramaUrl;
  final double? timeWatched;
  final List<Video> videos ;
  const PlayerPage({
    super.key,
    required this.videoId,
    required this.title,
    required this.thumbnailUrl, required this.videos,required this.dramaUrl, this.timeWatched,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with AutomaticKeepAliveClientMixin {
  late String _currentVideoId, _currentTitle, _currentThumbnailUrl;
  YoutubePlayerController? _controller;
  late VideoControllerHelper _videoHelper;
  bool _isPanelVisible = false;
  bool _isPlayerReady = false;

  bool _isPlaying = false;

  void _videoListener() {
    if (!mounted) return;
    final isPlayingNow = _controller!.value.isPlaying;
    if (isPlayingNow != _isPlaying) {
      setState(() {
        _isPlaying = isPlayingNow;
      });
    }
  }

  @override
  bool get wantKeepAlive => true; // Keeps the state alive during orientation change

  @override
  void initState() {
    super.initState();
   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([

      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _currentVideoId=widget.videoId;
    _currentTitle=widget.title;
    _currentThumbnailUrl=widget.thumbnailUrl;
  _videoHelper = VideoControllerHelper();
    _initPlayerSetup(_currentVideoId,_currentTitle,_currentThumbnailUrl);

  }
  // void _fullscreenListener() {
  //   if (_controller == null) return;
  //
  //   final isFullScreenNow = _controller!.value.isFullScreen;
  //   if (isFullScreenNow != _isFullScreen) {
  //     setState(() {
  //       _isFullScreen = isFullScreenNow;
  //     });
  //   }
  // }

  Future<void> _initPlayerSetup(String videoId,String title,String thumbnailUrl) async {
    try {

      _videoHelper.initController(videoId, title,thumbnailUrl,widget.timeWatched);

      setState(() {
        _controller = _videoHelper.getController();
        _controller?.addListener(_videoListener);
      });

    } catch (e) {
      print("Error: $e");
    }
  }


  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller?.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context); // Make sure to call this to keep alive

    if (_controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,

      );
    }

    return
      WillPopScope(
        onWillPop: () async {
          // final currentPosition = _controller?.value.position?.inSeconds.toDouble() ?? 0.0;
          // final totalDuration = _controller?.metadata.duration.inSeconds.toDouble() ?? 0.0;
          // WatchHistoryItem watchItem= WatchHistoryItem(videoId:_currentVideoId, title: _currentTitle, thumbnailUrl: _currentThumbnailUrl, watchedAt:DateTime.now(),timeWatched:currentPosition,totalDuration: totalDuration,dramaUrl: widget.dramaUrl);
          // final user = FirebaseAuth.instance.currentUser;
          // if (user != null) {
          //   _videoHelper.addToWatchHistory(watchItem, user.uid);
          // }
          Navigator.pop(context);
          return true; // allow the pop (exit app)
    },child:
        AnnotatedRegion<SystemUiOverlayStyle>(
           value: SystemUiOverlayStyle.light,

      child:Scaffold(

      backgroundColor: Colors.black,
  body:
  Stack(
    children: [
      YoutubePlayerBuilder(
          player: YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: false,
          thumbnail:Image.network(
            _currentThumbnailUrl,
            fit: BoxFit.cover,
          ),
          // progressIndicatorColor: Colors.redAccent,
          onReady: () {
            setState(() {
              _isPlayerReady = true;
            });
            if (widget.timeWatched != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _controller!.seekTo(Duration(seconds: widget.timeWatched!.toInt()));
                _controller!.play();
              });
            } else {
              _controller!.play();
            }
          },
          bottomActions: [
          IconButton(
          icon: Icon(
            color:Colors.white,
            _isPlaying ? Icons.pause : Icons.play_arrow,
          ),
                      onPressed:  () {
                        _isPlaying ? _controller?.pause() : _controller?.play();
          //setState(() {});
                      }
           ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _videoHelper.skipBackward,
              child: const Icon(Icons.replay_5, color: Colors.white),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _videoHelper.skipForward,
              child: const Icon(Icons.forward_5, color: Colors.white),
            ),
            const SizedBox(width: 8.0),
            CurrentPosition(),

            const SizedBox(width: 8.0),
            Expanded(
              child: ProgressBar(
                isExpanded: true,
                colors: const ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.redAccent,
                  backgroundColor: Colors.black26,
                  bufferedColor: Colors.grey,
                ),
              ),
            ),
            RemainingDuration(),
            const SizedBox(width: 8.0),
            PlaybackSpeedButton(),
            // FullScreenButton()




          ],
          topActions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () {
                final currentPosition = _controller?.value.position?.inSeconds.toDouble() ?? 0.0;
                final totalDuration = _controller?.metadata.duration.inSeconds.toDouble() ?? 0.0;

                // WatchHistoryItem watchItem = WatchHistoryItem(
                //   videoId: _currentVideoId,
                //   title: _currentTitle,
                //   thumbnailUrl: _currentThumbnailUrl,
                //   watchedAt: DateTime.now(),
                //   timeWatched: currentPosition,
                //   totalDuration: totalDuration,
                //   dramaUrl: widget.dramaUrl,
                // );
                //
                // final user = FirebaseAuth.instance.currentUser;
                // if (user != null) {
                //   _videoHelper.addToWatchHistory(watchItem, user.uid);
                // }
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller!,
                builder: (context, _) {
                  return Text(
                    _controller!.metadata.title.isNotEmpty
                        ? _controller!.metadata.title
                        : 'Loading...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );
                },
              ),
            ),




          ],

                      ),
        builder: (context, player) {
          return
            SafeArea(
              child: player,
            );

        }



    ),
      _buildSidePanel(context),

    ]
  )

  )

        ));
  }


  Widget _buildSidePanel(BuildContext context) {
    return Stack(
      children: [
        _buildPanelToggle(context),
        _buildPlaylistPanel(context),

      ],
    );
  }

  Widget _buildPanelToggle(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      right: _isPanelVisible ? 280 : -20,
      top: MediaQuery.of(context).size.height / 2 - 25,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isPanelVisible = !_isPanelVisible;
          });
        },
        child: ClipPath(
          clipper: SemiCircleClipper(),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor == Colors.black ? Colors.black : Colors.red,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildPlaylistPanel(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      right: _isPanelVisible ? 0 : -300,
      top: 0,
      bottom: 0,
      width: 300,
      child: Container(
        color:Theme.of(context).scaffoldBackgroundColor == Colors.black ? Colors.black : Colors.red,
        child: ListView.builder(
          itemCount: widget.videos.length,
          itemBuilder: (context, index) => _buildPlaylistItem(context, index),
        ),
      ),
    );
  }


  Widget _buildPlaylistItem(BuildContext context, int index) {
    final video = widget.videos[index];
    final isCurrent = video.id == _currentVideoId;

    return GestureDetector(
      onTap: () {
        _controller!.load(video.id);
        setState(() {
          _isPanelVisible = false;
          _currentVideoId = video.id;
          _currentTitle = video.title;
          _currentThumbnailUrl = video.thumbnailUrl;
        });

        final currentPosition = _controller?.value.position?.inSeconds.toDouble() ?? 0.0;
        final totalDuration = _controller?.metadata.duration.inSeconds.toDouble() ?? 0.0;

        WatchHistoryItem watchItem = WatchHistoryItem(
          videoId: _currentVideoId,
          title: _currentTitle,
          thumbnailUrl: _currentThumbnailUrl,
          watchedAt: DateTime.now(),
          timeWatched: currentPosition,
          totalDuration: totalDuration,
          dramaUrl: widget.dramaUrl,
        );

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          _videoHelper.addToWatchHistory(watchItem, user.uid);
        }
      },
      child: Container(
        color: isCurrent ? Colors.white : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: video.thumbnailUrl,
                height: 70,
                width: 130,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: Icon(Icons.broken_image, size: 40)),
                errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image, size: 40)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCurrent ? Colors.black : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    video.channelTitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isCurrent ? Colors.grey[700] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SemiCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.addArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height), radius: size.width / 2),
      0, // starting angle
      3.14, // arc angle (semi-circle)
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

