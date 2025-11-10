import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../pages/drama_page.dart';
import '../utilities/triangle_clipper.dart';
class DramaRatingsCard extends StatefulWidget {
  final dynamic item;
  final int index;
  const DramaRatingsCard({required this.item,super.key, required this.index});

  @override
  State<DramaRatingsCard> createState() => _DramaRatingsCardState();
}

class _DramaRatingsCardState extends State<DramaRatingsCard> {
  late String imageUrl;

  @override
  void initState() {
    super.initState();

    // Construct the image URL once
    imageUrl = "https://www.paktvdramas.pk:3060/drama-thumbnails/${widget.item.thumbnail.replaceAll('./assets/drama_thumbnails/', '')}";

    // Preload the image into memory before it’s rendered

  }
  @override
  Widget build(BuildContext context) {
    precacheImage(NetworkImage(imageUrl), context);
    return Container(
      width: 120,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                  bottom: Radius.circular(16),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DramaPage(
                        dramaId: widget.item.dramaID,
                        channelId: widget.item.channelId,
                      ),
                    ));
                  },
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    Center(child: Image.asset("assets/images/placeholder.png")),
                    errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.broken_image, size: 40)),
                  ),
                ),
              ),

              // Top right red triangle with rating
              Positioned(
                top: 0,
                right: 0,
                child: ClipPath(
                  clipper: TriangleClipper(),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0, right: 4.0),
                      child: Text(
                        // '#${widget.index+1}',
                        '#${widget.item.ml_ratings.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom left drama name overlay
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  widget.item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}


class DramaRecommendationCard extends StatefulWidget {
  final dynamic item;
  const DramaRecommendationCard({required this.item,super.key});

  @override
  State<DramaRecommendationCard> createState() => _DramaRecommendationCardState();
}

class _DramaRecommendationCardState extends State<DramaRecommendationCard> {
  late String imageUrl;

  @override
  void initState() {
    super.initState();

    // Construct the image URL once
    imageUrl =
    "https://www.paktvdramas.pk:3060/drama-thumbnails/${widget.item.thumbnail
        .replaceAll('./assets/drama_thumbnails/', '')}";
  }
    @override
    Widget build(BuildContext context) {
      precacheImage(NetworkImage(imageUrl), context);
      return Container(
        width: 120,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                    bottom: Radius.circular(16),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DramaPage(
                          dramaId: widget.item.dramaID,
                          channelId: widget.item.channelId,
                        ),
                      ));
                    },
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 180,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                       Center(child: Image.asset("assets/images/placeholder.png")),
                      errorWidget: (context, url, error) =>
                       Center(child: Image.asset("assets/images/placeholder.png")),
                    ),
                  ),
                ),

                // Top right red triangle with rating
                Positioned(
                  top: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: TriangleClipper(),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.red,
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6.0, right: 4.0),
                        child: Text(
                          '#${widget.item.ratings}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom left drama name overlay
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Text(
                    widget.item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

  }


