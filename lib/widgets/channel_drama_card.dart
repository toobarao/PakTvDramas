import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/channel_drama.dart';
import '../pages/drama_page.dart';
class DramaCard extends StatelessWidget {
  final ChannelDramaGroup drama;
  final String imageUrl;
  final int channelId;

  const DramaCard({required this.drama, required this.imageUrl, super.key, required this.channelId});
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

                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DramaPage(dramaId: drama.dramas[0].id, channelId: channelId)));
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

              // Bottom left drama name overlay
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  drama.dramas[0].name,
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


