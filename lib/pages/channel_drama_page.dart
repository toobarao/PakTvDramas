import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/channel_drama.dart';
import '../models/channel_info.dart';
import '../providers/channel_drama_provider.dart';
import '../providers/drama_provider.dart';
import '../providers/network_provider.dart';
import '../screens/search_screen.dart';
import '../services/apiservice.dart';
import '../widgets/channel_drama_card.dart';
class ChannelDramaPage extends StatefulWidget {
  final Map<int, ChannelInfo> channelInfoMap;
  final int selectedChannelId;

  const ChannelDramaPage({
    super.key,
    required this.channelInfoMap,
    required this.selectedChannelId,
  });

  @override
  State<ChannelDramaPage> createState() => _ChannelDramaPageState();
}
class _ChannelDramaPageState extends State<ChannelDramaPage> {
  late List<ChannelInfo> allChannels;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    allChannels = widget.channelInfoMap.values.toList();
    selectedIndex = allChannels.indexWhere((c) => c.id == widget.selectedChannelId);
  }

  void _changeChannel(int offset) {
    setState(() {
      selectedIndex = (selectedIndex + offset) % allChannels.length;
      if (selectedIndex < 0) selectedIndex = allChannels.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {

    final networkProvider = context.watch<NetworkProvider>();
    final dramaProvider = context.watch<ChannelDramaProvider>();


    final selectedChannel = allChannels[selectedIndex];

    final List<ChannelDramaGroup>? dramas = dramaProvider.getDramasByChannel(selectedChannel.id);


    return Scaffold(
      body: SafeArea(
        child: networkProvider.noInternet
            ? const Center(child: Text("No Internet Connection"))
            : dramas == null
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 46,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/PakTvDramaLogo.png',
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => _changeChannel(-1),
                    ),
                    Text(
                      selectedChannel.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => _changeChannel(1),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(

                      (context, index) {
                    final drama = dramas[index];
                    final imageUrl = "https://www.paktvdramas.pk:3060/drama-thumbnails/${drama.thumbnail.replaceAll('./assets/drama_thumbnails/', '')}";
                    return DramaCard(

                    drama: drama,
                    imageUrl: imageUrl,
                    channelId: selectedChannel.id,
                    );
                  },
                  childCount: dramas.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  crossAxisCount: 3,
                  childAspectRatio: 0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
