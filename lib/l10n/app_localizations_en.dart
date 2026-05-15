// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LikeALocal';

  @override
  String get tabDiscover => 'Discover';

  @override
  String get tabSearch => 'Search';

  @override
  String get tabSaved => 'Saved';

  @override
  String get tabInbox => 'Inbox';

  @override
  String get tabProfile => 'Profile';

  @override
  String get discoverTitle => 'Discover';

  @override
  String get discoverNearYou => 'Near You';

  @override
  String get discoverFeatured => 'Featured';

  @override
  String get discoverTrending => 'Trending Now';

  @override
  String get discoverLocalOfWeek => 'Local of the Week';

  @override
  String get discoverLocalOfWeekBadge => 'LOCAL OF THE WEEK';

  @override
  String get discoverViewProfile => 'View Profile';

  @override
  String get discoverSeeAll => 'See all';

  @override
  String get discoverSearchHint => 'Search restaurants, places…';

  @override
  String get discoverCustomDistance => 'Custom distance';

  @override
  String discoverCustomDistanceFilter(String distance) {
    return 'Custom $distance';
  }

  @override
  String get discoverDistanceKm => 'Distance in km';

  @override
  String get discoverNoNearbyPlaces => 'No nearby places';

  @override
  String get discoverNoNearbyPlacesBody => 'Try a wider distance filter.';

  @override
  String get discoverRefreshLocation => 'Refresh location';

  @override
  String get superUsersDiscoverTitle => 'Top Super Locals';

  @override
  String get superUsersDiscoverBody =>
      'See contributors whose places, chats and reviews rank highest.';

  @override
  String get superUsersTitle => 'Super Users';

  @override
  String get superUsersBadge => 'Super Local';

  @override
  String get superUsersScore => 'Score';

  @override
  String superUsersStats(int places, int chats, int reviews) {
    return '$places places · $chats chats · $reviews reviews';
  }

  @override
  String get superUsersEmpty => 'No Super Users yet';

  @override
  String get superUsersEmptyBody =>
      'Contributors appear here after their score reaches the badge threshold.';

  @override
  String get superUsersError => 'Couldn\'t load Super Users';

  @override
  String get publicProfileTitle => 'Contributor';

  @override
  String get publicProfileNotFound => 'Contributor not found';

  @override
  String get publicProfileNotFoundBody =>
      'This profile may no longer be available.';

  @override
  String get publicProfilePlaces => 'Places';

  @override
  String get publicProfileNoPlaces => 'No public places yet';

  @override
  String get publicProfileChats => 'Chats';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryRestaurant => 'Restaurant';

  @override
  String get categoryCafe => 'Café';

  @override
  String get categoryBar => 'Bar';

  @override
  String get categoryViewpoint => 'Viewpoint';

  @override
  String get categoryMarket => 'Market';

  @override
  String get categoryMuseum => 'Museum';

  @override
  String get categoryPark => 'Park';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search places, neighborhoods…';

  @override
  String get searchRecent => 'Recent';

  @override
  String get searchMoods => 'Explore by Mood';

  @override
  String get searchNoResults => 'No places found';

  @override
  String get searchNoResultsBody =>
      'Try different keywords or remove some filters.';

  @override
  String get moodRomantic => 'Romantic';

  @override
  String get moodFamily => 'Family';

  @override
  String get moodHiddenGem => 'Hidden Gem';

  @override
  String get moodLively => 'Lively';

  @override
  String get moodPeaceful => 'Peaceful';

  @override
  String get moodFoodie => 'Foodie';

  @override
  String get moodOffBeaten => 'Off-the-beaten-track';

  @override
  String get savedTitle => 'Saved';

  @override
  String get savedCollections => 'Collections';

  @override
  String get savedAllPlaces => 'All Places';

  @override
  String get savedReminders => 'Reminders';

  @override
  String get savedEmpty => 'Nothing saved yet';

  @override
  String get savedEmptyBody => 'Save places you love to find them later.';

  @override
  String get savedUnlockCollections => 'Unlock unlimited collections';

  @override
  String get savedFreePlan => 'Free plan: up to 10 saved places.';

  @override
  String get savedFreePlanCollections => 'Free plan: up to 3 collections.';

  @override
  String get savedUpgrade => 'Upgrade';

  @override
  String get savedNoCollections => 'No collections yet';

  @override
  String get savedNoCollectionsBody =>
      'Group your saved places into collections.';

  @override
  String get savedCreateCollection => 'Create collection';

  @override
  String get savedNewCollection => 'New collection';

  @override
  String get savedCollectionName => 'Collection name';

  @override
  String get savedCreate => 'Create';

  @override
  String savedPlacesCount(int count) {
    return '$count places';
  }

  @override
  String get savedNoReminders => 'No reminders set';

  @override
  String get savedNoRemindersBody =>
      'Set location reminders on any saved place.';

  @override
  String get reminderSet => 'Reminder set';

  @override
  String get reminderFreeLimitTitle => 'Reminder limit reached';

  @override
  String get reminderFreeLimitBody =>
      'Free plan includes up to 3 location reminders. Upgrade to Premium for unlimited reminders.';

  @override
  String reminderRemovedFor(String place) {
    return 'Reminder removed for $place';
  }

  @override
  String reminderNearPlace(String place) {
    return 'We\'ll remind you near $place';
  }

  @override
  String get pinFreeLimitTitle => 'Saved places limit reached';

  @override
  String get pinFreeLimitBody =>
      'Free plan includes up to 10 saved places. Upgrade to Premium for unlimited saves.';

  @override
  String get collectionFreeLimitTitle => 'Collections limit reached';

  @override
  String get collectionFreeLimitBody =>
      'Free plan includes up to 3 collections. Upgrade to Premium for unlimited collections.';

  @override
  String get inboxTitle => 'Inbox';

  @override
  String get inboxEmpty => 'No messages yet';

  @override
  String get inboxEmptyBody => 'Start a conversation with a local contributor.';

  @override
  String get chatLocalBadge => 'LOCAL';

  @override
  String get chatMessageHint => 'Message…';

  @override
  String get chatSuperLocal => 'Super Local';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileContributions => 'Contributions';

  @override
  String get profileSavedPlaces => 'Saved Places';

  @override
  String get profileYourName => 'Your Name';

  @override
  String get profileLocation => 'Lisbon, Portugal';

  @override
  String get profileStatPlaces => 'Places';

  @override
  String get profileStatSaved => 'Saved';

  @override
  String get profileStatHelpful => 'Helpful';

  @override
  String get profileVerified => 'Verified Member';

  @override
  String get profileVerifiedBody => 'Share 5 places to become a Super Local';

  @override
  String get profileMyPlaces => 'My Places';

  @override
  String get profileNoPlaces => 'No places shared yet';

  @override
  String get profileTestPay => 'Test Pay (debug)';

  @override
  String get placeDetails => 'Details';

  @override
  String get placeTips => 'Local Tips';

  @override
  String get placeDishes => 'Must-Try Dishes';

  @override
  String get placeReviews => 'Reviews';

  @override
  String placeReviewsCount(int count) {
    return '($count reviews)';
  }

  @override
  String get placeRemindMe => 'Remind me near';

  @override
  String get placeSave => 'Save place';

  @override
  String get placeSaved => 'Saved';

  @override
  String get placeChatContributor => 'Chat with contributor';

  @override
  String get placeNotFound => 'Place not found';

  @override
  String get placeNotFoundBody =>
      'This place may have been removed or is no longer available.';

  @override
  String get placeGoBack => 'Go back';

  @override
  String get placeAnonymous => 'Anonymous';

  @override
  String get placeContributor => 'Contributor';

  @override
  String get placeSuperLocal => 'Super Local';

  @override
  String get placeChat => 'Chat';

  @override
  String get placeNoReviews => 'No reviews yet';

  @override
  String get placeNoReviewsBody => 'Be the first to share your experience.';

  @override
  String get placeWriteReview => 'Write a review';

  @override
  String get placeEditReview => 'Edit your review';

  @override
  String get placeDeleteReview => 'Delete review';

  @override
  String get reviewComposerTitle => 'Share your experience';

  @override
  String get reviewComposerBody => 'Help travelers find great spots.';

  @override
  String get reviewComposerHint => 'What did you love? Any tips?';

  @override
  String get reviewComposerSubmit => 'Post review';

  @override
  String get reviewComposerUpdate => 'Update review';

  @override
  String get mapTitle => 'Map';

  @override
  String get mapNearMe => 'Near Me';

  @override
  String get mapLocating => 'Locating…';

  @override
  String get mapSearchOnMap => 'Search on map…';

  @override
  String get mapDirections => 'Directions';

  @override
  String get mapNoLocation => 'Location access needed';

  @override
  String get mapNoLocationBody => 'Enable location to see places near you.';

  @override
  String get mapEnableLocationServices =>
      'Enable location services to center the map near you.';

  @override
  String get mapLocationDenied =>
      'Location permission denied. The map will stay interactive.';

  @override
  String get mapCannotFetchLocation =>
      'Unable to fetch your current location right now.';

  @override
  String get mapCannotOpenMaps => 'Unable to open Google Maps right now.';

  @override
  String mapPickCount(int count) {
    return '$count picks';
  }

  @override
  String get addPlaceTitle => 'Add Place';

  @override
  String get addPlacePhotos => 'Photos';

  @override
  String get addPlaceBasics => 'Basics';

  @override
  String get addPlaceTips => 'Tips & Dishes';

  @override
  String get addPlacePreview => 'Preview';

  @override
  String get addPlacePublish => 'Publish Place';

  @override
  String addPlaceNext(String step) {
    return 'Next: $step';
  }

  @override
  String get addPlacePhotosTitle => 'Add photos';

  @override
  String get addPlacePhotosHint => 'At least 1 photo required.';

  @override
  String get addPlaceDetailsTitle => 'Place details';

  @override
  String get addPlaceName => 'Place name';

  @override
  String get addPlaceNeighborhood => 'Neighborhood';

  @override
  String get addPlaceDescription => 'Description';

  @override
  String get addPlaceCategory => 'Category';

  @override
  String get addPlaceTipsSubtitle => 'Add up to 5 local tips.';

  @override
  String get addPlaceTipLabel => 'Tip 1';

  @override
  String get addPlaceTipHint => 'What should visitors know?';

  @override
  String get addPlaceAddTip => 'Add another tip';

  @override
  String get addPlaceDishName => 'Dish name';

  @override
  String get addPlaceAddDish => 'Add a dish';

  @override
  String get addPlaceReadyTitle => 'Ready to publish?';

  @override
  String get addPlaceReadyBody =>
      'Your place will be visible to everyone once published.';

  @override
  String get aiTitle => 'Local AI';

  @override
  String get aiPlaceholder => 'Ask about the best places…';

  @override
  String get aiPoweredBy => 'Powered by Gemini';

  @override
  String get aiGreeting =>
      'Hi! I\'m your Local AI. I know the city\'s hidden gems inside out. What are you looking for today?';

  @override
  String get aiSuggestion1 => 'Where to eat solo tonight?';

  @override
  String get aiSuggestion2 => 'Best Sunday brunch spots';

  @override
  String get aiSuggestion3 => 'Hidden bars in the old town';

  @override
  String get aiSuggestion4 => 'Viewpoints without the crowds';

  @override
  String get aiFallbackReply =>
      'Great question! Based on your preferences, I can suggest a few hidden gems locals love. Would you like me to narrow down by cuisine or atmosphere?';

  @override
  String get smartSuggestionsTitle => 'Smart suggestions for you';

  @override
  String get smartSuggestionsSubtitle => 'Picks tailored to your taste';

  @override
  String get smartRecsTitle => 'For you';

  @override
  String get smartRecsRanked => 'Ranked for your style';

  @override
  String get smartRecsEmptyPrefs => 'Set your preferences';

  @override
  String get smartRecsEmptyPrefsBody =>
      'Tell us what you like and we\'ll personalize your picks.';

  @override
  String get smartRecsSetPreferences => 'Open settings';

  @override
  String get smartRecsError => 'Couldn\'t load recommendations';

  @override
  String get smartPickHeading => 'AI\'s pick for you';

  @override
  String get smartPickBadge => 'AI PICK';

  @override
  String get smartPickPremiumLocked =>
      'Upgrade to Premium to get one personalized AI pick with a short reason.';

  @override
  String get smartPickError => 'AI is unavailable right now.';

  @override
  String get settingsPrefPlaceTypes => 'Place types';

  @override
  String get settingsPrefMoods => 'Atmosphere';

  @override
  String get settingsPrefBudget => 'Budget';

  @override
  String get settingsPrefNotSet => 'Not set';

  @override
  String get settingsPrefClear => 'Clear';

  @override
  String get budgetLow => 'Budget-friendly';

  @override
  String get budgetMid => 'Mid-range';

  @override
  String get budgetHigh => 'Splurge';

  @override
  String get premiumTitle => 'Go Premium';

  @override
  String get premiumSubtitle => 'Unlock the full\nlocal experience.';

  @override
  String get premiumBadge => 'PREMIUM';

  @override
  String get premiumHeadlinePrefix => 'Unlock the full\n';

  @override
  String get premiumHeadlineAccent => 'local';

  @override
  String get premiumHeadlineSuffix => ' experience.';

  @override
  String get premiumMonthly => 'Monthly';

  @override
  String get premiumYearly => 'Yearly';

  @override
  String get premiumMonthlyPrice => '€4.99 / month';

  @override
  String get premiumYearlyPrice => '€2.99 / month';

  @override
  String get premiumPriceMonthly => '€4.99';

  @override
  String get premiumPriceYearly => '€2.99';

  @override
  String get premiumPeriod => '/ month';

  @override
  String get premiumYearlyBadge => 'Save 40%';

  @override
  String get premiumCta => 'Start Premium';

  @override
  String get premiumRestorePurchases => 'Restore purchases';

  @override
  String get premiumCancelAnnually => 'Cancel anytime. Billed annually.';

  @override
  String get premiumCancelMonthly => 'Cancel anytime. Billed monthly.';

  @override
  String get premiumFeatureUnlimitedSaves =>
      'Unlimited saved places (free: 10)';

  @override
  String get premiumFeatureUnlimitedCollections =>
      'Unlimited collections (free: 3)';

  @override
  String get premiumFeatureAiChat => 'Local AI chat assistant';

  @override
  String get premiumFeatureOfflineMaps => 'Offline neighborhood maps';

  @override
  String get premiumFeatureReminders =>
      'Unlimited location reminders (free: 3)';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsPersonalization => 'Personalization';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsEnglish => 'English';

  @override
  String get settingsGerman => 'German';

  @override
  String get settingsGermanNative => 'Deutsch';

  @override
  String get settingsEnableChat => 'Enable chat';

  @override
  String get settingsEnableChatSubtitle => 'Allow contributors to message you';

  @override
  String get settingsAwayMode => 'Away mode';

  @override
  String get settingsAwayModeSubtitle => 'Decline new messages temporarily';

  @override
  String get settingsChatSchedule => 'Chat schedule';

  @override
  String get settingsChatScheduleSubtitle => 'Set available hours';

  @override
  String get settingsShareLocation => 'Share location';

  @override
  String get settingsShareLocationSubtitle => 'Used for Near Me and reminders';

  @override
  String get settingsWhoCanFindMe => 'Who can find me';

  @override
  String get settingsEveryone => 'Everyone';

  @override
  String get settingsAiRecommendations => 'AI recommendations';

  @override
  String get settingsAiRecommendationsSubtitle =>
      'Personalize your feed with Gemini';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsPreferencesSubtitle => 'Place types, mood, budget';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsToday => 'Today';

  @override
  String get notificationsEarlier => 'Earlier';

  @override
  String get notificationsEmpty => 'You\'re all caught up';

  @override
  String get notificationsEmptyBody => 'New notifications will appear here.';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordHelper => 'At least 6 characters';

  @override
  String get authName => 'Full Name';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNoAccount => 'Don\'t have an account? ';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get authSignInLink => 'Sign in';

  @override
  String get authSignUpLink => 'Sign up';

  @override
  String get authWelcomeBack => 'Welcome\nback.';

  @override
  String get authWelcomeSubtitle => 'Sign in to discover your next local gem.';

  @override
  String get authCreateAccount => 'Create\naccount.';

  @override
  String get authCreateSubtitle =>
      'Join a community of locals sharing hidden gems.';

  @override
  String get authCreateAccountButton => 'Create account';

  @override
  String get authSignInButton => 'Sign in';

  @override
  String get authEnterEmailPassword => 'Please enter your email and password.';

  @override
  String get authEnterName => 'Please enter your name.';

  @override
  String get authEnterEmail => 'Please enter your email.';

  @override
  String get authPasswordMinLength => 'Password must be at least 6 characters.';

  @override
  String get authResetPasswordTitle => 'Reset password';

  @override
  String get authResetSend => 'Send';

  @override
  String get authResetSent => 'Password reset email sent.';

  @override
  String get authErrorInvalidCredential => 'Email or password is incorrect.';

  @override
  String get authErrorEmailInUse => 'This email is already registered.';

  @override
  String get authErrorWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get authErrorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get authErrorNoInternet => 'No internet connection. Please try again.';

  @override
  String get authErrorSignInFailed => 'Sign in failed. Please try again.';

  @override
  String onboardingGreeting(String name) {
    return 'Hey $name 👋';
  }

  @override
  String get onboardingSubtitle =>
      'Tell us what you love — we\'ll personalise your feed.';

  @override
  String get onboardingPlaceTypes => 'What kind of places?';

  @override
  String get onboardingVibe => 'What\'s your vibe?';

  @override
  String get onboardingStart => 'Start exploring';

  @override
  String get onboardingSkip => 'Skip for now';

  @override
  String get onboardingDefaultName => 'there';

  @override
  String get placeTypeRestaurants => 'Restaurants';

  @override
  String get placeTypeCafes => 'Cafés';

  @override
  String get placeTypeBars => 'Bars';

  @override
  String get placeTypeViewpoints => 'Viewpoints';

  @override
  String get placeTypeMarkets => 'Markets';

  @override
  String get placeTypeMuseums => 'Museums';

  @override
  String get placeTypeParks => 'Parks';

  @override
  String get placeTypeHiddenGems => 'Hidden Gems';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get errorGenericBody => 'Something went wrong.';

  @override
  String get errorRetry => 'Try again';

  @override
  String get errorNoConnection => 'No internet';

  @override
  String get errorNoConnectionBody => 'Check your connection and try again.';

  @override
  String get offlineBanner => 'No internet';

  @override
  String get offlineBackOnline => 'Back online';

  @override
  String get offlineActionUnavailable => 'This action cannot be done offline.';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonNext => 'Next';

  @override
  String get buttonDone => 'Done';

  @override
  String get dayMonday => 'Monday';

  @override
  String get dayTuesday => 'Tuesday';

  @override
  String get dayWednesday => 'Wednesday';

  @override
  String get dayThursday => 'Thursday';

  @override
  String get dayFriday => 'Friday';

  @override
  String get daySaturday => 'Saturday';

  @override
  String get daySunday => 'Sunday';

  @override
  String get chatScheduleTitle => 'Chat Schedule';

  @override
  String get chatScheduleEnforce => 'Enforce schedule';

  @override
  String get chatScheduleEnforceSubtitle =>
      'Only accept messages during set hours';

  @override
  String get chatScheduleFrom => 'From';

  @override
  String get chatScheduleTo => 'To';

  @override
  String get chatScheduleSaved => 'Schedule saved';

  @override
  String get chatOwnerDisabled => 'This owner has disabled chat';

  @override
  String get chatOwnerAway => 'This owner is in away mode';

  @override
  String get chatOwnerUnavailable => 'Owner is unavailable during these hours';

  @override
  String get authSignInWithGoogle => 'Sign in with Google';

  @override
  String get authSignUpWithGoogle => 'Sign up with Google';
}
