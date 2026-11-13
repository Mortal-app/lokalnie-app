import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_info.dart';
import 'utils/flutter_runtime.dart';
import 'utils/privacy_log.dart';
import 'services/storage_guard.dart';
import 'l10n/app_locale.dart';
import 'l10n/app_localizations.dart';
import 'models/announcement.dart';
import 'models/app_theme_preference.dart';
import 'models/neighborhood_event.dart';
import 'models/neighborhood_poll.dart';
import 'models/cooperative_notice.dart';
import 'models/eco_report.dart';
import 'models/food_spot.dart';
import 'models/local_deal.dart';
import 'models/neighbor_reminder.dart';
import 'models/neighborhood_club.dart';
import 'models/neighbor_badge.dart';
import 'models/neighbor_message.dart';
import 'models/neighbor_service.dart';
import 'models/notification_radius.dart';
import 'models/barter_offer.dart';
import 'models/camp_gear.dart';
import 'models/caretaker_note.dart';
import 'models/digital_help.dart';
import 'models/ev_charging.dart';
import 'models/grill_event.dart';
import 'models/jasien_guide.dart';
import 'models/bike_station.dart';
import 'models/block_push.dart';
import 'models/board_game_night.dart';
import 'models/bulk_waste.dart';
import 'models/fitness_gear.dart';
import 'models/handy_job.dart';
import 'models/retro_gaming.dart';
import 'models/rod_share.dart';
import 'models/small_appliance.dart';
import 'models/widzew_architecture.dart';
import 'models/wildlife_care.dart';
import 'models/winter_help.dart';
import 'models/av_gear.dart';
import 'models/bike_trip.dart';
import 'models/craft_workshop.dart';
import 'models/crossing_report.dart';
import 'models/garden_note.dart';
import 'models/green_path.dart';
import 'models/night_carpool.dart';
import 'models/photo_club.dart';
import 'models/school_eco_drive.dart';
import 'models/vinyl_swap.dart';
import 'models/workwear.dart';
import 'models/baby_gear.dart';
import 'models/console_tourney.dart';
import 'models/found_plate.dart';
import 'models/generation_bridge.dart';
import 'models/home_sit.dart';
import 'models/home_stats_config.dart';
import 'models/industrial_guide.dart';
import 'models/jar_swap.dart';
import 'models/micro_business.dart';
import 'models/pet_blood.dart';
import 'models/workshop_tool.dart';
import 'models/youth_code.dart';
import 'models/air_quality.dart';
import 'models/cargo_carpool.dart';
import 'models/chess_club.dart';
import 'models/collector_fair.dart';
import 'models/lego_swap.dart';
import 'models/local_art.dart';
import 'models/medicine_chest.dart';
import 'models/memorial_guide.dart';
import 'models/power_share.dart';
import 'models/safety_school.dart';
import 'models/wild_dump.dart';
import 'models/block_tool.dart';
import 'models/classic_car.dart';
import 'models/emergency_rental.dart';
import 'models/green_waste.dart';
import 'models/home_module_visibility.dart';
import 'models/mushroom_trip.dart';
import 'models/parking_share.dart';
import 'models/smile_tutor.dart';
import 'models/time_capsule.dart';
import 'models/upcycle_craft.dart';
import 'models/voltage_outage.dart';
import 'models/walk_find.dart';
import 'models/finance_tip.dart';
import 'models/fishing_club.dart';
import 'models/heat_alert.dart';
import 'models/kid_costume.dart';
import 'models/mall_carpool.dart';
import 'models/model_fair.dart';
import 'models/pet_pro.dart';
import 'models/pram_rack.dart';
import 'models/rtv_repair.dart';
import 'models/street_archive.dart';
import 'models/widzew_skin.dart';
import 'models/wildlife_shelter.dart';
import 'models/app_error_log.dart';
import 'models/park_chess.dart';
import 'models/plant_hotel.dart';
import 'models/print_3d.dart';
import 'models/scam_alert.dart';
import 'models/senior_shop.dart';
import 'models/smog_filter.dart';
import 'models/solar_share.dart';
import 'models/sport_kit.dart';
import 'models/street_art.dart';
import 'models/water_pressure.dart';
import 'models/window_view.dart';
import 'models/airport_ride.dart';
import 'models/energy_recipe.dart';
import 'models/ewaste_point.dart';
import 'models/filament_share.dart';
import 'models/garden_tool_care.dart';
import 'models/indie_cinema.dart';
import 'models/gas_inspection.dart';
import 'models/hepa_tracker.dart';
import 'models/holy_cross_trip.dart';
import 'models/industry_memory.dart';
import 'models/lang_book.dart';
import 'models/mpo_bulky.dart';
import 'models/pcv_window.dart';
import 'models/polish_fantasy.dart';
import 'models/preserve_jar.dart';
import 'models/school_gear.dart';
import 'models/scooter_hub.dart';
import 'models/table_sport.dart';
import 'models/widzew_film.dart';
import 'models/air_plant.dart';
import 'models/balcony_wash.dart';
import 'models/car_policy.dart';
import 'models/dart_billiard.dart';
import 'models/eco_cleaner.dart';
import 'models/forest_forage.dart';
import 'models/lock_care.dart';
import 'models/phone_charge.dart';
import 'models/rock_metal.dart';
import 'models/seasonal_skate.dart';
import 'models/tram_photo.dart';
import 'models/amateur_theater.dart';
import 'models/aquarium_swap.dart';
import 'models/carpet_vac.dart';
import 'models/cinema_photo.dart';
import 'models/electro_ambient.dart';
import 'models/farm_stall.dart';
import 'models/garden_furniture.dart';
import 'models/kayak_trip.dart';
import 'models/lunchbox.dart';
import 'models/puzzle_swap.dart';
import 'models/water_filter.dart';
import 'models/balcony_herb.dart';
import 'models/bazaar_photo.dart';
import 'models/beach_gear.dart';
import 'models/bocce_meetup.dart';
import 'models/car_oil.dart';
import 'models/disco_retro.dart';
import 'models/pavement_clean.dart';
import 'models/pram_access.dart';
import 'models/roller_shutter.dart';
import 'models/sourdough.dart';
import 'models/thermal_trip.dart';
import 'models/badminton_meetup.dart';
import 'models/bench_paint.dart';
import 'models/bike_child.dart';
import 'models/fruit_preserve.dart';
import 'models/home_safe.dart';
import 'models/jazz_blues.dart';
import 'models/pavilion_photo.dart';
import 'models/parking_mark.dart';
import 'models/bieszczady_trip.dart';
import 'models/fruit_vinegar.dart';
import 'models/video_intercom.dart';
import 'models/baby_carrier.dart';
import 'models/tennis_squash.dart';
import 'models/classical_opera.dart';
import 'models/pitcher_filter.dart';
import 'models/clothes_bin.dart';
import 'models/aqua_stock.dart';
import 'models/school_photo.dart';
import 'models/sidewalk_salt.dart';
import 'models/landscape_park_trip.dart';
import 'models/veggie_pickle.dart';
import 'models/radiator_thermo.dart';
import 'models/archery_gear.dart';
import 'models/yard_game.dart';
import 'models/polish_film.dart';
import 'models/safety_kit.dart';
import 'models/soda_co2.dart';
import 'models/terrarium_pet.dart';
import 'models/park_photo.dart';
import 'models/sound_alert.dart';
import 'models/pet_bird.dart';
import 'models/smoke_alarm.dart';
import 'models/sourdough_shop.dart';
import 'models/sudety_trip.dart';
import 'models/lost_pet.dart';
import 'models/stair_clean.dart';
import 'models/streetball.dart';
import 'models/animal_patrol.dart';
import 'models/cine_club.dart';
import 'models/compost_swap.dart';
import 'models/fire_safety.dart';
import 'models/mobile_craft.dart';
import 'models/prl_furniture.dart';
import 'models/slab_museum.dart';
import 'models/sport_league.dart';
import 'models/staircase_code.dart';
import 'models/trailer_share.dart';
import 'models/weekend_trip.dart';
import 'models/led_swap.dart';
import 'models/open_air_show.dart';
import 'models/playground_report.dart';
import 'models/school_book.dart';
import 'models/student_ride.dart';
import 'models/tailor_offer.dart';
import 'models/eco_collection.dart';
import 'models/fauna_sighting.dart';
import 'models/food_share.dart';
import 'models/kids_creation.dart';
import 'models/leftover_material.dart';
import 'models/long_distance_ride.dart';
import 'models/medical_gear.dart';
import 'models/neighbor_recipe.dart';
import 'models/smile_gift.dart';
import 'models/widzew_timeline.dart';
import 'models/bike_help.dart';
import 'models/blood_drive.dart';
import 'models/bulk_buy.dart';
import 'models/cost_split.dart';
import 'models/craft_passage.dart';
import 'models/culture_event.dart';
import 'models/district_activity.dart';
import 'models/diy_workshop.dart';
import 'models/drone_alert.dart';
import 'models/energy_experience.dart';
import 'models/garage_listing.dart';
import 'models/party_gear.dart';
import 'models/pet_health.dart';
import 'models/retro_it_offer.dart';
import 'models/lost_found_item.dart';
import 'models/market_stall.dart';
import 'models/media_outage.dart';
import 'models/odd_job.dart';
import 'models/shared_tool.dart';
import 'models/staircase_fund.dart';
import 'models/craft_maker.dart';
import 'models/home_duty.dart';
import 'models/neighbor_template.dart';
import 'models/safety_alert.dart';
import 'models/tutoring_offer.dart';
import 'models/book_offer.dart';
import 'models/carpool_ride.dart';
import 'models/charity_drive.dart';
import 'models/community_stats.dart';
import 'models/flea_market_item.dart';
import 'models/infrastructure_report.dart';
import 'models/pet_sit_offer.dart';
import 'models/sport_meetup.dart';
import 'models/parent_meetup.dart';
import 'models/parcel_locker.dart';
import 'models/plant_swap.dart';
import 'models/senior_offer.dart';
import 'models/start_destination.dart';
import 'models/time_bank_offer.dart';
import 'models/venue_slot.dart';
import 'models/walking_bus.dart';
import 'models/widzew_history.dart';
import 'theme/widzew_theme.dart';
import 'screens/add_announcement_screen.dart';
import 'screens/content_review_screen.dart';
import 'screens/announcement_detail_screen.dart';
import 'screens/add_event_screen.dart';
import 'screens/home_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/conversations_list_screen.dart';
import 'models/neighbor_conversation.dart';
import 'models/neighbor_avatar.dart';
import 'widgets/voice_note_player.dart';
import 'screens/profile_screen.dart';
import 'screens/snap_post_screen.dart';
import 'screens/cooperative_board_screen.dart';
import 'screens/eco_patrol_screen.dart';
import 'screens/food_guide_screen.dart';
import 'screens/local_deals_screen.dart';
import 'screens/barter_screen.dart';
import 'screens/bulk_buy_screen.dart';
import 'screens/market_stalls_screen.dart';
import 'screens/energy_hub_screen.dart';
import 'screens/retro_it_screen.dart';
import 'screens/cost_split_screen.dart';
import 'screens/bike_help_screen.dart';
import 'screens/diy_academy_screen.dart';
import 'screens/blood_club_screen.dart';
import 'screens/garage_listings_screen.dart';
import 'screens/pet_health_screen.dart';
import 'screens/party_gear_screen.dart';
import 'screens/drone_alerts_screen.dart';
import 'screens/craft_passage_screen.dart';
import 'screens/district_report_screen.dart';
import 'screens/eco_collection_screen.dart';
import 'screens/long_distance_rides_screen.dart';
import 'screens/smile_gifts_screen.dart';
import 'screens/food_share_screen.dart';
import 'screens/medical_gear_screen.dart';
import 'screens/leftover_materials_screen.dart';
import 'screens/fauna_alerts_screen.dart';
import 'screens/recipe_club_screen.dart';
import 'screens/kids_creations_screen.dart';
import 'screens/widzew_timeline_screen.dart';
import 'screens/ev_charging_screen.dart';
import 'screens/tailor_screen.dart';
import 'screens/student_rides_screen.dart';
import 'screens/grill_zone_screen.dart';
import 'screens/playground_reports_screen.dart';
import 'screens/camp_gear_screen.dart';
import 'screens/school_books_screen.dart';
import 'screens/open_air_shows_screen.dart';
import 'screens/digital_help_screen.dart';
import 'screens/led_swap_screen.dart';
import 'screens/jasien_guide_screen.dart';
import 'screens/district_eco_stats_screen.dart';
import 'screens/bike_stations_screen.dart';
import 'screens/handy_jobs_screen.dart';
import 'screens/tradesperson_card_screen.dart';
import 'screens/tradesperson_catalog_screen.dart';
import 'screens/tradesperson_portfolio_screen.dart';
import 'screens/tradesperson_price_list_screen.dart';
import 'screens/tradesperson_subscription_screen.dart';
import 'screens/winter_help_screen.dart';
import 'screens/board_games_screen.dart';
import 'screens/wildlife_care_screen.dart';
import 'screens/fitness_gear_screen.dart';
import 'screens/small_appliances_screen.dart';
import 'screens/bulk_waste_screen.dart';
import 'screens/retro_gaming_screen.dart';
import 'screens/architecture_guide_screen.dart';
import 'screens/rod_share_screen.dart';
import 'screens/block_push_screen.dart';
import 'screens/vinyl_swap_screen.dart';
import 'screens/garden_notes_screen.dart';
import 'screens/night_carpool_screen.dart';
import 'screens/craft_workshop_screen.dart';
import 'screens/bike_trips_screen.dart';
import 'screens/school_eco_screen.dart';
import 'screens/photo_club_screen.dart';
import 'screens/crossing_reports_screen.dart';
import 'screens/av_gear_screen.dart';
import 'screens/workwear_screen.dart';
import 'screens/green_paths_screen.dart';
import 'screens/neighbor_quests_screen.dart';
import 'screens/micro_business_screen.dart';
import 'screens/home_sit_screen.dart';
import 'screens/workshop_garage_screen.dart';
import 'screens/console_tourney_screen.dart';
import 'screens/pet_blood_screen.dart';
import 'screens/jar_swap_screen.dart';
import 'screens/baby_gear_screen.dart';
import 'screens/youth_code_screen.dart';
import 'screens/generation_bridge_screen.dart';
import 'screens/found_plates_screen.dart';
import 'screens/industrial_guide_screen.dart';
import 'screens/home_stats_config_screen.dart';
import 'screens/fire_safety_screen.dart';
import 'screens/compost_swap_screen.dart';
import 'screens/mobile_craft_screen.dart';
import 'screens/sport_league_screen.dart';
import 'screens/animal_patrol_screen.dart';
import 'screens/weekend_trips_screen.dart';
import 'screens/trailer_share_screen.dart';
import 'screens/prl_furniture_screen.dart';
import 'screens/cine_club_screen.dart';
import 'screens/slab_museum_screen.dart';
import 'screens/staircase_codes_screen.dart';
import 'screens/district_analytics_screen.dart';
import 'screens/air_quality_screen.dart';
import 'screens/power_share_screen.dart';
import 'screens/wild_dump_screen.dart';
import 'screens/safety_school_screen.dart';
import 'screens/cargo_carpool_screen.dart';
import 'screens/collector_fair_screen.dart';
import 'screens/lego_swap_screen.dart';
import 'screens/chess_club_screen.dart';
import 'screens/local_art_screen.dart';
import 'screens/memorial_guide_screen.dart';
import 'screens/medicine_chest_screen.dart';
import 'screens/user_backup_screen.dart';
import 'screens/voltage_outage_screen.dart';
import 'screens/parking_share_screen.dart';
import 'screens/block_tool_screen.dart';
import 'screens/mushroom_trip_screen.dart';
import 'screens/smile_tutor_screen.dart';
import 'screens/upcycle_craft_screen.dart';
import 'screens/classic_car_screen.dart';
import 'screens/walk_find_screen.dart';
import 'screens/green_waste_screen.dart';
import 'screens/time_capsule_screen.dart';
import 'screens/emergency_rental_screen.dart';
import 'screens/home_module_visibility_screen.dart';
import 'screens/heat_alert_screen.dart';
import 'screens/mall_carpool_screen.dart';
import 'screens/pram_rack_screen.dart';
import 'screens/rtv_repair_screen.dart';
import 'screens/kid_costume_screen.dart';
import 'screens/model_fair_screen.dart';
import 'screens/fishing_club_screen.dart';
import 'screens/finance_tip_screen.dart';
import 'screens/wildlife_shelter_screen.dart';
import 'screens/pet_pro_screen.dart';
import 'screens/street_archive_screen.dart';
import 'screens/widzew_skin_screen.dart';
import 'screens/smog_filter_screen.dart';
import 'screens/water_pressure_screen.dart';
import 'screens/solar_share_screen.dart';
import 'screens/print_3d_screen.dart';
import 'screens/sport_kit_screen.dart';
import 'screens/senior_shop_screen.dart';
import 'screens/park_chess_screen.dart';
import 'screens/scam_alert_screen.dart';
import 'screens/street_art_screen.dart';
import 'screens/plant_hotel_screen.dart';
import 'screens/window_view_screen.dart';
import 'screens/app_diagnostics_screen.dart';
import 'screens/stair_clean_screen.dart';
import 'screens/airport_ride_screen.dart';
import 'screens/energy_recipe_screen.dart';
import 'screens/garden_tool_care_screen.dart';
import 'screens/lang_book_screen.dart';
import 'screens/streetball_screen.dart';
import 'screens/indie_cinema_screen.dart';
import 'screens/lost_pet_screen.dart';
import 'screens/ewaste_map_screen.dart';
import 'screens/filament_share_screen.dart';
import 'screens/industry_memory_screen.dart';
import 'screens/achievement_share_screen.dart';
import 'screens/mpo_bulky_screen.dart';
import 'screens/holy_cross_trip_screen.dart';
import 'screens/preserve_jar_screen.dart';
import 'screens/pcv_window_screen.dart';
import 'screens/school_gear_screen.dart';
import 'screens/table_sport_screen.dart';
import 'screens/polish_fantasy_screen.dart';
import 'screens/gas_inspection_screen.dart';
import 'screens/scooter_hub_screen.dart';
import 'screens/hepa_tracker_screen.dart';
import 'screens/widzew_film_screen.dart';
import 'screens/activity_report_screen.dart';
import 'screens/balcony_wash_screen.dart';
import 'screens/forest_forage_screen.dart';
import 'screens/eco_cleaner_screen.dart';
import 'screens/lock_care_screen.dart';
import 'screens/seasonal_skate_screen.dart';
import 'screens/dart_billiard_screen.dart';
import 'screens/rock_metal_screen.dart';
import 'screens/car_policy_screen.dart';
import 'screens/phone_charge_screen.dart';
import 'screens/air_plant_screen.dart';
import 'screens/tram_photo_screen.dart';
import 'screens/local_vault_screen.dart';
import 'screens/carpet_vac_screen.dart';
import 'screens/kayak_trip_screen.dart';
import 'screens/lunchbox_screen.dart';
import 'screens/garden_furniture_screen.dart';
import 'screens/puzzle_swap_screen.dart';
import 'screens/amateur_theater_screen.dart';
import 'screens/electro_ambient_screen.dart';
import 'screens/water_filter_screen.dart';
import 'screens/farm_stall_screen.dart';
import 'screens/aquarium_swap_screen.dart';
import 'screens/cinema_photo_screen.dart';
import 'screens/app_cache_screen.dart';
import 'screens/pavement_clean_screen.dart';
import 'screens/thermal_trip_screen.dart';
import 'screens/sourdough_screen.dart';
import 'screens/roller_shutter_screen.dart';
import 'screens/beach_gear_screen.dart';
import 'screens/bocce_meetup_screen.dart';
import 'screens/disco_retro_screen.dart';
import 'screens/car_oil_screen.dart';
import 'screens/pram_access_screen.dart';
import 'screens/balcony_herb_screen.dart';
import 'screens/bazaar_photo_screen.dart';
import 'screens/access_panel_screen.dart';
import 'screens/bench_paint_screen.dart';
import 'screens/sudety_trip_screen.dart';
import 'screens/fruit_preserve_screen.dart';
import 'screens/home_safe_screen.dart';
import 'screens/bike_child_screen.dart';
import 'screens/badminton_meetup_screen.dart';
import 'screens/jazz_blues_screen.dart';
import 'screens/smoke_alarm_screen.dart';
import 'screens/sourdough_shop_screen.dart';
import 'screens/pet_bird_screen.dart';
import 'screens/pavilion_photo_screen.dart';
import 'screens/network_api_screen.dart';
import 'screens/parking_mark_screen.dart';
import 'screens/bieszczady_trip_screen.dart';
import 'screens/fruit_vinegar_screen.dart';
import 'screens/video_intercom_screen.dart';
import 'screens/baby_carrier_screen.dart';
import 'screens/tennis_squash_screen.dart';
import 'screens/classical_opera_screen.dart';
import 'screens/pitcher_filter_screen.dart';
import 'screens/clothes_bin_screen.dart';
import 'screens/aqua_stock_screen.dart';
import 'screens/school_photo_screen.dart';
import 'screens/home_shortcuts_screen.dart';
import 'screens/neighbor_hub_screen.dart';
import 'screens/sidewalk_salt_screen.dart';
import 'screens/landscape_park_trip_screen.dart';
import 'screens/veggie_pickle_screen.dart';
import 'screens/radiator_thermo_screen.dart';
import 'screens/archery_gear_screen.dart';
import 'screens/yard_game_screen.dart';
import 'screens/polish_film_screen.dart';
import 'screens/safety_kit_screen.dart';
import 'screens/soda_co2_screen.dart';
import 'screens/terrarium_pet_screen.dart';
import 'screens/park_photo_screen.dart';
import 'screens/sound_alert_screen.dart';
import 'screens/venue_booking_screen.dart';
import 'screens/walking_bus_screen.dart';
import 'screens/widzew_history_screen.dart';
import 'screens/culture_events_screen.dart';
import 'screens/lost_found_screen.dart';
import 'screens/media_outages_screen.dart';
import 'screens/odd_jobs_screen.dart';
import 'screens/shared_tools_screen.dart';
import 'screens/staircase_fund_screen.dart';
import 'screens/craft_makers_screen.dart';
import 'screens/home_assistant_screen.dart';
import 'screens/neighbor_templates_screen.dart';
import 'screens/safety_patrol_screen.dart';
import 'screens/tutoring_screen.dart';
import 'screens/book_shelf_screen.dart';
import 'screens/carpool_screen.dart';
import 'screens/charity_drives_screen.dart';
import 'screens/flea_market_screen.dart';
import 'screens/infrastructure_screen.dart';
import 'screens/pet_sit_screen.dart';
import 'screens/sport_meetups_screen.dart';
import 'screens/parcel_locker_screen.dart';
import 'screens/parents_club_screen.dart';
import 'screens/plant_swap_screen.dart';
import 'screens/senior_corner_screen.dart';
import 'screens/time_bank_screen.dart';
import 'screens/waste_points_screen.dart';
import 'screens/neighbor_qr_screen.dart';
import 'screens/neighborhood_groups_screen.dart';
import 'screens/neighborhood_services_screen.dart';
import 'screens/qr_scan_screen.dart';
import 'screens/saved_announcements_screen.dart';
import 'services/app_store.dart';
import 'models/neighborhood_geo.dart';
import 'services/local_push_service.dart';
import 'services/badge_service.dart';
import 'services/board_safety.dart';
import 'services/stats_service.dart';
import 'services/neighbor_profile_store.dart';
import 'services/tradesperson_store.dart';
import 'models/tradesperson_marketplace.dart';
import 'services/widzew_location.dart';
import 'services/network_gate.dart';
import 'utils/neighbor_share.dart';
import 'widgets/app_page_route.dart';
import 'widgets/offline_banner.dart';
import 'widgets/splash_view.dart';
import 'widgets/widzew_system_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(LokalnieWidzewApp(networkGate: ConnectivityNetworkGate()));
}

class LokalnieWidzewApp extends StatefulWidget {
  final AppStore? store;
  final NetworkGate? networkGate;

  const LokalnieWidzewApp({super.key, this.store, this.networkGate});

  @override
  State<LokalnieWidzewApp> createState() => _LokalnieWidzewAppState();
}

