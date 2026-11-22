import 'package:flutter/material.dart';

import 'borrow_terms.dart';

enum AnnouncementStatus { current, resolved }

extension AnnouncementStatusLabel on AnnouncementStatus {
  String get label => switch (this) {
    AnnouncementStatus.current => 'Aktualne',
    AnnouncementStatus.resolved => 'Zakończone',
  };
}

class AnnouncementComment {
  final String authorName;
  final String text;

  const AnnouncementComment({required this.authorName, required this.text});

  Map<String, Object?> toJson() => {'authorName': authorName, 'text': text};

  factory AnnouncementComment.fromJson(Object? json) {
    if (json is String) {
      return AnnouncementComment(authorName: 'Sąsiad', text: json);
    }
    final map = Map<String, dynamic>.from(json as Map);
    return AnnouncementComment(
      authorName: map['authorName'] as String? ?? 'Sąsiad',
      text: map['text'] as String? ?? '',
    );
  }
}

class Announcement {
  static const petCategory = 'Zwierzaki';
  static const wildlifeCategory = 'Dziki / Zwierzęta w mieście';
  static const alertCategory = 'Alerty / awarie';
  static const helpCategory = 'Potrzebuję pomocy / Zaoferuj pomoc';
  static const lendingCategory = 'Wypożyczalnia / Dzielenie się';
  static const otherCategory = 'Inne';
  static const formCategories = [
    'Fachowcy',
    'Złota Rączka',
    'Remont',
    'Jednorazowe zlecenia',
    petCategory,
    'Zgubione / znalezione',
    'Oddam/Kupię',
    'Jedzenie',
    'Sąsiedzi',
    'Wydarzenia',
    helpCategory,
    lendingCategory,
    alertCategory,
    otherCategory,
  ];
  static const subDistricts = [
    'Twoja okolica',
  ];

  static String canonicalizeCategory(String category) {
    final trimmed = category.trim();
    if (trimmed.isEmpty) return otherCategory;
    if (formCategories.contains(trimmed)) return trimmed;
    final lower = trimmed.toLowerCase();
    if (lower == 'zwierzaki / zgubione' ||
        lower.contains('zgubion') ||
        lower.contains('znalezion')) {
      return 'Zgubione / znalezione';
    }
    if (lower == wildlifeCategory.toLowerCase() ||
        lower == 'dzikie zwierzęta') {
      return petCategory;
    }
    if (lower.contains('uwaga') || lower.contains('ostrze')) {
      return alertCategory;
    }
    final first = trimmed.split(' / ').first.trim();
    if (formCategories.contains(first)) return first;
    return otherCategory;
  }

  final String title;
  final String category;
  final String subDistrict;
  final String time;
  final IconData icon;
  final String description;
  final DateTime publishedAt;
  final String id;
  final String authorUid;
  final bool isFavorite;
  final int likesCount;
  final bool isLiked;
  final AnnouncementStatus status;
  final List<AnnouncementComment> comments;
  final bool isMine;
  final String authorName;
  final String? imageUrl;
  final String? imagePath;
  final String? imageBase64;
  final int viewsCount;
  final String? price;
  final BorrowTerms? borrowTerms;
  final int supportCount;
  final bool isSupported;
  final bool pendingSync;
  final double? latitude;
  final double? longitude;
  final Map<String, int> reactions;
  final String myReaction;
  final DateTime? resolvedAt;
  final bool contentFlagged;

  static const reactionEmojis = ['👍', '❤️', '🤝'];

  bool get hasImage {
    final encoded = imageBase64;
    final url = imageUrl;
    final path = imagePath;
    return (encoded != null && encoded.isNotEmpty) ||
        (url != null && url.isNotEmpty) ||
        (path != null && path.isNotEmpty);
  }

  String get displayCategory => canonicalizeCategory(category);

  bool get isAlert {
    final normalizedCategory = category.toLowerCase();
    return normalizedCategory == wildlifeCategory.toLowerCase() ||
        normalizedCategory == alertCategory.toLowerCase() ||
        normalizedCategory.contains('uwaga') ||
        normalizedCategory.contains('ostrze');
  }

  bool get isHelp {
    return category == helpCategory ||
        category.toLowerCase().contains('pomoc') ||
        category.toLowerCase().contains('wolont');
  }

  bool get isLending {
    return category == lendingCategory ||
        category.toLowerCase().contains('wypożycz') ||
        category.toLowerCase().contains('dzielen');
  }

  bool get isFree {
    if (borrowTerms == BorrowTerms.free) return true;
    final normalizedPrice = (price ?? '').trim().toLowerCase();
    if (normalizedPrice == '0' ||
        normalizedPrice == '0zł' ||
        normalizedPrice == '0 zł' ||
        normalizedPrice == 'darmo') {
      return true;
    }
    final haystack = '$title $description $normalizedPrice'.toLowerCase();
    return haystack.contains('za darmo') || haystack.contains('0 zł');
  }

