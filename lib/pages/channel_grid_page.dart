import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uielem/pages/channel_drama_page.dart';
import 'package:uielem/services/apiservice.dart';
import '../models/channel_info.dart';
import '../providers/drama_provider.dart';
import '../providers/network_provider.dart';
import 'no_internet_page.dart';

class ChannelGridPage extends StatefulWidget {
  const ChannelGridPage({super.key});

  @override
  State<ChannelGridPage> createState() => _ChannelGridPageState();
}

class _ChannelGridPageState extends State<ChannelGridPage> {
  DateTime? lastBackPressed;
  Map<int, ChannelInfo>? _channelMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var channelMap =await ApiService.instance.loadChannelInfo();
      setState(() {
        _channelMap= channelMap;
      });
    });


  }
  Future<bool> _handleBackPress() async {
    final now = DateTime.now();
    if (lastBackPressed == null || now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
     final dramaProvider = Provider.of<DramaProvider>(context);
    // final grouped = dramaProvider.channelDramas;
    final networkProvider = context.watch<NetworkProvider>();

    return   WillPopScope(
     onWillPop: () async {
      final now = DateTime.now();
      if (lastBackPressed == null ||
          now.difference(lastBackPressed!) > Duration(seconds: 2)) {
        lastBackPressed = now;

        Fluttertoast.showToast(
          msg: "Press back again to exit",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        return false; // block the pop
      }
      return true; // allow the pop (exit app)
    },
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('TV Rating'),
        //   centerTitle: true,
        // ),
        body: networkProvider.noInternet
            ? NoInternetPage(
          onRetry: () => null
              //dramaProvider.fetchChannelDramas(forceRefresh: true),
        )
            : _channelMap == null
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Text(
                  "Browse Channels",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _channelMap!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final channel = _channelMap!.values.elementAt(index);
                  print(channel);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: GestureDetector(
                      onTap: ()async {

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChannelDramaPage(
                              channelInfoMap:_channelMap! , // load from asset
                          selectedChannelId: channel.id,
                        ),
                        ));


                      },
                      child: Image.asset(
                        "assets/images/PakTvDramaAppDesign/${channel.name}.png",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child:Center(child:Image.asset("assets/images/placeholder.png")),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
