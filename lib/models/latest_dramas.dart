class LatestDramas {
  final int dcId;
  final int id;
  final String thumbnail;
  final int channelId;
  final String name;

  LatestDramas({
    required this.dcId,
    required this.id,
    required this.thumbnail,
    required this.channelId,
    required this.name,
  });

  factory LatestDramas.fromJson(Map<String, dynamic> json) {
    return LatestDramas(
      dcId: json['dc_id'],
      id: json['id'],
      thumbnail: json['thumbnail'],
      channelId: json['channelId'],
      name: json['name'],
    );
  }

}