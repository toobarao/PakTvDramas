class ChannelDramaGroup {
  final String thumbnail;
  final List<Drama> dramas;

  ChannelDramaGroup({
    required this.thumbnail,
    required this.dramas,
  });

  factory ChannelDramaGroup.fromJson(Map<String, dynamic> json) {
    return ChannelDramaGroup(
      thumbnail: json['thumbnail'] as String,
      dramas: (json['Dramas'] as List<dynamic>)
          .map((e) => Drama.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
      'Dramas': dramas.map((d) => d.toJson()).toList(),
    };
  }
}

class Drama {
  final int id;
  final String name;

  Drama({
    required this.id,
    required this.name,
  });

  factory Drama.fromJson(Map<String, dynamic> json) {
    return Drama(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
