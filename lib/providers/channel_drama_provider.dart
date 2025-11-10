import 'package:flutter/foundation.dart';
import 'package:uielem/services/apiservice.dart';
import '../models/channel_info.dart';
import '../models/channel_drama.dart';


class ChannelDramaProvider with ChangeNotifier {
  Map<int, List<ChannelDramaGroup>> _channelDramas = {};
  bool _isLoaded = false;

  Map<int, List<ChannelDramaGroup>> get channelDramas => _channelDramas;
  bool get isLoaded => _isLoaded;

  Future<void> fetchChannelDramas() async {
    if (_isLoaded) return;

    try {
      _channelDramas = await ApiService.instance.fetchChannelsDramas();
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      print('Error fetching channel dramas: $e');
    }
  }

  List<ChannelDramaGroup>? getDramasByChannel(int channel) {


    return _channelDramas[channel];
  }
}
