import 'package:flutter/material.dart';

import '../models/channel_info.dart';
import '../models/drama_response.dart';
class ChannelSelector extends StatelessWidget {
  final List<ChannelInfo?> channels;
  final ChannelInfo? selectedChannel;
  final ValueChanged<ChannelInfo?> onChannelSelected;

  const ChannelSelector({
    required this.channels,
    required this.selectedChannel,
    required this.onChannelSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index];
          final isSelected = selectedChannel == channel;

          return GestureDetector(
            onTap: () => onChannelSelected(channel),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red.withAlpha(80) : null,
                border: isSelected ? Border.all(color: Colors.red) : null,
                borderRadius: isSelected ? BorderRadius.circular(17) : null,
              ),
              child: Center(
                child: Text(
                  channel?.name ?? "All Channel Dramas",
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected ? Colors.red : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
