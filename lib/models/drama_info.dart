class DramaInfo{
  final String name;
  final String thumbnail;
  final String? description;
  final String director;
  final String producer;
  final String cast;
  final String keywords;
  final int channelId;
  final String dramaURL;
  final String channelName;
  final String dramaOnAir;
  final int likesCounts;
  final int dislikeCounts;

  DramaInfo({required this.name, required this.thumbnail,required  this.description,required  this.director,
    required this.producer, required this.cast,required  this.keywords,required  this.channelId, required this.dramaURL,
    required this.channelName, required this.dramaOnAir,required  this.likesCounts, required this.dislikeCounts});


  factory DramaInfo.fromJson(Map<String, dynamic> json) {
    return DramaInfo(name:json["name"], thumbnail:json['thumbnail'], description:json['description'], director:json["director"], producer:json["producer"], cast:json["cast"], keywords:json["keywords"], channelId:json["dramaChannelid"], dramaURL:json["dramaPlaylistURL"], channelName:json["channelName"], dramaOnAir:json["dramaOnAir"], likesCounts:json["likesCount"], dislikeCounts:json["dislikesCount"]);
  }
}