import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import '../models/event.dart';
import '../models/news.dart';

class LocalDb {
  static Future<File> _file() async {
    final dir = Directory.current;
    return File(p.join(dir.path, 'mock_db.json'));
  }

  static Future<({List<Event> events, List<News> news})> read() async {
    final f = await _file();
    if (!await f.exists()) return (events: <Event>[], news: <News>[]);
    final json = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
    final events =
        (json['events'] as List<dynamic>? ?? [])
            .map((e) => Event.fromJson(e as Map<String, dynamic>))
            .toList();
    final news =
        (json['news'] as List<dynamic>? ?? [])
            .map((n) => News.fromJson(n as Map<String, dynamic>))
            .toList();
    return (events: events, news: news);
  }

  static Future<void> write(List<Event> events, List<News> news) async {
    final f = await _file();
    final json = jsonEncode({
      'events': events.map((e) => e.toJson()).toList(),
      'news': news.map((n) => n.toJson()).toList(),
    });
    await f.writeAsString(json, flush: true);
  }
}
