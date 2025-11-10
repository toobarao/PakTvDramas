class ChannelInfo {
  final int id;
  final String name;
  final String iconUrl;
  final String bannerUrl;

  ChannelInfo({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.bannerUrl,
  });

  factory ChannelInfo.fromJson(Map<String, dynamic> json) {
    return ChannelInfo(
      id: json['id'],
      name: json['Name'],
      iconUrl: json['IconURL'],
      bannerUrl: json['BannerURL'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'IconURL':iconUrl,
      'BannerURL':bannerUrl
    };
  }
}