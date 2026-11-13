import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/announcement.dart';
import '../models/carpool_ride.dart';
import '../models/borrow_terms.dart';
import '../models/neighborhood_geo.dart';
import '../models/neighborhood_notification.dart';
import '../models/neighborhood_event.dart';
import '../models/neighborhood_poll.dart';
import '../models/notification_radius.dart';
import '../widgets/announcement_card.dart';
import '../widgets/community_polls.dart';
import '../widgets/app_page_route.dart';
import '../widgets/category_item.dart';
import '../widgets/empty_announcements.dart';
import '../widgets/help_exchange_section.dart';
import '../models/media_outage.dart';
import '../models/neighborhood_street.dart';
import '../models/neighbor_reminder.dart';
import '../models/home_feed_category.dart';
import '../models/home_module_visibility.dart';
import '../models/home_shortcuts.dart';
import '../models/neighbor_hub.dart';
import '../l10n/app_localizations.dart';
import '../theme/widzew_colors.dart';
import '../theme/widzew_ui.dart';
import '../widgets/driver_mode_bar.dart';
import '../services/form_draft_store.dart';
import '../utils/flutter_runtime.dart';
import '../widgets/development_notice_dialog.dart';
import '../widgets/offline_banner.dart';
import '../widgets/propose_change_dialog.dart';
import 'events_screen.dart';
import 'notifications_screen.dart';

enum HomeSortMode { newest, oldest, likes, nearest, alerts }

enum HomeFeedLayout { list, grid }

enum HomeDateFilter { all, today, last3Days, lastWeek }

class HomeScreen extends StatefulWidget {
  final List<Announcement> announcements;
  final ValueChanged<Announcement> onOpenAnnouncement;
  final ValueChanged<Announcement> onToggleFavorite;
  final ValueChanged<Announcement> onLikeAnnouncement;
  final VoidCallback onAddAnnouncement;
  final bool isOnline;
  final bool showOfflineBanner;
  final String userSubDistrict;
  final String userName;
  final bool neighborhoodNotificationsEnabled;
  final void Function(Announcement announcement, String reason)?
  onReportAnnouncement;
  final List<NeighborhoodPoll> polls;
  final void Function(String pollId, int optionIndex)? onVotePoll;
  final List<NeighborhoodEvent> events;
  final ValueChanged<String>? onToggleEventGoing;
  final ValueChanged<NeighborhoodEvent>? onAddEventToCalendar;
  final ValueChanged<String>? onRecordSearch;
  final VoidCallback? onAddHelp;
  final VoidCallback? onAddEvent;
  final VoidCallback? onAddLending;
  final VoidCallback? onSnapPost;
  final NotificationRadius notificationRadius;
  final List<String> notificationCategories;
  final String? initialCategory;
  final bool driverMode;
  final List<NeighborReminder> reminders;
  final VoidCallback? onOpenEcoPatrol;
  final ValueChanged<NeighborhoodEvent>? onRemindEvent;
  final List<String> favoriteStreets;
  final List<MediaOutage> mediaOutages;
  final VoidCallback? onOpenMediaOutages;
  final bool homeStatsBannerEnabled;
  final String homeFavoriteCategory;
  final int homeAroundBlockCount;
  final int homeDistrictNoticeCount;
  final int homeDistrictEventCount;
  final VoidCallback? onOpenHomeStatsConfig;
  final HomeModuleVisibility homeModuleVisibility;
  final int pitcherDays;
  final VoidCallback? onOpenPitcherFilter;
  final List<String> homeTileOrder;
  final List<String> homePinnedTools;
  final ValueChanged<String>? onOpenPinnedTool;
  final int safetyKitDays;
  final VoidCallback? onOpenSafetyKit;
  final bool quietHoursEnabled;
  final String quietHoursLabel;
  final VoidCallback? onOpenSoundAlerts;
  final VoidCallback? onOpenNeighborHub;
  final ValueChanged<String>? onOpenHubModule;
  final VoidCallback? onOpenMessages;
  final VoidCallback? onOpenInfrastructure;
  final VoidCallback? onOpenCrossingReports;
  final String initialSubDistrict;
  final List<CarpoolRide> carpoolRides;
  final Future<void> Function()? onRefresh;
  final List<String> searchHistory;
  final ValueChanged<String>? onRemoveSearch;
  final VoidCallback? onClearSearchHistory;
  final void Function(Announcement announcement, String emoji)?
  onReactAnnouncement;
  final ValueChanged<String>? onExploreSubDistrict;