  bool get isLostFound {
    final haystack = '$category $title $description'.toLowerCase();
    return haystack.contains('zgub') || haystack.contains('znalaz');
  }

  String? get accentLabel {
    if (isAlert) return 'Alerty / Awarie';
    if (isHelp) return 'Pomoc sąsiedzka';
    if (isLostFound) return 'Zgubiono / Znaleziono';
    if (isFree) return 'Oddam za darmo';
    return null;
  }

  Color get accentColor {
    if (isAlert) return const Color(0xFFD32F2F);
    if (isHelp) return const Color(0xFF1565C0);
    if (isLostFound) return const Color(0xFFEF6C00);
    if (isFree) return const Color(0xFF2E7D32);
    return const Color(0xFF616161);
  }

  Color get accentFill {
    if (isAlert) return const Color(0xFFFFEBEE);
    if (isHelp) return const Color(0xFFE3F2FD);
    if (isLostFound) return const Color(0xFFFFF3E0);
    if (isFree) return const Color(0xFFE8F5E9);
    return const Color(0xFFEEEEEE);
  }

  const Announcement({
    required this.title,
    required this.category,
    required this.subDistrict,
    required this.time,
    required this.icon,
    required this.publishedAt,
    this.id = '',
    this.authorUid = '',
    this.description = '',
    this.isFavorite = false,
    this.likesCount = 0,
    this.isLiked = false,
    this.status = AnnouncementStatus.current,
    this.comments = const [],
    this.isMine = false,
    this.authorName = 'Sąsiad',
    this.imageUrl,
    this.imagePath,
    this.imageBase64,
    this.viewsCount = 0,
    this.price,
    this.borrowTerms,
    this.supportCount = 0,
    this.isSupported = false,
    this.pendingSync = false,
    this.latitude,
    this.longitude,
    this.reactions = const {},
    this.myReaction = '',
    this.resolvedAt,
    this.contentFlagged = false,
  });

  String get heroTag =>
      'announcement-hero-${id.isNotEmpty ? id : publishedAt.microsecondsSinceEpoch}';

  bool sameAs(Announcement other) {
    if (id.isNotEmpty && other.id.isNotEmpty) return id == other.id;
    return publishedAt == other.publishedAt;
  }

  Announcement copyWith({
    String? title,
    String? category,
    String? subDistrict,
    IconData? icon,
    String? description,
    bool? isFavorite,
    int? likesCount,
    bool? isLiked,
    AnnouncementStatus? status,
    List<AnnouncementComment>? comments,
    bool? isMine,
    String? authorName,
    String? imageUrl,
    String? imagePath,
    String? imageBase64,
    bool clearImageMedia = false,
    int? viewsCount,
    String? price,
    BorrowTerms? borrowTerms,
    int? supportCount,
    bool? isSupported,
    bool? pendingSync,
    double? latitude,
    double? longitude,
    Map<String, int>? reactions,
    String? myReaction,
    DateTime? resolvedAt,
    bool clearResolvedAt = false,
    bool? contentFlagged,
    String? id,
    String? authorUid,
  }) {
    return Announcement(
      title: title ?? this.title,
      category: category ?? this.category,
      subDistrict: subDistrict ?? this.subDistrict,
      time: time,
      icon: icon ?? this.icon,
      publishedAt: publishedAt,
      id: id ?? this.id,
      authorUid: authorUid ?? this.authorUid,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      isMine: isMine ?? this.isMine,
      authorName: authorName ?? this.authorName,
      imageUrl: clearImageMedia ? null : (imageUrl ?? this.imageUrl),
      imagePath: clearImageMedia ? null : (imagePath ?? this.imagePath),
      imageBase64: clearImageMedia ? null : (imageBase64 ?? this.imageBase64),
      viewsCount: viewsCount ?? this.viewsCount,
      price: price ?? this.price,
      borrowTerms: borrowTerms ?? this.borrowTerms,
      supportCount: supportCount ?? this.supportCount,
      isSupported: isSupported ?? this.isSupported,
      pendingSync: pendingSync ?? this.pendingSync,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reactions: reactions ?? this.reactions,
      myReaction: myReaction ?? this.myReaction,
      resolvedAt: clearResolvedAt ? null : (resolvedAt ?? this.resolvedAt),
      contentFlagged: contentFlagged ?? this.contentFlagged,
    );
  }

