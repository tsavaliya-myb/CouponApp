class LeaderboardUserModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final double metricValue;
  final int rank;

  LeaderboardUserModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.metricValue,
    required this.rank,
  });

  factory LeaderboardUserModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardUserModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      avatarUrl: json['avatarUrl'] as String?,
      metricValue: (json['metricValue'] as num).toDouble(),
      rank: json['rank'] as int,
    );
  }
}