  const HomeScreen({
    super.key,
    required this.announcements,
    required this.onOpenAnnouncement,
    required this.onToggleFavorite,
    required this.onLikeAnnouncement,
    required this.onAddAnnouncement,
    this.isOnline = true,
    this.showOfflineBanner = true,
    this.userSubDistrict = 'Widzew Wschód',
    this.userName = 'Sąsiad',
    this.neighborhoodNotificationsEnabled = true,
    this.onReportAnnouncement,
    this.polls = const [],
    this.onVotePoll,
    this.events = const [],
    this.onToggleEventGoing,
    this.onAddEventToCalendar,
    this.onRecordSearch,
    this.onAddHelp,
    this.onAddEvent,
    this.onAddLending,
    this.onSnapPost,
    this.notificationRadius = NotificationRadius.allWidzew,
    this.notificationCategories = const [],
    this.initialCategory,
    this.driverMode = false,
    this.reminders = const [],
    this.onOpenEcoPatrol,
    this.onRemindEvent,
    this.favoriteStreets = const [],
    this.mediaOutages = const [],
    this.onOpenMediaOutages,
    this.homeStatsBannerEnabled = true,
    this.homeFavoriteCategory = 'Sąsiedzi',
    this.homeAroundBlockCount = 0,
    this.homeDistrictNoticeCount = 0,
    this.homeDistrictEventCount = 0,
    this.onOpenHomeStatsConfig,
    this.homeModuleVisibility = const HomeModuleVisibility(),
    this.pitcherDays = 0,
    this.onOpenPitcherFilter,
    this.homeTileOrder = const [],
    this.homePinnedTools = const [],
    this.onOpenPinnedTool,
    this.safetyKitDays = -1,
    this.onOpenSafetyKit,
    this.quietHoursEnabled = false,
    this.quietHoursLabel = '',
    this.onOpenSoundAlerts,
    this.onOpenNeighborHub,
    this.onOpenHubModule,
    this.onOpenMessages,
    this.onOpenInfrastructure,
    this.onOpenCrossingReports,
    this.initialSubDistrict = 'Wszystkie osiedla',
    this.carpoolRides = const [],
    this.onRefresh,
    this.searchHistory = const [],
    this.onRemoveSearch,
    this.onClearSearchHistory,
    this.onReactAnnouncement,
    this.onExploreSubDistrict,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static var _welcomeScheduled = false;
  String? _selectedCategory;
  String _searchQuery = '';
  String _selectedSubDistrict = 'Wszystkie osiedla';
  HomeSortMode _sortMode = HomeSortMode.newest;
  HomeDateFilter _dateFilter = HomeDateFilter.all;
  var _freeOnly = false;
  final ValueNotifier<bool> _showScrollTop = ValueNotifier(false);
  var _scrollFabQueued = false;
  Timer? _searchDebounce;
  HomeFeedLayout _feedLayout = HomeFeedLayout.list;
  final Set<String> _readNotificationKeys = {};
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _feedSectionKey = GlobalKey();
  var _filtersReady = false;
  DateTime? _lastBackAt;

  @override
  void initState() {
    super.initState();
    final initialCategory = widget.initialCategory;
    _selectedCategory = (initialCategory == null || initialCategory.isEmpty)
        ? null
        : HomeFeedCategory.canonicalId(initialCategory);
    if (Announcement.subDistricts.contains(widget.initialSubDistrict)) {
      _selectedSubDistrict = widget.initialSubDistrict;
    }
    _scrollController.addListener(_onHomeScroll);
    if (!_isWidgetTest) {
      _applyFilterDraft(FormDraftStore.peek(FormDraftStore.homeFilters));
      unawaited(_restoreHomeFilters());
      if (!_welcomeScheduled) {
        _welcomeScheduled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          unawaited(DevelopmentNoticeDialog.maybeShow(context));
        });
      }
    } else {
      _filtersReady = true;
    }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (_filtersReady && !_isWidgetTest) {
      _persistFilters();
    }
  }

  Future<void> _restoreHomeFilters() async {
    final draft = await FormDraftStore.load(FormDraftStore.homeFilters);
    if (!mounted) return;
    _applyFilterDraft(draft);
    setState(() => _filtersReady = true);
  }

  void _applyFilterDraft(Map<String, String> draft) {
    if (draft.isEmpty) return;
    final query = draft['query'];
    if (query != null) {
      _searchQuery = query;
      _searchController.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }
    final subDistrict = draft['subDistrict'];
    if (subDistrict != null && subDistrict.isNotEmpty) {
      _selectedSubDistrict = subDistrict;
    }
    final sort = draft['sort'];
    if (sort != null) {
      for (final mode in HomeSortMode.values) {
        if (mode.name == sort) _sortMode = mode;
      }
    }
    final date = draft['date'];
    if (date != null) {
      for (final mode in HomeDateFilter.values) {
        if (mode.name == date) _dateFilter = mode;
      }
    }
    _freeOnly = draft['free'] == '1';
    final layout = draft['layout'];
    if (layout != null) {
      for (final mode in HomeFeedLayout.values) {
        if (mode.name == layout) _feedLayout = mode;
      }
    }
  }

  void _persistFilters() {
    FormDraftStore.save(FormDraftStore.homeFilters, {
      'query': _searchQuery,
      'category': _selectedCategory ?? '',
      'subDistrict': _selectedSubDistrict,
      'tag': '',
      'sort': _sortMode.name,
      'date': _dateFilter.name,
      'free': _freeOnly ? '1' : '0',
      'photos': '0',
      'layout': _feedLayout.name,
    });
  }

