
import '../models/drama_info.dart';
import '../models/drama_response.dart';
import '../models/video.dart';
import '../services/apiservice.dart';

class VideosFetchHelper {
  Future<DramaInfo?> fetchDramaDetails(int dramaId, int channelId) async {
    return await ApiService.instance.fetchDramaDetails(dramaId, channelId);
  }

  Future<List<Video>> extractVideoIds(String url) async {
    Uri uri = Uri.parse(url);
    final playlistId = uri.queryParameters['list'] ?? '';
    return await ApiService.instance.fetchPlayList(playlistId);
  }
}
