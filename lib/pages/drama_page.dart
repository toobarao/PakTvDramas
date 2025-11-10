import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uielem/pages/player_page.dart';
import '../models/drama_info.dart';
import '../models/favourite_dramas.dart';
import '../models/video.dart';
import '../providers/favourite_dramas_provider.dart';
import '../services/favourite_service.dart';
import '../utilities/videos_fetch_helper.dart';



class DramaPage extends StatefulWidget {
  final dynamic dramaId,channelId;
  const DramaPage({super.key, this.dramaId, this.channelId});

  @override
  State<DramaPage> createState() => _DramaPageState();
}

class _DramaPageState extends State<DramaPage> {
  late VideosFetchHelper _videosFetchHelper;
  User? _user;
  DramaInfo? _dramaInfo;
  List<Video> _videos = [];
  bool isFavorite = false;
  int _currentVideoIndex = 0;
  bool _isLoading=true;// Track the current video index
  bool _isExpanded = false;
  DateTime? lastBackPressed;
  late String _playlistId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    _videosFetchHelper =VideosFetchHelper();
     _fetchDramaInfo();
     _checkUser();


  }
  Future<void> checkIfFavourite(String playlistId) async {

    final favouriteService = FavouriteService(userId: userId);

    final exists = await favouriteService.isFavourite(playlistId);

    setState(() {
      isFavorite = exists;
      //isFavorite = true;

     // print("Drama isFavorite: $isFavorite");
    });
  }

  void _checkUser() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = user;
    });
  }
  // Add to favourites
  Future<void> addToFavourites(FavouriteDramas drama) async {

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .doc(drama.dramaId.toString()) // use dramaId as document ID
        .set(drama.toJson());
  }


  Future<void> _fetchDramaInfo() async {
    try {
      final dramaData = await _videosFetchHelper.fetchDramaDetails(
          widget.dramaId, widget.channelId);

      List<Video> videoItems =
      await _videosFetchHelper.extractVideoIds(dramaData!.dramaURL);

      Uri uri = Uri.parse(dramaData!.dramaURL);
      final playlistId = uri.queryParameters['list'] ?? '';



      setState(() {
        _dramaInfo = dramaData;
        _videos = videoItems;
_playlistId=playlistId;
        _isLoading = false;
      });
      checkIfFavourite(_playlistId);
      print(_videos.length);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        "https://www.paktvdramas.pk:3060/drama-thumbnails/${_dramaInfo?.thumbnail.replaceAll('./assets/drama_thumbnails/', '')}";
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body:
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stack to place gradient only on bottom of image
            Stack(
              children: [
                ClipRect(
                  child: Align(
                    // alignment: Alignment.center,

                    heightFactor: 0.75, // Adjust how much height to keep (0.0 - 1.0)
                    child:
                    CachedNetworkImage(
                        imageUrl: imageUrl,
                        height: 500,
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => const Center(child: Icon(Icons.broken_image)),
                        errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image))

                    ),




                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 2, // for safe area
                  left: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.all(15),

                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Positioned gradient at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 160, // Adjust the height as needed
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black87,
                          Colors.black38,

                          Colors.transparent, // Fade upward
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Text content below image
            if(_dramaInfo!=null) Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_dramaInfo?.name}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold,fontSize:30.0),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_dramaInfo?.dramaOnAir}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                       ,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Director: ${_dramaInfo?.director}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Producer: ${_dramaInfo?.producer}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Cast:',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                    ,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_dramaInfo?.cast?.replaceAll(RegExp(r'[\n\r]+'), ' ')}',
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Show less' : '...more',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          if(_user!=null)
                           {
                             Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlayerPage(videoId: _videos[0].id, title: _videos[0].title, thumbnailUrl: _videos[0].thumbnailUrl,videos: _videos,dramaUrl: _dramaInfo!.dramaURL,)));
                           }
                          else{
                            Fluttertoast.showToast(
                              msg: "Please Login To Watch",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0,
                            );
                          }

                          // Your action here
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFDA1F26),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "PLAY NOW",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size:24
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),
                  Divider(color: Colors.grey[800]),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        "EPISODES",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold,fontSize:20.0,),
                      ),
Spacer(),
                      TextButton.icon(
                        onPressed: () async {
                          final lastVideo = _videos[_videos.length - 1];
                          final drama = FavouriteDramas(
                            dramaId: widget.dramaId,
                            channelId: widget.channelId,
                            lastVideo: lastVideo.id,
                            playlistId: _playlistId,
                            dramaName: _dramaInfo!.name,
                          );

                          final favoriteProvider = Provider.of<FavoriteDramaProvider>(context, listen: false);

                          try {
                            if (isFavorite) {
                              await favoriteProvider.removeFromFavorites(_playlistId);
                            } else {
                              await favoriteProvider.addToFavorites(drama, _dramaInfo!);
                            }

                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          } catch (e) {
                            print('Error updating favorites: $e');
                            // Optionally show a snackbar here
                          }
                        }
,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.redAccent : Colors.grey,
                          size: 20,
                        ),
                        label: Text(
                          isFavorite ? "Favourited" : "Add to Favourite",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12.0,
                            color: Colors.white, // optional styling
                          ),
                        ),
                      )

                    ],
                  )



                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,

              physics: NeverScrollableScrollPhysics(),
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                onTap: (){
            // if(_user!=null)
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlayerPage(videoId: _videos[index].id, title: _videos[index].title, thumbnailUrl: _videos[index].thumbnailUrl,videos: _videos,dramaUrl: _dramaInfo!.dramaURL,)));
            // else{
            //   Fluttertoast.showToast(
            //     msg: "Please Login To Watch",
            //     toastLength: Toast.LENGTH_SHORT,
            //     gravity: ToastGravity.SNACKBAR,
            //     timeInSecForIosWeb: 1,
            //     backgroundColor: Colors.white,
            //     textColor: Colors.black,
            //     fontSize: 16.0,
            //   );
            // }

                },
                  child: Container(


                    color: _videos[_currentVideoIndex] == index
                        ? Colors.red
                        : Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 3),
                    child: Row(
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:CachedNetworkImage(
                            imageUrl: _videos[index].thumbnailUrl,
                            height: 70,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                            const Center(child: Icon(Icons.broken_image, size: 40)),
                            errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.broken_image, size: 40)),
                          )

                        ),
                        const SizedBox(width: 10),


                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start, // Align to top vertically
                            crossAxisAlignment: CrossAxisAlignment.start, // Align to start horizontally (left)
                            children: [
                              Text(
                                  _videos[index].title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium),
                              SizedBox(height: 1,),
                              Text(
                             _videos[index].channelTitle,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      )



    );
  }
}
