import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_locale.dart';
import '../l10n/app_localizations.dart';
import '../services/app_image_picker.dart';
import '../models/announcement.dart';
import '../models/widzew_skin.dart';
import '../models/neighbor_badge.dart';
import '../models/neighborhood_event.dart';
import '../models/neighbor_trust.dart';
import '../models/infrastructure_report.dart';
import '../models/community_stats.dart';
import '../models/tradesperson_marketplace.dart';
import '../widgets/subscription_status_panel.dart';
import '../widgets/community_stats_panel.dart';
import '../models/neighbor_avatar.dart';
import '../widgets/announcement_card.dart';
import '../widgets/badges_modal.dart';
import '../theme/widzew_colors.dart';
import '../theme/widzew_ui.dart';
import '../widgets/app_page_route.dart';
import '../utils/flutter_runtime.dart';
import 'my_announcements_screen.dart';
import 'my_reports_screen.dart';
import 'settings_screen.dart';
import 'tradesperson_pro_benefits_screen.dart';

class ProfileScreen extends StatelessWidget {
  final List<Announcement> favoriteAnnouncements;
  final List<Announcement> ownAnnouncements;
  final List<Announcement> communityAnnouncements;
  final ValueChanged<Announcement> onOpenAnnouncement;
  final ValueChanged<Announcement> onToggleFavorite;
  final ValueChanged<Announcement> onLikeAnnouncement;
  final String userName;
  final String defaultSubDistrict;
  final int createdAnnouncementCount;
  final bool isDarkMode;
  final ValueChanged<String> onDefaultSubDistrictChanged;
  final ValueChanged<bool> onThemeChanged;
  final bool neighborhoodNotificationsEnabled;
  final ValueChanged<bool> onNeighborhoodNotificationsChanged;
  final void Function(Announcement announcement, String reason)
  onReportAnnouncement;
  final VoidCallback? onOpenContentReview;
  final Future<Announcement?> Function(Announcement announcement)
  onEditAnnouncement;
  final ValueChanged<Announcement> onCompleteAnnouncement;
  final ValueChanged<Announcement> onDeleteAnnouncement;
  final VoidCallback onRestoreDefaults;
  final VoidCallback onClearCachedAnnouncements;
  final List<NeighborhoodEvent> events;
  final bool seniorMode;
  final ValueChanged<bool> onSeniorModeChanged;
  final AppLocale appLocale;
  final ValueChanged<AppLocale> onAppLocaleChanged;
  final VoidCallback onOpenServices;
  final VoidCallback onOpenGroups;
  final VoidCallback onOpenCooperativeBoard;
  final VoidCallback onOpenNeighborQr;
  final VoidCallback onScanQr;
  final bool driverMode;
  final ValueChanged<bool> onDriverModeChanged;
  final VoidCallback onOpenFoodGuide;
  final VoidCallback onOpenLocalDeals;
  final VoidCallback onOpenBookShelf;
  final int timeBankHours;
  final CommunityStats communityStats;
  final VoidCallback onOpenCharityDrives;
  final VoidCallback onOpenInfrastructure;
  final VoidCallback onOpenFleaMarket;
  final VoidCallback onOpenSportMeetups;
  final VoidCallback onOpenSeniorCorner;
  final VoidCallback onOpenPlantSwap;
  final VoidCallback onOpenParentsClub;
  final VoidCallback onOpenBarter;
  final VoidCallback onOpenCraftMakers;
  final VoidCallback onOpenTutoring;
  final VoidCallback onOpenSafetyPatrol;
  final VoidCallback onOpenHomeAssistant;
  final VoidCallback onOpenNeighborTemplates;
  final VoidCallback onOpenOddJobs;
  final VoidCallback onOpenLostFound;
  final VoidCallback onOpenStaircaseFund;
  final VoidCallback onOpenSharedTools;
  final VoidCallback onOpenCultureEvents;
  final VoidCallback onOpenMarketStalls;
  final VoidCallback onOpenBulkBuy;
  final VoidCallback onOpenWalkingBus;
  final VoidCallback onOpenWidzewHistory;
  final VoidCallback onOpenEnergyHub;
  final VoidCallback onOpenRetroIt;
  final VoidCallback onOpenCostSplit;
  final VoidCallback onOpenBikeHelp;
  final VoidCallback onOpenDiyAcademy;
  final VoidCallback onOpenBloodClub;
  final VoidCallback onOpenGarageListings;
  final VoidCallback onOpenPetHealth;
  final VoidCallback onOpenPartyGear;
  final VoidCallback onOpenDroneAlerts;
  final VoidCallback onOpenCraftPassage;
  final VoidCallback onOpenDistrictReport;
  final VoidCallback onOpenEcoCollection;
  final VoidCallback onOpenLongDistanceRides;
  final VoidCallback onOpenSmileGifts;
  final VoidCallback onOpenFoodShare;
  final VoidCallback onOpenMedicalGear;
  final VoidCallback onOpenLeftoverMaterials;
  final VoidCallback onOpenFaunaAlerts;
  final VoidCallback onOpenRecipeClub;
  final VoidCallback onOpenKidsCreations;
  final VoidCallback onOpenWidzewTimeline;
  final VoidCallback onOpenEvCharging;
  final VoidCallback onOpenTailor;
  final VoidCallback onOpenStudentRides;
  final VoidCallback onOpenGrillZone;
  final VoidCallback onOpenPlaygroundReports;
  final VoidCallback onOpenCampGear;
  final VoidCallback onOpenSchoolBooks;
  final VoidCallback onOpenAirShows;
  final VoidCallback onOpenDigitalHelp;
  final VoidCallback onOpenLedSwap;
  final VoidCallback onOpenJasienGuide;
  final VoidCallback onOpenDistrictEcoStats;
  final VoidCallback onOpenBikeStations;
  final VoidCallback onOpenHandyJobs;
  final VoidCallback onOpenWinterHelp;
  final VoidCallback onOpenBoardGames;
  final VoidCallback onOpenWildlifeCare;
  final VoidCallback onOpenFitnessGear;
  final VoidCallback onOpenSmallAppliances;
  final VoidCallback onOpenBulkWaste;
  final VoidCallback onOpenRetroGaming;
  final VoidCallback onOpenArchitectureGuide;
  final VoidCallback onOpenRodShare;
  final VoidCallback onOpenBlockPush;
  final VoidCallback onOpenVinylSwap;
  final VoidCallback onOpenGardenNotes;
  final VoidCallback onOpenNightCarpool;
  final VoidCallback onOpenCraftWorkshop;
  final VoidCallback onOpenBikeTrips;
  final VoidCallback onOpenSchoolEco;
  final VoidCallback onOpenPhotoClub;
  final VoidCallback onOpenCrossingReports;
  final VoidCallback onOpenAvGear;
  final VoidCallback onOpenWorkwear;
  final VoidCallback onOpenGreenPaths;
  final VoidCallback onOpenNeighborQuests;
  final VoidCallback onOpenMicroBusiness;
  final VoidCallback onOpenHomeSit;
  final VoidCallback onOpenWorkshopGarage;
  final VoidCallback onOpenConsoleTourney;
  final VoidCallback onOpenJarSwap;
  final VoidCallback onOpenBabyGear;
  final VoidCallback onOpenYouthCode;
  final VoidCallback onOpenGenerationBridge;
  final VoidCallback onOpenFoundPlates;
  final VoidCallback onOpenIndustrialGuide;
  final VoidCallback onOpenHomeStatsConfig;
  final VoidCallback onOpenFireSafety;
  final VoidCallback onOpenCompostSwap;
  final VoidCallback onOpenMobileCraft;
  final VoidCallback onOpenSportLeague;
  final VoidCallback onOpenAnimalPatrol;
  final VoidCallback onOpenWeekendTrips;
  final VoidCallback onOpenTrailerShare;
  final VoidCallback onOpenPrlFurniture;
  final VoidCallback onOpenCineClub;
  final VoidCallback onOpenSlabMuseum;
  final VoidCallback onOpenStaircaseCodes;
  final VoidCallback onOpenDistrictAnalytics;
  final VoidCallback onOpenAirQuality;
  final VoidCallback onOpenPowerShare;
  final VoidCallback onOpenWildDump;
  final VoidCallback onOpenSafetySchool;
  final VoidCallback onOpenCargoCarpool;
  final VoidCallback onOpenCollectorFair;
  final VoidCallback onOpenLegoSwap;
  final VoidCallback onOpenChessClub;
  final VoidCallback onOpenLocalArt;
  final VoidCallback onOpenMemorialGuide;
  final VoidCallback onOpenMedicineChest;
  final VoidCallback onOpenUserBackup;
  final VoidCallback onOpenVoltageOutages;
  final VoidCallback onOpenParkingShare;
  final VoidCallback onOpenBlockTools;
  final VoidCallback onOpenMushroomTrips;
  final VoidCallback onOpenSmileTutors;
  final VoidCallback onOpenUpcycleCraft;
  final VoidCallback onOpenClassicCars;
  final VoidCallback onOpenWalkFinds;
  final VoidCallback onOpenGreenWaste;
  final VoidCallback onOpenTimeCapsule;
  final VoidCallback onOpenEmergencyRental;
  final VoidCallback onOpenHomeModuleVisibility;
  final VoidCallback onOpenHeatAlerts;
  final VoidCallback onOpenMallCarpool;
  final VoidCallback onOpenPramRacks;
  final VoidCallback onOpenRtvRepair;
  final VoidCallback onOpenKidCostumes;
  final VoidCallback onOpenModelFair;
  final VoidCallback onOpenFishingClub;
  final VoidCallback onOpenFinanceTips;
  final VoidCallback onOpenWildlifeShelters;
  final VoidCallback onOpenPetPros;
  final VoidCallback onOpenStreetArchive;
  final VoidCallback onOpenWidzewSkins;
  final WidzewSkin widzewSkin;
  final ValueChanged<WidzewSkin> onWidzewSkinChanged;
  final VoidCallback onOpenSmogFilters;
  final VoidCallback onOpenWaterPressure;
  final VoidCallback onOpenSolarShare;
  final VoidCallback onOpenPrint3d;
  final VoidCallback onOpenSportKits;
  final VoidCallback onOpenSeniorShop;
  final VoidCallback onOpenParkChess;
  final VoidCallback onOpenScamAlerts;
  final VoidCallback onOpenStreetArt;
  final VoidCallback onOpenPlantHotel;
  final VoidCallback onOpenWindowViews;
  final VoidCallback onOpenDiagnostics;
  final VoidCallback onVersionTileTap;
  final VoidCallback onOpenStairClean;
  final VoidCallback onOpenAirportRides;
  final VoidCallback onOpenEnergyRecipes;
  final VoidCallback onOpenGardenToolCare;
  final VoidCallback onOpenLangBooks;
  final VoidCallback onOpenStreetball;
  final VoidCallback onOpenIndieCinema;
  final VoidCallback onOpenLostPets;
  final VoidCallback onOpenEwasteMap;
  final VoidCallback onOpenFilamentShare;
  final VoidCallback onOpenIndustryMemory;
  final VoidCallback onOpenAchievementShare;
  final VoidCallback onOpenMpoBulky;
  final VoidCallback onOpenHolyCrossTrips;
  final VoidCallback onOpenPreserveJars;
  final VoidCallback onOpenPcvWindows;
  final VoidCallback onOpenSchoolGear;
  final VoidCallback onOpenTableSports;
  final VoidCallback onOpenPolishFantasy;
  final VoidCallback onOpenGasInspections;
  final VoidCallback onOpenScooterHubs;
  final VoidCallback onOpenHepaTrackers;
  final VoidCallback onOpenWidzewFilms;
  final VoidCallback onOpenActivityReport;
  final VoidCallback onOpenBalconyWash;
  final VoidCallback onOpenForestForage;
  final VoidCallback onOpenEcoCleaners;
  final VoidCallback onOpenLockCare;
  final VoidCallback onOpenSeasonalSkates;
  final VoidCallback onOpenDartBilliard;
  final VoidCallback onOpenRockMetal;
  final VoidCallback onOpenCarPolicies;
  final VoidCallback onOpenPhoneCharge;
  final VoidCallback onOpenAirPlants;
  final VoidCallback onOpenTramPhotos;
  final VoidCallback onOpenLocalVault;
  final VoidCallback onOpenCarpetVac;
  final VoidCallback onOpenKayakTrips;
  final VoidCallback onOpenLunchboxes;
  final VoidCallback onOpenGardenFurniture;
  final VoidCallback onOpenPuzzleSwap;
  final VoidCallback onOpenAmateurTheater;
  final VoidCallback onOpenElectroAmbient;
  final VoidCallback onOpenWaterFilters;
  final VoidCallback onOpenFarmStalls;
  final VoidCallback onOpenAquariumSwap;
  final VoidCallback onOpenCinemaPhotos;
  final VoidCallback onOpenAppCache;
  final VoidCallback onOpenPavementClean;
  final VoidCallback onOpenThermalTrips;
  final VoidCallback onOpenSourdough;
  final VoidCallback onOpenRollerShutters;
  final VoidCallback onOpenBeachGear;
  final VoidCallback onOpenBocce;
  final VoidCallback onOpenDiscoRetro;
  final VoidCallback onOpenCarOil;
  final VoidCallback onOpenPramAccess;
  final VoidCallback onOpenBalconyHerbs;
  final VoidCallback onOpenBazaarPhotos;
  final VoidCallback onOpenAccessPanel;
  final VoidCallback onOpenBenchPaint;
  final VoidCallback onOpenSudetyTrips;
  final VoidCallback onOpenFruitPreserves;
  final VoidCallback onOpenHomeSafes;
  final VoidCallback onOpenBikeChild;
  final VoidCallback onOpenBadminton;
  final VoidCallback onOpenJazzBlues;
  final VoidCallback onOpenSmokeAlarms;
  final VoidCallback onOpenSourdoughShops;
  final VoidCallback onOpenPetBirds;
  final VoidCallback onOpenPavilionPhotos;
  final VoidCallback onOpenNetworkApi;
  final VoidCallback onOpenParkingMarks;
  final VoidCallback onOpenBieszczadyTrips;
  final VoidCallback onOpenFruitVinegars;
  final VoidCallback onOpenVideoIntercoms;
  final VoidCallback onOpenBabyCarriers;
  final VoidCallback onOpenTennisSquash;
  final VoidCallback onOpenClassicalOpera;
  final VoidCallback onOpenPitcherFilters;
  final VoidCallback onOpenClothesBins;
  final VoidCallback onOpenAquaLivestock;
  final VoidCallback onOpenSchoolPhotos;
  final VoidCallback onOpenHomeShortcuts;
  final VoidCallback onOpenSidewalkSalts;
  final VoidCallback onOpenLandscapeParkTrips;
  final VoidCallback onOpenVeggiePickles;
  final VoidCallback onOpenRadiatorThermos;
  final VoidCallback onOpenArcheryGear;
  final VoidCallback onOpenYardGames;
  final VoidCallback onOpenPolishFilms;
  final VoidCallback onOpenSafetyKits;
  final VoidCallback onOpenSodaCo2;
  final VoidCallback onOpenTerrariumPets;
  final VoidCallback onOpenParkPhotos;
  final VoidCallback onOpenSoundAlerts;
  final int neighborQuestPoints;
  final List<String> unlockedNeighborQuestIds;
  final int avatarIndex;
  final String? avatarPhotoPath;
  final ValueChanged<int>? onAvatarChanged;
  final ValueChanged<String?>? onAvatarPhotoChanged;
  final bool locationVerified;
  final VoidCallback? onConfirmLocation;
  final MarketplaceState marketplace;
  final ValueChanged<bool>? onTradespersonRoleChanged;
  final VoidCallback? onOpenTradespersonCard;
  final VoidCallback? onOpenTradespersonSubscription;
  final VoidCallback? onRenewTradespersonSubscription;
  final VoidCallback? onOpenTradespersonCatalog;
  final VoidCallback? onOpenFavoriteTradespeople;
  final VoidCallback? onOpenTradespersonPortfolio;
  final VoidCallback? onOpenTradespersonPriceList;
  final List<String> exploredSubDistricts;
  final List<InfrastructureReport> infrastructureReports;
  final Set<String> unlockedBadgeIds;

