class FeedbackModel {
  final String kesan;
  final String saran;
  final int rating;
  final String mood;
  final DateTime createdAt;

  FeedbackModel({
    required this.kesan,
    required this.saran,
    required this.rating,
    required this.mood,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'kesan': kesan,
      'saran': saran,
      'rating': rating,
      'mood': mood,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static FeedbackModel fromMap(Map map) {
    return FeedbackModel(
      kesan: map['kesan'],
      saran: map['saran'],
      rating: map['rating'],
      mood: map['mood'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}