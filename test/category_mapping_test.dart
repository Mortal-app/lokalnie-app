import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalnie_widzew/models/announcement.dart';
import 'package:lokalnie_widzew/models/home_feed_category.dart';

Announcement _item({
  required String title,
  required String category,
}) {
  return Announcement(
    title: title,
    category: category,
    subDistrict: 'Twoja okolica',
    time: 'Teraz',
    icon: Icons.campaign,
    publishedAt: DateTime(2026, 10, 13),
    description: title,
  );
}

void main() {
  test('form categories include Inne and a single Zwierzaki entry', () {
    expect(Announcement.formCategories, contains(Announcement.otherCategory));
    expect(Announcement.otherCategory, 'Inne');
    expect(
      Announcement.formCategories.where((item) => item == Announcement.petCategory),
      hasLength(1),
    );
  });

  test('canonicalizeCategory maps unknown and alert aliases', () {
    expect(Announcement.canonicalizeCategory('Inne'), Announcement.otherCategory);
    expect(Announcement.canonicalizeCategory(''), Announcement.otherCategory);
    expect(Announcement.canonicalizeCategory('Coś nowego'), Announcement.otherCategory);
    expect(
      Announcement.canonicalizeCategory('Uwaga/Ostrzeżenie'),
      Announcement.alertCategory,
    );
  });

  test('home tile Inne is the catch-all category', () {
    expect(HomeFeedCategory.wiecej.tileId, 'Inne');
    expect(HomeFeedCategory.wiecej.title, 'Inne');
    expect(HomeFeedCategory.resolve('Inne')?.id, 'wiecej');
    expect(HomeFeedCategory.resolve('Więcej')?.id, 'wiecej');

    final other = _item(title: 'Oddam doniczkę', category: 'Inne');
    expect(HomeFeedCategory.wiecej.matchesAnnouncement(other), isTrue);
    expect(HomeFeedCategory.fachowcy.matchesAnnouncement(other), isFalse);

    final plumber = _item(title: 'Hydraulik', category: 'Fachowcy');
    expect(HomeFeedCategory.fachowcy.matchesAnnouncement(plumber), isTrue);
    expect(HomeFeedCategory.wiecej.matchesAnnouncement(plumber), isFalse);
  });
}