  const ProfileScreen({
    super.key,
    required this.favoriteAnnouncements,
    required this.ownAnnouncements,
    this.communityAnnouncements = const [],
    required this.onOpenAnnouncement,
    required this.onToggleFavorite,
    required this.onLikeAnnouncement,
    required this.userName,
    required this.defaultSubDistrict,
    required this.createdAnnouncementCount,
    required this.isDarkMode,
    required this.onDefaultSubDistrictChanged,
    required this.onThemeChanged,
    required this.neighborhoodNotificationsEnabled,
    required this.onNeighborhoodNotificationsChanged,
    required this.onReportAnnouncement,
    this.onOpenContentReview,
    required this.onEditAnnouncement,
    required this.onCompleteAnnouncement,
    required this.onDeleteAnnouncement,
    required this.onRestoreDefaults,
    required this.onClearCachedAnnouncements,
    this.events = const [],
    this.seniorMode = false,
    required this.onSeniorModeChanged,
    this.appLocale = AppLocale.pl,
    required this.onAppLocaleChanged,
    required this.onOpenServices,
    required this.onOpenGroups,
    required this.onOpenCooperativeBoard,
    required this.onOpenNeighborQr,
    required this.onScanQr,
    this.driverMode = false,
    required this.onDriverModeChanged,
    required this.onOpenFoodGuide,
    required this.onOpenLocalDeals,
    required this.onOpenBookShelf,
    this.timeBankHours = 0,
    required this.communityStats,
    required this.onOpenCharityDrives,
    required this.onOpenInfrastructure,
    required this.onOpenFleaMarket,
    required this.onOpenSportMeetups,
    required this.onOpenSeniorCorner,
    required this.onOpenPlantSwap,
    required this.onOpenParentsClub,
    required this.onOpenBarter,
    required this.onOpenCraftMakers,
    required this.onOpenTutoring,
    required this.onOpenSafetyPatrol,
    required this.onOpenHomeAssistant,
    required this.onOpenNeighborTemplates,
    required this.onOpenOddJobs,
    required this.onOpenLostFound,
    required this.onOpenStaircaseFund,
    required this.onOpenSharedTools,
    required this.onOpenCultureEvents,
    required this.onOpenMarketStalls,
    required this.onOpenBulkBuy,
    required this.onOpenWalkingBus,
    required this.onOpenWidzewHistory,
    required this.onOpenEnergyHub,
    required this.onOpenRetroIt,
    required this.onOpenCostSplit,
    required this.onOpenBikeHelp,
    required this.onOpenDiyAcademy,
    required this.onOpenBloodClub,
    required this.onOpenGarageListings,
    required this.onOpenPetHealth,
    required this.onOpenPartyGear,
    required this.onOpenDroneAlerts,
    required this.onOpenCraftPassage,
    required this.onOpenDistrictReport,
    required this.onOpenEcoCollection,
    required this.onOpenLongDistanceRides,
    required this.onOpenSmileGifts,
    required this.onOpenFoodShare,
    required this.onOpenMedicalGear,
    required this.onOpenLeftoverMaterials,
    required this.onOpenFaunaAlerts,
    required this.onOpenRecipeClub,
    required this.onOpenKidsCreations,
    required this.onOpenWidzewTimeline,
    required this.onOpenEvCharging,
    required this.onOpenTailor,
    required this.onOpenStudentRides,
    required this.onOpenGrillZone,
    required this.onOpenPlaygroundReports,
    required this.onOpenCampGear,
    required this.onOpenSchoolBooks,
    required this.onOpenAirShows,
    required this.onOpenDigitalHelp,
    required this.onOpenLedSwap,
    required this.onOpenJasienGuide,
    required this.onOpenDistrictEcoStats,
    required this.onOpenBikeStations,
    required this.onOpenHandyJobs,
    required this.onOpenWinterHelp,
    required this.onOpenBoardGames,
    required this.onOpenWildlifeCare,
    required this.onOpenFitnessGear,
    required this.onOpenSmallAppliances,
    required this.onOpenBulkWaste,
    required this.onOpenRetroGaming,
    required this.onOpenArchitectureGuide,
    required this.onOpenRodShare,
    required this.onOpenBlockPush,
    required this.onOpenVinylSwap,
    required this.onOpenGardenNotes,
    required this.onOpenNightCarpool,
    required this.onOpenCraftWorkshop,
    required this.onOpenBikeTrips,
    required this.onOpenSchoolEco,
    required this.onOpenPhotoClub,
    required this.onOpenCrossingReports,
    required this.onOpenAvGear,
    required this.onOpenWorkwear,
    required this.onOpenGreenPaths,
    required this.onOpenNeighborQuests,
    required this.onOpenMicroBusiness,
    required this.onOpenHomeSit,
    required this.onOpenWorkshopGarage,
    required this.onOpenConsoleTourney,
    required this.onOpenJarSwap,
    required this.onOpenBabyGear,
    required this.onOpenYouthCode,
    required this.onOpenGenerationBridge,
    required this.onOpenFoundPlates,
    required this.onOpenIndustrialGuide,
    required this.onOpenHomeStatsConfig,
    required this.onOpenFireSafety,
    required this.onOpenCompostSwap,
    required this.onOpenMobileCraft,
    required this.onOpenSportLeague,
    required this.onOpenAnimalPatrol,
    required this.onOpenWeekendTrips,
    required this.onOpenTrailerShare,
    required this.onOpenPrlFurniture,
    required this.onOpenCineClub,
    required this.onOpenSlabMuseum,
    required this.onOpenStaircaseCodes,
    required this.onOpenDistrictAnalytics,
    required this.onOpenAirQuality,
    required this.onOpenPowerShare,
    required this.onOpenWildDump,
    required this.onOpenSafetySchool,
    required this.onOpenCargoCarpool,
    required this.onOpenCollectorFair,
    required this.onOpenLegoSwap,
    required this.onOpenChessClub,
    required this.onOpenLocalArt,
    required this.onOpenMemorialGuide,
    required this.onOpenMedicineChest,
    required this.onOpenUserBackup,
    required this.onOpenVoltageOutages,
    required this.onOpenParkingShare,
    required this.onOpenBlockTools,
    required this.onOpenMushroomTrips,
    required this.onOpenSmileTutors,
    required this.onOpenUpcycleCraft,
    required this.onOpenClassicCars,
    required this.onOpenWalkFinds,
    required this.onOpenGreenWaste,
    required this.onOpenTimeCapsule,
    required this.onOpenEmergencyRental,
    required this.onOpenHomeModuleVisibility,
    required this.onOpenHeatAlerts,
    required this.onOpenMallCarpool,
    required this.onOpenPramRacks,
    required this.onOpenRtvRepair,
    required this.onOpenKidCostumes,
    required this.onOpenModelFair,
    required this.onOpenFishingClub,
    required this.onOpenFinanceTips,
    required this.onOpenWildlifeShelters,
    required this.onOpenPetPros,
    required this.onOpenStreetArchive,
    required this.onOpenWidzewSkins,
    this.widzewSkin = WidzewSkin.classic,
    required this.onWidzewSkinChanged,
    required this.onOpenSmogFilters,
    required this.onOpenWaterPressure,
    required this.onOpenSolarShare,
    required this.onOpenPrint3d,
    required this.onOpenSportKits,
    required this.onOpenSeniorShop,
    required this.onOpenParkChess,
    required this.onOpenScamAlerts,
    required this.onOpenStreetArt,
    required this.onOpenPlantHotel,
    required this.onOpenWindowViews,
    required this.onOpenDiagnostics,
    required this.onVersionTileTap,
    required this.onOpenStairClean,
    required this.onOpenAirportRides,
    required this.onOpenEnergyRecipes,
    required this.onOpenGardenToolCare,
    required this.onOpenLangBooks,
    required this.onOpenStreetball,
    required this.onOpenIndieCinema,
    required this.onOpenLostPets,
    required this.onOpenEwasteMap,
    required this.onOpenFilamentShare,
    required this.onOpenIndustryMemory,
    required this.onOpenAchievementShare,
    required this.onOpenMpoBulky,
    required this.onOpenHolyCrossTrips,
    required this.onOpenPreserveJars,
    required this.onOpenPcvWindows,
    required this.onOpenSchoolGear,
    required this.onOpenTableSports,
    required this.onOpenPolishFantasy,
    required this.onOpenGasInspections,
    required this.onOpenScooterHubs,
    required this.onOpenHepaTrackers,
    required this.onOpenWidzewFilms,
    required this.onOpenActivityReport,
    required this.onOpenBalconyWash,
    required this.onOpenForestForage,
    required this.onOpenEcoCleaners,
    required this.onOpenLockCare,
    required this.onOpenSeasonalSkates,
    required this.onOpenDartBilliard,
    required this.onOpenRockMetal,
    required this.onOpenCarPolicies,
    required this.onOpenPhoneCharge,
    required this.onOpenAirPlants,
    required this.onOpenTramPhotos,
    required this.onOpenLocalVault,
    required this.onOpenCarpetVac,
    required this.onOpenKayakTrips,
    required this.onOpenLunchboxes,
    required this.onOpenGardenFurniture,
    required this.onOpenPuzzleSwap,
    required this.onOpenAmateurTheater,
    required this.onOpenElectroAmbient,
    required this.onOpenWaterFilters,
    required this.onOpenFarmStalls,
    required this.onOpenAquariumSwap,
    required this.onOpenCinemaPhotos,
    required this.onOpenAppCache,
    required this.onOpenPavementClean,
    required this.onOpenThermalTrips,
    required this.onOpenSourdough,
    required this.onOpenRollerShutters,
    required this.onOpenBeachGear,
    required this.onOpenBocce,
    required this.onOpenDiscoRetro,
    required this.onOpenCarOil,
    required this.onOpenPramAccess,
    required this.onOpenBalconyHerbs,
    required this.onOpenBazaarPhotos,
    required this.onOpenAccessPanel,
    required this.onOpenBenchPaint,
    required this.onOpenSudetyTrips,
    required this.onOpenFruitPreserves,
    required this.onOpenHomeSafes,
    required this.onOpenBikeChild,
    required this.onOpenBadminton,
    required this.onOpenJazzBlues,
    required this.onOpenSmokeAlarms,
    required this.onOpenSourdoughShops,
    required this.onOpenPetBirds,
    required this.onOpenPavilionPhotos,
    required this.onOpenNetworkApi,
    required this.onOpenParkingMarks,
    required this.onOpenBieszczadyTrips,
    required this.onOpenFruitVinegars,
    required this.onOpenVideoIntercoms,
    required this.onOpenBabyCarriers,
    required this.onOpenTennisSquash,
    required this.onOpenClassicalOpera,
    required this.onOpenPitcherFilters,
    required this.onOpenClothesBins,
    required this.onOpenAquaLivestock,
    required this.onOpenSchoolPhotos,
    required this.onOpenHomeShortcuts,
    required this.onOpenSidewalkSalts,
    required this.onOpenLandscapeParkTrips,
    required this.onOpenVeggiePickles,
    required this.onOpenRadiatorThermos,
    required this.onOpenArcheryGear,
    required this.onOpenYardGames,
    required this.onOpenPolishFilms,
    required this.onOpenSafetyKits,
    required this.onOpenSodaCo2,
    required this.onOpenTerrariumPets,
    required this.onOpenParkPhotos,
    required this.onOpenSoundAlerts,
    this.neighborQuestPoints = 0,
    this.unlockedNeighborQuestIds = const [],
    this.avatarIndex = 0,
    this.avatarPhotoPath,
    this.onAvatarChanged,
    this.onAvatarPhotoChanged,
    this.locationVerified = false,
    this.onConfirmLocation,
    this.marketplace = const MarketplaceState(),
    this.onTradespersonRoleChanged,
    this.onOpenTradespersonCard,
    this.onOpenTradespersonSubscription,
    this.onRenewTradespersonSubscription,
    this.onOpenTradespersonCatalog,
    this.onOpenFavoriteTradespeople,
    this.onOpenTradespersonPortfolio,
    this.onOpenTradespersonPriceList,
    this.exploredSubDistricts = const [],
    this.infrastructureReports = const [],
    this.unlockedBadgeIds = const {},
  });

