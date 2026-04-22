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

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

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
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
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

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

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
