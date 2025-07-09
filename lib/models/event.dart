class Event {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final String imageUrl;
  final String level;
  final int capacity;
  final List<String> attendees;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.level,
    required this.capacity,
    this.attendees = const [],
  });

  bool get isFull => attendees.length >= capacity;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json['id'] as String,
    title: json['title'] as String,
    date: DateTime.parse(json['date'] as String),
    location: json['location'] as String,
    imageUrl: json['imageUrl'] as String,
    level: json['level'] as String,
    capacity: json['capacity'] as int,
    attendees: (json['attendees'] as List<dynamic>? ?? []).cast<String>(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date.toIso8601String(),
    'location': location,
    'imageUrl': imageUrl,
    'level': level,
    'capacity': capacity,
    'attendees': attendees,
  };

  Event copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? location,
    String? imageUrl,
    String? level,
    int? capacity,
    List<String>? attendees,
  }) => Event(
    id: id ?? this.id,
    title: title ?? this.title,
    date: date ?? this.date,
    location: location ?? this.location,
    imageUrl: imageUrl ?? this.imageUrl,
    level: level ?? this.level,
    capacity: capacity ?? this.capacity,
    attendees: attendees ?? this.attendees,
  );
}