  bool get _expandProfileMenus => isFlutterWidgetTest;

  List<Announcement> get _myReports =>
      ownAnnouncements.where((item) => item.isAlert || item.isHelp).toList();

  NeighborTrust get _trust {
    final likes = ownAnnouncements.fold<int>(
      0,
      (sum, announcement) => sum + announcement.likesCount,
    );
    return NeighborTrust.forAuthor(userName, likesCount: likes);
  }

  void _openMyAnnouncements(BuildContext context) {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => MyAnnouncementsScreen(
          announcements: ownAnnouncements,
          onOpen: onOpenAnnouncement,
          onEdit: onEditAnnouncement,
          onComplete: onCompleteAnnouncement,
          onDelete: onDeleteAnnouncement,
        ),
      ),
    );
  }

  void _openMyReports(BuildContext context) {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) =>
            MyReportsScreen(reports: _myReports, onOpen: onOpenAnnouncement),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SettingsScreen(
          isDarkMode: isDarkMode,
          onThemeChanged: onThemeChanged,
          widzewSkin: widzewSkin,
          onWidzewSkinChanged: onWidzewSkinChanged,
          onRestoreDefaults: onRestoreDefaults,
          onVersionTileTap: onVersionTileTap,
        ),
      ),
    );
  }

  Future<void> _pickHomeNeighborhood(BuildContext context) async {
    final selected = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => SimpleDialog(
        title: Text(dialogContext.tr('pickDistrict')),
        children: [
          RadioGroup<String>(
            groupValue: defaultSubDistrict,
            onChanged: (value) => Navigator.of(dialogContext).pop(value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final subDistrict in Announcement.subDistricts)
                  RadioListTile<String>(
                    value: subDistrict,
                    title: Text(subDistrict),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (selected != null && selected != defaultSubDistrict) {
      onDefaultSubDistrictChanged(selected);
    }
  }

  File? get _avatarPhotoFile {
    final path = avatarPhotoPath;
    if (kIsWeb || path == null || path.isEmpty) return null;
    final file = File(path);
    return file.existsSync() ? file : null;
  }

  Future<void> _pickAvatarPhoto(
    BuildContext context, {
    required bool camera,
  }) async {
    if (isFlutterWidgetTest || onAvatarPhotoChanged == null) return;
    final picker = const AppImagePicker();
    final path = camera
        ? await picker.pickFromCamera()
        : await picker.pickFromGallery();
    if (!context.mounted || path == null) return;
    onAvatarPhotoChanged!(path);
  }

  Future<void> _openAvatarSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return WidzewUi.barrierDismissibleSheet(
          context: sheetContext,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.62,
            minChildSize: 0.4,
            maxChildSize: 0.92,
            builder: (sheetContext, scrollController) {
              return Material(
                color: Theme.of(sheetContext).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(WidzewUi.radius),
                ),
                clipBehavior: Clip.antiAlias,
                child: SafeArea(
                  top: false,
                  child: CustomScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            context.tr('avatarSheetTitle'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ListTile(
                          leading: const Icon(Icons.camera_alt_outlined),
                          title: Text(context.tr('avatarTakePhoto')),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            unawaited(_pickAvatarPhoto(context, camera: true));
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ListTile(
                          leading: const Icon(Icons.image_outlined),
                          title: Text(context.tr('avatarPickGallery')),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            unawaited(_pickAvatarPhoto(context, camera: false));
                          },
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            context.tr('avatarPresets'),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 1.15,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final selected =
                                  avatarPhotoPath == null &&
                                  avatarIndex == index;
                              return Material(
                                key: ValueKey('neighbor-avatar-$index'),
                                color: selected
                                    ? WidzewColors.redSoft
                                    : Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest,
                                shape: WidzewUi.shape,
                                child: InkWell(
                                  customBorder: WidzewUi.shape,
                                  onTap: onAvatarChanged == null
                                      ? null
                                      : () {
                                          onAvatarChanged!(index);
                                          onAvatarPhotoChanged?.call(null);
                                          Navigator.of(sheetContext).pop();
                                        },
                                  child: Icon(
                                    NeighborAvatar.at(index),
                                    size: 26,
                                    color: selected ? WidzewColors.red : null,
                                  ),
                                ),
                              );
                            },
                            childCount: NeighborAvatar.icons.length,
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  List<NeighborBadge> _badgeCatalog(BuildContext context) {
    final reputation = NeighborReputation.badges(
      createdAnnouncementCount: createdAnnouncementCount,
      ownAnnouncements: ownAnnouncements,
    );
    NeighborBadge? reputationBadge(String title) {
      for (final badge in reputation) {
        if (badge.title == title) return badge;
      }
      return null;
    }

    final firstPost = reputationBadge('Pierwsze Ogłoszenie');
    final helpful = reputationBadge('Pomocny Sąsiad');
    final verified = _trust.isVerified;
    final helpingUnlocked =
        (helpful?.unlocked ?? false) ||
        unlockedNeighborQuestIds.contains('nq-dlon');
    final ecoUnlocked = ownAnnouncements.any((item) => item.isFree);
    final expertUnlocked =
        createdAnnouncementCount >= 5 || ownAnnouncements.length >= 5;
    final helpedRepairJob =
        marketplace.helpPosts.any(
          (post) =>
              (post.acceptedBy ?? '').isNotEmpty && post.acceptedBy == userName,
        ) ||
        marketplace.jobRequests.any((job) => job.tradespersonName == userName);
    final solvedCityReport = infrastructureReports.any(
      (report) =>
          report.authorName == userName &&
          report.status == InfrastructureStatus.repaired,
    );
    final achievements = NeighborAchievements.evaluate(
      ownAnnouncements: ownAnnouncements,
      helpedRepairJob: helpedRepairJob,
      solvedCityReport: solvedCityReport,
    );

    bool earned(String id, bool live) => live || unlockedBadgeIds.contains(id);

    NeighborBadge? withPersisted(NeighborBadge? badge) {
      if (badge == null) return null;
      final unlocked = earned(badge.id, badge.unlocked);
      return NeighborBadge(
        id: badge.id,
        title: badge.title,
        description: badge.description,
        icon: badge.icon,
        unlocked: unlocked,
      );
    }

    NeighborBadge achievement({
      required String id,
      required String titleKey,
      required String hintKey,
      required String earnedKey,
      required IconData icon,
      required bool unlocked,
    }) {
      final isUnlocked = earned(id, unlocked);
      return NeighborBadge(
        id: id,
        title: context.tr(titleKey),
        description: context.tr(isUnlocked ? earnedKey : hintKey),
        icon: icon,
        unlocked: isUnlocked,
      );
    }

    return [
      NeighborBadge(
        id: 'active_neighbor',
        title: context.tr('activeNeighbor'),
        description: context.tr('badgeActiveHint'),
        icon: Icons.verified,
        unlocked: true,
      ),
      NeighborBadge(
        id: 'verified_neighbor',
        title: context.tr('verifiedNeighbor'),
        description: context.tr(
          locationVerified && verified
              ? 'badgeVerifiedEarnedHint'
              : 'badgeVerifiedHint',
        ),
        icon: Icons.verified_user,
        unlocked: locationVerified && verified,
      ),
      NeighborBadge(
        id: 'gps_verified',
        title: context.tr('confirmedResident'),
        description: context.tr(
          locationVerified ? 'badgeResidentEarnedHint' : 'badgeResidentHint',
        ),
        icon: Icons.location_on,
        unlocked: locationVerified,
      ),
      ?withPersisted(firstPost),
      NeighborBadge(
        id: 'helpful_hand',
        title: context.tr('badgeHelpingTitle'),
        description: context.tr(
          earned('helpful_hand', helpingUnlocked)
              ? 'badgeHelpingEarnedHint'
              : 'badgeHelpingHint',
        ),
        icon: Icons.volunteer_activism_outlined,
        unlocked: earned('helpful_hand', helpingUnlocked),
      ),
      achievement(
        id: 'eco_resident',
        titleKey: 'badgeEcoTitle',
        hintKey: 'badgeEcoHint',
        earnedKey: 'badgeEcoEarnedHint',
        icon: Icons.eco_outlined,
        unlocked: ecoUnlocked,
      ),
      NeighborBadge(
        id: 'local_expert',
        title: context.tr('badgeExpertTitle'),
        description: context.tr(
          earned('local_expert', expertUnlocked)
              ? 'badgeExpertEarnedHint'
              : 'badgeExpertHint',
        ),
        icon: Icons.workspace_premium_outlined,
        unlocked: earned('local_expert', expertUnlocked),
      ),
      achievement(
        id: 'fast_deal',
        titleKey: 'badgeFastDealTitle',
        hintKey: 'badgeFastDealHint',
        earnedKey: 'badgeFastDealEarnedHint',
        icon: Icons.flash_on_outlined,
        unlocked: achievements.fastDeal,
      ),
      achievement(
        id: 'garage_king',
        titleKey: 'badgeGarageKingTitle',
        hintKey: 'badgeGarageKingHint',
        earnedKey: 'badgeGarageKingEarnedHint',
        icon: Icons.garage_outlined,
        unlocked: achievements.garageKing,
      ),
      achievement(
        id: 'golden_hand',
        titleKey: 'badgeGoldenHandTitle',
        hintKey: 'badgeGoldenHandHint',
        earnedKey: 'badgeGoldenHandEarnedHint',
        icon: Icons.handyman_outlined,
        unlocked: achievements.goldenHand,
      ),
      achievement(
        id: 'watchful_eye',
        titleKey: 'badgeWatchfulEyeTitle',
        hintKey: 'badgeWatchfulEyeHint',
        earnedKey: 'badgeWatchfulEyeEarnedHint',
        icon: Icons.visibility_outlined,
        unlocked: achievements.watchfulEye,
      ),
      achievement(
        id: 'popular_neighbor',
        titleKey: 'badgePopularTitle',
        hintKey: 'badgePopularHint',
        earnedKey: 'badgePopularEarnedHint',
        icon: Icons.trending_up,
        unlocked: achievements.popularNeighbor,
      ),
    ];
  }

  Future<void> _openBadgesSheet(BuildContext context) {
    final points = NeighborReputation.points(
      createdAnnouncementCount: createdAnnouncementCount,
      ownAnnouncements: ownAnnouncements,
      communityAnnouncements: communityAnnouncements,
      userName: userName,
      events: events,
    );
    return BadgesModal.show(
      context,
      badges: _badgeCatalog(context),
      pointsLabel:
          '$points pkt reputacji · $neighborQuestPoints pkt aktywności',
    );
  }

  @override
  Widget build(BuildContext context) {
    final badges = _badgeCatalog(context);
    final earnedCount = badges.where((badge) => badge.unlocked).length;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('profileTitle')),
        actions: [
          IconButton(
            key: const ValueKey('profile-settings'),
            tooltip: context.tr('settingsTooltip'),
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: CustomScrollView(
        key: const ValueKey('profile-list'),
        scrollCacheExtent: WidzewUi.listCacheExtent,
        shrinkWrap: false,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 28),
                Center(
                  child: SizedBox(
                    width: 116,
                    height: 116,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => unawaited(_openAvatarSheet(context)),
                              child: CircleAvatar(
                                radius: 52,
                                backgroundColor: const Color(0xFFFDE0E0),
                                backgroundImage: _avatarPhotoFile == null
                                    ? null
                                    : ResizeImage(
                                        FileImage(_avatarPhotoFile!),
                                        width: WidzewUi.imageCachePixels(
                                          context,
                                          116,
                                        ),
                                        height: WidzewUi.imageCachePixels(
                                          context,
                                          116,
                                        ),
                                      ),
                                child: _avatarPhotoFile != null
                                    ? null
                                    : Icon(
                                        NeighborAvatar.at(avatarIndex),
                                        size: 56,
                                        color: const Color(0xFFD32F2F),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 2,
                          bottom: 2,
                          child: Material(
                            color: WidzewColors.red,
                            shape: const CircleBorder(),
                            elevation: 2,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => unawaited(_openAvatarSheet(context)),
                              child: Tooltip(
                                message: context.tr('changeAvatar'),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700, height: 1.2),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    key: const ValueKey('active-neighbor-badge'),
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    shape: WidzewUi.shape,
                    child: InkWell(
                      customBorder: WidzewUi.shape,
                      onTap: () => unawaited(_openBadgesSheet(context)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: WidzewColors.red.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.military_tech,
                                    color: WidzewColors.red,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.tr('yourBadges'),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        context.tr('badgesEarnedCount', {
                                          'earned': '$earnedCount',
                                          'total': '${badges.length}',
                                        }),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ],
                            ),
                            if (_expandProfileMenus)
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Opacity(
                                  opacity: 0,
                                  child: Text(context.tr('activeNeighbor')),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (onConfirmLocation != null)
                  ListTile(
                    leading: const Icon(Icons.my_location_outlined),
                    title: Text(context.tr('confirmLocation')),
                    subtitle: Text(
                      locationVerified
                          ? context.tr('locationOn')
                          : context.tr('locationOff'),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onConfirmLocation,
                  ),
                ListTile(
                  leading: const Icon(Icons.push_pin_outlined),
                  title: Text(context.tr('defaultDistrict')),
                  subtitle: Text(defaultSubDistrict),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickHomeNeighborhood(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      key: const ValueKey('activity-summary-header'),
                      context.tr('activitySummary'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ProfileStat(
                          label: context.tr('statPosted'),
                          value: '$createdAnnouncementCount',
                          icon: Icons.campaign_outlined,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ProfileStat(
                          label: context.tr('statFavorites'),
                          value: '${favoriteAnnouncements.length}',
                          icon: Icons.bookmark_border,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ProfileStat(
                          label: context.tr('statArea'),
                          value: defaultSubDistrict,
                          icon: Icons.location_on_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ProfileStat(
                          label: context.tr('statReports'),
                          value:
                              '${ownAnnouncements.where((item) => item.isAlert || item.isHelp).length}',
                          icon: Icons.report_outlined,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ProfileStat(
                          label: context.tr('statMyPosts'),
                          value: '${ownAnnouncements.length}',
                          icon: Icons.inventory_2_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.hourglass_bottom),
                  title: Text(context.tr('timeBankTitle')),
                  subtitle: Text(
                    context.tr('timeBankHint', {'hours': '$timeBankHours'}),
                  ),
                ),
                CommunityStatsPanel(
                  key: ValueKey(communityStats.hashCode),
                  stats: communityStats,
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.handyman_outlined),
                  title: const Text('Konto Fachowca (Złota Rączka)'),
                  subtitle: Text(
                    marketplace.account.isTradesperson
                        ? 'Wizytówka fachowca · PRO ${marketplace.account.subscriptionStatusLabel}'
                        : 'Konto klienta — zlecenia przez katalog',
                  ),
                  value: marketplace.account.isTradesperson,
                  onChanged: onTradespersonRoleChanged,
                ),
                if (marketplace.account.isTradesperson) ...[
                  ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('Wizytówka fachowca'),
                    subtitle: Text(
                      marketplace.account.card.isComplete
                          ? '${marketplace.account.card.displayName} · ${marketplace.account.card.trade}'
                          : 'Uzupełnij nazwę, branżę, opis i stawkę',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onOpenTradespersonCard,
                  ),
                  if (onRenewTradespersonSubscription != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: SubscriptionStatusPanel(
                        account: marketplace.account,
                        onRenew: onRenewTradespersonSubscription!,
                        onOpenDetails: onOpenTradespersonSubscription,
                      ),
                    )
                  else
                    ListTile(
                      leading: const Icon(Icons.workspace_premium_outlined),
                      title: const Text('Abonament Fachowca'),
                      subtitle: Text(
                        'Status: ${marketplace.account.subscriptionStatusLabel}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: onOpenTradespersonSubscription,
                    ),
                  ListTile(
                    leading: const Icon(Icons.photo_library_outlined),
                    title: const Text('Zdjęcia moich prac'),
                    subtitle: Text(
                      marketplace.account.portfolio.isEmpty
                          ? 'Galeria Przed / Po ostatnich realizacji'
                          : '${marketplace.account.portfolio.length} zdjęć w portfolio',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onOpenTradespersonPortfolio,
                  ),
                  ListTile(
                    leading: const Icon(Icons.request_quote_outlined),
                    title: const Text('Orientacyjny Cennik'),
                    subtitle: Text(
                      marketplace.account.priceList.isEmpty
                          ? 'Lista usług i stawek'
                          : '${marketplace.account.priceList.length} pozycji',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onOpenTradespersonPriceList,
                  ),
                ],
                ListTile(
                  leading: const Icon(Icons.workspace_premium_outlined),
                  title: const Text('Dlaczego warto zostać Fachowcem PRO'),
                  subtitle: const Text(
                    'Korzyści pakietu abonamentowego dla wykonawców',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      AppPageRoute<void>(
                        builder: (_) => TradespersonProBenefitsScreen(
                          onBecomePro: () {
                            Navigator.of(context).pop();
                            onOpenTradespersonSubscription?.call();
                          },
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home_repair_service_outlined),
                  title: const Text('Katalog Fachowców'),
                  subtitle: const Text(
                    'Zweryfikowani fachowcy PRO na Widzewie',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onOpenTradespersonCatalog,
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_outline),
                  title: const Text('Ulubieni Fachowcy'),
                  subtitle: Text(
                    marketplace.favoriteListingIds.isEmpty
                        ? 'Zapisani, zaufani wykonawcy'
                        : '${marketplace.favoriteListingIds.length} zapisanych fachowców',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap:
                      onOpenFavoriteTradespeople ?? onOpenTradespersonCatalog,
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.text_increase),
                  title: Text(context.tr('seniorMode')),
                  subtitle: Text(context.tr('seniorModeHint')),
                  value: seniorMode,
                  onChanged: onSeniorModeChanged,
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.directions_car_outlined),
                  title: Text(context.tr('driverMode')),
                  subtitle: Text(context.tr('driverModeHint')),
                  value: driverMode,
                  onChanged: onDriverModeChanged,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Text(
                    context.tr('language'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final locale in AppLocale.values.take(3))
                        ChoiceChip(
                          label: Text(locale.label),
                          selected: appLocale == locale,
                          onSelected: (_) => onAppLocaleChanged(locale),
                        ),
                    ],
                  ),
                ),
                SwitchListTile(
                  key: const ValueKey('notifications-switch'),
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: Text(context.tr('neighborhoodNotifications')),
                  subtitle: Text(
                    neighborhoodNotificationsEnabled
                        ? context.tr('notificationsOn')
                        : context.tr('notificationsOff'),
                  ),
                  value: neighborhoodNotificationsEnabled,
                  onChanged: onNeighborhoodNotificationsChanged,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    context.tr('myPostsSection'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: ListTile(
                    key: const ValueKey('my-announcements-tile'),
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: Text(context.tr('myAnnouncements')),
                    subtitle: Text(context.tr('editStatuses')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openMyAnnouncements(context),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: ListTile(
                    key: const ValueKey('my-reports-tile'),
                    leading: const Icon(Icons.report_outlined),
                    title: Text(context.tr('myReports')),
                    subtitle: Text(context.tr('reportStatuses')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openMyReports(context),
                  ),
                ),
                if (onOpenContentReview != null)
                  Card(
                    margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    child: ListTile(
                      key: const ValueKey('content-review-tile'),
                      leading: const Icon(Icons.gpp_maybe_outlined),
                      title: Text(context.tr('contentReview')),
                      subtitle: Text(context.tr('contentReviewHint')),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: onOpenContentReview,
                    ),
                  ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    context.tr('savedTitle'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (favoriteAnnouncements.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(context.tr('savedEmpty')),
                  ),
              ]),
            ),
          ),
          if (favoriteAnnouncements.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 80),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final announcement = favoriteAnnouncements[index];
                    return AnnouncementCard(
                      key: ValueKey(announcement.heroTag),
                      announcement: announcement,
                      useHero: false,
                      onTap: () => onOpenAnnouncement(announcement),
                      onFavoriteToggle: () => onToggleFavorite(announcement),
                      onLike: () => onLikeAnnouncement(announcement),
                      onReport: (reason) =>
                          onReportAnnouncement(announcement, reason),
                    );
                  },
                  childCount: favoriteAnnouncements.length,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            softWrap: true,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            label,
            softWrap: true,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
