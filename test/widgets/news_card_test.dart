/// 06 – NewsCard surface test
///
/// Similar to EventCard test but ensures NewsCard can render in isolation
/// WITHOUT a ProviderScope (popup menu disabled automatically).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec_center_interview/models/news.dart';
import 'package:rec_center_interview/widgets/news_card.dart';

void main() {
  testWidgets('NewsCard shows title and category', (tester) async {
    final news = News(
      id: 'n1',
      title: 'Platform Update',
      description: 'We launched feature',
      date: DateTime.now(),
      category: 'Update',
      imageUrl: '',
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: NewsCard(news: news))),
    );

    expect(find.text('Platform Update'), findsOneWidget);
    expect(find.text('Update'), findsOneWidget);
  });
}
