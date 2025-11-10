
class Recommendations{
  final String name;
  final String thumbnail;
  final int ratings;
  final String rank_date;
  final int dramaID;
  final int channelId;


  Recommendations({required this.name, required this.thumbnail,required  this.ratings, required this.rank_date,
    required this.dramaID,required  this.channelId});



  factory Recommendations.fromJson(Map<String, dynamic> json) {
    return Recommendations(
      name: json['name'],
      thumbnail: json['thumbnail'],
      ratings: json['ratings'],
      rank_date: json['rank_date'],
      dramaID:json['dramaID'],
      channelId: json['channelId'],
    );
  }
}