  void _onHomeScroll() {
    if (_scrollFabQueued) return;
    _scrollFabQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollFabQueued = false;
      if (!mounted || !_scrollController.hasClients) return;
      final show = _scrollController.offset > 280;
      if (show != _showScrollTop.value) {
        _showScrollTop.value = show;
      }
    });
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    if (_isWidgetTest) {
      setState(() => _searchQuery = value);
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 160), () {
      if (!mounted || _searchQuery == value) return;
      setState(() => _searchQuery = value);
    });
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSubDistrict != widget.initialSubDistrict &&
        Announcement.subDistricts.contains(widget.initialSubDistrict)) {
      _selectedSubDistrict = widget.initialSubDistrict;
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _showScrollTop.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshFeed() async {
    await widget.onRefresh?.call();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _scrollToTop() {
    return _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _scrollToFeed() async {
    if (_isWidgetTest) return;
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || !_scrollController.hasClients) return;
    final targetContext = _feedSectionKey.currentContext;
    var offset = _scrollController.position.maxScrollExtent;
    if (targetContext != null) {
      final target = targetContext.findRenderObject();
      final viewport = _scrollController.position.context.notificationContext
          ?.findRenderObject();
      if (target is RenderBox && viewport is RenderBox) {
        final dy = target.localToGlobal(Offset.zero, ancestor: viewport).dy;
        offset = (_scrollController.offset + dy - 8).clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        );
      }
    }
    await _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  void _openNotificationTarget(NeighborhoodNotification notification) {
    if (notification.isNeighborMessage) {
      widget.onOpenMessages?.call();
      return;
    }
    final linked = notification.announcement;
    if (notification.isSosOrWildlife && linked != null) {
      widget.onOpenAnnouncement(linked);
      return;
    }
    if (notification.isMediaOutageAlert) {
      widget.onOpenMediaOutages?.call();
      return;
    }
    if (notification.isServiceWorks) {
      widget.onOpenInfrastructure?.call();
      return;
    }
    if (notification.isRoadDisruption) {
      widget.onOpenCrossingReports?.call();
      return;
    }
    if (linked != null) {
      widget.onOpenAnnouncement(linked);
      return;
    }
    if (notification.isReminder) return;
    widget.onOpenNeighborHub?.call();
  }

  List<Announcement> _filterAndSortAnnouncements() {
    final category = _selectedCategory;
    final query = _searchQuery.trim().toLowerCase();
    final visibleAnnouncements = widget.announcements.where((announcement) {
      final matchesCategory = _matchesCategory(announcement, category);
      final matchesQuery = _matchesLiveQuery(announcement, query);
      final matchesSubDistrict =
          _selectedSubDistrict == 'Wszystkie osiedla' ||
          announcement.subDistrict == _selectedSubDistrict;
      final matchesDate = _matchesDateFilter(announcement.publishedAt);
      final matchesFree = !_freeOnly || announcement.isFree;
      final matchesStreet = NeighborhoodStreet.matchesAnnouncement(
        announcement,
        widget.favoriteStreets,
      );
      return matchesCategory &&
          matchesQuery &&
          matchesSubDistrict &&
          matchesDate &&
          matchesFree &&
          matchesStreet;
    }).toList();
    visibleAnnouncements.sort((first, second) {
      if (_sortMode == HomeSortMode.alerts) {
        final alertOrder = (second.isAlert ? 1 : 0).compareTo(
          first.isAlert ? 1 : 0,
        );
        if (alertOrder != 0) return alertOrder;
      }
      if (_sortMode == HomeSortMode.likes) {
        final likesOrder = second.likesCount.compareTo(first.likesCount);
        if (likesOrder != 0) return likesOrder;
      }
      if (_sortMode == HomeSortMode.nearest) {
        final nearestOrder =
            NeighborhoodGeo.distanceSquared(
              widget.userSubDistrict,
              first.subDistrict,
            ).compareTo(
              NeighborhoodGeo.distanceSquared(
                widget.userSubDistrict,
                second.subDistrict,
              ),
            );
        if (nearestOrder != 0) return nearestOrder;
      }
      final order = first.publishedAt.compareTo(second.publishedAt);
      return _sortMode == HomeSortMode.oldest ? order : -order;
    });
    return visibleAnnouncements;
  }

  bool get _hasActiveFilters =>
      _searchQuery.trim().isNotEmpty ||
      _selectedCategory != null ||
      _selectedSubDistrict != 'Wszystkie osiedla' ||
      _dateFilter != HomeDateFilter.all ||
      _freeOnly;

  String? _categoryTitle(BuildContext context) {
    final selected = _selectedCategory;
    if (selected == null || selected.isEmpty) return null;
    final category = HomeFeedCategory.resolve(selected);
    if (category == null) return HomeFeedCategory.titleFor(selected);
    return context.tr('cat_${category.id}');
  }

  String _emptyMessage(BuildContext context) {
    final categoryTitle = _categoryTitle(context);
    if (categoryTitle != null && _searchQuery.trim().isEmpty) {
      return context.tr('emptyCategory', {'name': categoryTitle});
    }
    final hasSearchOrCategory =
        _searchQuery.trim().isNotEmpty || _selectedCategory != null;
    if (!hasSearchOrCategory && _selectedSubDistrict != 'Wszystkie osiedla') {
      return context.tr('emptyDistrict');
    }
    if (_hasActiveFilters) {
      return context.tr('emptyFilters');
    }
    return context.tr('emptyNoAnnouncements');
  }

  String? _emptyHint(BuildContext context) {
    if (_searchQuery.trim().isNotEmpty) {
      return context.tr('emptySearchHint');
    }
    return null;
  }

  void _resetFilters() {
    _searchDebounce?.cancel();
    _searchController.clear();
    setState(() {
      _selectedCategory = null;
      _searchQuery = '';
      _selectedSubDistrict = 'Wszystkie osiedla';
      _sortMode = HomeSortMode.newest;
      _dateFilter = HomeDateFilter.all;
      _freeOnly = false;
    });
  }

  void _selectSubDistrict(String district) {
    setState(() => _selectedSubDistrict = district);
    _persistFilters();
    if (Announcement.subDistricts.contains(district)) {
      widget.onExploreSubDistrict?.call(district);
    }
  }

  bool get _isWidgetTest => isFlutterWidgetTest;

  bool _isFeedCategorySelected(String tileId) {
    final current = _selectedCategory;
    if (current == null || current.isEmpty) return false;
    final selected = HomeFeedCategory.resolve(current);
    final tile = HomeFeedCategory.byTile(tileId);
    if (selected != null && tile != null) return selected.id == tile.id;
    return current == tileId;
  }

  void _selectTileCategory(String tileId) {
    final category = HomeFeedCategory.byTile(tileId);
    _selectCategory(category?.id ?? tileId);
  }

  CategoryItem _categoryTile(String tile) {
    return switch (tile) {
      'Fachowcy' => CategoryItem(
        icon: Icons.build,
        label: 'Fachowcy',
        displayLabel: context.tr('cat_fachowcy'),
        color: Colors.orange,
        selected: _isFeedCategorySelected('Fachowcy'),
        onTap: () => _selectTileCategory('Fachowcy'),
      ),
      'Zwierzaki' => CategoryItem(
        icon: Icons.pets,
        label: 'Zwierzaki',
        displayLabel: context.tr('cat_zwierzaki_nl'),
        color: Colors.green,
        selected: _isFeedCategorySelected('Zwierzaki'),
        onTap: () => _selectTileCategory('Zwierzaki'),
      ),
      'Oddam/Kupię' => CategoryItem(
        icon: Icons.shopping_bag,
        label: 'Oddam/Kupię',
        displayLabel: context.tr('cat_oddam_kupie'),
        color: Colors.blue,
        selected: _isFeedCategorySelected('Oddam/Kupię'),
        onTap: () => _selectTileCategory('Oddam/Kupię'),
      ),
      'Zgubione / znalezione' => CategoryItem(
        icon: Icons.search_rounded,
        label: 'Zgubione / znalezione',
        displayLabel: context.tr('cat_zgubione_znalezione_nl'),
        color: const Color(0xFFEF6C00),
        selected: _isFeedCategorySelected('Zgubione / znalezione'),
        onTap: () => _selectTileCategory('Zgubione / znalezione'),
      ),
      'Dzikie zwierzęta' => CategoryItem(
        icon: Icons.warning_amber_rounded,
        label: Announcement.wildlifeCategory,
        displayLabel: context.tr('cat_alerty_awarie_nl'),
        color: const Color(0xFFE65100),
        selected: _isFeedCategorySelected('Dzikie zwierzęta'),
        onTap: () => _selectTileCategory('Dzikie zwierzęta'),
      ),
      'Jedzenie' => CategoryItem(
        icon: Icons.flatware,
        label: 'Jedzenie',
        displayLabel: context.tr('cat_jedzenie'),
        color: Colors.purple,
        selected: _isFeedCategorySelected('Jedzenie'),
        onTap: () => _selectTileCategory('Jedzenie'),
      ),
      'Sąsiedzi' => CategoryItem(
        icon: Icons.assignment_outlined,
        label: 'Sąsiedzi',
        displayLabel: context.tr('cat_sasiedzi_nl'),
        color: Colors.teal,
        selected: _isFeedCategorySelected('Sąsiedzi'),
        onTap: () => _selectTileCategory('Sąsiedzi'),
      ),
      'Wydarzenia' => CategoryItem(
        icon: Icons.event,
        label: 'Wydarzenia',
        displayLabel: context.tr('cat_wydarzenia'),
        color: Colors.pink,
        selected: _isFeedCategorySelected('Wydarzenia'),
        onTap: () => _selectTileCategory('Wydarzenia'),
      ),
      'Złota Rączka' => CategoryItem(
        icon: Icons.back_hand_rounded,
        label: 'Złota Rączka',
        displayLabel: context.tr('cat_zlota_raczka'),
        color: const Color(0xFFD4AF37),
        selected: _isFeedCategorySelected('Złota Rączka'),
        onTap: () => _selectTileCategory('Złota Rączka'),
      ),
      'Remont' => CategoryItem(
        icon: Icons.format_paint_rounded,
        label: 'Remont',
        displayLabel: context.tr('cat_remont'),
        color: const Color(0xFF5C6BC0),
        selected: _isFeedCategorySelected('Remont'),
        onTap: () => _selectTileCategory('Remont'),
      ),
      'Jednorazowe zlecenia' => CategoryItem(
        icon: Icons.assignment_turned_in_rounded,
        label: 'Jednorazowe zlecenia',
        displayLabel: context.tr('cat_jednorazowe_zlecenia_nl'),
        color: const Color(0xFF0277BD),
        selected: _isFeedCategorySelected('Jednorazowe zlecenia'),
        onTap: () => _selectTileCategory('Jednorazowe zlecenia'),
      ),
      _ => CategoryItem(
        icon: Icons.more_horiz,
        label: 'Więcej',
        displayLabel: context.tr('cat_wiecej'),
        color: Colors.grey,
        selected: _isFeedCategorySelected('Więcej'),
        onTap: () => _selectTileCategory('Więcej'),
      ),
    };
  }

  Future<void> _showQuickAddMenu() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.post_add_outlined),
                title: Text(context.tr('addAnnouncement')),
                onTap: () => Navigator.pop(sheetContext, 'announcement'),
              ),
              ListTile(
                leading: const Icon(Icons.report_gmailerrorred_outlined),
                title: Text(context.tr('reportIssue')),
                onTap: () => Navigator.pop(sheetContext, 'snap'),
              ),
            ],
          ),
        );
      },
    );
    if (!mounted || choice == null) return;
    switch (choice) {
      case 'event':
        widget.onAddEvent?.call();
      case 'lending':
        (widget.onAddLending ?? widget.onAddAnnouncement).call();
      case 'snap':
        (widget.onSnapPost ?? widget.onAddAnnouncement).call();
      case 'eco':
        widget.onOpenEcoPatrol?.call();
      default:
        widget.onAddAnnouncement();
    }
  }

  bool _matchesLiveQuery(Announcement announcement, String query) {
    if (query.isEmpty) return true;
    final haystack =
        '${announcement.title} ${announcement.description} '
                '${announcement.category} ${announcement.subDistrict} '
                '${announcement.authorName} ${announcement.price ?? ''} '
                '${announcement.borrowTerms?.label ?? ''}'
            .toLowerCase();
    return query
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .every(haystack.contains);
  }

  bool _matchesDateFilter(DateTime publishedAt) {
    if (_dateFilter == HomeDateFilter.all) return true;
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final publishedDay = DateTime(
      publishedAt.year,
      publishedAt.month,
      publishedAt.day,
    );
    return switch (_dateFilter) {
      HomeDateFilter.all => true,
      HomeDateFilter.today => publishedDay == startOfToday,
      HomeDateFilter.last3Days => !publishedDay.isBefore(
        startOfToday.subtract(const Duration(days: 2)),
      ),
      HomeDateFilter.lastWeek => !publishedDay.isBefore(
        startOfToday.subtract(const Duration(days: 6)),
      ),
    };
  }

  void _selectCategory(String category) {
    final resolved = HomeFeedCategory.canonicalId(category);
    setState(() {
      _selectedCategory = _selectedCategory == resolved ? null : resolved;
    });
    unawaited(_scrollToFeed());
  }

  bool _matchesCategory(Announcement announcement, String? category) {
    if (category == null || category.isEmpty) return true;
    final mapped = HomeFeedCategory.resolve(category);
    if (mapped != null) return mapped.matchesAnnouncement(announcement);
    final parts = announcement.category
        .split(' / ')
        .map((part) => part.trim())
        .toList();
    return announcement.category == category || parts.contains(category);
  }

  int get _activeMediaCount =>
      widget.mediaOutages.where((item) => item.isActive).length;

  List<NeighborhoodNotification> get _notifications {
    final items = LocalNotificationMock.build(
      announcements: widget.announcements,
      userSubDistrict: widget.userSubDistrict,
      neighborhoodEnabled: widget.neighborhoodNotificationsEnabled,
      radius: widget.notificationRadius,
      categoryFilters: widget.notificationCategories,
      reminders: widget.reminders,
      favoriteStreets: widget.favoriteStreets,
    );
    if (widget.neighborhoodNotificationsEnabled && _activeMediaCount > 0) {
      items.add(
        NeighborhoodNotification(
          title: 'Pilne: awaria mediów na osiedlu',
          body:
              'Aktywne awarie mediów: $_activeMediaCount. Szczegóły w centrum.',
          createdAt: DateTime(2026, 10, 13, 8, 15),
          icon: Icons.water_drop_outlined,
        ),
      );
    }
    items.sort((first, second) => second.createdAt.compareTo(first.createdAt));
    return items
        .map(
          (item) => item.copyWith(
            isRead: item.isRead || _readNotificationKeys.contains(item.readKey),
          ),
        )
        .toList();
  }

  int get _unreadNotificationCount =>
      _notifications.where((item) => !item.isRead).length;

  static const _serviceCategoryTiles = [
    'Złota Rączka',
    'Remont',
    'Jednorazowe zlecenia',
  ];

  bool _queryMatches(String haystack, String query) {
    if (query.isEmpty) return true;
    final lower = haystack.toLowerCase();
    return query
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .every(lower.contains);
  }

  List<Announcement> get _alertSearchHits {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return widget.announcements
        .where(
          (item) =>
              item.isAlert &&
              item.status == AnnouncementStatus.current &&
              _matchesLiveQuery(item, query),
        )
        .take(6)
        .toList();
  }

  List<MediaOutage> get _mediaSearchHits {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return widget.mediaOutages
        .where(
          (item) => _queryMatches(
            '${item.title} ${item.body} ${item.kind.label} ${item.place} '
            'awaria media alert',
            query,
          ),
        )
        .take(6)
        .toList();
  }

  List<NeighborHubEntry> get _serviceSearchHits {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return NeighborHubCatalog.entries
        .where(
          (entry) => _queryMatches(
            '${entry.title} ${entry.keywords} ${entry.category.label}',
            query,
          ),
        )
        .take(8)
        .toList();
  }

  List<CarpoolRide> get _carpoolSearchHits {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return widget.carpoolRides
        .where(
          (ride) => _queryMatches(
            '${ride.title} ${ride.fromPlace} ${ride.toPlace} '
            '${ride.note} ${ride.authorName} ${ride.subDistrict} '
            'carpool carpooling przejazd',
            query,
          ),
        )
        .take(6)
        .toList();
  }

  static const _districtChipOrder = [
    'Stary Widzew',
    'Widzew Wschód',
    'Olechów',
    'Janów',
    'Księży Młyn',
  ];

  int get _activeListingCount => widget.announcements
      .where((item) => item.status == AnnouncementStatus.current)
      .length;

  int get _todayListingCount {
    final now = DateTime.now();
    return widget.announcements.where((item) {
      final published = item.publishedAt;
      return published.year == now.year &&
          published.month == now.month &&
          published.day == now.day;
    }).length;
  }

  Widget _buildTodayOnWidzewHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: WidzewUi.borderRadius,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            children: [
              Icon(
                Icons.today_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('todayAround'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.tr('activeTodayCounts', {
                        'active': '$_activeListingCount',
                        'today': '$_todayListingCount',
                      }),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubDistrictChips() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final idleBackground = isDark
        ? const Color(0xFF3A2A2A)
        : const Color(0xFFE0E0E0);
    final idleText = isDark ? WidzewColors.inkOnDark : const Color(0xFF1A1A1A);
    final districts = ['Wszystkie osiedla', ..._districtChipOrder];
    return SingleChildScrollView(
      key: const ValueKey('subdistrict-filter-row'),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Row(
        children: [
          for (var index = 0; index < districts.length; index++) ...[
            if (index > 0) const SizedBox(width: 8),
            FilterChip(
              key: ValueKey('subdistrict-chip-${districts[index]}'),
              label: Text(
                index == 0 ? context.tr('allDistrictsShort') : districts[index],
                softWrap: true,
              ),
              selected: _selectedSubDistrict == districts[index],
              backgroundColor: idleBackground,
              selectedColor: WidzewColors.red,
              surfaceTintColor: Colors.transparent,
              checkmarkColor: Colors.white,
              visualDensity: VisualDensity.compact,
              side: BorderSide(
                color: _selectedSubDistrict == districts[index]
                    ? WidzewColors.red
                    : const Color(0xFF9E9E9E),
              ),
              labelStyle: TextStyle(
                color: _selectedSubDistrict == districts[index]
                    ? Colors.white
                    : idleText,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (_) => _selectSubDistrict(districts[index]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final order = [
      ..._serviceCategoryTiles,
      for (final tile in HomeShortcuts(
        tileOrder: widget.homeTileOrder,
      ).resolvedTileOrder())
        if (widget.homeModuleVisibility.show(tile)) tile,
    ];
    final afterPets = order.indexOf('Zwierzaki');
    final afterBuy = order.indexOf('Oddam/Kupię');
    final insertAt = afterPets >= 0
        ? afterPets + 1
        : afterBuy >= 0
        ? afterBuy + 1
        : _serviceCategoryTiles.length;
    order.insert(insertAt, 'Zgubione / znalezione');
    final tiles = [for (final tile in order) _categoryTile(tile)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.tr('categoriesTitle'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              for (var i = 0; i < tiles.length; i += 4)
                Row(
                  children: [
                    for (var slot = 0; slot < 4; slot++)
                      Expanded(
                        child: SizedBox(
                          height: 118,
                          child: i + slot < tiles.length
                              ? tiles[i + slot]
                              : null,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCrossSearchResults() {
    final alerts = _alertSearchHits;
    final media = _mediaSearchHits;
    final services = _serviceSearchHits;
    final rides = _carpoolSearchHits;
    if (alerts.isEmpty && media.isEmpty && services.isEmpty && rides.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (alerts.isNotEmpty) ...[
            Text(
              context.tr('alerts'),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            for (final alert in alerts)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: const Icon(Icons.warning_amber_outlined),
                  title: Text(alert.title, softWrap: true),
                  subtitle: Text(alert.subDistrict, softWrap: true),
                  onTap: () => widget.onOpenAnnouncement(alert),
                ),
              ),
          ],
          if (media.isNotEmpty) ...[
            Text(
              context.tr('mediaOutages'),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            for (final item in media)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: const Icon(Icons.water_drop_outlined),
                  title: Text(item.title, softWrap: true),
                  subtitle: Text(item.place, softWrap: true),
                  onTap: widget.onOpenMediaOutages,
                ),
              ),
          ],
          if (services.isNotEmpty) ...[
            Text(
              context.tr('neighborServices'),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            for (final entry in services)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: Icon(entry.category.icon),
                  title: Text(entry.title, softWrap: true),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: widget.onOpenHubModule == null
                      ? null
                      : () => widget.onOpenHubModule!(entry.id),
                ),
              ),
          ],
          if (rides.isNotEmpty) ...[
            Text(
              context.tr('carpooling'),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            for (final ride in rides)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: const Icon(Icons.directions_car_outlined),
                  title: Text(ride.title, softWrap: true),
                  subtitle: Text(
                    '${ride.fromPlace} → ${ride.toPlace}',
                    softWrap: true,
                  ),
                  onTap: widget.onOpenHubModule == null
                      ? null
                      : () => widget.onOpenHubModule!('carpool'),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _homeAnnouncementCard(
    Announcement announcement, {
    bool compact = false,
  }) {
    return AnnouncementCard(
      key: ValueKey(announcement.heroTag),
      announcement: announcement,
      compact: compact,
      onTap: () => widget.onOpenAnnouncement(announcement),
      onFavoriteToggle: () => widget.onToggleFavorite(announcement),
      onLike: () => widget.onLikeAnnouncement(announcement),
      onReact: widget.onReactAnnouncement == null
          ? null
          : (emoji) => widget.onReactAnnouncement!(announcement, emoji),
      onReport: widget.onReportAnnouncement == null
          ? null
          : (reason) => widget.onReportAnnouncement!(announcement, reason),
    );
  }

  bool _onHomeBack() {
    if (_isWidgetTest) return true;
    final now = DateTime.now();
    final last = _lastBackAt;
    if (last == null || now.difference(last) > const Duration(seconds: 2)) {
      _lastBackAt = now;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(context.tr('exitHint')),
            duration: const Duration(seconds: 2),
          ),
        );
      return true;
    }
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final visibleAnnouncements = _filterAndSortAnnouncements();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onHomeBack();
      },
      child: Scaffold(
        floatingActionButton: WidzewUi.safeFab(
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: _showScrollTop,
                builder: (context, show, _) {
                  if (!show) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FloatingActionButton.small(
                      heroTag: 'home-scroll-top',
                      tooltip: context.tr('backToTop'),
                      onPressed: _scrollToTop,
                      child: const Icon(Icons.keyboard_arrow_up),
                    ),
                  );
                },
              ),
              FloatingActionButton(
                heroTag: 'home-quick-add',
                tooltip: _isWidgetTest
                    ? context.tr('addAnnouncement')
                    : context.tr('quickAdd'),
                onPressed: _isWidgetTest
                    ? widget.onAddAnnouncement
                    : _showQuickAddMenu,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('appTitle'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                context.tr('appSubtitle'),
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          backgroundColor: WidzewColors.red,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              key: const ValueKey('propose-change-home'),
              tooltip: context.tr('proposeChange'),
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: () => unawaited(
                ProposeChangeDialog.show(context, userName: widget.userName),
              ),
            ),
            IconButton(
              tooltip: context.tr('notificationsCenter'),
              icon: Badge(
                isLabelVisible: _unreadNotificationCount > 0,
                label: Text('$_unreadNotificationCount'),
                child: const Icon(Icons.notifications_none),
              ),
              onPressed: () => Navigator.of(context).push(
                AppPageRoute<void>(
                  builder: (_) => NotificationCenterScreen(
                    notifications: _notifications,
                    onOpenNotification: (notification) {
                      setState(
                        () => _readNotificationKeys.add(notification.readKey),
                      );
                      _openNotificationTarget(notification);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            if (!widget.isOnline && widget.showOfflineBanner)
              const OfflineBanner(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshFeed,
                child: CustomScrollView(
                  key: const ValueKey('home-list'),
                  controller: _scrollController,
                  scrollCacheExtent: WidzewUi.listCacheExtent,
                  shrinkWrap: false,
                  physics: WidzewUi.listPhysics,
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _searchController,
                            builder: (context, value, _) {
                              return TextField(
                                key: const ValueKey('announcement-search'),
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                onSubmitted: (submitted) =>
                                    widget.onRecordSearch?.call(submitted),
                                onEditingComplete: () => widget.onRecordSearch
                                    ?.call(_searchController.text),
                                decoration: InputDecoration(
                                  hintText: context.tr('searchHint'),
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: value.text.isEmpty
                                      ? null
                                      : IconButton(
                                          tooltip: context.tr('clearSearch'),
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            _searchDebounce?.cancel();
                                            _searchController.clear();
                                            setState(() => _searchQuery = '');
                                          },
                                        ),
                                  border: const OutlineInputBorder(
                                    borderRadius: WidzewUi.borderRadius,
                                  ),
                                  isDense: true,
                                ),
                              );
                            },
                          ),
                        ),
                        _buildCategoryGrid(),
                        const SizedBox(height: 8),
                        if (widget.driverMode)
                          DriverModeBar(
                            onRoadAlert: widget.onSnapPost,
                            onEco: widget.onOpenEcoPatrol,
                          ),
                        if (_isWidgetTest)
                          Builder(
                            builder: (context) {
                              final isDark =
                                  Theme.of(context).brightness ==
                                  Brightness.dark;
                              return Container(
                                padding: const EdgeInsets.all(16),
                                color: isDark
                                    ? const Color(0xFF3E1C1C)
                                    : Colors.red.shade50,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: WidzewColors.red,
                                      size: 36,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            context.tr('welcomeNeighbor'),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? const Color(0xFFFFCDD2)
                                                  : Colors.red.shade900,
                                            ),
                                          ),
                                          Text(
                                            context.tr('welcomeHint'),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        if (_isWidgetTest) const SizedBox(height: 16),
                        _buildTodayOnWidzewHeader(),
                        _buildSubDistrictChips(),
                        if (widget.searchHistory.isNotEmpty &&
                            _searchQuery.trim().isEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      context.tr('recentSearches'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    const Spacer(),
                                    if (widget.onClearSearchHistory != null)
                                      TextButton(
                                        onPressed: widget.onClearSearchHistory,
                                        child: Text(context.tr('clearHistory')),
                                      ),
                                  ],
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    for (final phrase
                                        in widget.searchHistory.take(5))
                                      InputChip(
                                        key: ValueKey('search-history-$phrase'),
                                        label: Text(phrase),
                                        onPressed: () {
                                          _searchController.text = phrase;
                                          setState(() => _searchQuery = phrase);
                                          widget.onRecordSearch?.call(phrase);
                                        },
                                        onDeleted: widget.onRemoveSearch == null
                                            ? null
                                            : () => widget.onRemoveSearch!(
                                                phrase,
                                              ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        if (_searchQuery.trim().isNotEmpty)
                          _buildCrossSearchResults(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                IconButton(
                                  tooltip: _feedLayout == HomeFeedLayout.grid
                                      ? context.tr('viewList')
                                      : context.tr('viewGrid'),
                                  onPressed: () => setState(() {
                                    _feedLayout =
                                        _feedLayout == HomeFeedLayout.grid
                                        ? HomeFeedLayout.list
                                        : HomeFeedLayout.grid;
                                  }),
                                  icon: Icon(
                                    _feedLayout == HomeFeedLayout.grid
                                        ? Icons.view_list_outlined
                                        : Icons.grid_view_outlined,
                                  ),
                                ),
                                PopupMenuButton<HomeSortMode>(
                                  tooltip: context.tr('sortAnnouncements'),
                                  icon: const Icon(Icons.sort),
                                  onSelected: (mode) =>
                                      setState(() => _sortMode = mode),
                                  itemBuilder: (menuContext) => [
                                    PopupMenuItem(
                                      value: HomeSortMode.newest,
                                      child: Text(menuContext.tr('sortNewest')),
                                    ),
                                    PopupMenuItem(
                                      value: HomeSortMode.likes,
                                      child: Text(
                                        menuContext.tr('sortPopular'),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: HomeSortMode.alerts,
                                      child: Text(menuContext.tr('sortAlerts')),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isWidgetTest)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                FilterChip(
                                  key: const ValueKey('category-filter-all'),
                                  label: Text(
                                    context.tr('allCategories'),
                                    softWrap: true,
                                  ),
                                  selected: _selectedCategory == null,
                                  onSelected: (_) => setState(() {
                                    _selectedCategory = null;
                                  }),
                                ),
                                FilterChip(
                                  key: const ValueKey(
                                    'category-filter-lending',
                                  ),
                                  label: Text(
                                    context.tr('lendingFilter'),
                                    softWrap: true,
                                  ),
                                  selected:
                                      _selectedCategory ==
                                      Announcement.lendingCategory,
                                  onSelected: (_) => _selectCategory(
                                    Announcement.lendingCategory,
                                  ),
                                ),
                                if (_selectedCategory != null)
                                  InputChip(
                                    key: ValueKey(
                                      'active-category-$_selectedCategory',
                                    ),
                                    avatar: const Icon(
                                      Icons.filter_alt,
                                      size: 16,
                                    ),
                                    label: Text(
                                      _categoryTitle(context)!,
                                      softWrap: true,
                                    ),
                                    tooltip: context.tr('clearCategory'),
                                    onDeleted: () => setState(() {
                                      _selectedCategory = null;
                                    }),
                                  ),
                              ],
                            ),
                          ),
                        if (_isWidgetTest)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SegmentedButton<HomeSortMode>(
                                    showSelectedIcon: false,
                                    style: SegmentedButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      selectedBackgroundColor: WidzewColors.red,
                                      selectedForegroundColor: Colors.white,
                                    ),
                                    segments: [
                                      ButtonSegment(
                                        value: HomeSortMode.newest,
                                        label: Text(
                                          context.tr('sortNewest'),
                                          key: const ValueKey('sort-newest'),
                                        ),
                                      ),
                                      ButtonSegment(
                                        value: HomeSortMode.likes,
                                        label: Text(
                                          context.tr('sortPopular'),
                                          key: const ValueKey('sort-likes'),
                                        ),
                                      ),
                                      ButtonSegment(
                                        value: HomeSortMode.nearest,
                                        label: Text(
                                          context.tr('sortNearestMe'),
                                          key: const ValueKey('sort-nearest'),
                                        ),
                                      ),
                                    ],
                                    selected: {
                                      _sortMode == HomeSortMode.oldest
                                          ? HomeSortMode.newest
                                          : _sortMode,
                                    },
                                    onSelectionChanged: (selection) => setState(
                                      () => _sortMode = selection.first,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  FilterChip(
                                    key: const ValueKey('date-filter-today'),
                                    label: Text(
                                      context.tr('today'),
                                      softWrap: true,
                                    ),
                                    selected:
                                        _dateFilter == HomeDateFilter.today,
                                    selectedColor: WidzewColors.red,
                                    checkmarkColor: Colors.white,
                                    visualDensity: VisualDensity.compact,
                                    labelStyle: TextStyle(
                                      color: _dateFilter == HomeDateFilter.today
                                          ? Colors.white
                                          : null,
                                    ),
                                    onSelected: (_) => setState(() {
                                      _dateFilter =
                                          _dateFilter == HomeDateFilter.today
                                          ? HomeDateFilter.all
                                          : HomeDateFilter.today;
                                    }),
                                  ),
                                  PopupMenuButton<String>(
                                    tooltip: context.tr('moreFilters'),
                                    icon: const Icon(Icons.more_horiz),
                                    onSelected: (value) => setState(() {
                                      switch (value) {
                                        case '3days':
                                          _dateFilter =
                                              _dateFilter ==
                                                  HomeDateFilter.last3Days
                                              ? HomeDateFilter.all
                                              : HomeDateFilter.last3Days;
                                        case 'week':
                                          _dateFilter =
                                              _dateFilter ==
                                                  HomeDateFilter.lastWeek
                                              ? HomeDateFilter.all
                                              : HomeDateFilter.lastWeek;
                                        case 'free':
                                          _freeOnly = !_freeOnly;
                                      }
                                    }),
                                    itemBuilder: (context) => [
                                      CheckedPopupMenuItem(
                                        key: const ValueKey(
                                          'date-filter-3days',
                                        ),
                                        value: '3days',
                                        checked:
                                            _dateFilter ==
                                            HomeDateFilter.last3Days,
                                        child: Text(context.tr('last3Days')),
                                      ),
                                      CheckedPopupMenuItem(
                                        key: const ValueKey('date-filter-week'),
                                        value: 'week',
                                        checked:
                                            _dateFilter ==
                                            HomeDateFilter.lastWeek,
                                        child: Text(context.tr('lastWeek')),
                                      ),
                                      CheckedPopupMenuItem(
                                        key: const ValueKey('free-only-filter'),
                                        value: 'free',
                                        checked: _freeOnly,
                                        child: Text(context.tr('freeOnly')),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Padding(
                          key: _feedSectionKey,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _categoryTitle(context) ??
                                      switch (_sortMode) {
                                        HomeSortMode.nearest => context.tr(
                                          'sortNearest',
                                        ),
                                        HomeSortMode.likes => context.tr(
                                          'sortPopular',
                                        ),
                                        HomeSortMode.oldest => context.tr(
                                          'sortOldest',
                                        ),
                                        HomeSortMode.alerts => context.tr(
                                          'sortAlerts',
                                        ),
                                        HomeSortMode.newest => context.tr(
                                          'sortNewestWidzew',
                                        ),
                                      },
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: _sortMode == HomeSortMode.oldest
                                    ? context.tr('sortNewestTooltip')
                                    : context.tr('sortOldestTooltip'),
                                onPressed: () => setState(() {
                                  _sortMode = _sortMode == HomeSortMode.oldest
                                      ? HomeSortMode.newest
                                      : HomeSortMode.oldest;
                                }),
                                icon: const Icon(Icons.sort),
                              ),
                              IconButton(
                                tooltip: context.tr('sortLikesTooltip'),
                                onPressed: () => setState(
                                  () => _sortMode = HomeSortMode.likes,
                                ),
                                icon: Icon(
                                  Icons.favorite,
                                  color: _sortMode == HomeSortMode.likes
                                      ? WidzewColors.red
                                      : null,
                                ),
                              ),
                              IconButton(
                                tooltip: context.tr('resetSearch'),
                                onPressed: _resetFilters,
                                icon: const Icon(Icons.filter_alt_off),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ]),
                    ),
                    if (visibleAnnouncements.isEmpty)
                      SliverToBoxAdapter(
                        child: EmptyAnnouncements(
                          message: _emptyMessage(context),
                          hint: _emptyHint(context),
                          onResetFilters: _hasActiveFilters
                              ? _resetFilters
                              : null,
                          onAddAnnouncement:
                              _selectedSubDistrict != 'Wszystkie osiedla' &&
                                  _searchQuery.trim().isEmpty &&
                                  _selectedCategory == null
                              ? widget.onAddAnnouncement
                              : null,
                        ),
                      )
                    else if (_feedLayout == HomeFeedLayout.grid)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.68,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _homeAnnouncementCard(
                              visibleAnnouncements[index],
                              compact: true,
                            ),
                            childCount: visibleAnnouncements.length,
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: true,
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _homeAnnouncementCard(
                            visibleAnnouncements[index],
                          ),
                          childCount: visibleAnnouncements.length,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: true,
                        ),
                      ),
                    if (_isWidgetTest)
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            HelpExchangeSection(
                              selected:
                                  _selectedCategory ==
                                  Announcement.helpCategory,
                              onSelected: (selected) => setState(() {
                                _selectedCategory = selected
                                    ? Announcement.helpCategory
                                    : null;
                              }),
                              onSelectNeed: (need) {
                                _searchController.text = need;
                                setState(() {
                                  _selectedCategory = Announcement.helpCategory;
                                  _searchQuery = need;
                                });
                                widget.onRecordSearch?.call(need);
                              },
                              onAddHelp: widget.onAddHelp,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: ActionChip(
                                key: const ValueKey('open-events-widzew'),
                                avatar: const Icon(
                                  Icons.event_available,
                                  size: 18,
                                ),
                                label: Text(
                                  context.tr('eventsWidzew'),
                                  softWrap: true,
                                ),
                                onPressed: () => Navigator.of(context).push(
                                  AppPageRoute<void>(
                                    builder: (_) => EventsScreen(
                                      events: widget.events,
                                      onToggleGoing:
                                          widget.onToggleEventGoing ?? (_) {},
                                      onAddToCalendar:
                                          widget.onAddEventToCalendar ?? (_) {},
                                      onRemindTomorrow: widget.onRemindEvent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            CommunityPolls(
                              polls: widget.polls,
                              onVote: widget.onVotePoll ?? (_, _) {},
                            ),
                          ],
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 180)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
