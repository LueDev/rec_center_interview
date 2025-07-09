class News {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String category;
  final String imageUrl;
  final String? eventId;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.imageUrl,
    this.eventId,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    date: DateTime.parse(json['date'] as String),
    category: json['category'] as String,
    imageUrl: json['imageUrl'] as String,
    eventId: json['eventId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'category': category,
    'imageUrl': imageUrl,
    'eventId': eventId,
  };

  News copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? category,
    String? imageUrl,
    String? eventId,
  }) => News(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    date: date ?? this.date,
    category: category ?? this.category,
    imageUrl: imageUrl ?? this.imageUrl,
    eventId: eventId ?? this.eventId,
  );
}