  Announcement withReaction(String emoji) {
    final next = Map<String, int>.from(reactions);
    var selected = myReaction;
    if (selected == emoji) {
      final count = (next[emoji] ?? 1) - 1;
      if (count <= 0) {
        next.remove(emoji);
      } else {
        next[emoji] = count;
      }
      selected = '';
    } else {
      if (selected.isNotEmpty) {
        final previous = (next[selected] ?? 1) - 1;
        if (previous <= 0) {
          next.remove(selected);
        } else {
          next[selected] = previous;
        }
      }
      next[emoji] = (next[emoji] ?? 0) + 1;
      selected = emoji;
    }
    return copyWith(reactions: next, myReaction: selected);
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'authorUid': authorUid,
    'title': title,
    'category': category,
    'subDistrict': subDistrict,
    'time': time,
    'icon': _iconName,
    'description': description,
    'publishedAt': publishedAt.toIso8601String(),
    'isFavorite': isFavorite,
    'likesCount': likesCount,
    'isLiked': isLiked,
    'status': status.name,
    'comments': comments.map((comment) => comment.toJson()).toList(),
    'isMine': isMine,
    'authorName': authorName,
    'imageUrl': imageUrl,
    'imagePath': imagePath,
    'imageBase64': imageBase64,
    'viewsCount': viewsCount,
    'price': price,
    'borrowTerms': borrowTerms?.name,
    'supportCount': supportCount,
    'isSupported': isSupported,
    'pendingSync': pendingSync,
    'latitude': latitude,
    'longitude': longitude,
    'reactions': reactions,
    'myReaction': myReaction,
    'resolvedAt': resolvedAt?.toIso8601String(),
    'contentFlagged': contentFlagged,
  };

  factory Announcement.fromJson(Map<String, dynamic> json) {
    final status = json['status'] == AnnouncementStatus.resolved.name
        ? AnnouncementStatus.resolved
        : AnnouncementStatus.current;
    final publishedAt = DateTime.tryParse(json['publishedAt'] as String? ?? '');
    return Announcement(
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'Sąsiedzi',
      subDistrict:
          json['subDistrict'] as String? ?? Announcement.subDistricts.first,
      time: json['time'] as String? ?? '',
      icon: switch (json['icon']) {
        'warning' => Icons.warning_amber_rounded,
        'build' => Icons.build,
        'search' => Icons.search,
        'gift' => Icons.card_giftcard,
        'sos' => Icons.warning_amber_rounded,
        'handyman' => Icons.handyman_outlined,
        _ => Icons.campaign,
      },
      description: json['description'] as String? ?? '',
      publishedAt: publishedAt ?? DateTime.now(),
      id: json['id'] as String? ?? '',
      authorUid: json['authorUid'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      likesCount: json['likesCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      status: status,
      comments: (json['comments'] as List<dynamic>? ?? const [])
          .map(AnnouncementComment.fromJson)
          .toList(),
      isMine: json['isMine'] as bool? ?? false,
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      imageUrl: _httpImageUrl(json['imageUrl'] as String?),
      imagePath: json['imagePath'] as String?,
      imageBase64: _readImageBase64(json),
      viewsCount: json['viewsCount'] as int? ?? 0,
      price: json['price'] as String?,
      borrowTerms: BorrowTermsX.fromStorage(json['borrowTerms'] as String?),
      supportCount: json['supportCount'] as int? ?? 0,
      isSupported: json['isSupported'] as bool? ?? false,
      pendingSync: json['pendingSync'] as bool? ?? false,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      reactions: {
        for (final entry
            in (json['reactions'] is Map
                    ? Map<Object?, Object?>.from(json['reactions'] as Map)
                    : const <Object?, Object?>{})
                .entries)
          '${entry.key}': (entry.value as num?)?.toInt() ?? 0,
      },
      myReaction: json['myReaction'] as String? ?? '',
      resolvedAt: DateTime.tryParse(json['resolvedAt'] as String? ?? ''),
      contentFlagged: json['contentFlagged'] as bool? ?? false,
    );
  }

  String get _iconName {
    if (icon.codePoint == Icons.warning_amber_rounded.codePoint) {
      return 'warning';
    }
    if (icon.codePoint == Icons.build.codePoint) return 'build';
    if (icon.codePoint == Icons.search.codePoint) return 'search';
    if (icon.codePoint == Icons.card_giftcard.codePoint) return 'gift';
    if (icon.codePoint == Icons.handyman_outlined.codePoint) return 'handyman';
    return 'campaign';
  }

  static String? _httpImageUrl(String? value) {
    final url = value?.trim() ?? '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return null;
  }

  static String? _readImageBase64(Map<String, dynamic> json) {
    final encoded = (json['imageBase64'] as String?)?.trim() ?? '';
    if (encoded.isNotEmpty) return encoded;
    final url = (json['imageUrl'] as String?)?.trim() ?? '';
    if (url.startsWith('data:image') && url.contains(',')) {
      return url.split(',').last;
    }
    return null;
  }
}