class _LokalnieWidzewAppState extends State<LokalnieWidzewApp> {
  late final AppStore _store;
  AppSnapshot? _snapshot;
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _store = widget.store ?? AppStoreFactory.local();
    _loadSnapshot();
  }

  Future<void> _loadSnapshot() async {
    AppSnapshot snapshot;
    try {
      snapshot = await _store.load();
    } catch (error) {
      PrivacyLog.debug('Nie udało się odczytać danych lokalnych', error);
      snapshot = AppSnapshot.initial();
    }
    if (mounted) setState(() => _snapshot = snapshot);
  }

  void _saveSnapshot(AppSnapshot snapshot) {
    setState(() => _snapshot = snapshot);
    unawaited(_persistSnapshot(snapshot));
  }

  Future<void> _persistSnapshot(AppSnapshot snapshot) async {
    try {
      await _store.save(snapshot);
    } catch (error) {
      PrivacyLog.debug('Nie udało się zapisać danych lokalnych', error);
      _messengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text(StorageGuard.diskFullMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;
    if (snapshot == null) {
      return MaterialApp(
        title: AppInfo.name,
        scaffoldMessengerKey: _messengerKey,
        debugShowCheckedModeBanner: false,
        theme: WidzewTheme.light(),
        locale: const Locale('pl'),
        supportedLocales: const [Locale('pl'), Locale('uk'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => WidzewSystemUi(
          child: AppLocalizations(
            locale: AppLocale.pl,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
        home: const SplashView(),
      );
    }

    return MaterialApp(
      title: AppInfo.name,
      scaffoldMessengerKey: _messengerKey,
      debugShowCheckedModeBanner: false,
      theme: WidzewTheme.light(
        seniorMode: snapshot.seniorMode,
        driverMode: snapshot.driverMode,
        skin: snapshot.widzewSkin,
        highContrast: snapshot.accessHighContrast,
        readability: snapshot.accessReadability,
      ),
      darkTheme: WidzewTheme.dark(
        seniorMode: snapshot.seniorMode,
        driverMode: snapshot.driverMode,
        skin: snapshot.widzewSkin,
        highContrast: snapshot.accessHighContrast,
        readability: snapshot.accessReadability,
      ),
      themeMode: snapshot.themePreference.themeMode,
      locale: snapshot.appLocale.locale,
      supportedLocales: const [Locale('pl'), Locale('uk'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return WidzewSystemUi(
          child: AppLocalizations(
            locale: snapshot.appLocale,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  (snapshot.driverMode
                          ? 1.4
                          : snapshot.seniorMode
                          ? 1.28
                          : 1.0) *
                      snapshot.accessTextScale,
                ),
              ),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
      home: MainTabScreen(
        key: const ValueKey('main-tabs'),
        initialSnapshot: snapshot,
        onSnapshotChanged: _saveSnapshot,
        networkGate: widget.networkGate ?? const AlwaysOnlineGate(),
      ),
    );
  }
}

class MainTabScreen extends StatefulWidget {
  final AppSnapshot initialSnapshot;
  final ValueChanged<AppSnapshot> onSnapshotChanged;
  final NetworkGate networkGate;

  const MainTabScreen({
    super.key,
    required this.initialSnapshot,
    required this.onSnapshotChanged,
    this.networkGate = const AlwaysOnlineGate(),
  });

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;
  late List<Announcement> _announcements;
  late String _userName;
  var _avatarIndex = 0;
  String? _avatarPhotoPath;
  var _locationVerified = false;
  var _marketplace = const MarketplaceState();
  var _exploredSubDistricts = <String>[];
  Announcement? _helpChatAnnouncement;
  late String _defaultSubDistrict;
  late bool _isDarkMode;
  late AppThemePreference _themePreference;
  late WidzewSkin _widzewSkin;
  late int _createdAnnouncementCount;
  late bool _neighborhoodNotificationsEnabled;
  late List<NeighborhoodPoll> _polls;
  late List<NeighborhoodEvent> _events;
  late List<String> _searchHistory;
  late List<NeighborMessage> _messages;
  String? _activeConversationId;
  late NotificationRadius _notificationRadius;
  late List<String> _notificationCategories;
  late bool _seniorMode;
  late AppLocale _appLocale;
  late bool _onboardingCompleted;
  late StartDestination _startDestination;
  late List<NeighborService> _services;
  late List<NeighborhoodClub> _clubs;
  late List<CooperativeNotice> _cooperativeNotices;
  late List<EcoReport> _ecoReports;
  late List<FoodSpot> _foodSpots;
  late List<LocalDeal> _localDeals;
  late List<NeighborReminder> _reminders;
  late bool _driverMode;
  late List<BookOffer> _bookOffers;
  late List<TimeBankOffer> _timeBankOffers;
  late int _timeBankHours;
  late List<String> _favoriteStreets;
  late List<ParcelLocker> _parcelLockers;
  late List<CharityDrive> _charityDrives;
  late List<CarpoolRide> _carpoolRides;
  late List<InfrastructureReport> _infrastructureReports;
  late List<FleaMarketItem> _fleaMarketItems;
  late List<SportMeetup> _sportMeetups;
  late List<PetSitOffer> _petSitOffers;
  late List<SeniorOffer> _seniorOffers;
  late List<PlantSwapOffer> _plantSwaps;
  late List<ParentMeetup> _parentMeetups;
  late List<BarterOffer> _barterOffers;
  late List<CraftMaker> _craftMakers;
  late List<TutoringOffer> _tutoringOffers;
  late List<SafetyAlert> _safetyAlerts;
  late List<HomeDuty> _homeDuties;
  late List<NeighborTemplate> _neighborTemplates;
  late List<OddJob> _oddJobs;
  late List<LostFoundItem> _lostFoundItems;
  late List<StaircaseFund> _staircaseFunds;
  late List<SharedTool> _sharedTools;
  late List<MediaOutage> _mediaOutages;
  late List<CultureEvent> _cultureEvents;
  late List<MarketStall> _marketStalls;
  late List<BulkBuy> _bulkBuys;
  late List<VenueSlot> _venueSlots;
  late List<WalkingBusShift> _walkingBusShifts;
  late List<HistoryStory> _historyStories;
  late bool _historyPatriotUnlocked;
  late List<EnergyExperience> _energyExperiences;
  late List<RetroItOffer> _retroItOffers;
  late List<CostSplit> _costSplits;
  late List<BikeHelpRequest> _bikeHelps;
  late List<BikeRack> _bikeRacks;
  late List<DiyWorkshop> _diyWorkshops;
  late List<BloodDrive> _bloodDrives;
  late List<GarageListing> _garageListings;
  late List<PetVaccineReminder> _petVaccineReminders;
  late List<VetClinic> _vetClinics;
  late List<PartyGear> _partyGear;
  late List<DroneAlert> _droneAlerts;
  late List<CraftPassageService> _craftPassageServices;
  late List<BlockRanking> _blockRankings;
  late int _completedInitiatives;
  late List<EcoCollectionDrive> _ecoCollections;
  late List<CaretakerNote> _caretakerNotes;
  late List<LongDistanceRide> _longDistanceRides;
  late List<SmileGift> _smileGifts;
  late List<FoodShareOffer> _foodShares;
  late List<MedicalGearItem> _medicalGear;
  late List<LeftoverMaterial> _leftoverMaterials;
  late List<FaunaSighting> _faunaSightings;
  late List<NeighborRecipe> _neighborRecipes;
  late List<KidsCreation> _kidsCreations;
  late List<TimelineEra> _timelineEras;
  late List<String> _pinnedAnnouncementKeys;
  late List<String> _blockedAnnouncementKeys;
  late List<EvChargingOffer> _evChargingOffers;
  late List<TailorOffer> _tailorOffers;
  late List<StudentRide> _studentRides;
  late List<GrillEvent> _grillEvents;
  late List<PortableGrill> _portableGrills;
  late List<PlaygroundReport> _playgroundReports;
  late List<CampGearItem> _campGear;
  late List<SchoolBookListing> _schoolBooks;
  late List<OpenAirShow> _openAirShows;
  late List<DigitalHelpOffer> _digitalHelpOffers;
  late List<LedSwapItem> _ledSwaps;
  late List<JasienSpot> _jasienSpots;
  late List<BikeRepairStation> _bikeStations;
  late List<HandyJob> _handyJobs;
  late List<WinterHelpOffer> _winterHelps;
  late List<BoardGameNight> _boardGameNights;
  late List<WildlifeCareReport> _wildlifeCares;
  late List<FitnessGearItem> _fitnessGear;
  late List<SmallAppliance> _smallAppliances;
  late List<BulkWasteReport> _bulkWastes;
  late List<RetroGamingEvent> _retroEvents;
  late List<ArchitectureSpot> _architectureSpots;
  late List<RodShare> _rodShares;
  late List<BlockPushNotice> _blockPushNotices;
  late String _homeBlockNumber;
  late String _homeStaircase;
  late List<BlockPushKind> _blockPushKinds;
  late List<VinylSwapItem> _vinylSwaps;
  late List<GardenNote> _gardenNotes;
  late List<NightCarpoolRide> _nightCarpools;
  late List<CraftWorkshopOffer> _craftWorkshops;
  late List<BikeTrip> _bikeTrips;
  late List<SchoolEcoDrive> _schoolEcoDrives;
  late List<PhotoClubItem> _photoClubItems;
  late List<CrossingReport> _crossingReports;
  late List<AvGearItem> _avGear;
  late List<WorkwearItem> _workwearItems;
  late List<GreenPathSpot> _greenPaths;
  late int _neighborQuestPoints;
  late List<String> _unlockedNeighborQuestIds;
  late List<MicroBusiness> _microBusinesses;
  late List<HomeSitRequest> _homeSits;
  late List<WorkshopTool> _workshopTools;
  late List<ConsoleTourney> _consoleTourneys;
  late List<PetBloodDonor> _petBloodDonors;
  late List<JarSwapOffer> _jarSwaps;
  late List<BabyGearItem> _babyGear;
  late List<YouthCodeWorkshop> _youthWorkshops;
  late List<GenerationBridgeOffer> _generationBridges;
  late List<FoundPlateAlert> _foundPlates;
  late List<IndustrialSpot> _industrialSpots;
  late HomeStatsConfig _homeStatsConfig;
  late List<FireSafetyReport> _fireSafetyReports;
  late List<CompostSwap> _compostSwaps;
  late List<MobileCraftPro> _mobileCraftPros;
  late List<SportHubItem> _sportHubItems;
  late List<AnimalPatrolReport> _animalPatrols;
  late List<WeekendTrip> _weekendTrips;
  late List<TrailerShare> _trailerShares;
  late List<PrlFurniturePost> _prlFurniture;
  late List<CineScreening> _cineScreenings;
  late List<SlabMemory> _slabMemories;
  late List<StaircaseCodeNote> _staircaseCodes;
  late bool _staircaseCodesUnlocked;
  late List<AirSensorReading> _airSensors;
  late List<PowerShareOffer> _powerShares;
  late List<WildDumpReport> _wildDumps;
  late List<SafetyWorkshop> _safetyWorkshops;
  late List<CargoCarpoolOffer> _cargoCarpools;
  late List<CollectorItem> _collectorItems;
  late List<LegoSwapItem> _legoSwaps;
  late List<ChessChallenge> _chessChallenges;
  late List<LocalArtWork> _localArtWorks;
  late List<MemorialSpot> _memorialSpots;
  late List<MedicineOffer> _medicineOffers;
  late List<VoltageOutageReport> _voltageOutages;
  late List<ParkingShareOffer> _parkingShares;
  late List<BlockToolItem> _blockTools;
  late List<MushroomTrip> _mushroomTrips;
  late List<SmileTutorOffer> _smileTutors;
  late List<UpcycleOffer> _upcycleOffers;
  late List<ClassicCarMeetup> _classicCarMeetups;
  late List<WalkFindReport> _walkFinds;
  late List<GreenWastePickup> _greenWastePickups;
  late List<TimeCapsuleEntry> _timeCapsuleEntries;
  late List<EmergencyRentalItem> _emergencyRentals;
  late HomeModuleVisibility _homeModuleVisibility;
  late List<HeatAlert> _heatAlerts;
  late List<MallCarpoolRide> _mallCarpools;
  late List<PramRackNotice> _pramRacks;
  late List<RtvRepairSession> _rtvRepairs;
  late List<KidCostumeOffer> _kidCostumes;
  late List<ModelFairItem> _modelFairItems;
  late List<FishingPost> _fishingPosts;
  late List<FinanceTip> _financeTips;
  late List<WildlifeShelter> _wildlifeShelters;
  late List<PetProReview> _petProReviews;
  late List<StreetArchiveEntry> _streetArchive;
  late List<SmogFilterOffer> _smogFilters;
  late List<WaterPressureReport> _waterPressures;
  late List<SolarSharePost> _solarPosts;
  late List<Print3dOffer> _print3dOffers;
  late List<SportKitOffer> _sportKits;
  late List<SeniorShopOffer> _seniorShops;
  late List<ParkChessMeetup> _parkChessMeetups;
  late List<ScamAlert> _scamAlerts;
  late List<StreetArtSpot> _streetArtSpots;
  late List<PlantHotelStay> _plantHotelStays;
  late List<WindowViewPhoto> _windowViews;
  late List<AppErrorLog> _errorLogs;
  late bool _diagnosticsUnlocked;
  var _diagnosticsTapCount = 0;
  late List<StairCleanSlot> _stairCleans;
  late List<AirportRide> _airportRides;
  late List<EnergyRecipe> _energyRecipes;
  late List<GardenToolCareOffer> _gardenToolCares;
  late List<LangBookOffer> _langBooks;
  late List<StreetballMeetup> _streetballMeetups;
  late List<IndieCinemaPost> _indieCinemaPosts;
  late List<LostPetAlert> _lostPets;
  late List<EwastePoint> _ewastePoints;
  late List<FilamentShareOffer> _filamentShares;
  late List<IndustryMemory> _industryMemories;
  late List<MpoBulkySlot> _bulkySlots;
  late List<HolyCrossTrip> _holyCrossTrips;
  late List<PreserveJarOffer> _preserveJars;
  late List<PcvWindowTip> _pcvWindows;
  late List<SchoolGearOffer> _schoolGear;
  late List<TableSportMeetup> _tableSports;
  late List<PolishFantasyOffer> _fantasyOffers;
  late List<GasInspection> _gasInspections;
  late List<ScooterHub> _scooterHubs;
  late List<HepaTracker> _hepaTrackers;
  late List<WidzewFilmClip> _filmClips;
  late List<BalconyWashSlot> _balconyWashes;
  late List<ForestForageTrip> _forestForageTrips;
  late List<EcoCleanRecipe> _ecoCleanRecipes;
  late List<LockCareTip> _lockCareTips;
  late List<SeasonalSkateOffer> _seasonalSkates;
  late List<DartBilliardMeetup> _dartBilliards;
  late List<RockMetalPost> _rockMetalPosts;
  late List<CarPolicyReminder> _carPolicies;
  late List<PhoneChargeHub> _phoneChargeHubs;
  late List<AirPlantGuide> _airPlants;
  late List<TramPhotoClip> _tramPhotos;
  late bool _localVaultPinEnabled;
  late String _localVaultPin;
  late bool _biometricUnlockEnabled;
  late List<CarpetVacOffer> _carpetVacs;
  late List<KayakTrip> _kayakTrips;
  late List<LunchboxRecipe> _lunchboxes;
  late List<GardenFurnitureTip> _gardenFurnitureTips;
  late List<PuzzleSwapOffer> _puzzleSwaps;
  late List<AmateurTheaterMeetup> _amateurTheaters;
  late List<ElectroAmbientPost> _electroAmbientPosts;
  late List<WaterFilterReminder> _waterFilters;
  late List<FarmStall> _farmStalls;
  late List<AquariumSwapOffer> _aquariumSwaps;
  late List<CinemaPhotoClip> _cinemaPhotos;
  late int _appCacheKb;
  late String _cacheRefreshedAt;
  late List<PavementCleanSlot> _pavementCleans;
  late List<ThermalTrip> _thermalTrips;
  late List<SourdoughRecipe> _sourdoughRecipes;
  late List<RollerShutterTip> _rollerShutters;
  late List<BeachGearOffer> _beachGear;
  late List<BocceMeetup> _bocceMeetups;
  late List<DiscoRetroPost> _discoRetroPosts;
  late List<CarOilReminder> _carOilReminders;
  late List<PramAccessSpot> _pramAccessSpots;
  late List<BalconyHerbOffer> _balconyHerbs;
  late List<BazaarPhotoClip> _bazaarPhotos;
  late double _accessTextScale;
  late bool _accessHighContrast;
  late bool _accessReadability;
  late List<BenchPaintSlot> _benchPaints;
  late List<SudetyTrip> _sudetyTrips;
  late List<FruitPreserveRecipe> _fruitPreserves;
  late List<HomeSafeTip> _homeSafes;
  late List<BikeChildOffer> _bikeChildOffers;
  late List<BadmintonMeetup> _badmintonMeetups;
  late List<JazzBluesPost> _jazzBluesPosts;
  late List<SmokeAlarmReminder> _smokeAlarms;
  late List<SourdoughShop> _sourdoughShops;
  late List<PetBirdOffer> _petBirds;
  late List<PavilionPhotoClip> _pavilionPhotos;
  late bool _apiLastPingOk;
  late String _apiSyncAt;
  late List<ParkingMarkReport> _parkingMarks;
  late List<BieszczadyTrip> _bieszczadyTrips;
  late List<FruitVinegarRecipe> _fruitVinegars;
  late List<VideoIntercomTip> _videoIntercoms;
  late List<BabyCarrierOffer> _babyCarriers;
  late List<TennisSquashMeetup> _tennisSquashMeetups;
  late List<ClassicalOperaPost> _classicalOperaPosts;
  late List<PitcherFilterLog> _pitcherFilters;
  late List<ClothesBinSpot> _clothesBins;
  late List<AquaStockOffer> _aquaLivestock;
  late List<SchoolPhotoClip> _schoolPhotos;
  late List<String> _homeTileOrder;
  late List<String> _homePinnedTools;
  late List<SidewalkSaltReport> _sidewalkSalts;
  late List<LandscapeParkTrip> _landscapeParkTrips;
  late List<VeggiePickleRecipe> _veggiePickles;
  late List<RadiatorThermoTip> _radiatorThermos;
  late List<ArcheryGearOffer> _archeryGear;
  late List<YardGameMeetup> _yardGames;
  late List<PolishFilmPost> _polishFilms;
  late List<SafetyKitLog> _safetyKits;
  late List<SodaCo2Spot> _sodaCo2Spots;
  late List<TerrariumOffer> _terrariumPets;
  late List<ParkPhotoClip> _parkPhotos;
  late SoundAlertPrefs _soundAlerts;
  var _groupsLanding = false;
  late bool _isOnline;
  StreamSubscription<bool>? _networkSubscription;
  final Set<String> _hiddenAnnouncementKeys = {};

  String _announcementKey(Announcement announcement) =>
      announcement.publishedAt.toIso8601String();

  List<Announcement> get _feedAnnouncements => _announcements
      .where(
        (announcement) =>
            !_hiddenAnnouncementKeys.contains(_announcementKey(announcement)),
      )
      .toList();

  @override
  void initState() {
    super.initState();
    final initial = widget.initialSnapshot;
    _announcements = List.of(initial.announcements);
    _userName = initial.userName;
    _defaultSubDistrict = initial.defaultSubDistrict;
    _isDarkMode = initial.isDarkMode;
    _themePreference = initial.themePreference;
    _widzewSkin = initial.widzewSkin;
    _createdAnnouncementCount = initial.createdAnnouncementCount;
    _neighborhoodNotificationsEnabled =
        initial.neighborhoodNotificationsEnabled;
    _polls = List.of(initial.polls);
    _events = List.of(initial.events);
    _searchHistory = List.of(initial.searchHistory);
    _messages = List.of(initial.messages);
    _notificationRadius = initial.notificationRadius;
    _notificationCategories = const [];
    _seniorMode = initial.seniorMode;
    _appLocale = initial.appLocale;
    _onboardingCompleted = initial.onboardingCompleted;
    _startDestination = initial.startDestination;
    _services = List.of(initial.services);
    _clubs = List.of(initial.clubs);
    _cooperativeNotices = List.of(initial.cooperativeNotices);
    _ecoReports = List.of(initial.ecoReports);
    _foodSpots = List.of(initial.foodSpots);
    _localDeals = List.of(initial.localDeals);
    _reminders = List.of(initial.reminders);
    _driverMode = initial.driverMode;
    _bookOffers = List.of(initial.bookOffers);
    _timeBankOffers = List.of(initial.timeBankOffers);
    _timeBankHours = initial.timeBankHours;
    _favoriteStreets = const [];
    _parcelLockers = List.of(initial.parcelLockers);
    _charityDrives = List.of(initial.charityDrives);
    _carpoolRides = List.of(initial.carpoolRides);
    _infrastructureReports = List.of(initial.infrastructureReports);
    _fleaMarketItems = List.of(initial.fleaMarketItems);
    _sportMeetups = List.of(initial.sportMeetups);
    _petSitOffers = List.of(initial.petSitOffers);
    _seniorOffers = List.of(initial.seniorOffers);
    _plantSwaps = List.of(initial.plantSwaps);
    _parentMeetups = List.of(initial.parentMeetups);
    _barterOffers = List.of(initial.barterOffers);
    _craftMakers = List.of(initial.craftMakers);
    _tutoringOffers = List.of(initial.tutoringOffers);
    _safetyAlerts = List.of(initial.safetyAlerts);
    _homeDuties = List.of(initial.homeDuties);
    _neighborTemplates = List.of(initial.neighborTemplates);
    _oddJobs = List.of(initial.oddJobs);
    _lostFoundItems = List.of(initial.lostFoundItems);
    _staircaseFunds = List.of(initial.staircaseFunds);
    _sharedTools = List.of(initial.sharedTools);
    _mediaOutages = List.of(initial.mediaOutages);
    _cultureEvents = List.of(initial.cultureEvents);
    _marketStalls = List.of(initial.marketStalls);
    _bulkBuys = List.of(initial.bulkBuys);
    _venueSlots = List.of(initial.venueSlots);
    _walkingBusShifts = List.of(initial.walkingBusShifts);
    _historyStories = List.of(initial.historyStories);
    _historyPatriotUnlocked = initial.historyPatriotUnlocked;
    _energyExperiences = List.of(initial.energyExperiences);
    _retroItOffers = List.of(initial.retroItOffers);
    _costSplits = List.of(initial.costSplits);
    _bikeHelps = List.of(initial.bikeHelps);
    _bikeRacks = List.of(initial.bikeRacks);
    _diyWorkshops = List.of(initial.diyWorkshops);
    _bloodDrives = List.of(initial.bloodDrives);
    _garageListings = List.of(initial.garageListings);
    _petVaccineReminders = List.of(initial.petVaccineReminders);
    _vetClinics = List.of(initial.vetClinics);
    _partyGear = List.of(initial.partyGear);
    _droneAlerts = List.of(initial.droneAlerts);
    _craftPassageServices = List.of(initial.craftPassageServices);
    _blockRankings = List.of(initial.blockRankings);
    _completedInitiatives = initial.completedInitiatives;
    _ecoCollections = List.of(initial.ecoCollections);
    _caretakerNotes = List.of(initial.caretakerNotes);
    _longDistanceRides = List.of(initial.longDistanceRides);
    _smileGifts = List.of(initial.smileGifts);
    _foodShares = List.of(initial.foodShares);
    _medicalGear = List.of(initial.medicalGear);
    _leftoverMaterials = List.of(initial.leftoverMaterials);
    _faunaSightings = List.of(initial.faunaSightings);
    _neighborRecipes = List.of(initial.neighborRecipes);
    _kidsCreations = List.of(initial.kidsCreations);
    _timelineEras = List.of(initial.timelineEras);
    _pinnedAnnouncementKeys = List.of(initial.pinnedAnnouncementKeys);
    _blockedAnnouncementKeys = List.of(initial.blockedAnnouncementKeys);
    _evChargingOffers = List.of(initial.evChargingOffers);
    _tailorOffers = List.of(initial.tailorOffers);
    _studentRides = List.of(initial.studentRides);
    _grillEvents = List.of(initial.grillEvents);
    _portableGrills = List.of(initial.portableGrills);
    _playgroundReports = List.of(initial.playgroundReports);
    _campGear = List.of(initial.campGear);
    _schoolBooks = List.of(initial.schoolBooks);
    _openAirShows = List.of(initial.openAirShows);
    _digitalHelpOffers = List.of(initial.digitalHelpOffers);
    _ledSwaps = List.of(initial.ledSwaps);
    _jasienSpots = List.of(initial.jasienSpots);
    _bikeStations = List.of(initial.bikeStations);
    _handyJobs = List.of(initial.handyJobs);
    _winterHelps = List.of(initial.winterHelps);
    _boardGameNights = List.of(initial.boardGameNights);
    _wildlifeCares = List.of(initial.wildlifeCares);
    _fitnessGear = List.of(initial.fitnessGear);
    _smallAppliances = List.of(initial.smallAppliances);
    _bulkWastes = List.of(initial.bulkWastes);
    _retroEvents = List.of(initial.retroEvents);
    _architectureSpots = List.of(initial.architectureSpots);
    _rodShares = List.of(initial.rodShares);
    _blockPushNotices = List.of(initial.blockPushNotices);
    _homeBlockNumber = initial.homeBlockNumber;
    _homeStaircase = initial.homeStaircase;
    _blockPushKinds = List.of(initial.blockPushKinds);
    _vinylSwaps = List.of(initial.vinylSwaps);
    _gardenNotes = List.of(initial.gardenNotes);
    _nightCarpools = List.of(initial.nightCarpools);
    _craftWorkshops = List.of(initial.craftWorkshops);
    _bikeTrips = List.of(initial.bikeTrips);
    _schoolEcoDrives = List.of(initial.schoolEcoDrives);
    _photoClubItems = List.of(initial.photoClubItems);
    _crossingReports = List.of(initial.crossingReports);
    _avGear = List.of(initial.avGear);
    _workwearItems = List.of(initial.workwearItems);
    _greenPaths = List.of(initial.greenPaths);
    _neighborQuestPoints = initial.neighborQuestPoints;
    _unlockedNeighborQuestIds = List.of(initial.unlockedNeighborQuestIds);
    _microBusinesses = List.of(initial.microBusinesses);
    _homeSits = List.of(initial.homeSits);
    _workshopTools = List.of(initial.workshopTools);
    _consoleTourneys = List.of(initial.consoleTourneys);
    _petBloodDonors = List.of(initial.petBloodDonors);
    _jarSwaps = List.of(initial.jarSwaps);
    _babyGear = List.of(initial.babyGear);
    _youthWorkshops = List.of(initial.youthWorkshops);
    _generationBridges = List.of(initial.generationBridges);
    _foundPlates = List.of(initial.foundPlates);
    _industrialSpots = List.of(initial.industrialSpots);
    _homeStatsConfig = initial.homeStatsConfig;
    _fireSafetyReports = List.of(initial.fireSafetyReports);
    _compostSwaps = List.of(initial.compostSwaps);
    _mobileCraftPros = List.of(initial.mobileCraftPros);
    _sportHubItems = List.of(initial.sportHubItems);
    _animalPatrols = List.of(initial.animalPatrols);
    _weekendTrips = List.of(initial.weekendTrips);
    _trailerShares = List.of(initial.trailerShares);
    _prlFurniture = List.of(initial.prlFurniture);
    _cineScreenings = List.of(initial.cineScreenings);
    _slabMemories = List.of(initial.slabMemories);
    _staircaseCodes = List.of(initial.staircaseCodes);
    _staircaseCodesUnlocked = initial.staircaseCodesUnlocked;
    _airSensors = List.of(initial.airSensors);
    _powerShares = List.of(initial.powerShares);
    _wildDumps = List.of(initial.wildDumps);
    _safetyWorkshops = List.of(initial.safetyWorkshops);
    _cargoCarpools = List.of(initial.cargoCarpools);
    _collectorItems = List.of(initial.collectorItems);
    _legoSwaps = List.of(initial.legoSwaps);
    _chessChallenges = List.of(initial.chessChallenges);
    _localArtWorks = List.of(initial.localArtWorks);
    _memorialSpots = List.of(initial.memorialSpots);
    _medicineOffers = List.of(initial.medicineOffers);
    _voltageOutages = List.of(initial.voltageOutages);
    _parkingShares = List.of(initial.parkingShares);
    _blockTools = List.of(initial.blockTools);
    _mushroomTrips = List.of(initial.mushroomTrips);
    _smileTutors = List.of(initial.smileTutors);
    _upcycleOffers = List.of(initial.upcycleOffers);
    _classicCarMeetups = List.of(initial.classicCarMeetups);
    _walkFinds = List.of(initial.walkFinds);
    _greenWastePickups = List.of(initial.greenWastePickups);
    _timeCapsuleEntries = List.of(initial.timeCapsuleEntries);
    _emergencyRentals = List.of(initial.emergencyRentals);
    _homeModuleVisibility = initial.homeModuleVisibility;
    _heatAlerts = List.of(initial.heatAlerts);
    _mallCarpools = List.of(initial.mallCarpools);
    _pramRacks = List.of(initial.pramRacks);
    _rtvRepairs = List.of(initial.rtvRepairs);
    _kidCostumes = List.of(initial.kidCostumes);
    _modelFairItems = List.of(initial.modelFairItems);
    _fishingPosts = List.of(initial.fishingPosts);
    _financeTips = List.of(initial.financeTips);
    _wildlifeShelters = List.of(initial.wildlifeShelters);
    _petProReviews = List.of(initial.petProReviews);
    _streetArchive = List.of(initial.streetArchive);
    _smogFilters = List.of(initial.smogFilters);
    _waterPressures = List.of(initial.waterPressures);
    _solarPosts = List.of(initial.solarPosts);
    _print3dOffers = List.of(initial.print3dOffers);
    _sportKits = List.of(initial.sportKits);
    _seniorShops = List.of(initial.seniorShops);
    _parkChessMeetups = List.of(initial.parkChessMeetups);
    _scamAlerts = List.of(initial.scamAlerts);
    _streetArtSpots = List.of(initial.streetArtSpots);
    _plantHotelStays = List.of(initial.plantHotelStays);
    _windowViews = List.of(initial.windowViews);
    _errorLogs = List.of(initial.errorLogs);
    _diagnosticsUnlocked = initial.diagnosticsUnlocked;
    _stairCleans = List.of(initial.stairCleans);
    _airportRides = List.of(initial.airportRides);
    _energyRecipes = List.of(initial.energyRecipes);
    _gardenToolCares = List.of(initial.gardenToolCares);
    _langBooks = List.of(initial.langBooks);
    _streetballMeetups = List.of(initial.streetballMeetups);
    _indieCinemaPosts = List.of(initial.indieCinemaPosts);
    _lostPets = List.of(initial.lostPets);
    _ewastePoints = List.of(initial.ewastePoints);
    _filamentShares = List.of(initial.filamentShares);
    _industryMemories = List.of(initial.industryMemories);
    _bulkySlots = List.of(initial.bulkySlots);
    _holyCrossTrips = List.of(initial.holyCrossTrips);
    _preserveJars = List.of(initial.preserveJars);
    _pcvWindows = List.of(initial.pcvWindows);
    _schoolGear = List.of(initial.schoolGear);
    _tableSports = List.of(initial.tableSports);
    _fantasyOffers = List.of(initial.fantasyOffers);
    _gasInspections = List.of(initial.gasInspections);
    _scooterHubs = List.of(initial.scooterHubs);
    _hepaTrackers = List.of(initial.hepaTrackers);
    _filmClips = List.of(initial.filmClips);
    _balconyWashes = List.of(initial.balconyWashes);
    _forestForageTrips = List.of(initial.forestForageTrips);
    _ecoCleanRecipes = List.of(initial.ecoCleanRecipes);
    _lockCareTips = List.of(initial.lockCareTips);
    _seasonalSkates = List.of(initial.seasonalSkates);
    _dartBilliards = List.of(initial.dartBilliards);
    _rockMetalPosts = List.of(initial.rockMetalPosts);
    _carPolicies = List.of(initial.carPolicies);
    _phoneChargeHubs = List.of(initial.phoneChargeHubs);
    _airPlants = List.of(initial.airPlants);
    _tramPhotos = List.of(initial.tramPhotos);
    _localVaultPinEnabled = initial.localVaultPinEnabled;
    _localVaultPin = initial.localVaultPin;
    _biometricUnlockEnabled = initial.biometricUnlockEnabled;
    _carpetVacs = List.of(initial.carpetVacs);
    _kayakTrips = List.of(initial.kayakTrips);
    _lunchboxes = List.of(initial.lunchboxes);
    _gardenFurnitureTips = List.of(initial.gardenFurnitureTips);
    _puzzleSwaps = List.of(initial.puzzleSwaps);
    _amateurTheaters = List.of(initial.amateurTheaters);
    _electroAmbientPosts = List.of(initial.electroAmbientPosts);
    _waterFilters = List.of(initial.waterFilters);
    _farmStalls = List.of(initial.farmStalls);
    _aquariumSwaps = List.of(initial.aquariumSwaps);
    _cinemaPhotos = List.of(initial.cinemaPhotos);
    _appCacheKb = initial.appCacheKb;
    _cacheRefreshedAt = initial.cacheRefreshedAt;
    _pavementCleans = List.of(initial.pavementCleans);
    _thermalTrips = List.of(initial.thermalTrips);
    _sourdoughRecipes = List.of(initial.sourdoughRecipes);
    _rollerShutters = List.of(initial.rollerShutters);
    _beachGear = List.of(initial.beachGear);
    _bocceMeetups = List.of(initial.bocceMeetups);
    _discoRetroPosts = List.of(initial.discoRetroPosts);
    _carOilReminders = List.of(initial.carOilReminders);
    _pramAccessSpots = List.of(initial.pramAccessSpots);
    _balconyHerbs = List.of(initial.balconyHerbs);
    _bazaarPhotos = List.of(initial.bazaarPhotos);
    _accessTextScale = initial.accessTextScale;
    _accessHighContrast = initial.accessHighContrast;
    _accessReadability = initial.accessReadability;
    _benchPaints = List.of(initial.benchPaints);
    _sudetyTrips = List.of(initial.sudetyTrips);
    _fruitPreserves = List.of(initial.fruitPreserves);
    _homeSafes = List.of(initial.homeSafes);
    _bikeChildOffers = List.of(initial.bikeChildOffers);
    _badmintonMeetups = List.of(initial.badmintonMeetups);
    _jazzBluesPosts = List.of(initial.jazzBluesPosts);
    _smokeAlarms = List.of(initial.smokeAlarms);
    _sourdoughShops = List.of(initial.sourdoughShops);
    _petBirds = List.of(initial.petBirds);
    _pavilionPhotos = List.of(initial.pavilionPhotos);
    _apiLastPingOk = initial.apiLastPingOk;
    _apiSyncAt = initial.apiSyncAt;
    _parkingMarks = List.of(initial.parkingMarks);
    _bieszczadyTrips = List.of(initial.bieszczadyTrips);
    _fruitVinegars = List.of(initial.fruitVinegars);
    _videoIntercoms = List.of(initial.videoIntercoms);
    _babyCarriers = List.of(initial.babyCarriers);
    _tennisSquashMeetups = List.of(initial.tennisSquashMeetups);
    _classicalOperaPosts = List.of(initial.classicalOperaPosts);
    _pitcherFilters = List.of(initial.pitcherFilters);
    _clothesBins = List.of(initial.clothesBins);
    _aquaLivestock = List.of(initial.aquaLivestock);
    _schoolPhotos = List.of(initial.schoolPhotos);
    _homeTileOrder = List.of(initial.homeTileOrder);
    _homePinnedTools = List.of(initial.homePinnedTools);
    _sidewalkSalts = List.of(initial.sidewalkSalts);
    _landscapeParkTrips = List.of(initial.landscapeParkTrips);
    _veggiePickles = List.of(initial.veggiePickles);
    _radiatorThermos = List.of(initial.radiatorThermos);
    _archeryGear = List.of(initial.archeryGear);
    _yardGames = List.of(initial.yardGames);
    _polishFilms = List.of(initial.polishFilms);
    _safetyKits = List.of(initial.safetyKits);
    _sodaCo2Spots = List.of(initial.sodaCo2Spots);
    _terrariumPets = List.of(initial.terrariumPets);
    _parkPhotos = List.of(initial.parkPhotos);
    _soundAlerts = initial.soundAlerts;
    _hiddenAnnouncementKeys.addAll(_blockedAnnouncementKeys);
    _groupsLanding = initial.startDestination == StartDestination.groups;
    _isOnline = widget.networkGate.current;
    unawaited(LocalPushService.init());
    unawaited(LocalPushService.setEnabled(_neighborhoodNotificationsEnabled));
    unawaited(_loadNeighborProfile());
    unawaited(_loadBoardSafety());
    _networkSubscription = widget.networkGate.changes.listen((isOnline) {
      if (!mounted) return;
      final cameOnline = !_isOnline && isOnline;
      setState(() => _isOnline = isOnline);
      if (cameOnline) _flushOfflineQueue();
    });
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    super.dispose();
  }

  AppSnapshot _currentSnapshot() => AppSnapshot(
    announcements: List.unmodifiable(_announcements),
    userName: _userName,
    defaultSubDistrict: _defaultSubDistrict,
    isDarkMode: _isDarkMode,
    themePreference: _themePreference,
    widzewSkin: _widzewSkin,
    createdAnnouncementCount: _createdAnnouncementCount,
    neighborhoodNotificationsEnabled: _neighborhoodNotificationsEnabled,
    polls: List.unmodifiable(_polls),
    events: List.unmodifiable(_events),
    searchHistory: List.unmodifiable(_searchHistory),
    messages: List.unmodifiable(_messages),
    notificationRadius: _notificationRadius,
    notificationCategories: List.unmodifiable(_notificationCategories),
    seniorMode: _seniorMode,
    appLocale: _appLocale,
    onboardingCompleted: _onboardingCompleted,
    startDestination: _startDestination,
    services: List.unmodifiable(_services),
    clubs: List.unmodifiable(_clubs),
    cooperativeNotices: List.unmodifiable(_cooperativeNotices),
    ecoReports: List.unmodifiable(_ecoReports),
    foodSpots: List.unmodifiable(_foodSpots),
    localDeals: List.unmodifiable(_localDeals),
    reminders: List.unmodifiable(_reminders),
    driverMode: _driverMode,
    bookOffers: List.unmodifiable(_bookOffers),
    timeBankOffers: List.unmodifiable(_timeBankOffers),
    timeBankHours: _timeBankHours,
    favoriteStreets: List.unmodifiable(_favoriteStreets),
    parcelLockers: List.unmodifiable(_parcelLockers),
    charityDrives: List.unmodifiable(_charityDrives),
    carpoolRides: List.unmodifiable(_carpoolRides),
    infrastructureReports: List.unmodifiable(_infrastructureReports),
    fleaMarketItems: List.unmodifiable(_fleaMarketItems),
    sportMeetups: List.unmodifiable(_sportMeetups),
    petSitOffers: List.unmodifiable(_petSitOffers),
    seniorOffers: List.unmodifiable(_seniorOffers),
    plantSwaps: List.unmodifiable(_plantSwaps),
    parentMeetups: List.unmodifiable(_parentMeetups),
    barterOffers: List.unmodifiable(_barterOffers),
    craftMakers: List.unmodifiable(_craftMakers),
    tutoringOffers: List.unmodifiable(_tutoringOffers),
    safetyAlerts: List.unmodifiable(_safetyAlerts),
    homeDuties: List.unmodifiable(_homeDuties),
    neighborTemplates: List.unmodifiable(_neighborTemplates),
    oddJobs: List.unmodifiable(_oddJobs),
    lostFoundItems: List.unmodifiable(_lostFoundItems),
    staircaseFunds: List.unmodifiable(_staircaseFunds),
    sharedTools: List.unmodifiable(_sharedTools),
    mediaOutages: List.unmodifiable(_mediaOutages),
    cultureEvents: List.unmodifiable(_cultureEvents),
    marketStalls: List.unmodifiable(_marketStalls),
    bulkBuys: List.unmodifiable(_bulkBuys),
    venueSlots: List.unmodifiable(_venueSlots),
    walkingBusShifts: List.unmodifiable(_walkingBusShifts),
    historyStories: List.unmodifiable(_historyStories),
    historyPatriotUnlocked: _historyPatriotUnlocked,
    energyExperiences: List.unmodifiable(_energyExperiences),
    retroItOffers: List.unmodifiable(_retroItOffers),
    costSplits: List.unmodifiable(_costSplits),
    bikeHelps: List.unmodifiable(_bikeHelps),
    bikeRacks: List.unmodifiable(_bikeRacks),
    diyWorkshops: List.unmodifiable(_diyWorkshops),
    bloodDrives: List.unmodifiable(_bloodDrives),
    garageListings: List.unmodifiable(_garageListings),
    petVaccineReminders: List.unmodifiable(_petVaccineReminders),
    vetClinics: List.unmodifiable(_vetClinics),
    partyGear: List.unmodifiable(_partyGear),
    droneAlerts: List.unmodifiable(_droneAlerts),
    craftPassageServices: List.unmodifiable(_craftPassageServices),
    blockRankings: List.unmodifiable(_blockRankings),
    completedInitiatives: _completedInitiatives,
    ecoCollections: List.unmodifiable(_ecoCollections),
    caretakerNotes: List.unmodifiable(_caretakerNotes),
    longDistanceRides: List.unmodifiable(_longDistanceRides),
    smileGifts: List.unmodifiable(_smileGifts),
    foodShares: List.unmodifiable(_foodShares),
    medicalGear: List.unmodifiable(_medicalGear),
    leftoverMaterials: List.unmodifiable(_leftoverMaterials),
    faunaSightings: List.unmodifiable(_faunaSightings),
    neighborRecipes: List.unmodifiable(_neighborRecipes),
    kidsCreations: List.unmodifiable(_kidsCreations),
    timelineEras: List.unmodifiable(_timelineEras),
    pinnedAnnouncementKeys: List.unmodifiable(_pinnedAnnouncementKeys),
    blockedAnnouncementKeys: List.unmodifiable(_blockedAnnouncementKeys),
    evChargingOffers: List.unmodifiable(_evChargingOffers),
    tailorOffers: List.unmodifiable(_tailorOffers),
    studentRides: List.unmodifiable(_studentRides),
    grillEvents: List.unmodifiable(_grillEvents),
    portableGrills: List.unmodifiable(_portableGrills),
    playgroundReports: List.unmodifiable(_playgroundReports),
    campGear: List.unmodifiable(_campGear),
    schoolBooks: List.unmodifiable(_schoolBooks),
    openAirShows: List.unmodifiable(_openAirShows),
    digitalHelpOffers: List.unmodifiable(_digitalHelpOffers),
    ledSwaps: List.unmodifiable(_ledSwaps),
    jasienSpots: List.unmodifiable(_jasienSpots),
    bikeStations: List.unmodifiable(_bikeStations),
    handyJobs: List.unmodifiable(_handyJobs),
    winterHelps: List.unmodifiable(_winterHelps),
    boardGameNights: List.unmodifiable(_boardGameNights),
    wildlifeCares: List.unmodifiable(_wildlifeCares),
    fitnessGear: List.unmodifiable(_fitnessGear),
    smallAppliances: List.unmodifiable(_smallAppliances),
    bulkWastes: List.unmodifiable(_bulkWastes),
    retroEvents: List.unmodifiable(_retroEvents),
    architectureSpots: List.unmodifiable(_architectureSpots),
    rodShares: List.unmodifiable(_rodShares),
    blockPushNotices: List.unmodifiable(_blockPushNotices),
    homeBlockNumber: _homeBlockNumber,
    homeStaircase: _homeStaircase,
    blockPushKinds: List.unmodifiable(_blockPushKinds),
    vinylSwaps: List.unmodifiable(_vinylSwaps),
    gardenNotes: List.unmodifiable(_gardenNotes),
    nightCarpools: List.unmodifiable(_nightCarpools),
    craftWorkshops: List.unmodifiable(_craftWorkshops),
    bikeTrips: List.unmodifiable(_bikeTrips),
    schoolEcoDrives: List.unmodifiable(_schoolEcoDrives),
    photoClubItems: List.unmodifiable(_photoClubItems),
    crossingReports: List.unmodifiable(_crossingReports),
    avGear: List.unmodifiable(_avGear),
    workwearItems: List.unmodifiable(_workwearItems),
    greenPaths: List.unmodifiable(_greenPaths),
    neighborQuestPoints: _neighborQuestPoints,
    unlockedNeighborQuestIds: List.unmodifiable(_unlockedNeighborQuestIds),
    microBusinesses: List.unmodifiable(_microBusinesses),
    homeSits: List.unmodifiable(_homeSits),
    workshopTools: List.unmodifiable(_workshopTools),
    consoleTourneys: List.unmodifiable(_consoleTourneys),
    petBloodDonors: List.unmodifiable(_petBloodDonors),
    jarSwaps: List.unmodifiable(_jarSwaps),
    babyGear: List.unmodifiable(_babyGear),
    youthWorkshops: List.unmodifiable(_youthWorkshops),
    generationBridges: List.unmodifiable(_generationBridges),
    foundPlates: List.unmodifiable(_foundPlates),
    industrialSpots: List.unmodifiable(_industrialSpots),
    homeStatsConfig: _homeStatsConfig,
    fireSafetyReports: List.unmodifiable(_fireSafetyReports),
    compostSwaps: List.unmodifiable(_compostSwaps),
    mobileCraftPros: List.unmodifiable(_mobileCraftPros),
    sportHubItems: List.unmodifiable(_sportHubItems),
    animalPatrols: List.unmodifiable(_animalPatrols),
    weekendTrips: List.unmodifiable(_weekendTrips),
    trailerShares: List.unmodifiable(_trailerShares),
    prlFurniture: List.unmodifiable(_prlFurniture),
    cineScreenings: List.unmodifiable(_cineScreenings),
    slabMemories: List.unmodifiable(_slabMemories),
    staircaseCodes: List.unmodifiable(_staircaseCodes),
    staircaseCodesUnlocked: _staircaseCodesUnlocked,
    airSensors: List.unmodifiable(_airSensors),
    powerShares: List.unmodifiable(_powerShares),
    wildDumps: List.unmodifiable(_wildDumps),
    safetyWorkshops: List.unmodifiable(_safetyWorkshops),
    cargoCarpools: List.unmodifiable(_cargoCarpools),
    collectorItems: List.unmodifiable(_collectorItems),
    legoSwaps: List.unmodifiable(_legoSwaps),
    chessChallenges: List.unmodifiable(_chessChallenges),
    localArtWorks: List.unmodifiable(_localArtWorks),
    memorialSpots: List.unmodifiable(_memorialSpots),
    medicineOffers: List.unmodifiable(_medicineOffers),
    voltageOutages: List.unmodifiable(_voltageOutages),
    parkingShares: List.unmodifiable(_parkingShares),
    blockTools: List.unmodifiable(_blockTools),
    mushroomTrips: List.unmodifiable(_mushroomTrips),
    smileTutors: List.unmodifiable(_smileTutors),
    upcycleOffers: List.unmodifiable(_upcycleOffers),
    classicCarMeetups: List.unmodifiable(_classicCarMeetups),
    walkFinds: List.unmodifiable(_walkFinds),
    greenWastePickups: List.unmodifiable(_greenWastePickups),
    timeCapsuleEntries: List.unmodifiable(_timeCapsuleEntries),
    emergencyRentals: List.unmodifiable(_emergencyRentals),
    homeModuleVisibility: _homeModuleVisibility,
    heatAlerts: List.unmodifiable(_heatAlerts),
    mallCarpools: List.unmodifiable(_mallCarpools),
    pramRacks: List.unmodifiable(_pramRacks),
    rtvRepairs: List.unmodifiable(_rtvRepairs),
    kidCostumes: List.unmodifiable(_kidCostumes),
    modelFairItems: List.unmodifiable(_modelFairItems),
    fishingPosts: List.unmodifiable(_fishingPosts),
    financeTips: List.unmodifiable(_financeTips),
    wildlifeShelters: List.unmodifiable(_wildlifeShelters),
    petProReviews: List.unmodifiable(_petProReviews),
    streetArchive: List.unmodifiable(_streetArchive),
    smogFilters: List.unmodifiable(_smogFilters),
    waterPressures: List.unmodifiable(_waterPressures),
    solarPosts: List.unmodifiable(_solarPosts),
    print3dOffers: List.unmodifiable(_print3dOffers),
    sportKits: List.unmodifiable(_sportKits),
    seniorShops: List.unmodifiable(_seniorShops),
    parkChessMeetups: List.unmodifiable(_parkChessMeetups),
    scamAlerts: List.unmodifiable(_scamAlerts),
    streetArtSpots: List.unmodifiable(_streetArtSpots),
    plantHotelStays: List.unmodifiable(_plantHotelStays),
    windowViews: List.unmodifiable(_windowViews),
    errorLogs: List.unmodifiable(_errorLogs),
    diagnosticsUnlocked: _diagnosticsUnlocked,
    stairCleans: List.unmodifiable(_stairCleans),
    airportRides: List.unmodifiable(_airportRides),
    energyRecipes: List.unmodifiable(_energyRecipes),
    gardenToolCares: List.unmodifiable(_gardenToolCares),
    langBooks: List.unmodifiable(_langBooks),
    streetballMeetups: List.unmodifiable(_streetballMeetups),
    indieCinemaPosts: List.unmodifiable(_indieCinemaPosts),
    lostPets: List.unmodifiable(_lostPets),
    ewastePoints: List.unmodifiable(_ewastePoints),
    filamentShares: List.unmodifiable(_filamentShares),
    industryMemories: List.unmodifiable(_industryMemories),
    bulkySlots: List.unmodifiable(_bulkySlots),
    holyCrossTrips: List.unmodifiable(_holyCrossTrips),
    preserveJars: List.unmodifiable(_preserveJars),
    pcvWindows: List.unmodifiable(_pcvWindows),
    schoolGear: List.unmodifiable(_schoolGear),
    tableSports: List.unmodifiable(_tableSports),
    fantasyOffers: List.unmodifiable(_fantasyOffers),
    gasInspections: List.unmodifiable(_gasInspections),
    scooterHubs: List.unmodifiable(_scooterHubs),
    hepaTrackers: List.unmodifiable(_hepaTrackers),
    filmClips: List.unmodifiable(_filmClips),
    balconyWashes: List.unmodifiable(_balconyWashes),
    forestForageTrips: List.unmodifiable(_forestForageTrips),
    ecoCleanRecipes: List.unmodifiable(_ecoCleanRecipes),
    lockCareTips: List.unmodifiable(_lockCareTips),
    seasonalSkates: List.unmodifiable(_seasonalSkates),
    dartBilliards: List.unmodifiable(_dartBilliards),
    rockMetalPosts: List.unmodifiable(_rockMetalPosts),
    carPolicies: List.unmodifiable(_carPolicies),
    phoneChargeHubs: List.unmodifiable(_phoneChargeHubs),
    airPlants: List.unmodifiable(_airPlants),
    tramPhotos: List.unmodifiable(_tramPhotos),
    localVaultPinEnabled: _localVaultPinEnabled,
    localVaultPin: _localVaultPin,
    biometricUnlockEnabled: _biometricUnlockEnabled,
    carpetVacs: List.unmodifiable(_carpetVacs),
    kayakTrips: List.unmodifiable(_kayakTrips),
    lunchboxes: List.unmodifiable(_lunchboxes),
    gardenFurnitureTips: List.unmodifiable(_gardenFurnitureTips),
    puzzleSwaps: List.unmodifiable(_puzzleSwaps),
    amateurTheaters: List.unmodifiable(_amateurTheaters),
    electroAmbientPosts: List.unmodifiable(_electroAmbientPosts),
    waterFilters: List.unmodifiable(_waterFilters),
    farmStalls: List.unmodifiable(_farmStalls),
    aquariumSwaps: List.unmodifiable(_aquariumSwaps),
    cinemaPhotos: List.unmodifiable(_cinemaPhotos),
    appCacheKb: _appCacheKb,
    cacheRefreshedAt: _cacheRefreshedAt,
    pavementCleans: List.unmodifiable(_pavementCleans),
    thermalTrips: List.unmodifiable(_thermalTrips),
    sourdoughRecipes: List.unmodifiable(_sourdoughRecipes),
    rollerShutters: List.unmodifiable(_rollerShutters),
    beachGear: List.unmodifiable(_beachGear),
    bocceMeetups: List.unmodifiable(_bocceMeetups),
    discoRetroPosts: List.unmodifiable(_discoRetroPosts),
    carOilReminders: List.unmodifiable(_carOilReminders),
    pramAccessSpots: List.unmodifiable(_pramAccessSpots),
    balconyHerbs: List.unmodifiable(_balconyHerbs),
    bazaarPhotos: List.unmodifiable(_bazaarPhotos),
    accessTextScale: _accessTextScale,
    accessHighContrast: _accessHighContrast,
    accessReadability: _accessReadability,
    benchPaints: List.unmodifiable(_benchPaints),
    sudetyTrips: List.unmodifiable(_sudetyTrips),
    fruitPreserves: List.unmodifiable(_fruitPreserves),
    homeSafes: List.unmodifiable(_homeSafes),
    bikeChildOffers: List.unmodifiable(_bikeChildOffers),
    badmintonMeetups: List.unmodifiable(_badmintonMeetups),
    jazzBluesPosts: List.unmodifiable(_jazzBluesPosts),
    smokeAlarms: List.unmodifiable(_smokeAlarms),
    sourdoughShops: List.unmodifiable(_sourdoughShops),
    petBirds: List.unmodifiable(_petBirds),
    pavilionPhotos: List.unmodifiable(_pavilionPhotos),
    apiLastPingOk: _apiLastPingOk,
    apiSyncAt: _apiSyncAt,
    parkingMarks: List.unmodifiable(_parkingMarks),
    bieszczadyTrips: List.unmodifiable(_bieszczadyTrips),
    fruitVinegars: List.unmodifiable(_fruitVinegars),
    videoIntercoms: List.unmodifiable(_videoIntercoms),
    babyCarriers: List.unmodifiable(_babyCarriers),
    tennisSquashMeetups: List.unmodifiable(_tennisSquashMeetups),
    classicalOperaPosts: List.unmodifiable(_classicalOperaPosts),
    pitcherFilters: List.unmodifiable(_pitcherFilters),
    clothesBins: List.unmodifiable(_clothesBins),
    aquaLivestock: List.unmodifiable(_aquaLivestock),
    schoolPhotos: List.unmodifiable(_schoolPhotos),
    homeTileOrder: List.unmodifiable(_homeTileOrder),
    homePinnedTools: List.unmodifiable(_homePinnedTools),
    sidewalkSalts: List.unmodifiable(_sidewalkSalts),
    landscapeParkTrips: List.unmodifiable(_landscapeParkTrips),
    veggiePickles: List.unmodifiable(_veggiePickles),
    radiatorThermos: List.unmodifiable(_radiatorThermos),
    archeryGear: List.unmodifiable(_archeryGear),
    yardGames: List.unmodifiable(_yardGames),
    polishFilms: List.unmodifiable(_polishFilms),
    safetyKits: List.unmodifiable(_safetyKits),
    sodaCo2Spots: List.unmodifiable(_sodaCo2Spots),
    terrariumPets: List.unmodifiable(_terrariumPets),
    parkPhotos: List.unmodifiable(_parkPhotos),
    soundAlerts: _soundAlerts,
  );

  void _persist() => widget.onSnapshotChanged(_currentSnapshot());

  CommunityStats get _communityStats => const StatsService().fromAppState(
    announcements: _announcements,
    ecoReports: _ecoReports,
    messages: _messages,
    infrastructureReports: _infrastructureReports,
    currentUserName: _userName,
  );

  List<Widget> get _screens => [
    HomeScreen(
      key: ValueKey('home-$_startDestination-$_defaultSubDistrict'),
      announcements: _feedAnnouncements,
      onOpenAnnouncement: _openAnnouncementDetails,
      onToggleFavorite: _toggleFavorite,
      onLikeAnnouncement: _likeAnnouncement,
      onAddAnnouncement: _openAddAnnouncement,
      isOnline: _isOnline,
      showOfflineBanner: false,
      userSubDistrict: _defaultSubDistrict,
      userName: _userName,
      neighborhoodNotificationsEnabled: _neighborhoodNotificationsEnabled,
      onReportAnnouncement: _reportAnnouncement,
      polls: _polls,
      onVotePoll: _votePoll,
      events: _events,
      onToggleEventGoing: _toggleEventGoing,
      onAddEventToCalendar: _addEventToCalendar,
      onRecordSearch: _recordSearch,
      onAddHelp: () =>
          _openAddAnnouncement(category: Announcement.helpCategory),
      onAddEvent: _openAddEvent,
      onAddLending: () =>
          _openAddAnnouncement(category: Announcement.lendingCategory),
      onSnapPost: _openSnapPost,
      onRefresh: () async => _refreshCachedAnnouncements(),
      notificationRadius: _notificationRadius,
      notificationCategories: _notificationCategories,
      initialCategory: null,
      driverMode: _driverMode,
      reminders: _reminders,
      onOpenEcoPatrol: _openEcoPatrol,
      onRemindEvent: _remindEvent,
      favoriteStreets: _favoriteStreets,
      mediaOutages: _mediaOutages,
      onOpenMediaOutages: _openMediaOutages,
      homeStatsBannerEnabled: _homeStatsConfig.bannerEnabled,
      homeFavoriteCategory: _homeStatsConfig.favoriteCategory,
      homeAroundBlockCount:
          _infrastructureReports.length +
          _crossingReports.length +
          _handyJobs.length +
          _foundPlates.length,
      homeDistrictNoticeCount: _feedAnnouncements
          .where((item) => item.status == AnnouncementStatus.current)
          .length,
      homeDistrictEventCount: _events.length,
      onOpenHomeStatsConfig: _openHomeStatsConfig,
      homeModuleVisibility: _homeModuleVisibility,
      pitcherDays: _pitcherFilters.isEmpty
          ? 0
          : _pitcherFilters.first.daysSinceChange,
      onOpenPitcherFilter: _openPitcherFilters,
      homeTileOrder: _homeTileOrder,
      homePinnedTools: _homePinnedTools,
      onOpenPinnedTool: _openPinnedTool,
      safetyKitDays: _safetyKits.isEmpty
          ? -1
          : _safetyKits.first.daysUntilReview,
      onOpenSafetyKit: _openSafetyKits,
      quietHoursEnabled: _soundAlerts.quietHoursEnabled,
      quietHoursLabel: _soundAlerts.quietHoursLabel,
      onOpenSoundAlerts: _openSoundAlerts,
      onOpenNeighborHub: _openNeighborHub,
      onOpenHubModule: _openHubModule,
      onOpenMessages: _openMessagesTab,
      onOpenInfrastructure: _openInfrastructure,
      onOpenCrossingReports: _openCrossingReports,
      initialSubDistrict: 'Wszystkie osiedla',
      carpoolRides: List.unmodifiable(_carpoolRides),
      searchHistory: List.unmodifiable(_searchHistory),
      onRemoveSearch: _removeSearchHistory,
      onClearSearchHistory: _clearSearchHistory,
      onReactAnnouncement: _reactAnnouncement,
      onExploreSubDistrict: _exploreSubDistrict,
    ),
    SavedAnnouncementsScreen(
      announcements: _feedAnnouncements
          .where((announcement) => announcement.isFavorite)
          .toList(),
      onOpenAnnouncement: _openAnnouncementDetails,
      onToggleFavorite: _toggleFavorite,
      onLikeAnnouncement: _likeAnnouncement,
      onReportAnnouncement: _reportAnnouncement,
      onReact: _reactAnnouncement,
    ),
    MessagesHub(
      conversations: NeighborConversation.group(_messages),
      activeConversation: _activeConversation(),
      onOpenConversation: _openConversation,
      onCloseConversation: _closeConversation,
      chatBuilder: (conversation) => ChatScreen(
        peerName: conversation.peerName,
        listingTitle: conversation.listingTitle,
        messages: conversation.messages,
        onSend: _sendNeighborMessage,
        onSendVoice: _sendVoiceMessage,
        onSendImage: _sendImageMessage,
        onClearHistory: _clearConversationHistory,
      ),
    ),
    ProfileScreen(
      favoriteAnnouncements: _feedAnnouncements
          .where((announcement) => announcement.isFavorite)
          .toList(),
      ownAnnouncements: _announcements
          .where((announcement) => announcement.isMine)
          .toList(),
      communityAnnouncements: _announcements,
      onOpenAnnouncement: _openAnnouncementDetails,
      onToggleFavorite: _toggleFavorite,
      onLikeAnnouncement: _likeAnnouncement,
      onRestoreDefaults: _restoreDefaults,
      onClearCachedAnnouncements: _clearCachedAnnouncements,
      userName: _userName,
      defaultSubDistrict: _defaultSubDistrict,
      isDarkMode: _isDarkMode,
      createdAnnouncementCount: _createdAnnouncementCount,
      onThemeChanged: _setTheme,
      widzewSkin: _widzewSkin,
      onWidzewSkinChanged: _setWidzewSkin,
      neighborhoodNotificationsEnabled: _neighborhoodNotificationsEnabled,
      onNeighborhoodNotificationsChanged: _setNeighborhoodNotifications,
      events: _events,
      seniorMode: _seniorMode,
      onSeniorModeChanged: _setSeniorMode,
      appLocale: _appLocale,
      onAppLocaleChanged: _setAppLocale,
      onOpenServices: _openServices,
      onOpenGroups: _openGroups,
      onOpenCooperativeBoard: _openCooperativeBoard,
      onOpenNeighborQr: _openNeighborQr,
      onScanQr: _openQrScan,
      driverMode: _driverMode,
      onDriverModeChanged: _setDriverMode,
      onOpenFoodGuide: _openFoodGuide,
      onOpenLocalDeals: _openLocalDeals,
      onOpenBookShelf: _openBookShelf,
      timeBankHours: _timeBankHours,
      communityStats: _communityStats,
      onOpenCharityDrives: _openCharityDrives,
      onOpenInfrastructure: _openInfrastructure,
      onOpenFleaMarket: _openFleaMarket,
      onOpenSportMeetups: _openSportMeetups,
      onOpenSeniorCorner: _openSeniorCorner,
      onOpenPlantSwap: _openPlantSwap,
      onOpenParentsClub: _openParentsClub,
      onOpenBarter: _openBarter,
      onOpenCraftMakers: _openCraftMakers,
      onOpenTutoring: _openTutoring,
      onOpenSafetyPatrol: _openSafetyPatrol,
      onOpenHomeAssistant: _openHomeAssistant,
      onOpenNeighborTemplates: _openNeighborTemplates,
      onOpenOddJobs: _openOddJobs,
      onOpenLostFound: _openLostFound,
      onOpenStaircaseFund: _openStaircaseFund,
      onOpenSharedTools: _openSharedTools,
      onOpenCultureEvents: _openCultureEvents,
      onOpenMarketStalls: _openMarketStalls,
      onOpenBulkBuy: _openBulkBuy,
      onOpenWalkingBus: _openWalkingBus,
      onOpenWidzewHistory: _openWidzewHistory,
      onOpenEnergyHub: _openEnergyHub,
      onOpenRetroIt: _openRetroIt,
      onOpenCostSplit: _openCostSplit,
      onOpenBikeHelp: _openBikeHelp,
      onOpenDiyAcademy: _openDiyAcademy,
      onOpenBloodClub: _openBloodClub,
      onOpenGarageListings: _openGarageListings,
      onOpenPetHealth: _openPetHealth,
      onOpenPartyGear: _openPartyGear,
      onOpenDroneAlerts: _openDroneAlerts,
      onOpenCraftPassage: _openCraftPassage,
      onOpenDistrictReport: _openDistrictReport,
      onOpenEcoCollection: _openEcoCollection,
      onOpenLongDistanceRides: _openLongDistanceRides,
      onOpenSmileGifts: _openSmileGifts,
      onOpenFoodShare: _openFoodShare,
      onOpenMedicalGear: _openMedicalGear,
      onOpenLeftoverMaterials: _openLeftoverMaterials,
      onOpenFaunaAlerts: _openFaunaAlerts,
      onOpenRecipeClub: _openRecipeClub,
      onOpenKidsCreations: _openKidsCreations,
      onOpenWidzewTimeline: _openWidzewTimeline,
      onOpenEvCharging: _openEvCharging,
      onOpenTailor: _openTailor,
      onOpenStudentRides: _openStudentRides,
      onOpenGrillZone: _openGrillZone,
      onOpenPlaygroundReports: _openPlaygroundReports,
      onOpenCampGear: _openCampGear,
      onOpenSchoolBooks: _openSchoolBooks,
      onOpenAirShows: _openOpenAirShows,
      onOpenDigitalHelp: _openDigitalHelp,
      onOpenLedSwap: _openLedSwap,
      onOpenJasienGuide: _openJasienGuide,
      onOpenDistrictEcoStats: _openDistrictEcoStats,
      onOpenBikeStations: _openBikeStations,
      onOpenHandyJobs: _openHandyJobs,
      onOpenWinterHelp: _openWinterHelp,
      onOpenBoardGames: _openBoardGames,
      onOpenWildlifeCare: _openWildlifeCare,
      onOpenFitnessGear: _openFitnessGear,
      onOpenSmallAppliances: _openSmallAppliances,
      onOpenBulkWaste: _openBulkWaste,
      onOpenRetroGaming: _openRetroGaming,
      onOpenArchitectureGuide: _openArchitectureGuide,
      onOpenRodShare: _openRodShare,
      onOpenBlockPush: _openBlockPush,
      onOpenVinylSwap: _openVinylSwap,
      onOpenGardenNotes: _openGardenNotes,
      onOpenNightCarpool: _openNightCarpool,
      onOpenCraftWorkshop: _openCraftWorkshop,
      onOpenBikeTrips: _openBikeTrips,
      onOpenSchoolEco: _openSchoolEco,
      onOpenPhotoClub: _openPhotoClub,
      onOpenCrossingReports: _openCrossingReports,
      onOpenAvGear: _openAvGear,
      onOpenWorkwear: _openWorkwear,
      onOpenGreenPaths: _openGreenPaths,
      onOpenNeighborQuests: _openNeighborQuests,
      onOpenMicroBusiness: _openMicroBusiness,
      onOpenHomeSit: _openHomeSit,
      onOpenWorkshopGarage: _openWorkshopGarage,
      onOpenConsoleTourney: _openConsoleTourney,
      onOpenJarSwap: _openJarSwap,
      onOpenBabyGear: _openBabyGear,
      onOpenYouthCode: _openYouthCode,
      onOpenGenerationBridge: _openGenerationBridge,
      onOpenFoundPlates: _openFoundPlates,
      onOpenIndustrialGuide: _openIndustrialGuide,
      onOpenHomeStatsConfig: _openHomeStatsConfig,
      onOpenFireSafety: _openFireSafety,
      onOpenCompostSwap: _openCompostSwap,
      onOpenMobileCraft: _openMobileCraft,
      onOpenSportLeague: _openSportLeague,
      onOpenAnimalPatrol: _openAnimalPatrol,
      onOpenWeekendTrips: _openWeekendTrips,
      onOpenTrailerShare: _openTrailerShare,
      onOpenPrlFurniture: _openPrlFurniture,
      onOpenCineClub: _openCineClub,
      onOpenSlabMuseum: _openSlabMuseum,
      onOpenStaircaseCodes: _openStaircaseCodes,
      onOpenDistrictAnalytics: _openDistrictAnalytics,
      onOpenAirQuality: _openAirQuality,
      onOpenPowerShare: _openPowerShare,
      onOpenWildDump: _openWildDump,
      onOpenSafetySchool: _openSafetySchool,
      onOpenCargoCarpool: _openCargoCarpool,
      onOpenCollectorFair: _openCollectorFair,
      onOpenLegoSwap: _openLegoSwap,
      onOpenChessClub: _openChessClub,
      onOpenLocalArt: _openLocalArt,
      onOpenMemorialGuide: _openMemorialGuide,
      onOpenMedicineChest: _openMedicineChest,
      onOpenUserBackup: _openUserBackup,
      onOpenVoltageOutages: _openVoltageOutages,
      onOpenParkingShare: _openParkingShare,
      onOpenBlockTools: _openBlockTools,
      onOpenMushroomTrips: _openMushroomTrips,
      onOpenSmileTutors: _openSmileTutors,
      onOpenUpcycleCraft: _openUpcycleCraft,
      onOpenClassicCars: _openClassicCars,
      onOpenWalkFinds: _openWalkFinds,
      onOpenGreenWaste: _openGreenWaste,
      onOpenTimeCapsule: _openTimeCapsule,
      onOpenEmergencyRental: _openEmergencyRental,
      onOpenHomeModuleVisibility: _openHomeModuleVisibility,
      onOpenHeatAlerts: _openHeatAlerts,
      onOpenMallCarpool: _openMallCarpool,
      onOpenPramRacks: _openPramRacks,
      onOpenRtvRepair: _openRtvRepair,
      onOpenKidCostumes: _openKidCostumes,
      onOpenModelFair: _openModelFair,
      onOpenFishingClub: _openFishingClub,
      onOpenFinanceTips: _openFinanceTips,
      onOpenWildlifeShelters: _openWildlifeShelters,
      onOpenPetPros: _openPetPros,
      onOpenStreetArchive: _openStreetArchive,
      onOpenWidzewSkins: _openWidzewSkins,
      onOpenSmogFilters: _openSmogFilters,
      onOpenWaterPressure: _openWaterPressure,
      onOpenSolarShare: _openSolarShare,
      onOpenPrint3d: _openPrint3d,
      onOpenSportKits: _openSportKits,
      onOpenSeniorShop: _openSeniorShop,
      onOpenParkChess: _openParkChess,
      onOpenScamAlerts: _openScamAlerts,
      onOpenStreetArt: _openStreetArt,
      onOpenPlantHotel: _openPlantHotel,
      onOpenWindowViews: _openWindowViews,
      onOpenDiagnostics: _openDiagnostics,
      onVersionTileTap: _onVersionTileTap,
      onOpenStairClean: _openStairClean,
      onOpenAirportRides: _openAirportRides,
      onOpenEnergyRecipes: _openEnergyRecipes,
      onOpenGardenToolCare: _openGardenToolCare,
      onOpenLangBooks: _openLangBooks,
      onOpenStreetball: _openStreetball,
      onOpenIndieCinema: _openIndieCinema,
      onOpenLostPets: _openLostPets,
      onOpenEwasteMap: _openEwasteMap,
      onOpenFilamentShare: _openFilamentShare,
      onOpenIndustryMemory: _openIndustryMemory,
      onOpenAchievementShare: _openAchievementShare,
      onOpenMpoBulky: _openMpoBulky,
      onOpenHolyCrossTrips: _openHolyCrossTrips,
      onOpenPreserveJars: _openPreserveJars,
      onOpenPcvWindows: _openPcvWindows,
      onOpenSchoolGear: _openSchoolGear,
      onOpenTableSports: _openTableSports,
      onOpenPolishFantasy: _openPolishFantasy,
      onOpenGasInspections: _openGasInspections,
      onOpenScooterHubs: _openScooterHubs,
      onOpenHepaTrackers: _openHepaTrackers,
      onOpenWidzewFilms: _openWidzewFilms,
      onOpenActivityReport: _openActivityReport,
      onOpenBalconyWash: _openBalconyWash,
      onOpenForestForage: _openForestForage,
      onOpenEcoCleaners: _openEcoCleaners,
      onOpenLockCare: _openLockCare,
      onOpenSeasonalSkates: _openSeasonalSkates,
      onOpenDartBilliard: _openDartBilliard,
      onOpenRockMetal: _openRockMetal,
      onOpenCarPolicies: _openCarPolicies,
      onOpenPhoneCharge: _openPhoneCharge,
      onOpenAirPlants: _openAirPlants,
      onOpenTramPhotos: _openTramPhotos,
      onOpenLocalVault: _openLocalVault,
      onOpenCarpetVac: _openCarpetVac,
      onOpenKayakTrips: _openKayakTrips,
      onOpenLunchboxes: _openLunchboxes,
      onOpenGardenFurniture: _openGardenFurniture,
      onOpenPuzzleSwap: _openPuzzleSwap,
      onOpenAmateurTheater: _openAmateurTheater,
      onOpenElectroAmbient: _openElectroAmbient,
      onOpenWaterFilters: _openWaterFilters,
      onOpenFarmStalls: _openFarmStalls,
      onOpenAquariumSwap: _openAquariumSwap,
      onOpenCinemaPhotos: _openCinemaPhotos,
      onOpenAppCache: _openAppCache,
      onOpenPavementClean: _openPavementClean,
      onOpenThermalTrips: _openThermalTrips,
      onOpenSourdough: _openSourdough,
      onOpenRollerShutters: _openRollerShutters,
      onOpenBeachGear: _openBeachGear,
      onOpenBocce: _openBocce,
      onOpenDiscoRetro: _openDiscoRetro,
      onOpenCarOil: _openCarOil,
      onOpenPramAccess: _openPramAccess,
      onOpenBalconyHerbs: _openBalconyHerbs,
      onOpenBazaarPhotos: _openBazaarPhotos,
      onOpenAccessPanel: _openAccessPanel,
      onOpenBenchPaint: _openBenchPaint,
      onOpenSudetyTrips: _openSudetyTrips,
      onOpenFruitPreserves: _openFruitPreserves,
      onOpenHomeSafes: _openHomeSafes,
      onOpenBikeChild: _openBikeChild,
      onOpenBadminton: _openBadminton,
      onOpenJazzBlues: _openJazzBlues,
      onOpenSmokeAlarms: _openSmokeAlarms,
      onOpenSourdoughShops: _openSourdoughShops,
      onOpenPetBirds: _openPetBirds,
      onOpenPavilionPhotos: _openPavilionPhotos,
      onOpenNetworkApi: _openNetworkApi,
      onOpenParkingMarks: _openParkingMarks,
      onOpenBieszczadyTrips: _openBieszczadyTrips,
      onOpenFruitVinegars: _openFruitVinegars,
      onOpenVideoIntercoms: _openVideoIntercoms,
      onOpenBabyCarriers: _openBabyCarriers,
      onOpenTennisSquash: _openTennisSquash,
      onOpenClassicalOpera: _openClassicalOpera,
      onOpenPitcherFilters: _openPitcherFilters,
      onOpenClothesBins: _openClothesBins,
      onOpenAquaLivestock: _openAquaLivestock,
      onOpenSchoolPhotos: _openSchoolPhotos,
      onOpenHomeShortcuts: _openHomeShortcuts,
      onOpenSidewalkSalts: _openSidewalkSalts,
      onOpenLandscapeParkTrips: _openLandscapeParkTrips,
      onOpenVeggiePickles: _openVeggiePickles,
      onOpenRadiatorThermos: _openRadiatorThermos,
      onOpenArcheryGear: _openArcheryGear,
      onOpenYardGames: _openYardGames,
      onOpenPolishFilms: _openPolishFilms,
      onOpenSafetyKits: _openSafetyKits,
      onOpenSodaCo2: _openSodaCo2,
      onOpenTerrariumPets: _openTerrariumPets,
      onOpenParkPhotos: _openParkPhotos,
      onOpenSoundAlerts: _openSoundAlerts,
      neighborQuestPoints: _neighborQuestPoints,
      unlockedNeighborQuestIds: _unlockedNeighborQuestIds,
      avatarIndex: _avatarIndex,
      avatarPhotoPath: _avatarPhotoPath,
      onAvatarChanged: _setAvatarIndex,
      onAvatarPhotoChanged: _setAvatarPhoto,
      locationVerified: _locationVerified,
      onConfirmLocation: _confirmWidzewLocation,
      marketplace: _marketplace,
      onTradespersonRoleChanged: _setTradespersonRole,
      onOpenTradespersonCard: _openTradespersonCard,
      onOpenTradespersonSubscription: _openTradespersonSubscription,
      onRenewTradespersonSubscription: () {
        unawaited(_renewTradespersonSubscription());
      },
      onOpenTradespersonCatalog: _openTradespersonCatalogTab,
      onOpenFavoriteTradespeople: _openFavoriteTradespeopleTab,
      onOpenTradespersonPortfolio: _openTradespersonPortfolio,
      onOpenTradespersonPriceList: _openTradespersonPriceList,
      exploredSubDistricts: List.unmodifiable(_exploredSubDistricts),
      infrastructureReports: List.unmodifiable(_infrastructureReports),
      unlockedBadgeIds: BadgeService.unlockedIds,
      onDefaultSubDistrictChanged: _setDefaultSubDistrict,
      onReportAnnouncement: _reportAnnouncement,
      onOpenContentReview: _openContentReview,
      onEditAnnouncement: _editAnnouncement,
      onCompleteAnnouncement: (announcement) =>
          _setStatus(announcement, AnnouncementStatus.resolved),
      onDeleteAnnouncement: _deleteAnnouncement,
    ),
  ];

  void _toggleFavorite(Announcement announcement) {
    final index = _announcements.indexWhere(
      (item) => item.publishedAt == announcement.publishedAt,
    );
    if (index == -1) return;
    setState(() {
      final current = _announcements[index];
      _announcements[index] = current.copyWith(isFavorite: !current.isFavorite);
    });
    _persist();
  }

  void _openMessagesTab() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    setState(() {
      _groupsLanding = false;
      _currentIndex = 2;
      _activeConversationId = null;
    });
  }

  void _openAnnouncementDetails(Announcement announcement) {
    final index = _announcementIndex(announcement);
    var opened = announcement;
    if (index != -1) {
      opened = _announcements[index].copyWith(
        viewsCount: _announcements[index].viewsCount + 1,
      );
      setState(() => _announcements[index] = opened);
      _persist();
      if (opened.viewsCount > NeighborAchievements.popularViewsThreshold) {
        unawaited(_unlockBadges([BadgeIds.popularNeighbor]));
      }
    }
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AnnouncementDetailScreen(
          announcement: opened,
          onToggleFavorite: _toggleFavorite,
          onAddComment: (comment) => _addComment(opened, comment),
          currentUserName: _userName,
          onStatusChanged: (status) => _setStatus(opened, status),
          onReport: (reason) => _reportAnnouncement(opened, reason),
          onRemindTomorrow: () => _remindAnnouncement(opened),
          onReact: (emoji) => _reactAnnouncement(opened, emoji),
          onWriteToAuthor: () => _startChatWithAuthor(opened),
        ),
      ),
    );
  }

  void _likeAnnouncement(Announcement announcement) {
    final index = _announcements.indexWhere(
      (item) => item.publishedAt == announcement.publishedAt,
    );
    if (index == -1 || _announcements[index].isLiked) return;
    setState(() {
      final current = _announcements[index];
      _announcements[index] = current.copyWith(
        likesCount: current.likesCount + 1,
        isLiked: true,
      );
    });
    _persist();
  }

  bool get _inWidgetTest => isFlutterWidgetTest;

  void _addComment(Announcement announcement, String comment) {
    final filter = ContentFilter.inspect(comment);
    if (filter.blocked) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(filter.message)));
      }
      return;
    }
    final index = _announcementIndex(announcement);
    if (index == -1) return;
    final current = _announcements[index];
    setState(() {
      _announcements[index] = current.copyWith(
        comments: [
          ...current.comments,
          AnnouncementComment(authorName: _userName, text: comment),
        ],
      );
    });
    _persist();
    if (_inWidgetTest || !current.isMine) return;
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      final latest = _announcementIndex(announcement);
      if (latest == -1) return;
      setState(() {
        final item = _announcements[latest];
        _announcements[latest] = item.copyWith(
          comments: [
            ...item.comments,
            const AnnouncementComment(
              authorName: 'Sąsiad z klatki',
              text: 'Dzięki, już sprawdzam ogłoszenie.',
            ),
          ],
        );
      });
      _persist();
      unawaited(
        LocalPushService.show(
          id: 12,
          title: 'Odpowiedź na Twoje ogłoszenie',
          body: current.title,
        ),
      );
    });
  }

  void _setStatus(Announcement announcement, AnnouncementStatus status) {
    final index = _announcementIndex(announcement);
    if (index == -1) return;
    final current = _announcements[index];
    if (!current.isMine && !current.isHelp) return;
    setState(() {
      _announcements[index] = current.copyWith(
        status: status,
        resolvedAt: status == AnnouncementStatus.resolved
            ? (current.resolvedAt ?? DateTime.now())
            : null,
        clearResolvedAt: status != AnnouncementStatus.resolved,
      );
    });
    _persist();
    if (status == AnnouncementStatus.resolved) {
      final updated = _announcements[index];
      unawaited(_unlockBadges(BadgeManager.idsForResolved(updated)));
    }
  }

  void _exploreSubDistrict(String district) {
    if (!Announcement.subDistricts.contains(district)) return;
    if (_exploredSubDistricts.contains(district)) return;
    setState(
      () => _exploredSubDistricts = [..._exploredSubDistricts, district],
    );
    unawaited(
      NeighborProfileStore.saveExploredDistricts(_exploredSubDistricts),
    );
  }

  int _announcementIndex(Announcement announcement) => _announcements
      .indexWhere((item) => item.publishedAt == announcement.publishedAt);

  void _setTheme(bool enabled) {
    _setThemePreference(
      enabled ? AppThemePreference.dark : AppThemePreference.light,
    );
  }

  void _setThemePreference(AppThemePreference preference) {
    setState(() {
      _themePreference = preference;
      _isDarkMode = preference == AppThemePreference.system
          ? View.of(context).platformDispatcher.platformBrightness ==
                Brightness.dark
          : preference == AppThemePreference.dark;
    });
    _persist();
  }

  void _setWidzewSkin(WidzewSkin skin) {
    setState(() => _widzewSkin = skin);
    _persist();
  }

  void _reportAnnouncement(Announcement announcement, String reason) {
    final key = _announcementKey(announcement);
    final outcome = BoardSafetyStore.addReport(
      announcementKey: key,
      reporterId: _userName,
      reason: reason,
    );
    if (outcome.hidden) {
      setState(() {
        _hiddenAnnouncementKeys.add(key);
        if (!_blockedAnnouncementKeys.contains(key)) {
          _blockedAnnouncementKeys = [..._blockedAnnouncementKeys, key];
        }
      });
      _persist();
    } else {
      setState(() {});
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(outcome.message)));
  }

  void _openContentReview() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ContentReviewScreen(
          items: _announcements
              .where(
                (item) => BoardSafetyStore.reviewKeys.contains(
                  _announcementKey(item),
                ),
              )
              .toList(),
          reportCount: (item) =>
              BoardSafetyStore.reportCount(_announcementKey(item)),
          onOpen: (item) {
            Navigator.of(context).pop();
            _openAnnouncementDetails(item);
          },
          onRestore: (item) {
            final key = _announcementKey(item);
            unawaited(BoardSafetyStore.restore(key));
            setState(() {
              _hiddenAnnouncementKeys.remove(key);
              _blockedAnnouncementKeys = [
                for (final entry in _blockedAnnouncementKeys)
                  if (entry != key) entry,
              ];
            });
            _persist();
            Navigator.of(context).pop();
          },
          onKeepHidden: (item) {
            unawaited(BoardSafetyStore.dismissReview(_announcementKey(item)));
            setState(() {});
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _loadBoardSafety() async {
    await BoardSafetyStore.load();
    if (!mounted) return;
    setState(() {
      _hiddenAnnouncementKeys.addAll(BoardSafetyStore.reviewKeys);
    });
  }

  bool _allowBoardPublish(String body) {
    final gate = BoardSafety.publishGate(
      BoardSafetyStore.publishTimes,
      bypass: _inWidgetTest,
    );
    if (!gate.allowed) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(gate.message)));
      return false;
    }
    final filter = ContentFilter.inspect(body);
    if (filter.blocked) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(filter.message)));
      return false;
    }
    return true;
  }

  void _setNeighborhoodNotifications(bool enabled) {
    setState(() => _neighborhoodNotificationsEnabled = enabled);
    unawaited(LocalPushService.setEnabled(enabled));
    _persist();
  }

  void _setSeniorMode(bool enabled) {
    setState(() => _seniorMode = enabled);
    _persist();
  }

  void _setDriverMode(bool enabled) {
    setState(() => _driverMode = enabled);
    _persist();
  }

  void _setAppLocale(AppLocale locale) {
    setState(() => _appLocale = locale);
    _persist();
  }

  void _addService(NeighborService service) {
    setState(() => _services = [service, ..._services]);
    _persist();
  }

  void _recommendService(String serviceId, ServiceReview review) {
    setState(() {
      _services = _services.map((item) {
        if (item.id != serviceId) return item;
        return item.copyWith(
          isRecommended: true,
          reviews: [review, ...item.reviews],
        );
      }).toList();
    });
    _persist();
  }

  void _toggleClubJoin(String clubId) {
    setState(() {
      _clubs = _clubs.map((club) {
        if (club.id != clubId) return club;
        final joining = !club.isJoined;
        return club.copyWith(
          isJoined: joining,
          memberCount: club.memberCount + (joining ? 1 : -1),
        );
      }).toList();
    });
    _persist();
  }

  void _sendClubMessage(String clubId, String text) {
    setState(() {
      _clubs = _clubs.map((club) {
        if (club.id != clubId) return club;
        return club.copyWith(
          messages: [
            ...club.messages,
            ClubMessage(
              authorName: _userName,
              text: text,
              sentAt: DateTime.now(),
              isMine: true,
            ),
          ],
        );
      }).toList();
    });
    _persist();
  }

  void _openServices() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => NeighborhoodServicesScreen(
          services: _services,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAddService: _addService,
          onRecommend: _recommendService,
          canPublishOffers: _marketplace.account.canPublishListing,
          onNeedSubscription: _openTradespersonSubscription,
        ),
      ),
    );
  }

  void _openGroups() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => NeighborhoodGroupsScreen(
          clubs: _clubs,
          userName: _userName,
          onToggleJoin: _toggleClubJoin,
          onSendMessage: _sendClubMessage,
        ),
      ),
    );
  }

  void _openCooperativeBoard() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CooperativeBoardScreen(
          notices: _cooperativeNotices,
          userSubDistrict: _defaultSubDistrict,
        ),
      ),
    );
  }

  void _openNeighborQr() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => NeighborQrScreen(
          userName: _userName,
          subDistrict: _defaultSubDistrict,
        ),
      ),
    );
  }

  void _openQrScan() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => QrScanScreen(
          announcements: _feedAnnouncements,
          onOpenAnnouncement: (announcement) {
            Navigator.of(context).pop();
            _openAnnouncementDetails(announcement);
          },
        ),
      ),
    );
  }

  void _openEcoPatrol() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => EcoPatrolScreen(
          reports: _ecoReports,
          userSubDistrict: _defaultSubDistrict,
          onAdd: (report) {
            setState(() => _ecoReports = [report, ..._ecoReports]);
            _persist();
          },
          onMarkAccepted: (id) {
            setState(() {
              _ecoReports = _ecoReports
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(
                            status: EcoInterventionStatus.acceptedByOffice,
                          )
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openWastePoints() {
    Navigator.of(context)
        .push(AppPageRoute<void>(builder: (_) => const WastePointsScreen()));
  }

  void _openFoodGuide() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FoodGuideScreen(
          spots: _foodSpots,
          userName: _userName,
          onAddReview: (spotId, review) {
            setState(() {
              _foodSpots = _foodSpots
                  .map(
                    (item) => item.id == spotId
                        ? item.copyWith(reviews: [review, ...item.reviews])
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openLocalDeals() {
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => LocalDealsScreen(deals: _localDeals)),
    );
  }

  void _openBookShelf() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BookShelfScreen(
          books: _bookOffers,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (book) {
            setState(() => _bookOffers = [book, ..._bookOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openTimeBank() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => TimeBankScreen(
          offers: _timeBankOffers,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          timeBankHours: _timeBankHours,
          onAdd: (offer) {
            setState(() => _timeBankOffers = [offer, ..._timeBankOffers]);
            _persist();
          },
          onComplete: _completeTimeOffer,
        ),
      ),
    );
  }

  void _completeTimeOffer(String id) {
    TimeBankOffer? offer;
    for (final item in _timeBankOffers) {
      if (item.id == id) {
        offer = item;
        break;
      }
    }
    if (offer == null || offer.isCompleted) return;
    final hours = offer.hours;
    setState(() {
      _timeBankHours += hours;
      _timeBankOffers = _timeBankOffers
          .map(
            (item) => item.id == id ? item.copyWith(isCompleted: true) : item,
          )
          .toList();
    });
    _persist();
  }

  void _openParcelLockers() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ParcelLockerScreen(
          lockers: _parcelLockers,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (locker) {
            setState(() => _parcelLockers = [locker, ..._parcelLockers]);
            _persist();
          },
          onUpdateOccupied: (id, occupied) {
            setState(() {
              _parcelLockers = _parcelLockers
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(occupied: occupied)
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openCharityDrives() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CharityDrivesScreen(
          drives: _charityDrives,
          onAdd: (drive) {
            setState(() => _charityDrives = [drive, ..._charityDrives]);
            _persist();
          },
          onContribute: (id, amount) {
            setState(() {
              _charityDrives = _charityDrives
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(collected: item.collected + amount)
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openCarpool() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CarpoolScreen(
          rides: _carpoolRides,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (ride) {
            setState(() => _carpoolRides = [ride, ..._carpoolRides]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openInfrastructure() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => InfrastructureScreen(
          reports: _infrastructureReports,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (report) {
            setState(
              () =>
                  _infrastructureReports = [report, ..._infrastructureReports],
            );
            _persist();
          },
          onStatusChanged: (id, status) {
            setState(() {
              _infrastructureReports = _infrastructureReports
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(status: status) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openFleaMarket() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FleaMarketScreen(
          items: _fleaMarketItems,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (item) {
            setState(() => _fleaMarketItems = [item, ..._fleaMarketItems]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSportMeetups() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SportMeetupsScreen(
          meetups: _sportMeetups,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (meetup) {
            setState(() => _sportMeetups = [meetup, ..._sportMeetups]);
            _persist();
          },
          onToggleJoin: (id) {
            setState(() {
              _sportMeetups = _sportMeetups
                  .map((item) => item.id == id ? item.toggleJoin() : item)
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openPetSit() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PetSitScreen(
          offers: _petSitOffers,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (offer) {
            setState(() => _petSitOffers = [offer, ..._petSitOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSeniorCorner() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SeniorCornerScreen(
          offers: _seniorOffers,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (offer) {
            setState(() => _seniorOffers = [offer, ..._seniorOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPlantSwap() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PlantSwapScreen(
          offers: _plantSwaps,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (offer) {
            setState(() => _plantSwaps = [offer, ..._plantSwaps]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openParentsClub() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ParentsClubScreen(
          meetups: _parentMeetups,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (meetup) {
            setState(() => _parentMeetups = [meetup, ..._parentMeetups]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBarter() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BarterScreen(
          offers: _barterOffers,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (offer) {
            setState(() => _barterOffers = [offer, ..._barterOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCraftMakers() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CraftMakersScreen(
          makers: _craftMakers,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (maker) {
            setState(() => _craftMakers = [maker, ..._craftMakers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openTutoring() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => TutoringScreen(
          offers: _tutoringOffers,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (offer) {
            setState(() => _tutoringOffers = [offer, ..._tutoringOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSafetyPatrol() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SafetyPatrolScreen(
          alerts: _safetyAlerts,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (alert) {
            setState(() => _safetyAlerts = [alert, ..._safetyAlerts]);
            _persist();
          },
          onWitness: (id) {
            setState(() {
              _safetyAlerts = _safetyAlerts
                  .map((item) => item.id == id ? item.confirmWitness() : item)
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openHomeAssistant() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => HomeAssistantScreen(
          duties: _homeDuties,
          onAdd: (duty) {
            setState(() => _homeDuties = [duty, ..._homeDuties]);
            _persist();
          },
          onRemind: (title, body) =>
              _scheduleReminder(title: title, body: body),
        ),
      ),
    );
  }

  void _openNeighborTemplates() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => NeighborTemplatesScreen(templates: _neighborTemplates),
      ),
    );
  }

  void _openOddJobs() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => OddJobsScreen(
          jobs: _oddJobs,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (job) {
            setState(() => _oddJobs = [job, ..._oddJobs]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openLostFound() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LostFoundScreen(
          items: _lostFoundItems,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (item) {
            setState(() => _lostFoundItems = [item, ..._lostFoundItems]);
            _persist();
          },
          onMarkReturned: (id) {
            setState(() {
              _lostFoundItems = _lostFoundItems
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(returned: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openStaircaseFund() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => StaircaseFundScreen(
          funds: _staircaseFunds,
          userName: _userName,
          onAdd: (fund) {
            setState(() => _staircaseFunds = [fund, ..._staircaseFunds]);
            _persist();
          },
          onPay: (id, payment) {
            setState(() {
              _staircaseFunds = _staircaseFunds
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(payments: [...item.payments, payment])
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openSharedTools() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SharedToolsScreen(
          tools: _sharedTools,
          onReserve: (id, date) {
            setState(() {
              _sharedTools = _sharedTools
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(
                            reservedDates: [...item.reservedDates, date],
                          )
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openMediaOutages() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => MediaOutagesScreen(
          outages: _mediaOutages,
          onAdd: (outage) {
            setState(() => _mediaOutages = [outage, ..._mediaOutages]);
            _persist();
          },
          onResolve: (id) {
            setState(() {
              _mediaOutages = _mediaOutages
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(isActive: false) : item,
                  )
                  .toList();
            });
            _persist();
          },
          onNotify: (title, body) =>
              _scheduleReminder(title: title, body: body),
        ),
      ),
    );
  }

  void _openCultureEvents() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CultureEventsScreen(
          events: _cultureEvents,
          onToggleInterested: (id) {
            setState(() {
              _cultureEvents = _cultureEvents
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(interested: !item.interested)
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
          onAddToCalendar: (event) {
            unawaited(
              NeighborShare.shareText(
                context,
                text: event.toIcs(),
                subject: event.title,
                copiedMessage: 'Skopiowano wydarzenie do kalendarza',
              ),
            );
          },
        ),
      ),
    );
  }

  void _openMarketStalls() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => MarketStallsScreen(
          stalls: _marketStalls,
          userName: _userName,
          onAdd: (stall) {
            setState(() => _marketStalls = [stall, ..._marketStalls]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBulkBuy() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BulkBuyScreen(
          buys: _bulkBuys,
          onAdd: (buy) {
            setState(() => _bulkBuys = [buy, ..._bulkBuys]);
            _persist();
          },
          onToggleJoin: (id) {
            setState(() {
              _bulkBuys = _bulkBuys
                  .map((item) => item.id == id ? item.toggleJoin() : item)
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openVenueBooking() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => VenueBookingScreen(
          slots: _venueSlots,
          userName: _userName,
          onReserve: (id, reservedBy) {
            setState(() {
              _venueSlots = _venueSlots
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(reservedBy: reservedBy)
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openWalkingBus() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WalkingBusScreen(
          shifts: _walkingBusShifts,
          userName: _userName,
          onAdd: (shift) {
            setState(() => _walkingBusShifts = [shift, ..._walkingBusShifts]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openWidzewHistory() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WidzewHistoryScreen(
          stories: _historyStories,
          patriotBadgeUnlocked: _historyPatriotUnlocked,
          onUnlockPatriot: () {
            setState(() => _historyPatriotUnlocked = true);
            _persist();
          },
        ),
      ),
    );
  }

  void _openEnergyHub() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => EnergyHubScreen(
          items: _energyExperiences,
          userName: _userName,
          onAdd: (item) {
            setState(() => _energyExperiences = [item, ..._energyExperiences]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openRetroIt() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => RetroItScreen(
          items: _retroItOffers,
          userName: _userName,
          onAdd: (item) {
            setState(() => _retroItOffers = [item, ..._retroItOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCostSplit() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CostSplitScreen(
          items: _costSplits,
          onAdd: (item) {
            setState(() => _costSplits = [item, ..._costSplits]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBikeHelp() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BikeHelpScreen(
          requests: _bikeHelps,
          racks: _bikeRacks,
          userName: _userName,
          onAdd: (item) {
            setState(() => _bikeHelps = [item, ..._bikeHelps]);
            _persist();
          },
          onOffer: (id) {
            setState(() {
              _bikeHelps = _bikeHelps
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(offered: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openDiyAcademy() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => DiyAcademyScreen(
          items: _diyWorkshops,
          userName: _userName,
          onAdd: (item) {
            setState(() => _diyWorkshops = [item, ..._diyWorkshops]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBloodClub() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BloodClubScreen(
          items: _bloodDrives,
          onAdd: (item) {
            setState(() => _bloodDrives = [item, ..._bloodDrives]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openGarageListings() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => GarageListingsScreen(
          items: _garageListings,
          userName: _userName,
          onAdd: (item) {
            setState(() => _garageListings = [item, ..._garageListings]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPetHealth() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PetHealthScreen(
          reminders: _petVaccineReminders,
          clinics: _vetClinics,
          onAdd: (item) {
            setState(
              () => _petVaccineReminders = [item, ..._petVaccineReminders],
            );
            _persist();
          },
          onRemind: (id) {
            setState(() {
              _petVaccineReminders = _petVaccineReminders
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(reminded: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openPartyGear() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PartyGearScreen(
          items: _partyGear,
          onAdd: (item) {
            setState(() => _partyGear = [item, ..._partyGear]);
            _persist();
          },
          onBorrow: (id) {
            setState(() {
              _partyGear = _partyGear
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(borrowed: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openDroneAlerts() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => DroneAlertsScreen(
          items: _droneAlerts,
          userName: _userName,
          onAdd: (item) {
            setState(() => _droneAlerts = [item, ..._droneAlerts]);
            _persist();
          },
          onSpot: (id) {
            setState(() {
              _droneAlerts = _droneAlerts
                  .map((item) => item.id == id ? item.spot() : item)
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openCraftPassage() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CraftPassageScreen(
          items: _craftPassageServices,
          onAdd: (item) {
            setState(
              () => _craftPassageServices = [item, ..._craftPassageServices],
            );
            _persist();
          },
        ),
      ),
    );
  }

  void _openEcoCollection() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => EcoCollectionScreen(
          items: _ecoCollections,
          onAdd: (item) {
            setState(() => _ecoCollections = [item, ..._ecoCollections]);
            _persist();
          },
          onAddKg: (id, kg) {
            setState(() {
              _ecoCollections = _ecoCollections
                  .map((item) => item.id == id ? item.addKg(kg) : item)
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openLongDistanceRides() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LongDistanceRidesScreen(
          items: _longDistanceRides,
          userName: _userName,
          onAdd: (item) {
            setState(() => _longDistanceRides = [item, ..._longDistanceRides]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSmileGifts() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SmileGiftsScreen(
          items: _smileGifts,
          userName: _userName,
          onAdd: (item) {
            setState(() => _smileGifts = [item, ..._smileGifts]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openFoodShare() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FoodShareScreen(
          items: _foodShares,
          userName: _userName,
          onAdd: (item) {
            setState(() => _foodShares = [item, ..._foodShares]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openMedicalGear() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => MedicalGearScreen(
          items: _medicalGear,
          onAdd: (item) {
            setState(() => _medicalGear = [item, ..._medicalGear]);
            _persist();
          },
          onBorrow: (id) {
            setState(() {
              _medicalGear = _medicalGear
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(borrowed: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openLeftoverMaterials() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LeftoverMaterialsScreen(
          items: _leftoverMaterials,
          userName: _userName,
          onAdd: (item) {
            setState(() => _leftoverMaterials = [item, ..._leftoverMaterials]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openFaunaAlerts() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FaunaAlertsScreen(
          items: _faunaSightings,
          userName: _userName,
          defaultSubDistrict: _defaultSubDistrict,
          onAdd: (item) {
            setState(() => _faunaSightings = [item, ..._faunaSightings]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openRecipeClub() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => RecipeClubScreen(
          items: _neighborRecipes,
          userName: _userName,
          onAdd: (item) {
            setState(() => _neighborRecipes = [item, ..._neighborRecipes]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openKidsCreations() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => KidsCreationsScreen(
          items: _kidsCreations,
          userName: _userName,
          onAdd: (item) {
            setState(() => _kidsCreations = [item, ..._kidsCreations]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openWidzewTimeline() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WidzewTimelineScreen(eras: _timelineEras),
      ),
    );
  }

  void _openEvCharging() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => EvChargingScreen(
          items: _evChargingOffers,
          userName: _userName,
          onAdd: (item) {
            setState(() => _evChargingOffers = [item, ..._evChargingOffers]);
            _persist();
          },
          onConsent: (id) {
            setState(() {
              _evChargingOffers = _evChargingOffers
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(neighborConsent: true)
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openTailor() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => TailorScreen(
          items: _tailorOffers,
          userName: _userName,
          onAdd: (item) {
            setState(() => _tailorOffers = [item, ..._tailorOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openStudentRides() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => StudentRidesScreen(
          items: _studentRides,
          userName: _userName,
          onAdd: (item) {
            setState(() => _studentRides = [item, ..._studentRides]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openGrillZone() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => GrillZoneScreen(
          events: _grillEvents,
          grills: _portableGrills,
          userName: _userName,
          onAddEvent: (item) {
            setState(() => _grillEvents = [item, ..._grillEvents]);
            _persist();
          },
          onReserveGrill: (id) {
            setState(() {
              _portableGrills = _portableGrills
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(reserved: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openPlaygroundReports() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PlaygroundReportsScreen(
          items: _playgroundReports,
          userName: _userName,
          onAdd: (item) {
            setState(() => _playgroundReports = [item, ..._playgroundReports]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCampGear() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CampGearScreen(
          items: _campGear,
          onAdd: (item) {
            setState(() => _campGear = [item, ..._campGear]);
            _persist();
          },
          onBorrow: (id) {
            setState(() {
              _campGear = _campGear
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(borrowed: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openSchoolBooks() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SchoolBooksScreen(
          items: _schoolBooks,
          userName: _userName,
          onAdd: (item) {
            setState(() => _schoolBooks = [item, ..._schoolBooks]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openOpenAirShows() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => OpenAirShowsScreen(
          items: _openAirShows,
          userName: _userName,
          onAdd: (item) {
            setState(() => _openAirShows = [item, ..._openAirShows]);
            _persist();
          },
          onVote: (id) {
            setState(() {
              _openAirShows = _openAirShows
                  .map((item) => item.id == id ? item.vote() : item)
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openDigitalHelp() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => DigitalHelpScreen(
          items: _digitalHelpOffers,
          userName: _userName,
          onAdd: (item) {
            setState(() => _digitalHelpOffers = [item, ..._digitalHelpOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openLedSwap() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LedSwapScreen(
          items: _ledSwaps,
          userName: _userName,
          onAdd: (item) {
            setState(() => _ledSwaps = [item, ..._ledSwaps]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openJasienGuide() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => JasienGuideScreen(spots: _jasienSpots),
      ),
    );
  }

  void _openBikeStations() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BikeStationsScreen(
          items: _bikeStations,
          onStatus: (id, {bool? toolsOk, bool? pumpOk}) {
            setState(() {
              _bikeStations = _bikeStations
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(toolsOk: toolsOk, pumpOk: pumpOk)
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openHandyJobs() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => HandyJobsScreen(
          items: _handyJobs,
          userName: _userName,
          onAdd: (item) {
            setState(() => _handyJobs = [item, ..._handyJobs]);
            _persist();
          },
          onDone: (id) {
            setState(() {
              _handyJobs = _handyJobs
                  .map(
                    (item) => item.id == id ? item.copyWith(done: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openWinterHelp() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WinterHelpScreen(
          items: _winterHelps,
          userName: _userName,
          onAdd: (item) {
            setState(() => _winterHelps = [item, ..._winterHelps]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBoardGames() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BoardGamesScreen(
          items: _boardGameNights,
          userName: _userName,
          onAdd: (item) {
            setState(() => _boardGameNights = [item, ..._boardGameNights]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openWildlifeCare() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WildlifeCareScreen(
          items: _wildlifeCares,
          userName: _userName,
          onAdd: (item) {
            setState(() => _wildlifeCares = [item, ..._wildlifeCares]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openFitnessGear() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FitnessGearScreen(
          items: _fitnessGear,
          onAdd: (item) {
            setState(() => _fitnessGear = [item, ..._fitnessGear]);
            _persist();
          },
          onBorrow: (id) {
            setState(() {
              _fitnessGear = _fitnessGear
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(borrowed: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openSmallAppliances() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SmallAppliancesScreen(
          items: _smallAppliances,
          userName: _userName,
          onAdd: (item) {
            setState(() => _smallAppliances = [item, ..._smallAppliances]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBulkWaste() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BulkWasteScreen(
          items: _bulkWastes,
          userName: _userName,
          onAdd: (item) {
            setState(() => _bulkWastes = [item, ..._bulkWastes]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openRetroGaming() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => RetroGamingScreen(
          items: _retroEvents,
          userName: _userName,
          onAdd: (item) {
            setState(() => _retroEvents = [item, ..._retroEvents]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openArchitectureGuide() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ArchitectureGuideScreen(spots: _architectureSpots),
      ),
    );
  }

  void _openRodShare() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => RodShareScreen(
          items: _rodShares,
          userName: _userName,
          onAdd: (item) {
            setState(() => _rodShares = [item, ..._rodShares]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBlockPush() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BlockPushScreen(
          notices: _blockPushNotices,
          homeBlockNumber: _homeBlockNumber,
          homeStaircase: _homeStaircase,
          selectedKinds: _blockPushKinds,
          onSaveFilter:
              ({
                required String block,
                required String staircase,
                required List<BlockPushKind> kinds,
              }) {
                setState(() {
                  _homeBlockNumber = block;
                  _homeStaircase = staircase;
                  _blockPushKinds = kinds;
                });
                _persist();
              },
        ),
      ),
    );
  }

  void _openVinylSwap() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => VinylSwapScreen(
          items: _vinylSwaps,
          userName: _userName,
          onAdd: (item) {
            setState(() => _vinylSwaps = [item, ..._vinylSwaps]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openGardenNotes() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => GardenNotesScreen(
          items: _gardenNotes,
          onAdd: (item) {
            setState(() => _gardenNotes = [item, ..._gardenNotes]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openNightCarpool() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => NightCarpoolScreen(
          items: _nightCarpools,
          userName: _userName,
          onAdd: (item) {
            setState(() => _nightCarpools = [item, ..._nightCarpools]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCraftWorkshop() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CraftWorkshopScreen(
          items: _craftWorkshops,
          userName: _userName,
          onAdd: (item) {
            setState(() => _craftWorkshops = [item, ..._craftWorkshops]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBikeTrips() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BikeTripsScreen(
          items: _bikeTrips,
          userName: _userName,
          onAdd: (item) {
            setState(() => _bikeTrips = [item, ..._bikeTrips]);
            _persist();
          },
          onJoin: (id) {
            setState(() {
              _bikeTrips = _bikeTrips
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(going: item.going + 1)
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openSchoolEco() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SchoolEcoScreen(
          items: _schoolEcoDrives,
          onAdd: (item) {
            setState(() => _schoolEcoDrives = [item, ..._schoolEcoDrives]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPhotoClub() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PhotoClubScreen(
          items: _photoClubItems,
          userName: _userName,
          onAdd: (item) {
            setState(() => _photoClubItems = [item, ..._photoClubItems]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCrossingReports() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CrossingReportsScreen(
          items: _crossingReports,
          userName: _userName,
          onAdd: (item) {
            setState(() => _crossingReports = [item, ..._crossingReports]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openAvGear() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AvGearScreen(
          items: _avGear,
          onAdd: (item) {
            setState(() => _avGear = [item, ..._avGear]);
            _persist();
          },
          onBorrow: (id) {
            setState(() {
              _avGear = _avGear
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(borrowed: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openWorkwear() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WorkwearScreen(
          items: _workwearItems,
          userName: _userName,
          onAdd: (item) {
            setState(() => _workwearItems = [item, ..._workwearItems]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openGreenPaths() {
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => GreenPathsScreen(spots: _greenPaths)),
    );
  }

  void _openNeighborQuests() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => NeighborQuestsScreen(
          points: _neighborQuestPoints,
          unlockedIds: _unlockedNeighborQuestIds,
          onUnlock: (id) {
            if (_unlockedNeighborQuestIds.contains(id)) return;
            setState(() {
              _unlockedNeighborQuestIds = [..._unlockedNeighborQuestIds, id];
              _neighborQuestPoints += 25;
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openMicroBusiness() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => MicroBusinessScreen(
          items: _microBusinesses,
          onAdd: (item) {
            setState(() => _microBusinesses = [item, ..._microBusinesses]);
            _persist();
          },
          onReview: (id, review) {
            setState(() {
              _microBusinesses = _microBusinesses
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(reviews: [...item.reviews, review])
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openHomeSit() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => HomeSitScreen(
          items: _homeSits,
          userName: _userName,
          onAdd: (item) {
            setState(() => _homeSits = [item, ..._homeSits]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openWorkshopGarage() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WorkshopGarageScreen(
          items: _workshopTools,
          onAdd: (item) {
            setState(() => _workshopTools = [item, ..._workshopTools]);
            _persist();
          },
          onBorrow: (id) {
            setState(() {
              _workshopTools = _workshopTools
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(borrowed: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openConsoleTourney() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ConsoleTourneyScreen(
          items: _consoleTourneys,
          userName: _userName,
          onAdd: (item) {
            setState(() => _consoleTourneys = [item, ..._consoleTourneys]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPetBlood() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PetBloodScreen(
          items: _petBloodDonors,
          userName: _userName,
          onAdd: (item) {
            setState(() => _petBloodDonors = [item, ..._petBloodDonors]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openJarSwap() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => JarSwapScreen(
          items: _jarSwaps,
          userName: _userName,
          onAdd: (item) {
            setState(() => _jarSwaps = [item, ..._jarSwaps]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBabyGear() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BabyGearScreen(
          items: _babyGear,
          userName: _userName,
          onAdd: (item) {
            setState(() => _babyGear = [item, ..._babyGear]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openYouthCode() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => YouthCodeScreen(
          items: _youthWorkshops,
          userName: _userName,
          onAdd: (item) {
            setState(() => _youthWorkshops = [item, ..._youthWorkshops]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openGenerationBridge() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => GenerationBridgeScreen(
          items: _generationBridges,
          userName: _userName,
          onAdd: (item) {
            setState(() => _generationBridges = [item, ..._generationBridges]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openFoundPlates() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FoundPlatesScreen(
          items: _foundPlates,
          userName: _userName,
          onAdd: (item) {
            setState(() => _foundPlates = [item, ..._foundPlates]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openIndustrialGuide() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => IndustrialGuideScreen(spots: _industrialSpots),
      ),
    );
  }

  void _openHomeStatsConfig() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => HomeStatsConfigScreen(
          config: _homeStatsConfig,
          onSave: (config) {
            setState(() => _homeStatsConfig = config);
            _persist();
          },
        ),
      ),
    );
  }

  void _openFireSafety() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FireSafetyScreen(
          items: _fireSafetyReports,
          userName: _userName,
          onAdd: (item) {
            setState(() => _fireSafetyReports = [item, ..._fireSafetyReports]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCompostSwap() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CompostSwapScreen(
          items: _compostSwaps,
          userName: _userName,
          onAdd: (item) {
            setState(() => _compostSwaps = [item, ..._compostSwaps]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openMobileCraft() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => MobileCraftScreen(
          items: _mobileCraftPros,
          onAdd: (item) {
            setState(() => _mobileCraftPros = [item, ..._mobileCraftPros]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSportLeague() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SportLeagueScreen(
          items: _sportHubItems,
          userName: _userName,
          onAdd: (item) {
            setState(() => _sportHubItems = [item, ..._sportHubItems]);
            _persist();
          },
          onPick: (id, pick) {
            setState(() {
              _sportHubItems = _sportHubItems
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(userPick: pick) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openAnimalPatrol() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AnimalPatrolScreen(
          items: _animalPatrols,
          userName: _userName,
          onAdd: (item) {
            setState(() => _animalPatrols = [item, ..._animalPatrols]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openWeekendTrips() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WeekendTripsScreen(
          items: _weekendTrips,
          userName: _userName,
          onAdd: (item) {
            setState(() => _weekendTrips = [item, ..._weekendTrips]);
            _persist();
          },
          onJoin: (id) {
            setState(() {
              _weekendTrips = _weekendTrips
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(going: item.going + 1)
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openTrailerShare() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => TrailerShareScreen(
          items: _trailerShares,
          onAdd: (item) {
            setState(() => _trailerShares = [item, ..._trailerShares]);
            _persist();
          },
          onBorrow: (id) {
            setState(() {
              _trailerShares = _trailerShares
                  .map(
                    (item) =>
                        item.id == id ? item.copyWith(borrowed: true) : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openPrlFurniture() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PrlFurnitureScreen(
          items: _prlFurniture,
          userName: _userName,
          onAdd: (item) {
            setState(() => _prlFurniture = [item, ..._prlFurniture]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCineClub() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CineClubScreen(
          items: _cineScreenings,
          onAdd: (item) {
            setState(() => _cineScreenings = [item, ..._cineScreenings]);
            _persist();
          },
          onReserve: (id) {
            setState(() {
              _cineScreenings = _cineScreenings
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(reserved: item.reserved + 1)
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openSlabMuseum() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SlabMuseumScreen(
          items: _slabMemories,
          onMemory: (id, memory) {
            setState(() {
              _slabMemories = _slabMemories
                  .map(
                    (item) => item.id == id
                        ? item.copyWith(memories: [...item.memories, memory])
                        : item,
                  )
                  .toList();
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openStaircaseCodes() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => StaircaseCodesScreen(
          items: _staircaseCodes,
          unlocked: _staircaseCodesUnlocked,
          onUnlocked: (value) {
            setState(() => _staircaseCodesUnlocked = value);
            _persist();
          },
          onAdd: (item) {
            setState(() => _staircaseCodes = [item, ..._staircaseCodes]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openDistrictAnalytics() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) =>
            DistrictAnalyticsScreen(announcements: _feedAnnouncements),
      ),
    );
  }

  void _openAirQuality() {
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => AirQualityScreen(items: _airSensors)),
    );
  }

  void _openPowerShare() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PowerShareScreen(
          items: _powerShares,
          userName: _userName,
          onAdd: (item) {
            setState(() => _powerShares = [item, ..._powerShares]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openWildDump() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WildDumpScreen(
          items: _wildDumps,
          userName: _userName,
          onAdd: (item) {
            setState(() => _wildDumps = [item, ..._wildDumps]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSafetySchool() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SafetySchoolScreen(
          items: _safetyWorkshops,
          userName: _userName,
          onAdd: (item) {
            setState(() => _safetyWorkshops = [item, ..._safetyWorkshops]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCargoCarpool() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CargoCarpoolScreen(
          items: _cargoCarpools,
          userName: _userName,
          onAdd: (item) {
            setState(() => _cargoCarpools = [item, ..._cargoCarpools]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCollectorFair() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CollectorFairScreen(
          items: _collectorItems,
          userName: _userName,
          onAdd: (item) {
            setState(() => _collectorItems = [item, ..._collectorItems]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openLegoSwap() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LegoSwapScreen(
          items: _legoSwaps,
          userName: _userName,
          onAdd: (item) {
            setState(() => _legoSwaps = [item, ..._legoSwaps]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openChessClub() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ChessClubScreen(
          items: _chessChallenges,
          userName: _userName,
          onAdd: (item) {
            setState(() => _chessChallenges = [item, ..._chessChallenges]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openLocalArt() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LocalArtScreen(
          items: _localArtWorks,
          userName: _userName,
          onAdd: (item) {
            setState(() => _localArtWorks = [item, ..._localArtWorks]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openMemorialGuide() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => MemorialGuideScreen(spots: _memorialSpots),
      ),
    );
  }

  void _openMedicineChest() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => MedicineChestScreen(
          items: _medicineOffers,
          userName: _userName,
          onAdd: (item) {
            setState(() => _medicineOffers = [item, ..._medicineOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openUserBackup() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => UserBackupScreen(onExportBackup: _exportUserBackupJson),
      ),
    );
  }

  void _exportUserBackupJson() {
    final payload = {
      'app': AppInfo.name,
      'kind': 'user-backup-json',
      'exportedAt': DateTime.now().toIso8601String(),
      'userName': _userName,
      'ownAnnouncements': _announcements
          .where((item) => item.isMine)
          .map((item) => item.toJson())
          .toList(),
      'favoriteThreads': _announcements
          .where((item) => item.isFavorite)
          .map((item) => item.toJson())
          .toList(),
      'searchHistory': _searchHistory,
      'reports': {
        'fireSafety': _fireSafetyReports.map((item) => item.toJson()).toList(),
        'wildDumps': _wildDumps.map((item) => item.toJson()).toList(),
        'airSensors': _airSensors.map((item) => item.toJson()).toList(),
      },
    };
    unawaited(
      NeighborShare.shareText(
        context,
        text: jsonEncode(payload),
        subject: 'Backup JSON Lokalnie Widzew',
        copiedMessage: 'Backup JSON skopiowany do schowka.',
      ),
    );
  }

  void _openVoltageOutages() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => VoltageOutageScreen(
          items: _voltageOutages,
          userName: _userName,
          onAdd: (item) {
            setState(() => _voltageOutages = [item, ..._voltageOutages]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openParkingShare() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ParkingShareScreen(
          items: _parkingShares,
          userName: _userName,
          onAdd: (item) {
            setState(() => _parkingShares = [item, ..._parkingShares]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBlockTools() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BlockToolScreen(
          items: _blockTools,
          userName: _userName,
          onAdd: (item) {
            setState(() => _blockTools = [item, ..._blockTools]);
            _persist();
          },
          onToggle: (item) {
            setState(() {
              _blockTools = [
                for (final row in _blockTools)
                  if (row.id == item.id) item else row,
              ];
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openMushroomTrips() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => MushroomTripScreen(
          items: _mushroomTrips,
          userName: _userName,
          onAdd: (item) {
            setState(() => _mushroomTrips = [item, ..._mushroomTrips]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSmileTutors() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SmileTutorScreen(
          items: _smileTutors,
          userName: _userName,
          onAdd: (item) {
            setState(() => _smileTutors = [item, ..._smileTutors]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openUpcycleCraft() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => UpcycleCraftScreen(
          items: _upcycleOffers,
          userName: _userName,
          onAdd: (item) {
            setState(() => _upcycleOffers = [item, ..._upcycleOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openClassicCars() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ClassicCarScreen(
          items: _classicCarMeetups,
          userName: _userName,
          onAdd: (item) {
            setState(() => _classicCarMeetups = [item, ..._classicCarMeetups]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openWalkFinds() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WalkFindScreen(
          items: _walkFinds,
          userName: _userName,
          onAdd: (item) {
            setState(() => _walkFinds = [item, ..._walkFinds]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openGreenWaste() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => GreenWasteScreen(
          items: _greenWastePickups,
          userName: _userName,
          onAdd: (item) {
            setState(() => _greenWastePickups = [item, ..._greenWastePickups]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openTimeCapsule() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => TimeCapsuleScreen(
          items: _timeCapsuleEntries,
          userName: _userName,
          onAdd: (item) {
            setState(
              () => _timeCapsuleEntries = [item, ..._timeCapsuleEntries],
            );
            _persist();
          },
        ),
      ),
    );
  }

  void _openEmergencyRental() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => EmergencyRentalScreen(
          items: _emergencyRentals,
          userName: _userName,
          onAdd: (item) {
            setState(() => _emergencyRentals = [item, ..._emergencyRentals]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openHomeModuleVisibility() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => HomeModuleVisibilityScreen(
          visibility: _homeModuleVisibility,
          onSave: (value) {
            setState(() => _homeModuleVisibility = value);
            _persist();
          },
        ),
      ),
    );
  }

  void _openHeatAlerts() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => HeatAlertScreen(
          items: _heatAlerts,
          userName: _userName,
          onAdd: (item) {
            setState(() => _heatAlerts = [item, ..._heatAlerts]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openMallCarpool() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => MallCarpoolScreen(
          items: _mallCarpools,
          userName: _userName,
          onAdd: (item) {
            setState(() => _mallCarpools = [item, ..._mallCarpools]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPramRacks() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PramRackScreen(
          items: _pramRacks,
          userName: _userName,
          onAdd: (item) {
            setState(() => _pramRacks = [item, ..._pramRacks]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openRtvRepair() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => RtvRepairScreen(
          items: _rtvRepairs,
          userName: _userName,
          onAdd: (item) {
            setState(() => _rtvRepairs = [item, ..._rtvRepairs]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openKidCostumes() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => KidCostumeScreen(
          items: _kidCostumes,
          userName: _userName,
          onAdd: (item) {
            setState(() => _kidCostumes = [item, ..._kidCostumes]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openModelFair() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ModelFairScreen(
          items: _modelFairItems,
          userName: _userName,
          onAdd: (item) {
            setState(() => _modelFairItems = [item, ..._modelFairItems]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openFishingClub() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FishingClubScreen(
          items: _fishingPosts,
          userName: _userName,
          onAdd: (item) {
            setState(() => _fishingPosts = [item, ..._fishingPosts]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openFinanceTips() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FinanceTipScreen(
          items: _financeTips,
          userName: _userName,
          onAdd: (item) {
            setState(() => _financeTips = [item, ..._financeTips]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openWildlifeShelters() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WildlifeShelterScreen(
          items: _wildlifeShelters,
          userName: _userName,
          onAdd: (item) {
            setState(() => _wildlifeShelters = [item, ..._wildlifeShelters]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPetPros() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PetProScreen(
          items: _petProReviews,
          userName: _userName,
          onAdd: (item) {
            setState(() => _petProReviews = [item, ..._petProReviews]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openStreetArchive() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => StreetArchiveScreen(entries: _streetArchive),
      ),
    );
  }

  void _openWidzewSkins() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) =>
            WidzewSkinScreen(selected: _widzewSkin, onChanged: _setWidzewSkin),
      ),
    );
  }

  void _openSmogFilters() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SmogFilterScreen(
          items: _smogFilters,
          userName: _userName,
          onAdd: (item) {
            setState(() => _smogFilters = [item, ..._smogFilters]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openWaterPressure() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WaterPressureScreen(
          items: _waterPressures,
          userName: _userName,
          onAdd: (item) {
            setState(() => _waterPressures = [item, ..._waterPressures]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSolarShare() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SolarShareScreen(
          items: _solarPosts,
          userName: _userName,
          onAdd: (item) {
            setState(() => _solarPosts = [item, ..._solarPosts]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPrint3d() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => Print3dScreen(
          items: _print3dOffers,
          userName: _userName,
          onAdd: (item) {
            setState(() => _print3dOffers = [item, ..._print3dOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSportKits() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SportKitScreen(
          items: _sportKits,
          userName: _userName,
          onAdd: (item) {
            setState(() => _sportKits = [item, ..._sportKits]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSeniorShop() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SeniorShopScreen(
          items: _seniorShops,
          userName: _userName,
          onAdd: (item) {
            setState(() => _seniorShops = [item, ..._seniorShops]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openParkChess() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ParkChessScreen(
          items: _parkChessMeetups,
          userName: _userName,
          onAdd: (item) {
            setState(() => _parkChessMeetups = [item, ..._parkChessMeetups]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openScamAlerts() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ScamAlertScreen(
          items: _scamAlerts,
          userName: _userName,
          onAdd: (item) {
            setState(() => _scamAlerts = [item, ..._scamAlerts]);
            _persist();
          },
          onNotifyNeighbors: _notifyScamNeighbors,
        ),
      ),
    );
  }

  void _notifyScamNeighbors(ScamAlert alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ostrzeżenie o oszustwie wysłane do sąsiadów: ${alert.kind.label}.',
        ),
      ),
    );
  }

  void _openStreetArt() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => StreetArtScreen(
          items: _streetArtSpots,
          userName: _userName,
          onAdd: (item) {
            setState(() => _streetArtSpots = [item, ..._streetArtSpots]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPlantHotel() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PlantHotelScreen(
          items: _plantHotelStays,
          userName: _userName,
          onAdd: (item) {
            setState(() => _plantHotelStays = [item, ..._plantHotelStays]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openWindowViews() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WindowViewScreen(
          items: _windowViews,
          userName: _userName,
          onAdd: (item) {
            setState(() => _windowViews = [item, ..._windowViews]);
            _persist();
          },
        ),
      ),
    );
  }

  void _onVersionTileTap() {
    _diagnosticsTapCount += 1;
    if (_diagnosticsTapCount < 5) return;
    _diagnosticsTapCount = 0;
    setState(() => _diagnosticsUnlocked = true);
    _persist();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Panel diagnostyczny odblokowany.')),
    );
  }

  void _unlockDiagnostics() {
    setState(() => _diagnosticsUnlocked = true);
    _persist();
  }

  void _openDiagnostics() {
    final snapshot = _currentSnapshot();
    final encoded = jsonEncode(snapshot.toJson());
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AppDiagnosticsScreen(
          unlocked: _diagnosticsUnlocked,
          announcementCount: _announcements.length,
          snapshotFieldCount: snapshot.toJson().length,
          jsonChars: encoded.length,
          backendLabel: 'LocalPreferencesBackend (lokalnie_widzew_doc_)',
          errorLogs: _errorLogs,
          onUnlock: _unlockDiagnostics,
        ),
      ),
    );
  }

  void _openStairClean() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => StairCleanScreen(
          items: _stairCleans,
          userName: _userName,
          onAdd: (item) {
            setState(() => _stairCleans = [item, ..._stairCleans]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openAirportRides() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AirportRideScreen(
          items: _airportRides,
          userName: _userName,
          onAdd: (item) {
            setState(() => _airportRides = [item, ..._airportRides]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openEnergyRecipes() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => EnergyRecipeScreen(
          items: _energyRecipes,
          userName: _userName,
          onAdd: (item) {
            setState(() => _energyRecipes = [item, ..._energyRecipes]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openGardenToolCare() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => GardenToolCareScreen(
          items: _gardenToolCares,
          userName: _userName,
          onAdd: (item) {
            setState(() => _gardenToolCares = [item, ..._gardenToolCares]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openLangBooks() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LangBookScreen(
          items: _langBooks,
          userName: _userName,
          onAdd: (item) {
            setState(() => _langBooks = [item, ..._langBooks]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openStreetball() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => StreetballScreen(
          items: _streetballMeetups,
          userName: _userName,
          onAdd: (item) {
            setState(() => _streetballMeetups = [item, ..._streetballMeetups]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openIndieCinema() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => IndieCinemaScreen(
          items: _indieCinemaPosts,
          userName: _userName,
          onAdd: (item) {
            setState(() => _indieCinemaPosts = [item, ..._indieCinemaPosts]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openLostPets() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LostPetScreen(
          items: _lostPets,
          userName: _userName,
          onAdd: (item) {
            setState(() => _lostPets = [item, ..._lostPets]);
            _persist();
          },
          onNotifyNearby: _notifyLostPetNearby,
        ),
      ),
    );
  }

  void _notifyLostPetNearby(LostPetAlert alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Push do sąsiadów w promieniu kilku bloków: ${alert.kind.label}.',
        ),
      ),
    );
  }

  void _openEwasteMap() {
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => EwasteMapScreen(items: _ewastePoints)),
    );
  }

  void _openFilamentShare() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FilamentShareScreen(
          items: _filamentShares,
          userName: _userName,
          onAdd: (item) {
            setState(() => _filamentShares = [item, ..._filamentShares]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openIndustryMemory() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => IndustryMemoryScreen(entries: _industryMemories),
      ),
    );
  }

  void _openAchievementShare() {
    final swapCount =
        _smileGifts.length +
        _legoSwaps.length +
        _sportKits.length +
        _kidCostumes.length +
        _langBooks.length;
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AchievementShareScreen(
          userName: _userName,
          swapCount: swapCount,
          helpPoints: _neighborQuestPoints,
          createdCount: _createdAnnouncementCount,
          onShare: _shareAchievementCard,
        ),
      ),
    );
  }

  void _shareAchievementCard(String text) {
    unawaited(
      NeighborShare.shareText(
        context,
        text: text,
        subject: 'Karta osiągnięć Lokalnie Widzew',
        copiedMessage: 'Kartę osiągnięć skopiowano do schowka.',
      ),
    );
  }

  void _openMpoBulky() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => MpoBulkyScreen(
          items: _bulkySlots,
          userName: _userName,
          onAdd: (item) {
            setState(() => _bulkySlots = [item, ..._bulkySlots]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openHolyCrossTrips() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => HolyCrossTripScreen(
          items: _holyCrossTrips,
          userName: _userName,
          onAdd: (item) {
            setState(() => _holyCrossTrips = [item, ..._holyCrossTrips]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPreserveJars() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PreserveJarScreen(
          items: _preserveJars,
          userName: _userName,
          onAdd: (item) {
            setState(() => _preserveJars = [item, ..._preserveJars]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPcvWindows() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PcvWindowScreen(
          items: _pcvWindows,
          userName: _userName,
          onAdd: (item) {
            setState(() => _pcvWindows = [item, ..._pcvWindows]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSchoolGear() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SchoolGearScreen(
          items: _schoolGear,
          userName: _userName,
          onAdd: (item) {
            setState(() => _schoolGear = [item, ..._schoolGear]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openTableSports() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => TableSportScreen(
          items: _tableSports,
          userName: _userName,
          onAdd: (item) {
            setState(() => _tableSports = [item, ..._tableSports]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPolishFantasy() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PolishFantasyScreen(
          items: _fantasyOffers,
          userName: _userName,
          onAdd: (item) {
            setState(() => _fantasyOffers = [item, ..._fantasyOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openGasInspections() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => GasInspectionScreen(
          items: _gasInspections,
          userName: _userName,
          onAdd: (item) {
            setState(() => _gasInspections = [item, ..._gasInspections]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openScooterHubs() {
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => ScooterHubScreen(items: _scooterHubs)),
    );
  }

  void _openHepaTrackers() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => HepaTrackerScreen(
          items: _hepaTrackers,
          userName: _userName,
          onAdd: (item) {
            setState(() => _hepaTrackers = [item, ..._hepaTrackers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openWidzewFilms() {
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => WidzewFilmScreen(items: _filmClips)),
    );
  }

  void _openActivityReport() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ActivityReportScreen(
          onExportCsv: _exportActivityCsv,
          onExportPdfText: _exportActivityPdfText,
        ),
      ),
    );
  }

  String _activityReportBody({required bool csv}) {
    final own = _announcements.where((item) => item.isMine).toList();
    final favorites = _announcements.where((item) => item.isFavorite).toList();
    if (csv) {
      final rows = <List<String>>[
        ['typ', 'tytul', 'szczegol'],
        ['uzytkownik', _userName, _defaultSubDistrict],
        ['liczba_zgloszen', '$_createdAnnouncementCount', ''],
        for (final item in own) ['ogloszenie', item.title, item.category],
        for (final item in favorites) ['ulubione', item.title, item.category],
        for (final item in _bulkySlots)
          ['gabaryt_mpo', item.street, item.whenText],
        for (final item in _holyCrossTrips)
          ['swietokrzyskie', item.title, item.whenText],
        for (final item in _gasInspections)
          ['przeglad_gazu', item.kind, item.whenText],
      ];
      return rows.map((row) => row.map(_csvCell).join(',')).join('\n');
    }
    return [
      'Lokalnie Widzew — raport aktywności',
      'Użytkownik: $_userName',
      'Osiedle: $_defaultSubDistrict',
      'Liczba zgłoszeń: $_createdAnnouncementCount',
      'Moje ogłoszenia: ${own.length}',
      'Ulubione: ${favorites.length}',
      'Gabaryty MPO: ${_bulkySlots.length}',
      'Wyjazdy Świętokrzyskie: ${_holyCrossTrips.length}',
      'Przeglądy gazu: ${_gasInspections.length}',
      for (final item in own) '- ${item.title}',
    ].join('\n');
  }

  String _csvCell(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  void _exportActivityCsv() {
    unawaited(
      NeighborShare.shareText(
        context,
        text: _activityReportBody(csv: true),
        subject: 'Raport CSV Lokalnie Widzew',
        copiedMessage: 'Raport CSV skopiowany do schowka.',
      ),
    );
  }

  void _exportActivityPdfText() {
    unawaited(
      NeighborShare.shareText(
        context,
        text: _activityReportBody(csv: false),
        subject: 'Raport PDF Lokalnie Widzew',
        copiedMessage: 'Raport PDF (tekst) skopiowany do schowka.',
      ),
    );
  }

  void _openBalconyWash() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BalconyWashScreen(
          items: _balconyWashes,
          userName: _userName,
          onAdd: (item) {
            setState(() => _balconyWashes = [item, ..._balconyWashes]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openForestForage() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ForestForageScreen(
          items: _forestForageTrips,
          userName: _userName,
          onAdd: (item) {
            setState(() => _forestForageTrips = [item, ..._forestForageTrips]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openEcoCleaners() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => EcoCleanerScreen(
          items: _ecoCleanRecipes,
          userName: _userName,
          onAdd: (item) {
            setState(() => _ecoCleanRecipes = [item, ..._ecoCleanRecipes]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openLockCare() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LockCareScreen(
          items: _lockCareTips,
          userName: _userName,
          onAdd: (item) {
            setState(() => _lockCareTips = [item, ..._lockCareTips]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSeasonalSkates() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SeasonalSkateScreen(
          items: _seasonalSkates,
          userName: _userName,
          onAdd: (item) {
            setState(() => _seasonalSkates = [item, ..._seasonalSkates]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openDartBilliard() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => DartBilliardScreen(
          items: _dartBilliards,
          userName: _userName,
          onAdd: (item) {
            setState(() => _dartBilliards = [item, ..._dartBilliards]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openRockMetal() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => RockMetalScreen(
          items: _rockMetalPosts,
          userName: _userName,
          onAdd: (item) {
            setState(() => _rockMetalPosts = [item, ..._rockMetalPosts]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCarPolicies() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CarPolicyScreen(
          items: _carPolicies,
          userName: _userName,
          onAdd: (item) {
            setState(() => _carPolicies = [item, ..._carPolicies]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPhoneCharge() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PhoneChargeScreen(items: _phoneChargeHubs),
      ),
    );
  }

  void _openAirPlants() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AirPlantScreen(
          items: _airPlants,
          userName: _userName,
          onAdd: (item) {
            setState(() => _airPlants = [item, ..._airPlants]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openTramPhotos() {
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => TramPhotoScreen(items: _tramPhotos)),
    );
  }

  void _openLocalVault() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LocalVaultScreen(
          pinEnabled: _localVaultPinEnabled,
          pinCode: _localVaultPin,
          biometricEnabled: _biometricUnlockEnabled,
          onChanged:
              ({
                required bool pinEnabled,
                required String pinCode,
                required bool biometricEnabled,
              }) {
                setState(() {
                  _localVaultPinEnabled = pinEnabled;
                  _localVaultPin = pinCode;
                  _biometricUnlockEnabled = biometricEnabled;
                });
                _persist();
              },
        ),
      ),
    );
  }

  void _openCarpetVac() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CarpetVacScreen(
          items: _carpetVacs,
          userName: _userName,
          onAdd: (item) {
            setState(() => _carpetVacs = [item, ..._carpetVacs]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openKayakTrips() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => KayakTripScreen(
          items: _kayakTrips,
          userName: _userName,
          onAdd: (item) {
            setState(() => _kayakTrips = [item, ..._kayakTrips]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openLunchboxes() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LunchboxScreen(
          items: _lunchboxes,
          userName: _userName,
          onAdd: (item) {
            setState(() => _lunchboxes = [item, ..._lunchboxes]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openGardenFurniture() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => GardenFurnitureScreen(
          items: _gardenFurnitureTips,
          userName: _userName,
          onAdd: (item) {
            setState(
              () => _gardenFurnitureTips = [item, ..._gardenFurnitureTips],
            );
            _persist();
          },
        ),
      ),
    );
  }

  void _openPuzzleSwap() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PuzzleSwapScreen(
          items: _puzzleSwaps,
          userName: _userName,
          onAdd: (item) {
            setState(() => _puzzleSwaps = [item, ..._puzzleSwaps]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openAmateurTheater() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AmateurTheaterScreen(
          items: _amateurTheaters,
          userName: _userName,
          onAdd: (item) {
            setState(() => _amateurTheaters = [item, ..._amateurTheaters]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openElectroAmbient() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ElectroAmbientScreen(
          items: _electroAmbientPosts,
          userName: _userName,
          onAdd: (item) {
            setState(
              () => _electroAmbientPosts = [item, ..._electroAmbientPosts],
            );
            _persist();
          },
        ),
      ),
    );
  }

  void _openWaterFilters() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => WaterFilterScreen(
          items: _waterFilters,
          userName: _userName,
          onAdd: (item) {
            setState(() => _waterFilters = [item, ..._waterFilters]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openFarmStalls() {
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => FarmStallScreen(items: _farmStalls)),
    );
  }

  void _openAquariumSwap() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AquariumSwapScreen(
          items: _aquariumSwaps,
          userName: _userName,
          onAdd: (item) {
            setState(() => _aquariumSwaps = [item, ..._aquariumSwaps]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCinemaPhotos() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CinemaPhotoScreen(items: _cinemaPhotos),
      ),
    );
  }

  void _openAppCache() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AppCacheScreen(
          cacheKb: _appCacheKb,
          refreshedAt: _cacheRefreshedAt,
          onClearCache: _clearAppCache,
          onRefreshAnnouncements: _refreshCachedAnnouncements,
        ),
      ),
    );
  }

  void _clearAppCache() {
    setState(() => _appCacheKb = 8);
    _persist();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache aplikacji wyczyszczony.')),
    );
  }

  void _refreshCachedAnnouncements() {
    final now = DateTime.now();
    final stamp =
        '${now.day.toString().padLeft(2, '0')}.'
        '${now.month.toString().padLeft(2, '0')}.'
        '${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
    setState(() {
      _cacheRefreshedAt = stamp;
      _appCacheKb = 48;
    });
    _persist();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pobrane ogłoszenia odświeżone.')),
    );
  }

  void _openPavementClean() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PavementCleanScreen(
          items: _pavementCleans,
          userName: _userName,
          onAdd: (item) {
            setState(() => _pavementCleans = [item, ..._pavementCleans]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openThermalTrips() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ThermalTripScreen(
          items: _thermalTrips,
          userName: _userName,
          onAdd: (item) {
            setState(() => _thermalTrips = [item, ..._thermalTrips]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSourdough() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SourdoughScreen(
          items: _sourdoughRecipes,
          userName: _userName,
          onAdd: (item) {
            setState(() => _sourdoughRecipes = [item, ..._sourdoughRecipes]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openRollerShutters() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => RollerShutterScreen(
          items: _rollerShutters,
          userName: _userName,
          onAdd: (item) {
            setState(() => _rollerShutters = [item, ..._rollerShutters]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBeachGear() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BeachGearScreen(
          items: _beachGear,
          userName: _userName,
          onAdd: (item) {
            setState(() => _beachGear = [item, ..._beachGear]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBocce() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BocceMeetupScreen(
          items: _bocceMeetups,
          userName: _userName,
          onAdd: (item) {
            setState(() => _bocceMeetups = [item, ..._bocceMeetups]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openDiscoRetro() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => DiscoRetroScreen(
          items: _discoRetroPosts,
          userName: _userName,
          onAdd: (item) {
            setState(() => _discoRetroPosts = [item, ..._discoRetroPosts]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openCarOil() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => CarOilScreen(
          items: _carOilReminders,
          userName: _userName,
          onAdd: (item) {
            setState(() => _carOilReminders = [item, ..._carOilReminders]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPramAccess() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PramAccessScreen(items: _pramAccessSpots),
      ),
    );
  }

  void _openBalconyHerbs() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BalconyHerbScreen(
          items: _balconyHerbs,
          userName: _userName,
          onAdd: (item) {
            setState(() => _balconyHerbs = [item, ..._balconyHerbs]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBazaarPhotos() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BazaarPhotoScreen(items: _bazaarPhotos),
      ),
    );
  }

  void _openAccessPanel() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AccessPanelScreen(
          textScale: _accessTextScale,
          highContrast: _accessHighContrast,
          readability: _accessReadability,
          onChanged:
              ({
                required double textScale,
                required bool highContrast,
                required bool readability,
              }) {
                setState(() {
                  _accessTextScale = textScale;
                  _accessHighContrast = highContrast;
                  _accessReadability = readability;
                });
                _persist();
              },
        ),
      ),
    );
  }

  void _openBenchPaint() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BenchPaintScreen(
          items: _benchPaints,
          userName: _userName,
          onAdd: (item) {
            setState(() => _benchPaints = [item, ..._benchPaints]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSudetyTrips() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SudetyTripScreen(
          items: _sudetyTrips,
          userName: _userName,
          onAdd: (item) {
            setState(() => _sudetyTrips = [item, ..._sudetyTrips]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openFruitPreserves() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FruitPreserveScreen(
          items: _fruitPreserves,
          userName: _userName,
          onAdd: (item) {
            setState(() => _fruitPreserves = [item, ..._fruitPreserves]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openHomeSafes() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => HomeSafeScreen(
          items: _homeSafes,
          userName: _userName,
          onAdd: (item) {
            setState(() => _homeSafes = [item, ..._homeSafes]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBikeChild() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BikeChildScreen(
          items: _bikeChildOffers,
          userName: _userName,
          onAdd: (item) {
            setState(() => _bikeChildOffers = [item, ..._bikeChildOffers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBadminton() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BadmintonMeetupScreen(
          items: _badmintonMeetups,
          userName: _userName,
          onAdd: (item) {
            setState(() => _badmintonMeetups = [item, ..._badmintonMeetups]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openJazzBlues() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => JazzBluesScreen(
          items: _jazzBluesPosts,
          userName: _userName,
          onAdd: (item) {
            setState(() => _jazzBluesPosts = [item, ..._jazzBluesPosts]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSmokeAlarms() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SmokeAlarmScreen(
          items: _smokeAlarms,
          userName: _userName,
          onAdd: (item) {
            setState(() => _smokeAlarms = [item, ..._smokeAlarms]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSourdoughShops() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SourdoughShopScreen(items: _sourdoughShops),
      ),
    );
  }

  void _openPetBirds() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PetBirdScreen(
          items: _petBirds,
          userName: _userName,
          onAdd: (item) {
            setState(() => _petBirds = [item, ..._petBirds]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPavilionPhotos() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PavilionPhotoScreen(items: _pavilionPhotos),
      ),
    );
  }

  void _openPinnedTool(String id) {
    switch (id) {
      case 'parking-mark':
        _openParkingMarks();
      case 'bieszczady':
        _openBieszczadyTrips();
      case 'pitcher':
        _openPitcherFilters();
      case 'clothes-bin':
        _openClothesBins();
      case 'tennis':
        _openTennisSquash();
      case 'opera':
        _openClassicalOpera();
    }
  }

  void _openParkingMarks() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ParkingMarkScreen(
          items: _parkingMarks,
          userName: _userName,
          onAdd: (item) {
            setState(() => _parkingMarks = [item, ..._parkingMarks]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBieszczadyTrips() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BieszczadyTripScreen(
          items: _bieszczadyTrips,
          userName: _userName,
          onAdd: (item) {
            setState(() => _bieszczadyTrips = [item, ..._bieszczadyTrips]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openFruitVinegars() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => FruitVinegarScreen(
          items: _fruitVinegars,
          userName: _userName,
          onAdd: (item) {
            setState(() => _fruitVinegars = [item, ..._fruitVinegars]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openVideoIntercoms() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => VideoIntercomScreen(
          items: _videoIntercoms,
          userName: _userName,
          onAdd: (item) {
            setState(() => _videoIntercoms = [item, ..._videoIntercoms]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openBabyCarriers() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => BabyCarrierScreen(
          items: _babyCarriers,
          userName: _userName,
          onAdd: (item) {
            setState(() => _babyCarriers = [item, ..._babyCarriers]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openTennisSquash() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => TennisSquashScreen(
          items: _tennisSquashMeetups,
          userName: _userName,
          onAdd: (item) {
            setState(
              () => _tennisSquashMeetups = [item, ..._tennisSquashMeetups],
            );
            _persist();
          },
        ),
      ),
    );
  }

  void _openClassicalOpera() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ClassicalOperaScreen(
          items: _classicalOperaPosts,
          userName: _userName,
          onAdd: (item) {
            setState(
              () => _classicalOperaPosts = [item, ..._classicalOperaPosts],
            );
            _persist();
          },
        ),
      ),
    );
  }

  void _openPitcherFilters() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PitcherFilterScreen(
          items: _pitcherFilters,
          userName: _userName,
          onAdd: (item) {
            setState(() => _pitcherFilters = [item, ..._pitcherFilters]);
            _persist();
          },
          onReset: (item) {
            setState(() {
              _pitcherFilters = [
                for (final entry in _pitcherFilters)
                  if (entry.id == item.id) item else entry,
              ];
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openClothesBins() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ClothesBinScreen(
          items: _clothesBins,
          onUpdate: (item) {
            setState(() {
              _clothesBins = [
                for (final entry in _clothesBins)
                  if (entry.id == item.id) item else entry,
              ];
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openAquaLivestock() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => AquaStockScreen(
          items: _aquaLivestock,
          userName: _userName,
          onAdd: (item) {
            setState(() => _aquaLivestock = [item, ..._aquaLivestock]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSchoolPhotos() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SchoolPhotoScreen(items: _schoolPhotos),
      ),
    );
  }

  void _openHomeShortcuts() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => HomeShortcutsScreen(
          tileOrder: _homeTileOrder,
          pinnedIds: _homePinnedTools,
          onSave: (order, pins) {
            setState(() {
              _homeTileOrder = List.of(order);
              _homePinnedTools = List.of(pins);
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openSidewalkSalts() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SidewalkSaltScreen(
          items: _sidewalkSalts,
          userName: _userName,
          onAdd: (item) {
            setState(() => _sidewalkSalts = [item, ..._sidewalkSalts]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openLandscapeParkTrips() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LandscapeParkTripScreen(
          items: _landscapeParkTrips,
          userName: _userName,
          onAdd: (item) {
            setState(
              () => _landscapeParkTrips = [item, ..._landscapeParkTrips],
            );
            _persist();
          },
        ),
      ),
    );
  }

  void _openVeggiePickles() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => VeggiePickleScreen(
          items: _veggiePickles,
          userName: _userName,
          onAdd: (item) {
            setState(() => _veggiePickles = [item, ..._veggiePickles]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openRadiatorThermos() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => RadiatorThermoScreen(
          items: _radiatorThermos,
          userName: _userName,
          onAdd: (item) {
            setState(() => _radiatorThermos = [item, ..._radiatorThermos]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openArcheryGear() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ArcheryGearScreen(
          items: _archeryGear,
          userName: _userName,
          onAdd: (item) {
            setState(() => _archeryGear = [item, ..._archeryGear]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openYardGames() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => YardGameScreen(
          items: _yardGames,
          userName: _userName,
          onAdd: (item) {
            setState(() => _yardGames = [item, ..._yardGames]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openPolishFilms() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => PolishFilmScreen(
          items: _polishFilms,
          userName: _userName,
          onAdd: (item) {
            setState(() => _polishFilms = [item, ..._polishFilms]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openSafetyKits() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SafetyKitScreen(
          items: _safetyKits,
          userName: _userName,
          onAdd: (item) {
            setState(() => _safetyKits = [item, ..._safetyKits]);
            _persist();
          },
          onReset: (item) {
            setState(() {
              _safetyKits = [
                for (final entry in _safetyKits)
                  if (entry.id == item.id) item else entry,
              ];
            });
            _persist();
          },
        ),
      ),
    );
  }

  void _openSodaCo2() {
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => SodaCo2Screen(items: _sodaCo2Spots)),
    );
  }

  void _openTerrariumPets() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => TerrariumPetScreen(
          items: _terrariumPets,
          userName: _userName,
          onAdd: (item) {
            setState(() => _terrariumPets = [item, ..._terrariumPets]);
            _persist();
          },
        ),
      ),
    );
  }

  void _openParkPhotos() {
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => ParkPhotoScreen(items: _parkPhotos)),
    );
  }

  void _openSoundAlerts() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SoundAlertScreen(
          prefs: _soundAlerts,
          onSave: (prefs) {
            setState(() => _soundAlerts = prefs);
            _persist();
          },
        ),
      ),
    );
  }

  Map<String, VoidCallback> get _hubOpeners => {
    'carpool': _openCarpool,
    'night-carpool': _openNightCarpool,
    'winter-help': _openWinterHelp,
    'long-distance': _openLongDistanceRides,
    'airport': _openAirportRides,
    'student-rides': _openStudentRides,
    'mall-carpool': _openMallCarpool,
    'cargo-carpool': _openCargoCarpool,
    'bieszczady': _openBieszczadyTrips,
    'landscape-park': _openLandscapeParkTrips,
    'weekend-trips': _openWeekendTrips,
    'sudety': _openSudetyTrips,
    'holy-cross': _openHolyCrossTrips,
    'thermal': _openThermalTrips,
    'kayak': _openKayakTrips,
    'parking-share': _openParkingShare,
    'parking-mark': _openParkingMarks,
    'garage': _openGarageListings,
    'car-oil': _openCarOil,
    'car-policy': _openCarPolicies,
    'classic-cars': _openClassicCars,
    'ev-charging': _openEvCharging,
    'scooter': _openScooterHubs,
    'bike-help': _openBikeHelp,
    'bike-stations': _openBikeStations,
    'bike-trips': _openBikeTrips,
    'bike-child': _openBikeChild,
    'trailer': _openTrailerShare,
    'found-plates': _openFoundPlates,
    'walking-bus': _openWalkingBus,
    'handy-jobs': _openHandyJobs,
    'services': _openServices,
    'roller-shutters': _openRollerShutters,
    'radiator': _openRadiatorThermos,
    'video-intercom': _openVideoIntercoms,
    'pcv-windows': _openPcvWindows,
    'lock-care': _openLockCare,
    'home-safe': _openHomeSafes,
    'smoke-alarms': _openSmokeAlarms,
    'safety-kits': _openSafetyKits,
    'fire-safety': _openFireSafety,
    'gas-inspections': _openGasInspections,
    'water-pressure': _openWaterPressure,
    'water-filters': _openWaterFilters,
    'pitcher': _openPitcherFilters,
    'hepa': _openHepaTrackers,
    'smog-filters': _openSmogFilters,
    'carpet-vac': _openCarpetVac,
    'balcony-wash': _openBalconyWash,
    'pavement-clean': _openPavementClean,
    'sidewalk-salt': _openSidewalkSalts,
    'stair-clean': _openStairClean,
    'block-tools': _openBlockTools,
    'shared-tools': _openSharedTools,
    'rtv-repair': _openRtvRepair,
    'small-appliances': _openSmallAppliances,
    'print-3d': _openPrint3d,
    'filament': _openFilamentShare,
    'home-assistant': _openHomeAssistant,
    'diy': _openDiyAcademy,
    'workshop-garage': _openWorkshopGarage,
    'emergency-rental': _openEmergencyRental,
    'flea-market': _openFleaMarket,
    'barter': _openBarter,
    'baby-carriers': _openBabyCarriers,
    'baby-gear': _openBabyGear,
    'kid-costumes': _openKidCostumes,
    'school-gear': _openSchoolGear,
    'school-books': _openSchoolBooks,
    'pram-racks': _openPramRacks,
    'pram-access': _openPramAccess,
    'sport-kits': _openSportKits,
    'venue': _openVenueBooking,
    'fitness-gear': _openFitnessGear,
    'beach-gear': _openBeachGear,
    'camp-gear': _openCampGear,
    'party-gear': _openPartyGear,
    'av-gear': _openAvGear,
    'workwear': _openWorkwear,
    'clothes-bin': _openClothesBins,
    'clothes-recycle': _openClothesBins,
    'smile-gifts': _openSmileGifts,
    'lego': _openLegoSwap,
    'puzzle': _openPuzzleSwap,
    'books': _openBookShelf,
    'medical-gear': _openMedicalGear,
    'parents': _openParentsClub,
    'groups': _openGroups,
    'time-bank': _openTimeBank,
    'parcel-lockers': _openParcelLockers,
    'charity': _openCharityDrives,
    'generation': _openGenerationBridge,
    'compost': _openCompostSwap,
    'balcony-herbs': _openBalconyHerbs,
    'air-plants': _openAirPlants,
    'garden-notes': _openGardenNotes,
    'plant-swap': _openPlantSwap,
    'plant-hotel': _openPlantHotel,
    'sourdough': _openSourdough,
    'sourdough-shops': _openSourdoughShops,
    'veggie-pickles': _openVeggiePickles,
    'fruit-vinegar': _openFruitVinegars,
    'fruit-preserves': _openFruitPreserves,
    'preserve-jars': _openPreserveJars,
    'jar-swap': _openJarSwap,
    'food-share': _openFoodShare,
    'lunchboxes': _openLunchboxes,
    'farm-stalls': _openFarmStalls,
    'rod-share': _openRodShare,
    'green-waste': _openGreenWaste,
    'eco-patrol': _openEcoPatrol,
    'waste-points': _openWastePoints,
    'wild-dump': _openWildDump,
    'ewaste': _openEwasteMap,
    'bulk-waste': _openBulkWaste,
    'mpo-bulky': _openMpoBulky,
    'soda-co2': _openSodaCo2,
    'aqua': _openAquaLivestock,
    'aquarium-swap': _openAquariumSwap,
    'terrarium': _openTerrariumPets,
    'pet-birds': _openPetBirds,
    'pet-sit': _openPetSit,
    'pet-blood': _openPetBlood,
    'lost-pets': _openLostPets,
    'wildlife-care': _openWildlifeCare,
    'animal-patrol': _openAnimalPatrol,
    'bocce': _openBocce,
    'yard-games': _openYardGames,
    'tennis': _openTennisSquash,
    'badminton': _openBadminton,
    'chess': _openChessClub,
    'park-chess': _openParkChess,
    'board-games': _openBoardGames,
    'vinyl': _openVinylSwap,
    'classical-opera': _openClassicalOpera,
    'jazz': _openJazzBlues,
    'rock-metal': _openRockMetal,
    'disco-retro': _openDiscoRetro,
    'electro': _openElectroAmbient,
    'cine-club': _openCineClub,
    'indie-cinema': _openIndieCinema,
    'polish-film': _openPolishFilms,
    'amateur-theater': _openAmateurTheater,
    'culture-events': _openCultureEvents,
    'widzew-history': _openWidzewHistory,
    'school-photos': _openSchoolPhotos,
    'park-photos': _openParkPhotos,
    'pavilion-photos': _openPavilionPhotos,
    'bazaar-photos': _openBazaarPhotos,
    'cinema-photos': _openCinemaPhotos,
    'tram-photos': _openTramPhotos,
    'street-archive': _openStreetArchive,
    'slab-museum': _openSlabMuseum,
    'industry-memory': _openIndustryMemory,
    'photo-club': _openPhotoClub,
    'archery': _openArcheryGear,
    'network-api': _openNetworkApi,
    'access-panel': _openAccessPanel,
    'sound-alerts': _openSoundAlerts,
    'home-shortcuts': _openHomeShortcuts,
    'home-modules': _openHomeModuleVisibility,
    'app-cache': _openAppCache,
    'diagnostics': _openDiagnostics,
    'user-backup': _openUserBackup,
    'block-push': _openBlockPush,
    'scam-alerts': _openScamAlerts,
    'finance-tips': _openFinanceTips,
    'digital-help': _openDigitalHelp,
  };

  void _openHubModule(String id) {
    _hubOpeners[id]?.call();
  }

  void _openNeighborHub() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => NeighborHubScreen(openers: _hubOpeners),
      ),
    );
  }

  void _openNetworkApi() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => NetworkApiScreen(
          isOnline: _isOnline,
          lastPingOk: _apiLastPingOk,
          lastSyncAt: _apiSyncAt,
          onPing: _pingApi,
          onForceSync: _forceApiSync,
        ),
      ),
    );
  }

  bool _pingApi() {
    final ok = widget.networkGate.current;
    setState(() => _apiLastPingOk = ok);
    _persist();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Ping API: połączenie OK.' : 'Ping API: brak połączenia.',
        ),
      ),
    );
    return ok;
  }

  String _forceApiSync() {
    final now = DateTime.now();
    final stamp =
        '${now.day.toString().padLeft(2, '0')}.'
        '${now.month.toString().padLeft(2, '0')}.'
        '${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
    setState(() => _apiSyncAt = stamp);
    _persist();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Synchronizacja treści wymuszona.')),
    );
    return stamp;
  }

  void _openDistrictEcoStats() {
    final reused =
        _smileGifts.length +
        _leftoverMaterials.length +
        _ledSwaps.length +
        _schoolBooks.length;
    final kg =
        _smileGifts.length * 3.0 +
        _leftoverMaterials.length * 12.0 +
        _ledSwaps.length * 0.4 +
        _ecoCollections.fold<double>(0, (sum, item) => sum + item.kgCollected);
    final trips =
        _carpoolRides.length + _longDistanceRides.length + _studentRides.length;
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => DistrictEcoStatsScreen(
          exchangedKg: kg,
          savedCo2Kg: trips * 4.2,
          carpoolTrips: trips,
          reusedItems: reused,
        ),
      ),
    );
  }

  void _openDistrictReport() {
    final staircases = <String>{
      ..._walkingBusShifts.map((item) => item.staircase),
      ..._staircaseFunds.map((item) => item.title),
    };
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => DistrictReportScreen(
          activeStaircases: staircases.length,
          staircaseNames: staircases.toList(),
          completedInitiatives: _completedInitiatives,
          ranking: _blockRankings,
        ),
      ),
    );
  }

  void _scheduleReminder({required String title, required String body}) {
    final reminder = NeighborReminder(
      id: 'rem-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      body: body,
      remindAt: DateTime.now().add(const Duration(days: 1)),
    );
    setState(() => _reminders = [reminder, ..._reminders]);
    _persist();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Ustawiono przypomnienie na jutro (powiadomienie lokalne).',
        ),
      ),
    );
  }

  void _remindAnnouncement(Announcement announcement) {
    _scheduleReminder(
      title: announcement.title,
      body: 'Wyprzedaż / ogłoszenie: ${announcement.subDistrict}',
    );
  }

  void _remindEvent(NeighborhoodEvent event) {
    _scheduleReminder(title: event.title, body: 'Wydarzenie: ${event.place}');
  }

  Future<void> _loadNeighborProfile() async {
    final loaded = await NeighborProfileStore.load();
    final marketplace = await TradespersonStore.load();
    final pruned = marketplace.prunedExpired();
    if (!mounted) return;
    final explored = await NeighborProfileStore.loadExploredDistricts();
    if (!mounted) return;
    setState(() {
      _avatarIndex = loaded.$1;
      _locationVerified = loaded.$2;
      _avatarPhotoPath = loaded.$3;
      _marketplace = pruned;
      _exploredSubDistricts = List.of(explored);
    });
    if (pruned.helpPosts.length != marketplace.helpPosts.length ||
        pruned.jobRequests.length != marketplace.jobRequests.length) {
      unawaited(TradespersonStore.save(pruned));
    }
    unawaited(_hydrateBadges());
  }

  Future<void> _hydrateBadges() async {
    await BadgeService.load();
    final own = _announcements.where((item) => item.isMine).toList();
    final helpedRepairJob =
        _marketplace.helpPosts.any(
          (post) =>
              (post.acceptedBy ?? '').isNotEmpty &&
              post.acceptedBy == _userName,
        ) ||
        _marketplace.jobRequests.any(
          (job) => job.tradespersonName == _userName,
        );
    final solvedCityReport = _infrastructureReports.any(
      (report) =>
          report.authorName == _userName &&
          report.status == InfrastructureStatus.repaired,
    );
    if (!_locationVerified) {
      await BadgeService.revoke([BadgeIds.gpsVerified]);
    }
    await BadgeService.unlock(
      BadgeManager.idsFromCurrentState(
        createdCount: _createdAnnouncementCount,
        ownAnnouncements: own,
        locationVerified: _locationVerified,
        neighborTrusted: false,
        helpedRepairJob: helpedRepairJob,
        solvedCityReport: solvedCityReport,
      ),
    );
    if (mounted) setState(() {});
  }

  Future<List<String>> _unlockBadges(Iterable<String> ids) async {
    final newly = await BadgeService.unlock(ids);
    if (!mounted || newly.isEmpty) return newly;
    setState(() {});
    BadgeManager.showUnlockedSnackBar(
      context,
      ids: newly,
      onSeeProfile: () => setState(() {
        _groupsLanding = false;
        _currentIndex = 3;
      }),
    );
    return newly;
  }

  void _unlockHelpChatBadges() {
    final related = _helpChatAnnouncement;
    if (related == null) return;
    unawaited(_unlockBadges(BadgeManager.idsForHelpMessage(related)));
  }

  void _persistMarketplace() {
    unawaited(_saveMarketplace());
  }

  Future<void> _saveMarketplace() async {
    final saved = await TradespersonStore.save(_marketplace);
    if (saved || !mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(StorageGuard.diskFullMessage)));
  }

  void _setTradespersonRole(bool enabled) {
    setState(() {
      _marketplace = _marketplace.copyWith(
        account: _marketplace.account.copyWith(
          isTradesperson: enabled,
          listingPublished: enabled
              ? _marketplace.account.listingPublished
              : false,
        ),
      );
    });
    _persistMarketplace();
    if (!enabled || !mounted) return;
    if (!_marketplace.account.card.isComplete) {
      _openTradespersonCard();
    }
  }

  void _openTradespersonCard() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => TradespersonCardScreen(
          initial: _marketplace.account.card,
          onSave: (card) {
            final nipDigits = card.nip.replaceAll(RegExp(r'\D'), '');
            setState(() {
              _marketplace = _marketplace.copyWith(
                account: _marketplace.account.copyWith(
                  isTradesperson: true,
                  card: card,
                  companyVerified: nipDigits.length >= 10,
                ),
              );
            });
            _persistMarketplace();
          },
        ),
      ),
    );
  }

  void _openTradespersonSubscription() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => StatefulBuilder(
          builder: (context, setRouteState) {
            return TradespersonSubscriptionScreen(
              account: _marketplace.account,
              jobRequests: _marketplace.jobRequests,
              onRenew: () async {
                await _renewTradespersonSubscription();
                setRouteState(() {});
              },
              onListingPublishedChanged: (published) {
                if (published && !_marketplace.account.canPublishListing) {
                  return;
                }
                setState(() {
                  _marketplace = _marketplace.copyWith(
                    account: _marketplace.account.copyWith(
                      listingPublished: published,
                    ),
                  );
                });
                _persistMarketplace();
                setRouteState(() {});
              },
            );
          },
        ),
      ),
    );
  }

  Widget _tradespersonCatalogScreen({required int tab}) {
    return TradespersonCatalogScreen(
      account: _marketplace.account,
      clientName: _userName,
      helpPosts: _marketplace.activeHelpPosts(),
      reviews: _marketplace.reviews,
      favoriteListingIds: _marketplace.favoriteListingIds,
      catalogTabIndex: tab,
      onSubmitJob: _submitTradespersonJob,
      onToggleFavorite: _toggleFavoriteTradesperson,
      searchHistory: _marketplace.searchHistory,
      onRecordSearch: _recordTradespersonSearch,
      onRemoveSearch: _removeTradespersonSearch,
      onAddReview: _addTradespersonReview,
      onOpenSubscription: _openTradespersonSubscription,
      onPublishMine: _publishTradespersonListing,
      onAddHelpPost: _addNeighborHelpPost,
      onAcceptHelpPost: _acceptNeighborHelpPost,
      onOpenPortfolio: _openTradespersonPortfolio,
      onOpenPriceList: _openTradespersonPriceList,
    );
  }

  void _openTradespersonCatalogTab() {
    setState(() {
      _groupsLanding = false;
    });
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => _tradespersonCatalogScreen(tab: 0)),
    );
  }

  void _openFavoriteTradespeopleTab() {
    setState(() {
      _groupsLanding = false;
    });
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => _tradespersonCatalogScreen(tab: 2)),
    );
  }

  void _recordTradespersonSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final next = [..._marketplace.searchHistory];
    next.remove(trimmed);
    next.insert(0, trimmed);
    setState(() {
      _marketplace = _marketplace.copyWith(
        searchHistory: next.take(8).toList(),
      );
    });
    _persistMarketplace();
  }

  void _removeTradespersonSearch(String query) {
    setState(() {
      _marketplace = _marketplace.copyWith(
        searchHistory: _marketplace.searchHistory
            .where((item) => item != query)
            .toList(),
      );
    });
    _persistMarketplace();
  }

  void _toggleFavoriteTradesperson(String listingId) {
    final current = [..._marketplace.favoriteListingIds];
    if (current.contains(listingId)) {
      current.remove(listingId);
    } else {
      current.add(listingId);
    }
    setState(() {
      _marketplace = _marketplace.copyWith(favoriteListingIds: current);
    });
    _persistMarketplace();
  }

  void _openTradespersonPortfolio() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => StatefulBuilder(
          builder: (context, setRouteState) {
            return TradespersonPortfolioScreen(
              photos: _marketplace.account.portfolio,
              canEdit: _marketplace.account.isTradesperson,
              onAdd: (photo) {
                setState(() {
                  _marketplace = _marketplace.copyWith(
                    account: _marketplace.account.copyWith(
                      portfolio: [photo, ..._marketplace.account.portfolio],
                    ),
                  );
                });
                _persistMarketplace();
                setRouteState(() {});
              },
              onRemove: (id) {
                setState(() {
                  _marketplace = _marketplace.copyWith(
                    account: _marketplace.account.copyWith(
                      portfolio: _marketplace.account.portfolio
                          .where((item) => item.id != id)
                          .toList(),
                    ),
                  );
                });
                _persistMarketplace();
                setRouteState(() {});
              },
            );
          },
        ),
      ),
    );
  }

  void _openTradespersonPriceList() {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => StatefulBuilder(
          builder: (context, setRouteState) {
            return TradespersonPriceListScreen(
              items: _marketplace.account.priceList,
              canEdit: _marketplace.account.isTradesperson,
              onAdd: (item) {
                setState(() {
                  _marketplace = _marketplace.copyWith(
                    account: _marketplace.account.copyWith(
                      priceList: [..._marketplace.account.priceList, item],
                    ),
                  );
                });
                _persistMarketplace();
                setRouteState(() {});
              },
              onRemove: (index) {
                final next = [..._marketplace.account.priceList]
                  ..removeAt(index);
                setState(() {
                  _marketplace = _marketplace.copyWith(
                    account: _marketplace.account.copyWith(priceList: next),
                  );
                });
                _persistMarketplace();
                setRouteState(() {});
              },
            );
          },
        ),
      ),
    );
  }

  void _addNeighborHelpPost(NeighborHelpPost post) {
    final current = _marketplace.helpPosts.isEmpty
        ? NeighborHelpPost.seeded()
        : _marketplace.helpPosts;
    setState(() {
      _marketplace = _marketplace.copyWith(helpPosts: [post, ...current]);
    });
    _persistMarketplace();
    _notifyProAboutHelpPost(post);
    unawaited(_unlockBadges([BadgeIds.helpfulHand]));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Zapytanie jest na giełdzie zleceń.')),
    );
  }

  bool _helpPostInArea(NeighborHelpPost post) {
    final home = _defaultSubDistrict;
    if (home == 'Wszystkie osiedla' || home == 'Widzew') return true;
    if (post.subDistrict == home) return true;
    const widzewCore = {
      'Widzew Wschód',
      'Stary Widzew',
      'Księży Młyn',
      'Widzew',
    };
    if (widzewCore.contains(home) && widzewCore.contains(post.subDistrict)) {
      return true;
    }
    return post.subDistrict == 'Olechów' && home == 'Olechów';
  }

  void _notifyProAboutHelpPost(NeighborHelpPost post) {
    if (!_marketplace.account.isProActive) return;
    if (!_helpPostInArea(post)) return;
    unawaited(
      LocalPushService.show(
        id: 42,
        title: 'Nowe zlecenie w okolicy',
        body:
            '${post.isUrgent ? 'Pilne: ' : ''}${post.title} · ${post.subDistrict}',
      ),
    );
  }

  void _addTradespersonReview(TradespersonReview review) {
    setState(() {
      var account = _marketplace.account;
      if (review.listingId == TradespersonCatalog.mineId) {
        account = account.copyWith(reviews: [review, ...account.reviews]);
      }
      _marketplace = _marketplace.copyWith(
        account: account,
        reviews: [review, ..._marketplace.reviews],
      );
    });
    _persistMarketplace();
  }

  void _acceptNeighborHelpPost(NeighborHelpPost post) {
    if (!_marketplace.account.isProActive) {
      _openTradespersonSubscription();
      return;
    }
    final name = _marketplace.account.card.displayName.isEmpty
        ? _userName
        : _marketplace.account.card.displayName;
    final current = _marketplace.helpPosts.isEmpty
        ? NeighborHelpPost.seeded()
        : _marketplace.helpPosts;
    setState(() {
      _marketplace = _marketplace.copyWith(
        helpPosts: current
            .map(
              (item) =>
                  item.id == post.id ? item.copyWith(acceptedBy: name) : item,
            )
            .toList(),
      );
    });
    _persistMarketplace();
    unawaited(_unlockBadges([BadgeIds.goldenHand, BadgeIds.helpfulHand]));
  }

  Future<void> _renewTradespersonSubscription() async {
    final method = await showModalBottomSheet<String>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (sheetContext) => TradespersonPaymentSheet(
        onPay: (value) => Navigator.of(sheetContext).pop(value),
      ),
    );
    if (method == null || !mounted) return;
    setState(() {
      _marketplace = _marketplace.copyWith(
        account: _marketplace.account.copyWith(
          isTradesperson: true,
          isPro: true,
          subscriptionExpiryDate: DateTime.now().add(const Duration(days: 30)),
        ),
      );
    });
    _persistMarketplace();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Płatność $method przyjęta (symulacja). Status PRO: Aktywny.',
        ),
      ),
    );
  }

  void _publishTradespersonListing() {
    if (!_marketplace.account.canPublishListing) {
      _openTradespersonSubscription();
      return;
    }
    setState(() {
      _marketplace = _marketplace.copyWith(
        account: _marketplace.account.copyWith(listingPublished: true),
      );
    });
    _persistMarketplace();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Oferta jest w katalogu. Numer telefonu widać tylko w opłaconym profilu PRO.',
        ),
      ),
    );
  }

  void _submitTradespersonJob(TradespersonJobRequest request) {
    setState(() {
      _marketplace = _marketplace.copyWith(
        jobRequests: [request, ..._marketplace.jobRequests],
      );
    });
    _persistMarketplace();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          request.isQuote
              ? 'Wycena wysłana do fachowca. Odpowiedź przyjdzie w aplikacji.'
              : 'Zlecenie wysłane wewnętrznie. Numer fachowca pozostaje ukryty.',
        ),
      ),
    );
  }

  void _setAvatarIndex(int index) {
    setState(() {
      _avatarIndex = index;
      _avatarPhotoPath = null;
    });
    unawaited(NeighborProfileStore.saveAvatarIndex(index));
    unawaited(NeighborProfileStore.saveAvatarPhotoPath(null));
  }

  void _setAvatarPhoto(String? path) {
    setState(() => _avatarPhotoPath = path);
    unawaited(NeighborProfileStore.saveAvatarPhotoPath(path));
  }

  Future<void> _confirmWidzewLocation() async {
    final fix = await WidzewLocation.current(
      fallbackDistrict: _defaultSubDistrict,
    );
    if (!mounted) return;
    final gpsOk =
        fix.success && NeighborhoodGeo.isInWidzew(fix.latitude, fix.longitude);
    if (!gpsOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nie udało się potwierdzić lokalizacji na Widzewie.'),
        ),
      );
      return;
    }
    setState(() {
      _locationVerified = true;
      _defaultSubDistrict = fix.subDistrict;
    });
    unawaited(
      NeighborProfileStore.saveVerifiedLocationFix(
        latitude: fix.latitude,
        longitude: fix.longitude,
      ),
    );
    _persist();
    if (!mounted) return;
    final newly = await _unlockBadges([BadgeIds.gpsVerified]);
    if (!mounted) return;
    if (newly.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lokalizacja potwierdzona: ${fix.subDistrict}.'),
        ),
      );
    }
  }

  NeighborConversation? _activeConversation() {
    final id = _activeConversationId;
    if (id == null) return null;
    for (final conversation in NeighborConversation.group(_messages)) {
      if (conversation.id == id) return conversation;
    }
    return null;
  }

  String _conversationIdFor(Announcement announcement) {
    for (final message in _messages) {
      if (message.peerName == announcement.authorName &&
          message.listingTitle == announcement.title) {
        return message.conversationId;
      }
    }
    return 'ann-${announcement.authorName}-${announcement.publishedAt.millisecondsSinceEpoch}';
  }

  int _avatarIndexFor(String name) {
    if (name.isEmpty || NeighborAvatar.icons.isEmpty) return 0;
    return name.hashCode.abs() % NeighborAvatar.icons.length;
  }

  ({String id, String peerName, String listingTitle, int avatarIndex})
  _activeConversationMeta() {
    final help = _helpChatAnnouncement;
    final activeId = _activeConversationId;
    if (help != null &&
        (activeId == null || activeId == _conversationIdFor(help))) {
      return (
        id: _conversationIdFor(help),
        peerName: help.authorName,
        listingTitle: help.title,
        avatarIndex: _avatarIndexFor(help.authorName),
      );
    }
    final existing = _messages.where(
      (message) => message.conversationId == activeId,
    );
    if (existing.isNotEmpty) {
      final sample = existing.last;
      return (
        id: sample.conversationId,
        peerName: sample.peerName,
        listingTitle: sample.listingTitle,
        avatarIndex: sample.avatarIndex,
      );
    }
    return (
      id: activeId ?? 'legacy',
      peerName: 'Sąsiad',
      listingTitle: '',
      avatarIndex: 0,
    );
  }

  void _openConversation(NeighborConversation conversation) {
    setState(() {
      _activeConversationId = conversation.id;
      _messages = [
        for (final message in _messages)
          message.conversationId == conversation.id &&
                  !message.isMine &&
                  message.status == NeighborMessageStatus.sent
              ? message.copyWith(status: NeighborMessageStatus.read)
              : message,
      ];
    });
    _persist();
  }

  void _closeConversation() {
    if (_activeConversationId == null) return;
    setState(() => _activeConversationId = null);
  }

  void _startChatWithAuthor(Announcement announcement) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    final conversationId = _conversationIdFor(announcement);
    _helpChatAnnouncement = announcement;
    setState(() {
      _groupsLanding = false;
      _currentIndex = 2;
      _activeConversationId = conversationId;
    });
    _sendNeighborMessage(
      'Cześć ${announcement.authorName}! Piszę w sprawie: „${announcement.title}”. Czy ogłoszenie jest aktualne?',
    );
  }

  void _setDefaultSubDistrict(String value) {
    setState(() => _defaultSubDistrict = value);
    _exploreSubDistrict(value);
    _persist();
  }

  void _restoreDefaults() {
    final initial = AppSnapshot.initial();
    setState(() {
      _announcements = List.of(initial.announcements);
      _userName = initial.userName;
      _avatarIndex = 0;
      _avatarPhotoPath = null;
      _locationVerified = false;
      _defaultSubDistrict = initial.defaultSubDistrict;
      _isDarkMode = initial.isDarkMode;
      _themePreference = initial.themePreference;
      _widzewSkin = initial.widzewSkin;
      _createdAnnouncementCount = initial.createdAnnouncementCount;
      _neighborhoodNotificationsEnabled =
          initial.neighborhoodNotificationsEnabled;
      _polls = List.of(initial.polls);
      _events = List.of(initial.events);
      _searchHistory = List.of(initial.searchHistory);
      _messages = List.of(initial.messages);
      _notificationRadius = initial.notificationRadius;
      _notificationCategories = const [];
      _seniorMode = initial.seniorMode;
      _appLocale = initial.appLocale;
      _onboardingCompleted = initial.onboardingCompleted;
      _startDestination = initial.startDestination;
      _services = List.of(initial.services);
      _clubs = List.of(initial.clubs);
      _cooperativeNotices = List.of(initial.cooperativeNotices);
      _ecoReports = List.of(initial.ecoReports);
      _foodSpots = List.of(initial.foodSpots);
      _localDeals = List.of(initial.localDeals);
      _reminders = List.of(initial.reminders);
      _driverMode = initial.driverMode;
      _bookOffers = List.of(initial.bookOffers);
      _timeBankOffers = List.of(initial.timeBankOffers);
      _timeBankHours = initial.timeBankHours;
      _favoriteStreets = const [];
      _parcelLockers = List.of(initial.parcelLockers);
      _charityDrives = List.of(initial.charityDrives);
      _carpoolRides = List.of(initial.carpoolRides);
      _infrastructureReports = List.of(initial.infrastructureReports);
      _fleaMarketItems = List.of(initial.fleaMarketItems);
      _sportMeetups = List.of(initial.sportMeetups);
      _petSitOffers = List.of(initial.petSitOffers);
      _seniorOffers = List.of(initial.seniorOffers);
      _plantSwaps = List.of(initial.plantSwaps);
      _parentMeetups = List.of(initial.parentMeetups);
      _barterOffers = List.of(initial.barterOffers);
      _craftMakers = List.of(initial.craftMakers);
      _tutoringOffers = List.of(initial.tutoringOffers);
      _safetyAlerts = List.of(initial.safetyAlerts);
      _homeDuties = List.of(initial.homeDuties);
      _neighborTemplates = List.of(initial.neighborTemplates);
      _oddJobs = List.of(initial.oddJobs);
      _lostFoundItems = List.of(initial.lostFoundItems);
      _staircaseFunds = List.of(initial.staircaseFunds);
      _sharedTools = List.of(initial.sharedTools);
      _mediaOutages = List.of(initial.mediaOutages);
      _cultureEvents = List.of(initial.cultureEvents);
      _marketStalls = List.of(initial.marketStalls);
      _bulkBuys = List.of(initial.bulkBuys);
      _venueSlots = List.of(initial.venueSlots);
      _walkingBusShifts = List.of(initial.walkingBusShifts);
      _historyStories = List.of(initial.historyStories);
      _historyPatriotUnlocked = initial.historyPatriotUnlocked;
      _energyExperiences = List.of(initial.energyExperiences);
      _retroItOffers = List.of(initial.retroItOffers);
      _costSplits = List.of(initial.costSplits);
      _bikeHelps = List.of(initial.bikeHelps);
      _bikeRacks = List.of(initial.bikeRacks);
      _diyWorkshops = List.of(initial.diyWorkshops);
      _bloodDrives = List.of(initial.bloodDrives);
      _garageListings = List.of(initial.garageListings);
      _petVaccineReminders = List.of(initial.petVaccineReminders);
      _vetClinics = List.of(initial.vetClinics);
      _partyGear = List.of(initial.partyGear);
      _droneAlerts = List.of(initial.droneAlerts);
      _craftPassageServices = List.of(initial.craftPassageServices);
      _blockRankings = List.of(initial.blockRankings);
      _completedInitiatives = initial.completedInitiatives;
      _ecoCollections = List.of(initial.ecoCollections);
      _caretakerNotes = List.of(initial.caretakerNotes);
      _longDistanceRides = List.of(initial.longDistanceRides);
      _smileGifts = List.of(initial.smileGifts);
      _foodShares = List.of(initial.foodShares);
      _medicalGear = List.of(initial.medicalGear);
      _leftoverMaterials = List.of(initial.leftoverMaterials);
      _faunaSightings = List.of(initial.faunaSightings);
      _neighborRecipes = List.of(initial.neighborRecipes);
      _kidsCreations = List.of(initial.kidsCreations);
      _timelineEras = List.of(initial.timelineEras);
      _pinnedAnnouncementKeys = List.of(initial.pinnedAnnouncementKeys);
      _blockedAnnouncementKeys = List.of(initial.blockedAnnouncementKeys);
      _evChargingOffers = List.of(initial.evChargingOffers);
      _tailorOffers = List.of(initial.tailorOffers);
      _studentRides = List.of(initial.studentRides);
      _grillEvents = List.of(initial.grillEvents);
      _portableGrills = List.of(initial.portableGrills);
      _playgroundReports = List.of(initial.playgroundReports);
      _campGear = List.of(initial.campGear);
      _schoolBooks = List.of(initial.schoolBooks);
      _openAirShows = List.of(initial.openAirShows);
      _digitalHelpOffers = List.of(initial.digitalHelpOffers);
      _ledSwaps = List.of(initial.ledSwaps);
      _jasienSpots = List.of(initial.jasienSpots);
      _bikeStations = List.of(initial.bikeStations);
      _handyJobs = List.of(initial.handyJobs);
      _winterHelps = List.of(initial.winterHelps);
      _boardGameNights = List.of(initial.boardGameNights);
      _wildlifeCares = List.of(initial.wildlifeCares);
      _fitnessGear = List.of(initial.fitnessGear);
      _smallAppliances = List.of(initial.smallAppliances);
      _bulkWastes = List.of(initial.bulkWastes);
      _retroEvents = List.of(initial.retroEvents);
      _architectureSpots = List.of(initial.architectureSpots);
      _rodShares = List.of(initial.rodShares);
      _blockPushNotices = List.of(initial.blockPushNotices);
      _homeBlockNumber = initial.homeBlockNumber;
      _homeStaircase = initial.homeStaircase;
      _blockPushKinds = List.of(initial.blockPushKinds);
      _vinylSwaps = List.of(initial.vinylSwaps);
      _gardenNotes = List.of(initial.gardenNotes);
      _nightCarpools = List.of(initial.nightCarpools);
      _craftWorkshops = List.of(initial.craftWorkshops);
      _bikeTrips = List.of(initial.bikeTrips);
      _schoolEcoDrives = List.of(initial.schoolEcoDrives);
      _photoClubItems = List.of(initial.photoClubItems);
      _crossingReports = List.of(initial.crossingReports);
      _avGear = List.of(initial.avGear);
      _workwearItems = List.of(initial.workwearItems);
      _greenPaths = List.of(initial.greenPaths);
      _neighborQuestPoints = initial.neighborQuestPoints;
      _unlockedNeighborQuestIds = List.of(initial.unlockedNeighborQuestIds);
      _microBusinesses = List.of(initial.microBusinesses);
      _homeSits = List.of(initial.homeSits);
      _workshopTools = List.of(initial.workshopTools);
      _consoleTourneys = List.of(initial.consoleTourneys);
      _petBloodDonors = List.of(initial.petBloodDonors);
      _jarSwaps = List.of(initial.jarSwaps);
      _babyGear = List.of(initial.babyGear);
      _youthWorkshops = List.of(initial.youthWorkshops);
      _generationBridges = List.of(initial.generationBridges);
      _foundPlates = List.of(initial.foundPlates);
      _industrialSpots = List.of(initial.industrialSpots);
      _homeStatsConfig = initial.homeStatsConfig;
      _fireSafetyReports = List.of(initial.fireSafetyReports);
      _compostSwaps = List.of(initial.compostSwaps);
      _mobileCraftPros = List.of(initial.mobileCraftPros);
      _sportHubItems = List.of(initial.sportHubItems);
      _animalPatrols = List.of(initial.animalPatrols);
      _weekendTrips = List.of(initial.weekendTrips);
      _trailerShares = List.of(initial.trailerShares);
      _prlFurniture = List.of(initial.prlFurniture);
      _cineScreenings = List.of(initial.cineScreenings);
      _slabMemories = List.of(initial.slabMemories);
      _staircaseCodes = List.of(initial.staircaseCodes);
      _staircaseCodesUnlocked = initial.staircaseCodesUnlocked;
      _airSensors = List.of(initial.airSensors);
      _powerShares = List.of(initial.powerShares);
      _wildDumps = List.of(initial.wildDumps);
      _safetyWorkshops = List.of(initial.safetyWorkshops);
      _cargoCarpools = List.of(initial.cargoCarpools);
      _collectorItems = List.of(initial.collectorItems);
      _legoSwaps = List.of(initial.legoSwaps);
      _chessChallenges = List.of(initial.chessChallenges);
      _localArtWorks = List.of(initial.localArtWorks);
      _memorialSpots = List.of(initial.memorialSpots);
      _medicineOffers = List.of(initial.medicineOffers);
      _voltageOutages = List.of(initial.voltageOutages);
      _parkingShares = List.of(initial.parkingShares);
      _blockTools = List.of(initial.blockTools);
      _mushroomTrips = List.of(initial.mushroomTrips);
      _smileTutors = List.of(initial.smileTutors);
      _upcycleOffers = List.of(initial.upcycleOffers);
      _classicCarMeetups = List.of(initial.classicCarMeetups);
      _walkFinds = List.of(initial.walkFinds);
      _greenWastePickups = List.of(initial.greenWastePickups);
      _timeCapsuleEntries = List.of(initial.timeCapsuleEntries);
      _emergencyRentals = List.of(initial.emergencyRentals);
      _homeModuleVisibility = initial.homeModuleVisibility;
      _heatAlerts = List.of(initial.heatAlerts);
      _mallCarpools = List.of(initial.mallCarpools);
      _pramRacks = List.of(initial.pramRacks);
      _rtvRepairs = List.of(initial.rtvRepairs);
      _kidCostumes = List.of(initial.kidCostumes);
      _modelFairItems = List.of(initial.modelFairItems);
      _fishingPosts = List.of(initial.fishingPosts);
      _financeTips = List.of(initial.financeTips);
      _wildlifeShelters = List.of(initial.wildlifeShelters);
      _petProReviews = List.of(initial.petProReviews);
      _streetArchive = List.of(initial.streetArchive);
      _smogFilters = List.of(initial.smogFilters);
      _waterPressures = List.of(initial.waterPressures);
      _solarPosts = List.of(initial.solarPosts);
      _print3dOffers = List.of(initial.print3dOffers);
      _sportKits = List.of(initial.sportKits);
      _seniorShops = List.of(initial.seniorShops);
      _parkChessMeetups = List.of(initial.parkChessMeetups);
      _scamAlerts = List.of(initial.scamAlerts);
      _streetArtSpots = List.of(initial.streetArtSpots);
      _plantHotelStays = List.of(initial.plantHotelStays);
      _windowViews = List.of(initial.windowViews);
      _errorLogs = List.of(initial.errorLogs);
      _diagnosticsUnlocked = initial.diagnosticsUnlocked;
      _diagnosticsTapCount = 0;
      _stairCleans = List.of(initial.stairCleans);
      _airportRides = List.of(initial.airportRides);
      _energyRecipes = List.of(initial.energyRecipes);
      _gardenToolCares = List.of(initial.gardenToolCares);
      _langBooks = List.of(initial.langBooks);
      _streetballMeetups = List.of(initial.streetballMeetups);
      _indieCinemaPosts = List.of(initial.indieCinemaPosts);
      _lostPets = List.of(initial.lostPets);
      _ewastePoints = List.of(initial.ewastePoints);
      _filamentShares = List.of(initial.filamentShares);
      _industryMemories = List.of(initial.industryMemories);
      _bulkySlots = List.of(initial.bulkySlots);
      _holyCrossTrips = List.of(initial.holyCrossTrips);
      _preserveJars = List.of(initial.preserveJars);
      _pcvWindows = List.of(initial.pcvWindows);
      _schoolGear = List.of(initial.schoolGear);
      _tableSports = List.of(initial.tableSports);
      _fantasyOffers = List.of(initial.fantasyOffers);
      _gasInspections = List.of(initial.gasInspections);
      _scooterHubs = List.of(initial.scooterHubs);
      _hepaTrackers = List.of(initial.hepaTrackers);
      _filmClips = List.of(initial.filmClips);
      _balconyWashes = List.of(initial.balconyWashes);
      _forestForageTrips = List.of(initial.forestForageTrips);
      _ecoCleanRecipes = List.of(initial.ecoCleanRecipes);
      _lockCareTips = List.of(initial.lockCareTips);
      _seasonalSkates = List.of(initial.seasonalSkates);
      _dartBilliards = List.of(initial.dartBilliards);
      _rockMetalPosts = List.of(initial.rockMetalPosts);
      _carPolicies = List.of(initial.carPolicies);
      _phoneChargeHubs = List.of(initial.phoneChargeHubs);
      _airPlants = List.of(initial.airPlants);
      _tramPhotos = List.of(initial.tramPhotos);
      _localVaultPinEnabled = initial.localVaultPinEnabled;
      _localVaultPin = initial.localVaultPin;
      _biometricUnlockEnabled = initial.biometricUnlockEnabled;
      _carpetVacs = List.of(initial.carpetVacs);
      _kayakTrips = List.of(initial.kayakTrips);
      _lunchboxes = List.of(initial.lunchboxes);
      _gardenFurnitureTips = List.of(initial.gardenFurnitureTips);
      _puzzleSwaps = List.of(initial.puzzleSwaps);
      _amateurTheaters = List.of(initial.amateurTheaters);
      _electroAmbientPosts = List.of(initial.electroAmbientPosts);
      _waterFilters = List.of(initial.waterFilters);
      _farmStalls = List.of(initial.farmStalls);
      _aquariumSwaps = List.of(initial.aquariumSwaps);
      _cinemaPhotos = List.of(initial.cinemaPhotos);
      _appCacheKb = initial.appCacheKb;
      _cacheRefreshedAt = initial.cacheRefreshedAt;
      _pavementCleans = List.of(initial.pavementCleans);
      _thermalTrips = List.of(initial.thermalTrips);
      _sourdoughRecipes = List.of(initial.sourdoughRecipes);
      _rollerShutters = List.of(initial.rollerShutters);
      _beachGear = List.of(initial.beachGear);
      _bocceMeetups = List.of(initial.bocceMeetups);
      _discoRetroPosts = List.of(initial.discoRetroPosts);
      _carOilReminders = List.of(initial.carOilReminders);
      _pramAccessSpots = List.of(initial.pramAccessSpots);
      _balconyHerbs = List.of(initial.balconyHerbs);
      _bazaarPhotos = List.of(initial.bazaarPhotos);
      _accessTextScale = initial.accessTextScale;
      _accessHighContrast = initial.accessHighContrast;
      _accessReadability = initial.accessReadability;
      _benchPaints = List.of(initial.benchPaints);
      _sudetyTrips = List.of(initial.sudetyTrips);
      _fruitPreserves = List.of(initial.fruitPreserves);
      _homeSafes = List.of(initial.homeSafes);
      _bikeChildOffers = List.of(initial.bikeChildOffers);
      _badmintonMeetups = List.of(initial.badmintonMeetups);
      _jazzBluesPosts = List.of(initial.jazzBluesPosts);
      _smokeAlarms = List.of(initial.smokeAlarms);
      _sourdoughShops = List.of(initial.sourdoughShops);
      _petBirds = List.of(initial.petBirds);
      _pavilionPhotos = List.of(initial.pavilionPhotos);
      _apiLastPingOk = initial.apiLastPingOk;
      _apiSyncAt = initial.apiSyncAt;
      _parkingMarks = List.of(initial.parkingMarks);
      _bieszczadyTrips = List.of(initial.bieszczadyTrips);
      _fruitVinegars = List.of(initial.fruitVinegars);
      _videoIntercoms = List.of(initial.videoIntercoms);
      _babyCarriers = List.of(initial.babyCarriers);
      _tennisSquashMeetups = List.of(initial.tennisSquashMeetups);
      _classicalOperaPosts = List.of(initial.classicalOperaPosts);
      _pitcherFilters = List.of(initial.pitcherFilters);
      _clothesBins = List.of(initial.clothesBins);
      _aquaLivestock = List.of(initial.aquaLivestock);
      _schoolPhotos = List.of(initial.schoolPhotos);
      _homeTileOrder = List.of(initial.homeTileOrder);
      _homePinnedTools = List.of(initial.homePinnedTools);
      _sidewalkSalts = List.of(initial.sidewalkSalts);
      _landscapeParkTrips = List.of(initial.landscapeParkTrips);
      _veggiePickles = List.of(initial.veggiePickles);
      _radiatorThermos = List.of(initial.radiatorThermos);
      _archeryGear = List.of(initial.archeryGear);
      _yardGames = List.of(initial.yardGames);
      _polishFilms = List.of(initial.polishFilms);
      _safetyKits = List.of(initial.safetyKits);
      _sodaCo2Spots = List.of(initial.sodaCo2Spots);
      _terrariumPets = List.of(initial.terrariumPets);
      _parkPhotos = List.of(initial.parkPhotos);
      _soundAlerts = initial.soundAlerts;
      _groupsLanding = false;
      _hiddenAnnouncementKeys.clear();
      _currentIndex = 0;
      _marketplace = const MarketplaceState();
      _exploredSubDistricts = [];
      _helpChatAnnouncement = null;
      _activeConversationId = null;
    });
    widget.onSnapshotChanged(initial);
    unawaited(
      LocalPushService.setEnabled(initial.neighborhoodNotificationsEnabled),
    );
    unawaited(NeighborProfileStore.clear());
    unawaited(TradespersonStore.clear());
    unawaited(BadgeService.clear());
    unawaited(BoardSafetyStore.clear());
  }

  Future<Announcement?> _editAnnouncement(Announcement announcement) async {
    final updated = await Navigator.of(context).push<Announcement>(
      AppPageRoute(
        builder: (_) => AddAnnouncementScreen(
          existing: announcement,
          initialSubDistrict: announcement.subDistrict,
          authorName: _userName,
        ),
      ),
    );
    if (updated == null || !mounted) return null;
    final index = _announcementIndex(announcement);
    if (index == -1) return null;
    setState(() => _announcements[index] = updated);
    _persist();
    return updated;
  }

  void _deleteAnnouncement(Announcement announcement) {
    setState(() {
      _announcements.removeWhere(
        (item) => item.publishedAt == announcement.publishedAt,
      );
    });
    _persist();
  }

  void _votePoll(String pollId, int optionIndex) {
    final index = _polls.indexWhere((poll) => poll.id == pollId);
    if (index == -1) return;
    setState(() => _polls[index] = _polls[index].vote(optionIndex));
    _persist();
  }

  void _flushOfflineQueue() {
    final pending = _announcements.where((item) => item.pendingSync).toList();
    if (pending.isEmpty) return;
    setState(() {
      _announcements = [
        for (final item in _announcements)
          item.pendingSync ? item.copyWith(pendingSync: false) : item,
      ];
    });
    _persist();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wysłano ogłoszenia z kolejki offline.')),
    );
  }

  void _commitLocalAnnouncement(Announcement announcement) {
    final body = '${announcement.title}\n${announcement.description}';
    if (!_allowBoardPublish(body)) return;
    final filter = ContentFilter.inspect(body);
    final queued = !_isOnline;
    final item = announcement.copyWith(
      pendingSync: queued,
      contentFlagged: filter.flagged || announcement.contentFlagged,
    );
    unawaited(BoardSafetyStore.recordPublish(DateTime.now()));
    if (filter.flagged) {
      unawaited(BoardSafetyStore.markFlagged(_announcementKey(item)));
    }
    setState(() {
      _announcements.insert(0, item);
      _createdAnnouncementCount++;
      _currentIndex = 0;
    });
    _persist();
    if (!mounted) return;
    if (queued) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Zapisano lokalnie. Wyśle się po powrocie sieci.'),
        ),
      );
    } else if (filter.flagged) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(filter.message)));
    }
    if (item.isAlert) {
      unawaited(
        LocalPushService.show(
          id: 21,
          title: item.title,
          body: 'Pilny alert/awaria w okolicy: ${item.subDistrict}',
        ),
      );
    }
    unawaited(
      _unlockBadges(
        BadgeManager.idsForAnnouncement(
          item: item,
          createdCount: _createdAnnouncementCount,
        ),
      ),
    );
  }

  void _toggleEventGoing(String eventId) {
    final index = _events.indexWhere((event) => event.id == eventId);
    if (index == -1) return;
    setState(() => _events[index] = _events[index].toggleGoing());
    _persist();
  }

  void _addEventToCalendar(NeighborhoodEvent event) {
    unawaited(
      NeighborShare.shareText(
        context,
        text: event.toIcs(),
        subject: event.title,
        copiedMessage: 'Skopiowano wydarzenie do kalendarza',
      ),
    );
  }

  void _removeSearchHistory(String query) {
    setState(() => _searchHistory.remove(query));
    _persist();
  }

  void _reactAnnouncement(Announcement announcement, String emoji) {
    final index = _announcementIndex(announcement);
    if (index == -1) return;
    setState(() {
      _announcements[index] = _announcements[index].withReaction(emoji);
    });
    _persist();
  }

  void _recordSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _searchHistory.remove(trimmed);
      _searchHistory.insert(0, trimmed);
      if (_searchHistory.length > 12) {
        _searchHistory = _searchHistory.take(12).toList();
      }
    });
    _persist();
  }

  void _clearSearchHistory() {
    setState(() => _searchHistory = []);
    _persist();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Historia wyszukiwania została wyczyszczona'),
      ),
    );
  }

  void _clearCachedAnnouncements() {
    setState(() {
      _announcements = List.of(AppSnapshot.initial().announcements);
      _hiddenAnnouncementKeys.clear();
    });
    _persist();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wyczyszczono ogłoszenia zapisane w cache')),
    );
  }

  void _sendVoiceMessage(VoiceNoteResult result) {
    final meta = _activeConversationMeta();
    final message = NeighborMessage(
      id: 'voice-${DateTime.now().microsecondsSinceEpoch}',
      text: 'Wiadomość głosowa (${result.durationSeconds} s)',
      isMine: true,
      status: NeighborMessageStatus.sent,
      sentAt: DateTime.now(),
      isVoice: true,
      durationSeconds: result.durationSeconds,
      audioPath: result.audioPath,
      conversationId: meta.id,
      peerName: meta.peerName,
      listingTitle: meta.listingTitle,
      avatarIndex: meta.avatarIndex,
    );
    setState(() {
      _activeConversationId = meta.id;
      _messages = [..._messages, message];
    });
    _persist();
    _unlockHelpChatBadges();
  }

  void _sendImageMessage(String imagePath, String caption) {
    final meta = _activeConversationMeta();
    final message = NeighborMessage(
      id: 'img-${DateTime.now().microsecondsSinceEpoch}',
      text: caption.trim(),
      isMine: true,
      status: NeighborMessageStatus.sent,
      sentAt: DateTime.now(),
      imagePath: imagePath,
      conversationId: meta.id,
      peerName: meta.peerName,
      listingTitle: meta.listingTitle,
      avatarIndex: meta.avatarIndex,
    );
    setState(() {
      _activeConversationId = meta.id;
      _messages = [..._messages, message];
    });
    _persist();
    _unlockHelpChatBadges();
  }

  void _sendNeighborMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final meta = _activeConversationMeta();
    final message = NeighborMessage(
      id: 'msg-${DateTime.now().microsecondsSinceEpoch}',
      text: trimmed,
      isMine: true,
      status: NeighborMessageStatus.sent,
      sentAt: DateTime.now(),
      conversationId: meta.id,
      peerName: meta.peerName,
      listingTitle: meta.listingTitle,
      avatarIndex: meta.avatarIndex,
    );
    setState(() {
      _activeConversationId = meta.id;
      _messages = [..._messages, message];
    });
    _persist();
    _unlockHelpChatBadges();
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      final index = _messages.indexWhere((item) => item.id == message.id);
      if (index == -1) return;
      final reply = NeighborMessage(
        id: 'msg-reply-${DateTime.now().microsecondsSinceEpoch}',
        text: 'Jasne, daj znać przy klatce.',
        isMine: false,
        status: _activeConversationId == meta.id
            ? NeighborMessageStatus.read
            : NeighborMessageStatus.sent,
        sentAt: DateTime.now(),
        conversationId: meta.id,
        peerName: meta.peerName,
        listingTitle: meta.listingTitle,
        avatarIndex: meta.avatarIndex,
      );
      setState(() {
        _messages[index] = _messages[index].copyWith(
          status: NeighborMessageStatus.read,
        );
        if (!_inWidgetTest) {
          _messages = [..._messages, reply];
        }
      });
      _persist();
      unawaited(
        LocalPushService.show(
          id: 11,
          title: 'Nowa wiadomość od sąsiada',
          body: reply.text,
        ),
      );
    });
  }

  void _clearConversationHistory() {
    final id = _activeConversationId;
    setState(() {
      if (id == null) {
        _messages = [];
      } else {
        _messages = [
          for (final message in _messages)
            if (message.conversationId != id) message,
        ];
      }
      _activeConversationId = null;
    });
    _persist();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wyczyszczono historię konwersacji')),
    );
  }

  Future<void> _openAddEvent() async {
    final event = await Navigator.of(context).push<NeighborhoodEvent>(
      AppPageRoute(
        builder: (_) => AddEventScreen(initialPlace: _defaultSubDistrict),
      ),
    );
    if (event == null || !mounted) return;
    setState(() {
      _events = [event, ..._events];
      _currentIndex = 0;
    });
    _persist();
  }

  Future<void> _openSnapPost() async {
    final gate = BoardSafety.publishGate(
      BoardSafetyStore.publishTimes,
      bypass: _inWidgetTest,
    );
    if (!gate.allowed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(gate.message)));
      return;
    }
    final announcement = await Navigator.of(context).push<Announcement>(
      AppPageRoute(
        builder: (_) => SnapPostScreen(
          initialSubDistrict: _defaultSubDistrict,
          authorName: _userName,
        ),
      ),
    );
    if (announcement != null && mounted) {
      _commitLocalAnnouncement(announcement);
    }
  }

  Future<void> _openAddAnnouncement({String? category}) async {
    final gate = BoardSafety.publishGate(
      BoardSafetyStore.publishTimes,
      bypass: _inWidgetTest,
    );
    if (!gate.allowed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(gate.message)));
      return;
    }
    final announcement = await Navigator.of(context).push<Announcement>(
      AppPageRoute(
        builder: (_) => AddAnnouncementScreen(
          initialSubDistrict: _defaultSubDistrict,
          authorName: _userName,
          initialCategory: category,
        ),
      ),
    );
    if (announcement != null && mounted) {
      _commitLocalAnnouncement(announcement);
    }
  }

  bool _handleShellBack() {
    if (_activeConversationId != null && _currentIndex == 2) {
      _closeConversation();
      return true;
    }
    if (_groupsLanding) {
      setState(() => _groupsLanding = false);
      return true;
    }
    if (_currentIndex != 0) {
      setState(() {
        _groupsLanding = false;
        _currentIndex = 0;
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleShellBack();
      },
      child: Scaffold(
        body: Column(
          children: [
            if (!_isOnline) const OfflineBanner(),
            Expanded(
              child: KeyedSubtree(
                key: ValueKey(
                  _groupsLanding && _currentIndex == 0
                      ? 'groups'
                      : 'tab-$_currentIndex',
                ),
                child: _groupsLanding && _currentIndex == 0
                    ? NeighborhoodGroupsScreen(
                        clubs: _clubs,
                        userName: _userName,
                        onToggleJoin: _toggleClubJoin,
                        onSendMessage: _sendClubMessage,
                      )
                    : _screens[_currentIndex.clamp(0, _screens.length - 1)],
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex.clamp(0, 3),
          onDestinationSelected: (index) {
            setState(() {
              _groupsLanding = false;
              _currentIndex = index.clamp(0, 3);
            });
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: _widzewSkin.seed),
              label: context.tr('navHome'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.bookmark_border),
              selectedIcon: Icon(Icons.bookmark, color: _widzewSkin.seed),
              label: context.tr('navSaved'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble, color: _widzewSkin.seed),
              label: context.tr('navMessages'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: _widzewSkin.seed),
              label: context.tr('navProfile'),
            ),
          ],
        ),
      ),
    );
  }
}
