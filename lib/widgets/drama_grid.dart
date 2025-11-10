// import 'package:flutter/material.dart';
//
// import '../models/channel_drama.dart';
//
// import 'channel_drama_card.dart';
// class DramaGrid extends StatelessWidget {
//   final List<ChannelDrama> dramas;
//
//   const DramaGrid({required this.dramas, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverGrid(
//       delegate: SliverChildBuilderDelegate(
//             (context, index) {
//           final drama = dramas[index];
//           final imageUrl =
//               "https://www.paktvdramas.pk:3060/drama-thumbnails/${drama.thumbnailUrl.replaceAll('./assets/drama_thumbnails/', '')}";
//           return DramaCard(drama: drama, imageUrl: imageUrl);
//         },
//         childCount: dramas.length,
//       ),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         mainAxisSpacing: 10,
//         crossAxisSpacing: 10,
//         childAspectRatio: 0.6,
//       ),
//     );
//   }
// }