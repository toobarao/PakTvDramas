// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/drama_info.dart';
import '../models/drama_response.dart';
import '../models/video.dart';
import '../models/watch_history_item.dart';
import '../utilities/video_controller_helper.dart';
class DramasBottomSheet extends StatefulWidget {
  final DramaInfo drama;
  final List<Video> videos;
  final int currentIndex;
  final Function(int index) onVideoSelected;

  const DramasBottomSheet({
    required this.videos,
    required this.currentIndex,
    required this.onVideoSelected,
    Key? key, required this.drama,
  }) : super(key: key);

  @override
  State<DramasBottomSheet> createState() => _DramasBottomSheetState();
}

class _DramasBottomSheetState extends State<DramasBottomSheet> {
  late VideoControllerHelper _videoHelper;
  late WatchHistoryItem watchHistoryItem;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoHelper = VideoControllerHelper();
  }
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(

            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20), // Rounded top corners
            ),
          ),
          padding: const EdgeInsets.only(top: 12), // Top padding
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.drama.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(), // Close sheet
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),


              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: widget.videos.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {


                        widget.onVideoSelected(index); // Notify DetailPage to update the video
                        // Navigator.pop(context);
                        // Navigator.of(context).pop();


                      },


                      child: Container(
                        color: widget.currentIndex == index
                            ? Colors.red
                            : Theme.of(context).scaffoldBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          children: [

                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  "https://www.paktvdramas.pk:3060/drama-thumbnails/${widget.drama.thumbnail.replaceAll('./assets/drama_thumbnails/', '')}",
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // 🔺 Title Text
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start, // Align to top vertically
                                crossAxisAlignment: CrossAxisAlignment.start, // Align to start horizontally (left)
                                children: [
                                  Text(
                                      widget.videos[index].title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyMedium),
                                  SizedBox(height: 1,),
                                  Text(
                                    widget.drama.channelName,
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
              ),
            ],
          ),
        );
      },
    );
  }
}

