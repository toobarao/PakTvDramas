import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../pages/drama_page.dart';
class LatestDramaCard extends StatefulWidget {
  final dynamic item;
  const LatestDramaCard({required this.item,super.key});

  @override
  State<LatestDramaCard> createState() => _LatestDramaCardState();
}

class _LatestDramaCardState extends State<LatestDramaCard> {
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
    return
      Container(
         width: 120,

        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child:
      Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [


              Container(
                width: 120,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16),bottom: Radius.circular(16) ),

                  child:


                  GestureDetector(
                    onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DramaPage(dramaId:widget.item.id,channelId:widget.item.channelId)));

                    },
                    child:

                    Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background image with blur
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(imageUrl),
                                  //fit:BoxFit.fitHeight
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Centered image
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:  CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              height: 80,
                              fit:BoxFit.fitWidth,
                              placeholder: (context, url) =>  Center(child: Image.asset("assets/images/placeholder.png")),
                              errorWidget: (context, url, error) =>  Center(child: Image.asset("assets/images/placeholder.png")),
                            ),


                          ),
                        ),
                      ],
                    ),


                  ),
                ),
              ),


            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  textAlign: TextAlign.center,
                  widget.item.name,
                  style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(overflow: TextOverflow.ellipsis,
                    // Prevents text overflow
    ),maxLines: 2,


                ),
              ),
            ),
          ],
        ),

    );
  }
}
