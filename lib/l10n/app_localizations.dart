import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'LikeALocal'**
  String get appName;

  /// Bottom nav tab
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get tabDiscover;

  /// No description provided for @tabSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tabSearch;

  /// No description provided for @tabSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get tabSaved;

  /// No description provided for @tabInbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get tabInbox;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTitle;

  /// No description provided for @discoverNearYou.
  ///
  /// In en, this message translates to:
  /// **'Near You'**
  String get discoverNearYou;

  /// No description provided for @discoverFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get discoverFeatured;

  /// No description provided for @discoverTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get discoverTrending;

  /// No description provided for @discoverLocalOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Local of the Week'**
  String get discoverLocalOfWeek;

  /// No description provided for @discoverLocalOfWeekBadge.
  ///
  /// In en, this message translates to:
  /// **'LOCAL OF THE WEEK'**
  String get discoverLocalOfWeekBadge;

  /// No description provided for @discoverViewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get discoverViewProfile;

  /// No description provided for @discoverSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get discoverSeeAll;

  /// No description provided for @discoverSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search restaurants, places…'**
  String get discoverSearchHint;

  /// No description provided for @discoverCustomDistance.
  ///
  /// In en, this message translates to:
  /// **'Custom distance'**
  String get discoverCustomDistance;

  /// No description provided for @discoverCustomDistanceFilter.
  ///
  /// In en, this message translates to:
  /// **'Custom {distance}'**
  String discoverCustomDistanceFilter(String distance);

  /// No description provided for @discoverDistanceKm.
  ///
  /// In en, this message translates to:
  /// **'Distance in km'**
  String get discoverDistanceKm;

  /// No description provided for @discoverNoNearbyPlaces.
  ///
  /// In en, this message translates to:
  /// **'No nearby places'**
  String get discoverNoNearbyPlaces;

  /// No description provided for @discoverNoNearbyPlacesBody.
  ///
  /// In en, this message translates to:
  /// **'Try a wider distance filter.'**
  String get discoverNoNearbyPlacesBody;

  /// No description provided for @discoverRefreshLocation.
  ///
  /// In en, this message translates to:
  /// **'Refresh location'**
  String get discoverRefreshLocation;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get categoryRestaurant;

  /// No description provided for @categoryCafe.
  ///
  /// In en, this message translates to:
  /// **'Café'**
  String get categoryCafe;

  /// No description provided for @categoryBar.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get categoryBar;

  /// No description provided for @categoryViewpoint.
  ///
  /// In en, this message translates to:
  /// **'Viewpoint'**
  String get categoryViewpoint;

  /// No description provided for @categoryMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get categoryMarket;

  /// No description provided for @categoryMuseum.
  ///
  /// In en, this message translates to:
  /// **'Museum'**
  String get categoryMuseum;

  /// No description provided for @categoryPark.
  ///
  /// In en, this message translates to:
  /// **'Park'**
  String get categoryPark;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search places, neighborhoods…'**
  String get searchHint;

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get searchRecent;

  /// No description provided for @searchMoods.
  ///
  /// In en, this message translates to:
  /// **'Explore by Mood'**
  String get searchMoods;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get searchNoResults;

  /// No description provided for @searchNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or remove some filters.'**
  String get searchNoResultsBody;

  /// No description provided for @moodRomantic.
  ///
  /// In en, this message translates to:
  /// **'Romantic'**
  String get moodRomantic;

  /// No description provided for @moodFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get moodFamily;

  /// No description provided for @moodHiddenGem.
  ///
  /// In en, this message translates to:
  /// **'Hidden Gem'**
  String get moodHiddenGem;

  /// No description provided for @moodLively.
  ///
  /// In en, this message translates to:
  /// **'Lively'**
  String get moodLively;

  /// No description provided for @moodPeaceful.
  ///
  /// In en, this message translates to:
  /// **'Peaceful'**
  String get moodPeaceful;

  /// No description provided for @moodFoodie.
  ///
  /// In en, this message translates to:
  /// **'Foodie'**
  String get moodFoodie;

  /// No description provided for @moodOffBeaten.
  ///
  /// In en, this message translates to:
  /// **'Off-the-beaten-track'**
  String get moodOffBeaten;

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @savedCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get savedCollections;

  /// No description provided for @savedAllPlaces.
  ///
  /// In en, this message translates to:
  /// **'All Places'**
  String get savedAllPlaces;

  /// No description provided for @savedReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get savedReminders;

  /// No description provided for @savedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get savedEmpty;

  /// No description provided for @savedEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Save places you love to find them later.'**
  String get savedEmptyBody;

  /// No description provided for @savedUnlockCollections.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited collections'**
  String get savedUnlockCollections;

  /// No description provided for @savedFreePlan.
  ///
  /// In en, this message translates to:
  /// **'Free plan: up to 10 saved places.'**
  String get savedFreePlan;

  /// No description provided for @savedUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get savedUpgrade;

  /// No description provided for @savedNoCollections.
  ///
  /// In en, this message translates to:
  /// **'No collections yet'**
  String get savedNoCollections;

  /// No description provided for @savedNoCollectionsBody.
  ///
  /// In en, this message translates to:
  /// **'Group your saved places into collections.'**
  String get savedNoCollectionsBody;

  /// No description provided for @savedCreateCollection.
  ///
  /// In en, this message translates to:
  /// **'Create collection'**
  String get savedCreateCollection;

  /// No description provided for @savedNewCollection.
  ///
  /// In en, this message translates to:
  /// **'New collection'**
  String get savedNewCollection;

  /// No description provided for @savedCollectionName.
  ///
  /// In en, this message translates to:
  /// **'Collection name'**
  String get savedCollectionName;

  /// No description provided for @savedCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get savedCreate;

  /// No description provided for @savedPlacesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} places'**
  String savedPlacesCount(int count);

  /// No description provided for @savedNoReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders set'**
  String get savedNoReminders;

  /// No description provided for @savedNoRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'Set location reminders on any saved place.'**
  String get savedNoRemindersBody;

  /// No description provided for @inboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inboxTitle;

  /// No description provided for @inboxEmpty.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get inboxEmpty;

  /// No description provided for @inboxEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with a local contributor.'**
  String get inboxEmptyBody;

  /// No description provided for @chatLocalBadge.
  ///
  /// In en, this message translates to:
  /// **'LOCAL'**
  String get chatLocalBadge;

  /// No description provided for @chatMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Message…'**
  String get chatMessageHint;

  /// No description provided for @chatSuperLocal.
  ///
  /// In en, this message translates to:
  /// **'Super Local'**
  String get chatSuperLocal;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileContributions.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get profileContributions;

  /// No description provided for @profileSavedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Saved Places'**
  String get profileSavedPlaces;

  /// No description provided for @profileYourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get profileYourName;

  /// No description provided for @profileLocation.
  ///
  /// In en, this message translates to:
  /// **'Lisbon, Portugal'**
  String get profileLocation;

  /// No description provided for @profileStatPlaces.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get profileStatPlaces;

  /// No description provided for @profileStatSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get profileStatSaved;

  /// No description provided for @profileStatHelpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful'**
  String get profileStatHelpful;

  /// No description provided for @profileVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified Member'**
  String get profileVerified;

  /// No description provided for @profileVerifiedBody.
  ///
  /// In en, this message translates to:
  /// **'Share 5 places to become a Super Local'**
  String get profileVerifiedBody;

  /// No description provided for @profileMyPlaces.
  ///
  /// In en, this message translates to:
  /// **'My Places'**
  String get profileMyPlaces;

  /// No description provided for @profileNoPlaces.
  ///
  /// In en, this message translates to:
  /// **'No places shared yet'**
  String get profileNoPlaces;

  /// No description provided for @profileTestPay.
  ///
  /// In en, this message translates to:
  /// **'Test Pay (debug)'**
  String get profileTestPay;

  /// No description provided for @placeDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get placeDetails;

  /// No description provided for @placeTips.
  ///
  /// In en, this message translates to:
  /// **'Local Tips'**
  String get placeTips;

  /// No description provided for @placeDishes.
  ///
  /// In en, this message translates to:
  /// **'Must-Try Dishes'**
  String get placeDishes;

  /// No description provided for @placeReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get placeReviews;

  /// No description provided for @placeReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'({count} reviews)'**
  String placeReviewsCount(int count);

  /// No description provided for @placeRemindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me near'**
  String get placeRemindMe;

  /// No description provided for @placeSave.
  ///
  /// In en, this message translates to:
  /// **'Save place'**
  String get placeSave;

  /// No description provided for @placeSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get placeSaved;

  /// No description provided for @placeChatContributor.
  ///
  /// In en, this message translates to:
  /// **'Chat with contributor'**
  String get placeChatContributor;

  /// No description provided for @placeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Place not found'**
  String get placeNotFound;

  /// No description provided for @placeNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'This place may have been removed or is no longer available.'**
  String get placeNotFoundBody;

  /// No description provided for @placeGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get placeGoBack;

  /// No description provided for @placeAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get placeAnonymous;

  /// No description provided for @placeContributor.
  ///
  /// In en, this message translates to:
  /// **'Contributor'**
  String get placeContributor;

  /// No description provided for @placeSuperLocal.
  ///
  /// In en, this message translates to:
  /// **'Super Local'**
  String get placeSuperLocal;

  /// No description provided for @placeChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get placeChat;

  /// No description provided for @placeNoReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get placeNoReviews;

  /// No description provided for @placeNoReviewsBody.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your experience.'**
  String get placeNoReviewsBody;

  /// No description provided for @placeWriteReview.
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get placeWriteReview;

  /// No description provided for @placeEditReview.
  ///
  /// In en, this message translates to:
  /// **'Edit your review'**
  String get placeEditReview;

  /// No description provided for @placeDeleteReview.
  ///
  /// In en, this message translates to:
  /// **'Delete review'**
  String get placeDeleteReview;

  /// No description provided for @reviewComposerTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your experience'**
  String get reviewComposerTitle;

  /// No description provided for @reviewComposerBody.
  ///
  /// In en, this message translates to:
  /// **'Help travelers find great spots.'**
  String get reviewComposerBody;

  /// No description provided for @reviewComposerHint.
  ///
  /// In en, this message translates to:
  /// **'What did you love? Any tips?'**
  String get reviewComposerHint;

  /// No description provided for @reviewComposerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Post review'**
  String get reviewComposerSubmit;

  /// No description provided for @reviewComposerUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update review'**
  String get reviewComposerUpdate;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapTitle;

  /// No description provided for @mapNearMe.
  ///
  /// In en, this message translates to:
  /// **'Near Me'**
  String get mapNearMe;

  /// No description provided for @mapLocating.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get mapLocating;

  /// No description provided for @mapSearchOnMap.
  ///
  /// In en, this message translates to:
  /// **'Search on map…'**
  String get mapSearchOnMap;

  /// No description provided for @mapDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get mapDirections;

  /// No description provided for @mapNoLocation.
  ///
  /// In en, this message translates to:
  /// **'Location access needed'**
  String get mapNoLocation;

  /// No description provided for @mapNoLocationBody.
  ///
  /// In en, this message translates to:
  /// **'Enable location to see places near you.'**
  String get mapNoLocationBody;

  /// No description provided for @mapEnableLocationServices.
  ///
  /// In en, this message translates to:
  /// **'Enable location services to center the map near you.'**
  String get mapEnableLocationServices;

  /// No description provided for @mapLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. The map will stay interactive.'**
  String get mapLocationDenied;

  /// No description provided for @mapCannotFetchLocation.
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch your current location right now.'**
  String get mapCannotFetchLocation;

  /// No description provided for @mapCannotOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Unable to open Google Maps right now.'**
  String get mapCannotOpenMaps;

  /// No description provided for @mapPickCount.
  ///
  /// In en, this message translates to:
  /// **'{count} picks'**
  String mapPickCount(int count);

  /// No description provided for @addPlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Place'**
  String get addPlaceTitle;

  /// No description provided for @addPlacePhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get addPlacePhotos;

  /// No description provided for @addPlaceBasics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get addPlaceBasics;

  /// No description provided for @addPlaceTips.
  ///
  /// In en, this message translates to:
  /// **'Tips & Dishes'**
  String get addPlaceTips;

  /// No description provided for @addPlacePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get addPlacePreview;

  /// No description provided for @addPlacePublish.
  ///
  /// In en, this message translates to:
  /// **'Publish Place'**
  String get addPlacePublish;

  /// No description provided for @addPlaceNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {step}'**
  String addPlaceNext(String step);

  /// No description provided for @addPlacePhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get addPlacePhotosTitle;

  /// No description provided for @addPlacePhotosHint.
  ///
  /// In en, this message translates to:
  /// **'At least 1 photo required.'**
  String get addPlacePhotosHint;

  /// No description provided for @addPlaceDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Place details'**
  String get addPlaceDetailsTitle;

  /// No description provided for @addPlaceName.
  ///
  /// In en, this message translates to:
  /// **'Place name'**
  String get addPlaceName;

  /// No description provided for @addPlaceNeighborhood.
  ///
  /// In en, this message translates to:
  /// **'Neighborhood'**
  String get addPlaceNeighborhood;

  /// No description provided for @addPlaceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get addPlaceDescription;

  /// No description provided for @addPlaceCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get addPlaceCategory;

  /// No description provided for @addPlaceTipsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add up to 5 local tips.'**
  String get addPlaceTipsSubtitle;

  /// No description provided for @addPlaceTipLabel.
  ///
  /// In en, this message translates to:
  /// **'Tip 1'**
  String get addPlaceTipLabel;

  /// No description provided for @addPlaceTipHint.
  ///
  /// In en, this message translates to:
  /// **'What should visitors know?'**
  String get addPlaceTipHint;

  /// No description provided for @addPlaceAddTip.
  ///
  /// In en, this message translates to:
  /// **'Add another tip'**
  String get addPlaceAddTip;

  /// No description provided for @addPlaceDishName.
  ///
  /// In en, this message translates to:
  /// **'Dish name'**
  String get addPlaceDishName;

  /// No description provided for @addPlaceAddDish.
  ///
  /// In en, this message translates to:
  /// **'Add a dish'**
  String get addPlaceAddDish;

  /// No description provided for @addPlaceReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to publish?'**
  String get addPlaceReadyTitle;

  /// No description provided for @addPlaceReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Your place will be visible to everyone once published.'**
  String get addPlaceReadyBody;

  /// No description provided for @aiTitle.
  ///
  /// In en, this message translates to:
  /// **'Local AI'**
  String get aiTitle;

  /// No description provided for @aiPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ask about the best places…'**
  String get aiPlaceholder;

  /// No description provided for @aiPoweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by Gemini'**
  String get aiPoweredBy;

  /// No description provided for @aiGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m your Local AI. I know the city\'s hidden gems inside out. What are you looking for today?'**
  String get aiGreeting;

  /// No description provided for @aiSuggestion1.
  ///
  /// In en, this message translates to:
  /// **'Where to eat solo tonight?'**
  String get aiSuggestion1;

  /// No description provided for @aiSuggestion2.
  ///
  /// In en, this message translates to:
  /// **'Best Sunday brunch spots'**
  String get aiSuggestion2;

  /// No description provided for @aiSuggestion3.
  ///
  /// In en, this message translates to:
  /// **'Hidden bars in the old town'**
  String get aiSuggestion3;

  /// No description provided for @aiSuggestion4.
  ///
  /// In en, this message translates to:
  /// **'Viewpoints without the crowds'**
  String get aiSuggestion4;

  /// No description provided for @aiFallbackReply.
  ///
  /// In en, this message translates to:
  /// **'Great question! Based on your preferences, I can suggest a few hidden gems locals love. Would you like me to narrow down by cuisine or atmosphere?'**
  String get aiFallbackReply;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get premiumTitle;

  /// No description provided for @premiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock the full\nlocal experience.'**
  String get premiumSubtitle;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get premiumBadge;

  /// No description provided for @premiumHeadlinePrefix.
  ///
  /// In en, this message translates to:
  /// **'Unlock the full\n'**
  String get premiumHeadlinePrefix;

  /// No description provided for @premiumHeadlineAccent.
  ///
  /// In en, this message translates to:
  /// **'local'**
  String get premiumHeadlineAccent;

  /// No description provided for @premiumHeadlineSuffix.
  ///
  /// In en, this message translates to:
  /// **' experience.'**
  String get premiumHeadlineSuffix;

  /// No description provided for @premiumMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get premiumMonthly;

  /// No description provided for @premiumYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get premiumYearly;

  /// No description provided for @premiumMonthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'€4.99 / month'**
  String get premiumMonthlyPrice;

  /// No description provided for @premiumYearlyPrice.
  ///
  /// In en, this message translates to:
  /// **'€2.99 / month'**
  String get premiumYearlyPrice;

  /// No description provided for @premiumPriceMonthly.
  ///
  /// In en, this message translates to:
  /// **'€4.99'**
  String get premiumPriceMonthly;

  /// No description provided for @premiumPriceYearly.
  ///
  /// In en, this message translates to:
  /// **'€2.99'**
  String get premiumPriceYearly;

  /// No description provided for @premiumPeriod.
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get premiumPeriod;

  /// No description provided for @premiumYearlyBadge.
  ///
  /// In en, this message translates to:
  /// **'Save 40%'**
  String get premiumYearlyBadge;

  /// No description provided for @premiumCta.
  ///
  /// In en, this message translates to:
  /// **'Start Premium'**
  String get premiumCta;

  /// No description provided for @premiumRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get premiumRestorePurchases;

  /// No description provided for @premiumCancelAnnually.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime. Billed annually.'**
  String get premiumCancelAnnually;

  /// No description provided for @premiumCancelMonthly.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime. Billed monthly.'**
  String get premiumCancelMonthly;

  /// No description provided for @premiumFeatureUnlimitedSaves.
  ///
  /// In en, this message translates to:
  /// **'Unlimited saved places'**
  String get premiumFeatureUnlimitedSaves;

  /// No description provided for @premiumFeatureUnlimitedCollections.
  ///
  /// In en, this message translates to:
  /// **'Unlimited collections'**
  String get premiumFeatureUnlimitedCollections;

  /// No description provided for @premiumFeatureAiChat.
  ///
  /// In en, this message translates to:
  /// **'Local AI chat assistant'**
  String get premiumFeatureAiChat;

  /// No description provided for @premiumFeatureOfflineMaps.
  ///
  /// In en, this message translates to:
  /// **'Offline neighborhood maps'**
  String get premiumFeatureOfflineMaps;

  /// No description provided for @premiumFeatureReminders.
  ///
  /// In en, this message translates to:
  /// **'Location reminders'**
  String get premiumFeatureReminders;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get settingsChat;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsPersonalization.
  ///
  /// In en, this message translates to:
  /// **'Personalization'**
  String get settingsPersonalization;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsEnglish;

  /// No description provided for @settingsGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingsGerman;

  /// No description provided for @settingsGermanNative.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get settingsGermanNative;

  /// No description provided for @settingsEnableChat.
  ///
  /// In en, this message translates to:
  /// **'Enable chat'**
  String get settingsEnableChat;

  /// No description provided for @settingsEnableChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow contributors to message you'**
  String get settingsEnableChatSubtitle;

  /// No description provided for @settingsAwayMode.
  ///
  /// In en, this message translates to:
  /// **'Away mode'**
  String get settingsAwayMode;

  /// No description provided for @settingsAwayModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Decline new messages temporarily'**
  String get settingsAwayModeSubtitle;

  /// No description provided for @settingsChatSchedule.
  ///
  /// In en, this message translates to:
  /// **'Chat schedule'**
  String get settingsChatSchedule;

  /// No description provided for @settingsChatScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set available hours'**
  String get settingsChatScheduleSubtitle;

  /// No description provided for @settingsShareLocation.
  ///
  /// In en, this message translates to:
  /// **'Share location'**
  String get settingsShareLocation;

  /// No description provided for @settingsShareLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used for Near Me and reminders'**
  String get settingsShareLocationSubtitle;

  /// No description provided for @settingsWhoCanFindMe.
  ///
  /// In en, this message translates to:
  /// **'Who can find me'**
  String get settingsWhoCanFindMe;

  /// No description provided for @settingsEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get settingsEveryone;

  /// No description provided for @settingsAiRecommendations.
  ///
  /// In en, this message translates to:
  /// **'AI recommendations'**
  String get settingsAiRecommendations;

  /// No description provided for @settingsAiRecommendationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalize your feed with Gemini'**
  String get settingsAiRecommendationsSubtitle;

  /// No description provided for @settingsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferences;

  /// No description provided for @settingsPreferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Place types, mood, budget'**
  String get settingsPreferencesSubtitle;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notificationsToday;

  /// No description provided for @notificationsEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notificationsEarlier;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'New notifications will appear here.'**
  String get notificationsEmptyBody;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPasswordHelper.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get authPasswordHelper;

  /// No description provided for @authName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authName;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authHaveAccount;

  /// No description provided for @authSignInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignInLink;

  /// No description provided for @authSignUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUpLink;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome\nback.'**
  String get authWelcomeBack;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to discover your next local gem.'**
  String get authWelcomeSubtitle;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create\naccount.'**
  String get authCreateAccount;

  /// No description provided for @authCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join a community of locals sharing hidden gems.'**
  String get authCreateSubtitle;

  /// No description provided for @authCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccountButton;

  /// No description provided for @authSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignInButton;

  /// No description provided for @authEnterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email and password.'**
  String get authEnterEmailPassword;

  /// No description provided for @authEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get authEnterName;

  /// No description provided for @authEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email.'**
  String get authEnterEmail;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get authPasswordMinLength;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authResetPasswordTitle;

  /// No description provided for @authResetSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get authResetSend;

  /// No description provided for @authResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent.'**
  String get authResetSent;

  /// No description provided for @authErrorInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get authErrorInvalidCredential;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please try again.'**
  String get authErrorNoInternet;

  /// No description provided for @authErrorSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed. Please try again.'**
  String get authErrorSignInFailed;

  /// No description provided for @onboardingGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hey {name} 👋'**
  String onboardingGreeting(String name);

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you love — we\'ll personalise your feed.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingPlaceTypes.
  ///
  /// In en, this message translates to:
  /// **'What kind of places?'**
  String get onboardingPlaceTypes;

  /// No description provided for @onboardingVibe.
  ///
  /// In en, this message translates to:
  /// **'What\'s your vibe?'**
  String get onboardingVibe;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start exploring'**
  String get onboardingStart;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingSkip;

  /// No description provided for @onboardingDefaultName.
  ///
  /// In en, this message translates to:
  /// **'there'**
  String get onboardingDefaultName;

  /// No description provided for @placeTypeRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get placeTypeRestaurants;

  /// No description provided for @placeTypeCafes.
  ///
  /// In en, this message translates to:
  /// **'Cafés'**
  String get placeTypeCafes;

  /// No description provided for @placeTypeBars.
  ///
  /// In en, this message translates to:
  /// **'Bars'**
  String get placeTypeBars;

  /// No description provided for @placeTypeViewpoints.
  ///
  /// In en, this message translates to:
  /// **'Viewpoints'**
  String get placeTypeViewpoints;

  /// No description provided for @placeTypeMarkets.
  ///
  /// In en, this message translates to:
  /// **'Markets'**
  String get placeTypeMarkets;

  /// No description provided for @placeTypeMuseums.
  ///
  /// In en, this message translates to:
  /// **'Museums'**
  String get placeTypeMuseums;

  /// No description provided for @placeTypeParks.
  ///
  /// In en, this message translates to:
  /// **'Parks'**
  String get placeTypeParks;

  /// No description provided for @placeTypeHiddenGems.
  ///
  /// In en, this message translates to:
  /// **'Hidden Gems'**
  String get placeTypeHiddenGems;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @errorGenericBody.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errorGenericBody;

  /// No description provided for @errorRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get errorRetry;

  /// No description provided for @errorNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNoConnection;

  /// No description provided for @errorNoConnectionBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get errorNoConnectionBody;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get offlineBanner;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// No description provided for @buttonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get buttonNext;

  /// No description provided for @buttonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get buttonDone;

  /// Button label for signing in with Google
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get authSignInWithGoogle;

  /// Button label for signing up with Google
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get authSignUpWithGoogle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
