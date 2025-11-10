import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uielem/pages/player_page.dart';
import '../models/latest_dramas.dart';
import '../models/recommendations.dart';
import '../models/tv_rating.dart';
import '../models/watch_history_item.dart';
import '../providers/drama_provider.dart';
import '../utilities/videos_fetch_helper.dart';
import '../widgets/date_text.dart';
import '../widgets/drama_list.dart';
import '../widgets/drama_rating_card.dart';
import '../widgets/latest_drama_card.dart';
import '../widgets/section_title.dart';
import 'drama_page.dart';
import 'package:shimmer/shimmer.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   User? user = FirebaseAuth.instance.currentUser;
  late Future<List<WatchHistoryItem>> _watchHistoryFuture;

  Future<List<WatchHistoryItem>> getWatchHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('watchhistory')
        .orderBy('watchedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => WatchHistoryItem.fromJson(doc.data()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
  _watchHistoryFuture = getWatchHistory();
  }
   CarouselSliderController buttonCarouselController = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    final dramas = Provider.of<DramaProvider>(context).dramas;

    if (dramas == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return
      StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
    final user = snapshot.data;
    return CustomScrollView(
    slivers: [
        // CarouselSlider
        SliverToBoxAdapter(
          child:
          Stack(
            children: [
              CarouselSlider(
                carouselController: buttonCarouselController,

                options: CarouselOptions(
                  height: 250,
                  // autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  initialPage: 1,
                ),
                items: dramas!.latestDramas.map((drama) {
                  return GestureDetector(
                    onTap: () {
                      // Your action
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: "https://www.paktvdramas.pk:3060/drama-thumbnails/${drama.thumbnail.replaceAll('./assets/drama_thumbnails/', '')}",
                            fit: BoxFit.cover,
                        placeholder: (context, url) =>  Center(child: Image.asset("assets/images/placeholder.png")),
                        errorWidget: (context, url, error) => Center(child:Image.asset("assets/images/placeholder.png"))

                          ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
              //crossAxisAlignment: CrossAxisAlignment.center,
                         // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              drama.name.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DramaPage(dramaId:drama.id,channelId:drama.channelId)));
                              },
                              child: const Text(
                                'WATCH NOW',
                                style: TextStyle(color: Colors.white,fontWeight:FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                      ),



                    ),
                  ])));
                }).toList(),
              ),
              Positioned(
                top:100,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    buttonCarouselController.previousPage( duration: const Duration(milliseconds: 300),
                      curve: Curves.linear,);
                  },
                ),
              ),

              // Right arrow
              Positioned(
                top:100,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () {
                    buttonCarouselController.nextPage( duration: const Duration(milliseconds: 300),
                      curve: Curves.linear,);
                  },
                ),
              ),
              // ElevatedButton(
              //   onPressed: () => buttonCarouselController.nextPage(
              //       duration: Duration(milliseconds: 300), curve: Curves.linear),
              //   child: Text('→'),
              // )
            ],
          ),

        ),

        // Section Title with GestureDetector
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SectionTitle(first: "Latest ", second: "Dramas", isRedSecond: true),

            ],
          ),
        ),

        // DramaList Widget
        SliverToBoxAdapter(
          child: DramaList<LatestDramas>(
            items: dramas!.latestDramas ?? [],
            itemBuilder: (drama) => LatestDramaCard(item: drama),
          ),
        ),
      if (user != null)
        SliverToBoxAdapter(
          child: FutureBuilder<List<WatchHistoryItem>>(
            future: getWatchHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SectionTitle(
                          first: "Continue ",
                          second: "Watching",
                          isRedSecond: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (_, __) => _buildShimmerCard(),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error fetching watch history'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('No Watch History available.'),
                );
              }

              final watchHistory = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionTitle(
                        first: "Continue ",
                        second: "Watching",
                        isRedSecond: true,
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: watchHistory.length,
                      itemBuilder: (context, index) {
                        final item = watchHistory[index];

                        final progressPercent = (item.timeWatched / item.totalDuration).clamp(0.0, 1.0);
                        return GestureDetector(
                          onTap: () async {
                            try {
                              final videos = await VideosFetchHelper().extractVideoIds(item.dramaUrl);

                              if (videos == null || videos.isEmpty) {
                                print("No videos found for URL: ${item.dramaUrl}");
                                return;
                              }

                              print("Navigating to PlayerPage with videos: $videos");
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (_, __, ___) => PlayerPage(
                                    videoId: item.videoId, // fallback
                                    title: item.title ?? 'Untitled',
                                    thumbnailUrl: item.thumbnailUrl ?? '',
                                    videos: videos,
                                    dramaUrl: item.dramaUrl ?? '',
                                    timeWatched: item.timeWatched ?? 0,
                                  ),
                                  transitionsBuilder: (_, anim, __, child) {
                                    return FadeTransition(opacity: anim, child: child);
                                  },
                                ),
                              );

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => PlayerPage(
                              //       videoId: item.videoId, // fallback
                              //       title: item.title ?? 'Untitled',
                              //       thumbnailUrl: item.thumbnailUrl ?? '',
                              //       videos: videos,
                              //       dramaUrl: item.dramaUrl ?? '',
                              //       timeWatched: item.timeWatched ?? 0,
                              //     ),
                              //   ),
                              // );
                            } catch (e, stack) {
                              print("Error on watch history tap: $e");
                              print(stack);
                            }
                          },
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl:item.thumbnailUrl,
                                        height: 100,
                                        width: 150,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                        const Center(child: Icon(Icons.broken_image, size: 40)),
                                        errorWidget: (context, url, error) =>
                                        const Center(child: Icon(Icons.broken_image, size: 40)),
                                      )



                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 4,
                                        color: Colors.black.withOpacity(0.3),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: progressPercent, // e.g. 0.6 for 60%
                                          child: Container(
                                            height: 4,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                // Drama title
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),


        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(first: "Trending ", second: "TOP 10 on TV", isRedSecond: true),
                  DateText(),
                ],
              ),

            ],
          ),
        ),

        // DramaList Widget for Trending TV Ratings
      SliverToBoxAdapter(
        child: DramaList<TvRating>(
          items: dramas!.tvRatings ?? [],
          itemBuilder: (drama) => DramaRatingsCard(item: drama, index:0),
        ),
      ),


      SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                      first: "Trending ",
                      second: "TOP 10 on YouTube",
                      isRedSecond: true),
                  DateText(),
                ],
              ),

            ],
          ),
        ),

        SliverToBoxAdapter(child:DramaList<TvRating>(
          items: dramas!.socialRatings ?? [],
          itemBuilder: (drama) => DramaRatingsCard(item: drama,index:0),
        )),

        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                      first: "Your ",
                      second: "Recommendations",
                      isRedSecond: true),
                  DateText(),
                ],
              ),

            ],
          ),
        ),

        SliverToBoxAdapter(child:DramaList<Recommendations>(
          items: dramas!.yourRecommendations ?? [],
          itemBuilder: (drama) => DramaRecommendationCard(item: drama),
        )),
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                      first: "Our ",
                      second: "Recommendations",
                      isRedSecond: true),
                  DateText(),
                ],
              ),

            ],
          ),
        ),

        SliverToBoxAdapter(child:DramaList<Recommendations>(
          items: dramas!.ourRecommendations ?? [],
          itemBuilder: (drama) => DramaRecommendationCard(item: drama),
        )),

      ]);
        });

  }
  Widget _buildShimmerCard() {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              height: 100,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              height: 12,
              width: 130,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              height: 12,
              width: 90,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

}
