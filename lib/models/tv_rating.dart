class TvRating{
  final String name;
  final String thumbnail;
  double? ml_ratings;
  final String rank_date;
  final int dramaID;
  final int channelId;

  TvRating({required this.name, required this.thumbnail, this.ml_ratings,required  this.rank_date,
    required  this.dramaID,required  this.channelId});
  factory TvRating.fromJson(Map<String, dynamic> json) {
    return TvRating(
      name: json['name'],
      thumbnail: json['thumbnail'],
      ml_ratings: ((json['ml_ratings'] ?? json['ratings']) as num).toDouble(),
      rank_date: json['rank_date'],
      dramaID:json['dramaID'],
      channelId: json['channelId'],
    );
  }
}