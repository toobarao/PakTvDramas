class SearchHistoryItem {
  final String keyword;
  final DateTime searchedAt;

  SearchHistoryItem({required this.keyword, required this.searchedAt});

  Map<String, dynamic> toJson() =>
      {
        'keyword': keyword,
        'searchedAt': searchedAt.toIso8601String(),
      };

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      keyword: json['keyword'],
      searchedAt: DateTime.parse(json['searchedAt']),
    );
  }
}