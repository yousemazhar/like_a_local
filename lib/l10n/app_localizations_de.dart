// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'LikeALocal';

  @override
  String get tabDiscover => 'Entdecken';

  @override
  String get tabSearch => 'Suche';

  @override
  String get tabSaved => 'Gespeichert';

  @override
  String get tabInbox => 'Nachrichten';

  @override
  String get tabProfile => 'Profil';

  @override
  String get discoverTitle => 'Entdecken';

  @override
  String get discoverNearYou => 'In deiner Nähe';

  @override
  String get discoverFeatured => 'Empfohlen';

  @override
  String get discoverTrending => 'Gerade angesagt';

  @override
  String get discoverLocalOfWeek => 'Local der Woche';

  @override
  String get discoverLocalOfWeekBadge => 'LOCAL DER WOCHE';

  @override
  String get discoverViewProfile => 'Profil ansehen';

  @override
  String get discoverSeeAll => 'Alle ansehen';

  @override
  String get discoverSearchHint => 'Restaurants, Orte suchen…';

  @override
  String get discoverCustomDistance => 'Eigene Entfernung';

  @override
  String discoverCustomDistanceFilter(String distance) {
    return 'Eigene $distance';
  }

  @override
  String get discoverDistanceKm => 'Entfernung in km';

  @override
  String get discoverNoNearbyPlaces => 'Keine Orte in der Nähe';

  @override
  String get discoverNoNearbyPlacesBody =>
      'Versuche einen größeren Entfernungsfilter.';

  @override
  String get discoverRefreshLocation => 'Standort aktualisieren';

  @override
  String get superUsersDiscoverTitle => 'Top Super Locals';

  @override
  String get superUsersDiscoverBody =>
      'Sieh Beitragende, deren Orte, Chats und Bewertungen am höchsten ranken.';

  @override
  String get superUsersTitle => 'Super Users';

  @override
  String get superUsersBadge => 'Super Local';

  @override
  String get superUsersScore => 'Score';

  @override
  String superUsersStats(int places, int chats, int reviews) {
    return '$places Orte · $chats Chats · $reviews Bewertungen';
  }

  @override
  String superUsersStatsNoChats(int places, int reviews) {
    return '$places Orte · $reviews Bewertungen';
  }

  @override
  String get superUsersRecalculateScores => 'Super-User-Scores neu berechnen';

  @override
  String superUsersRecalculatedScores(int count) {
    return 'Scores für $count Nutzer neu berechnet';
  }

  @override
  String get superUsersEmpty => 'Noch keine Super Users';

  @override
  String get superUsersEmptyBody =>
      'Beitragende erscheinen hier, sobald ihr Score den Badge-Schwellenwert erreicht.';

  @override
  String get superUsersError => 'Super Users konnten nicht geladen werden';

  @override
  String get publicProfileTitle => 'Beitragender';

  @override
  String get publicProfileNotFound => 'Beitragender nicht gefunden';

  @override
  String get publicProfileNotFoundBody =>
      'Dieses Profil ist möglicherweise nicht mehr verfügbar.';

  @override
  String get publicProfilePlaces => 'Orte';

  @override
  String get publicProfileNoPlaces => 'Noch keine öffentlichen Orte';

  @override
  String get publicProfileChats => 'Chats';

  @override
  String get categoryAll => 'Alle';

  @override
  String get categoryRestaurant => 'Restaurant';

  @override
  String get categoryCafe => 'Café';

  @override
  String get categoryBar => 'Bar';

  @override
  String get categoryViewpoint => 'Aussichtspunkt';

  @override
  String get categoryMarket => 'Markt';

  @override
  String get categoryMuseum => 'Museum';

  @override
  String get categoryPark => 'Park';

  @override
  String get searchTitle => 'Suche';

  @override
  String get searchHint => 'Orte, Stadtviertel suchen…';

  @override
  String get searchRecent => 'Zuletzt';

  @override
  String get searchMoods => 'Nach Stimmung entdecken';

  @override
  String get searchNoResults => 'Keine Orte gefunden';

  @override
  String get searchNoResultsBody =>
      'Versuch andere Suchbegriffe oder entferne Filter.';

  @override
  String get moodRomantic => 'Romantisch';

  @override
  String get moodFamily => 'Familie';

  @override
  String get moodHiddenGem => 'Geheimtipp';

  @override
  String get moodLively => 'Lebendig';

  @override
  String get moodPeaceful => 'Ruhig';

  @override
  String get moodFoodie => 'Foodie';

  @override
  String get moodOffBeaten => 'Abseits der Touristenpfade';

  @override
  String get savedTitle => 'Gespeichert';

  @override
  String get savedCollections => 'Sammlungen';

  @override
  String get savedAllPlaces => 'Alle Orte';

  @override
  String get savedReminders => 'Erinnerungen';

  @override
  String get savedEmpty => 'Noch nichts gespeichert';

  @override
  String get savedEmptyBody =>
      'Speichere Orte, die du liebst, um sie später wiederzufinden.';

  @override
  String get savedUnlockCollections => 'Unbegrenzte Sammlungen freischalten';

  @override
  String get savedFreePlan => 'Gratis-Plan: bis zu 10 gespeicherte Orte.';

  @override
  String get savedFreePlanCollections => 'Gratis-Plan: bis zu 3 Sammlungen.';

  @override
  String get savedUpgrade => 'Upgraden';

  @override
  String get savedNoCollections => 'Noch keine Sammlungen';

  @override
  String get savedNoCollectionsBody =>
      'Ordne deine gespeicherten Orte in Sammlungen.';

  @override
  String get savedCreateCollection => 'Sammlung erstellen';

  @override
  String get savedNewCollection => 'Neue Sammlung';

  @override
  String get savedCollectionName => 'Name der Sammlung';

  @override
  String get savedCreate => 'Erstellen';

  @override
  String savedPlacesCount(int count) {
    return '$count Orte';
  }

  @override
  String get savedNoReminders => 'Keine Erinnerungen';

  @override
  String get savedNoRemindersBody =>
      'Setze Orts-Erinnerungen für gespeicherte Orte.';

  @override
  String get reminderSet => 'Erinnerung gesetzt';

  @override
  String get reminderFreeLimitTitle => 'Erinnerungslimit erreicht';

  @override
  String get reminderFreeLimitBody =>
      'Der Gratis-Plan umfasst bis zu 3 Orts-Erinnerungen. Upgrade auf Premium für unbegrenzte Erinnerungen.';

  @override
  String reminderRemovedFor(String place) {
    return 'Erinnerung für $place entfernt';
  }

  @override
  String reminderNearPlace(String place) {
    return 'Wir erinnern dich in der Nähe von $place';
  }

  @override
  String get pinFreeLimitTitle => 'Limit für gespeicherte Orte erreicht';

  @override
  String get pinFreeLimitBody =>
      'Der Gratis-Plan umfasst bis zu 10 gespeicherte Orte. Upgrade auf Premium für unbegrenzte Speicherungen.';

  @override
  String get collectionFreeLimitTitle => 'Sammlungslimit erreicht';

  @override
  String get collectionFreeLimitBody =>
      'Der Gratis-Plan umfasst bis zu 3 Sammlungen. Upgrade auf Premium für unbegrenzte Sammlungen.';

  @override
  String get inboxTitle => 'Nachrichten';

  @override
  String get inboxEmpty => 'Noch keine Nachrichten';

  @override
  String get inboxEmptyBody =>
      'Starte ein Gespräch mit einem lokalen Beitragenden.';

  @override
  String get chatLocalBadge => 'LOCAL';

  @override
  String get chatMessageHint => 'Nachricht…';

  @override
  String get chatSuperLocal => 'Super Local';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileSettings => 'Einstellungen';

  @override
  String get profileContributions => 'Beiträge';

  @override
  String get profileSavedPlaces => 'Gespeicherte Orte';

  @override
  String get profileYourName => 'Dein Name';

  @override
  String get profileLocation => 'Lissabon, Portugal';

  @override
  String get profileStatPlaces => 'Orte';

  @override
  String get profileStatSaved => 'Gespeichert';

  @override
  String get profileStatHelpful => 'Hilfreich';

  @override
  String get profileVerified => 'Verifiziertes Mitglied';

  @override
  String get profileVerifiedBody => 'Teile 5 Orte, um Super Local zu werden';

  @override
  String get profileMyPlaces => 'Meine Orte';

  @override
  String get profileNoPlaces => 'Noch keine Orte geteilt';

  @override
  String get profileTestPay => 'Test-Zahlung (Debug)';

  @override
  String get placeDetails => 'Details';

  @override
  String get placeTips => 'Lokale Tipps';

  @override
  String get placeDishes => 'Must-Try-Gerichte';

  @override
  String get placeReviews => 'Bewertungen';

  @override
  String placeReviewsCount(int count) {
    return '($count Bewertungen)';
  }

  @override
  String get placeRemindMe => 'Erinnere mich';

  @override
  String get placeSave => 'Ort speichern';

  @override
  String get placeSaved => 'Gespeichert';

  @override
  String get placeChatContributor => 'Mit Beitragendem chatten';

  @override
  String get placeNotFound => 'Ort nicht gefunden';

  @override
  String get placeNotFoundBody =>
      'Dieser Ort wurde möglicherweise entfernt oder ist nicht mehr verfügbar.';

  @override
  String get placeGoBack => 'Zurück';

  @override
  String get placeAnonymous => 'Anonym';

  @override
  String get placeContributor => 'Beitragender';

  @override
  String get placeSuperLocal => 'Super Local';

  @override
  String get placeChat => 'Chat';

  @override
  String get placeNoReviews => 'Noch keine Bewertungen';

  @override
  String get placeNoReviewsBody => 'Sei der oder die Erste, die hier teilt.';

  @override
  String get placeWriteReview => 'Bewertung schreiben';

  @override
  String get placeEditReview => 'Bewertung bearbeiten';

  @override
  String get placeDeleteReview => 'Bewertung löschen';

  @override
  String get reviewComposerTitle => 'Teile deine Erfahrung';

  @override
  String get reviewComposerBody => 'Hilf Reisenden, gute Orte zu finden.';

  @override
  String get reviewComposerHint => 'Was hat dir gefallen? Tipps?';

  @override
  String get reviewComposerSubmit => 'Bewertung posten';

  @override
  String get reviewComposerUpdate => 'Bewertung aktualisieren';

  @override
  String get mapTitle => 'Karte';

  @override
  String get mapNearMe => 'In meiner Nähe';

  @override
  String get mapLocating => 'Suche…';

  @override
  String get mapSearchOnMap => 'Auf Karte suchen…';

  @override
  String get mapDirections => 'Route';

  @override
  String get mapNoLocation => 'Standortzugriff erforderlich';

  @override
  String get mapNoLocationBody =>
      'Aktiviere den Standort, um Orte in der Nähe zu sehen.';

  @override
  String get mapEnableLocationServices =>
      'Aktiviere Standortdienste, um die Karte auf dich zu zentrieren.';

  @override
  String get mapLocationDenied =>
      'Standortzugriff verweigert. Die Karte bleibt interaktiv.';

  @override
  String get mapCannotFetchLocation =>
      'Dein aktueller Standort kann gerade nicht ermittelt werden.';

  @override
  String get mapCannotOpenMaps =>
      'Google Maps kann gerade nicht geöffnet werden.';

  @override
  String mapPickCount(int count) {
    return '$count Tipps';
  }

  @override
  String get addPlaceTitle => 'Ort hinzufügen';

  @override
  String get addPlacePhotos => 'Fotos';

  @override
  String get addPlaceBasics => 'Basis';

  @override
  String get addPlaceTips => 'Tipps & Gerichte';

  @override
  String get addPlacePreview => 'Vorschau';

  @override
  String get addPlacePublish => 'Ort veröffentlichen';

  @override
  String addPlaceNext(String step) {
    return 'Weiter: $step';
  }

  @override
  String get addPlacePhotosTitle => 'Fotos & Videos hinzufügen';

  @override
  String get addPlacePhotosHint => 'Mindestens 1 Foto oder Video erforderlich.';

  @override
  String get addPlaceAddMedia => 'Medien hinzufügen';

  @override
  String get addPlacePickPhoto => 'Foto aus Galerie';

  @override
  String get addPlacePickVideo => 'Video aus Galerie';

  @override
  String get addPlaceDetailsTitle => 'Details zum Ort';

  @override
  String get addPlaceName => 'Name des Orts';

  @override
  String get addPlaceNeighborhood => 'Stadtviertel';

  @override
  String get addPlaceDescription => 'Beschreibung';

  @override
  String get addPlaceCategory => 'Kategorie';

  @override
  String get addPlaceTipsSubtitle => 'Füge bis zu 5 lokale Tipps hinzu.';

  @override
  String get addPlaceTipLabel => 'Tipp 1';

  @override
  String get addPlaceTipHint => 'Was sollten Besucher wissen?';

  @override
  String get addPlaceAddTip => 'Weiteren Tipp hinzufügen';

  @override
  String get addPlaceDishName => 'Gerichtsname';

  @override
  String get addPlaceAddDish => 'Gericht hinzufügen';

  @override
  String get placeAbout => 'Über';

  @override
  String get placeMoodsTitle => 'Stimmung';

  @override
  String get placePriceLevel => 'Preisniveau';

  @override
  String get addPlaceMoods => 'Stimmungen';

  @override
  String get addPlaceBudget => 'Budget';

  @override
  String get addPlaceMoodsHint => 'Wähle alle passenden aus';

  @override
  String get addPlaceReadyTitle => 'Bereit zu veröffentlichen?';

  @override
  String get addPlaceReadyBody =>
      'Dein Ort ist nach dem Veröffentlichen für alle sichtbar.';

  @override
  String get aiTitle => 'Local AI';

  @override
  String get aiPlaceholder => 'Frag nach den besten Orten…';

  @override
  String get aiPoweredBy => 'Unterstützt von Gemini';

  @override
  String get aiGreeting =>
      'Hi! Ich bin deine Local AI. Ich kenne die Geheimtipps der Stadt. Wonach suchst du heute?';

  @override
  String get aiSuggestion1 => 'Wo heute Abend alleine essen?';

  @override
  String get aiSuggestion2 => 'Beste Sonntags-Brunch-Spots';

  @override
  String get aiSuggestion3 => 'Versteckte Bars in der Altstadt';

  @override
  String get aiSuggestion4 => 'Aussichtspunkte abseits der Massen';

  @override
  String get aiFallbackReply =>
      'Gute Frage! Basierend auf deinen Vorlieben kann ich ein paar Geheimtipps empfehlen, die Locals lieben. Soll ich nach Küche oder Atmosphäre filtern?';

  @override
  String get smartSuggestionsTitle => 'Smarte Vorschläge für dich';

  @override
  String get smartSuggestionsSubtitle => 'Auf deinen Geschmack zugeschnitten';

  @override
  String get smartRecsTitle => 'Für dich';

  @override
  String get smartRecsRanked => 'Nach deinem Stil sortiert';

  @override
  String get smartRecsEmptyPrefs => 'Vorlieben festlegen';

  @override
  String get smartRecsEmptyPrefsBody =>
      'Sag uns, was du magst – wir personalisieren deine Empfehlungen.';

  @override
  String get smartRecsSetPreferences => 'Einstellungen öffnen';

  @override
  String get smartRecsError => 'Empfehlungen konnten nicht geladen werden';

  @override
  String get smartPickHeading => 'KI-Tipp für dich';

  @override
  String get smartPickBadge => 'KI-TIPP';

  @override
  String get smartPickPremiumLocked =>
      'Upgrade auf Premium für einen personalisierten KI-Tipp mit kurzer Begründung.';

  @override
  String get smartPickError => 'KI ist gerade nicht verfügbar.';

  @override
  String get settingsPrefPlaceTypes => 'Orte';

  @override
  String get settingsPrefMoods => 'Atmosphäre';

  @override
  String get settingsPrefBudget => 'Budget';

  @override
  String get settingsPrefNotSet => 'Nicht festgelegt';

  @override
  String get settingsPrefClear => 'Zurücksetzen';

  @override
  String get budgetLow => 'Günstig';

  @override
  String get budgetMid => 'Mittel';

  @override
  String get budgetHigh => 'Premium';

  @override
  String get premiumTitle => 'Premium holen';

  @override
  String get premiumSubtitle => 'Erlebe die Stadt\nwie ein Local.';

  @override
  String get premiumBadge => 'PREMIUM';

  @override
  String get premiumHeadlinePrefix => 'Erlebe die Stadt\nwie ein ';

  @override
  String get premiumHeadlineAccent => 'Local';

  @override
  String get premiumHeadlineSuffix => '.';

  @override
  String get premiumMonthly => 'Monatlich';

  @override
  String get premiumYearly => 'Jährlich';

  @override
  String get premiumMonthlyPrice => '4,99 € / Monat';

  @override
  String get premiumYearlyPrice => '2,99 € / Monat';

  @override
  String get premiumPriceMonthly => '4,99 €';

  @override
  String get premiumPriceYearly => '2,99 €';

  @override
  String get premiumPeriod => '/ Monat';

  @override
  String get premiumYearlyBadge => '40% sparen';

  @override
  String get premiumCta => 'Premium starten';

  @override
  String get premiumRestorePurchases => 'Käufe wiederherstellen';

  @override
  String get premiumCancelAnnually =>
      'Jederzeit kündbar. Jährliche Abrechnung.';

  @override
  String get premiumCancelMonthly =>
      'Jederzeit kündbar. Monatliche Abrechnung.';

  @override
  String get premiumFeatureUnlimitedSaves =>
      'Unbegrenzt gespeicherte Orte (Gratis: 10)';

  @override
  String get premiumFeatureUnlimitedCollections =>
      'Unbegrenzte Sammlungen (Gratis: 3)';

  @override
  String get premiumFeatureAiChat => 'Local AI Chat-Assistent';

  @override
  String get premiumFeatureOfflineMaps => 'Offline-Karten für Stadtviertel';

  @override
  String get premiumFeatureReminders =>
      'Unbegrenzte Orts-Erinnerungen (Gratis: 3)';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsPrivacy => 'Privatsphäre';

  @override
  String get settingsPersonalization => 'Personalisierung';

  @override
  String get settingsAccount => 'Konto';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsEnglish => 'Englisch';

  @override
  String get settingsGerman => 'Deutsch';

  @override
  String get settingsGermanNative => 'Deutsch';

  @override
  String get settingsEnableChat => 'Chat aktivieren';

  @override
  String get settingsEnableChatSubtitle =>
      'Beitragende dürfen dir Nachrichten senden';

  @override
  String get settingsAwayMode => 'Abwesend-Modus';

  @override
  String get settingsAwayModeSubtitle =>
      'Neue Nachrichten vorübergehend ablehnen';

  @override
  String get settingsChatSchedule => 'Chat-Zeiten';

  @override
  String get settingsChatScheduleSubtitle => 'Verfügbare Zeiten festlegen';

  @override
  String get settingsShareLocation => 'Standort teilen';

  @override
  String get settingsShareLocationSubtitle =>
      'Für „In meiner Nähe“ und Erinnerungen';

  @override
  String get settingsWhoCanFindMe => 'Wer kann mich finden';

  @override
  String get settingsEveryone => 'Alle';

  @override
  String get settingsAiRecommendations => 'KI-Empfehlungen';

  @override
  String get settingsAiRecommendationsSubtitle =>
      'Personalisiere deinen Feed mit Gemini';

  @override
  String get settingsPreferences => 'Vorlieben';

  @override
  String get settingsPreferencesSubtitle => 'Orte, Stimmung, Budget';

  @override
  String get settingsSignOut => 'Abmelden';

  @override
  String get notificationsTitle => 'Benachrichtigungen';

  @override
  String get notificationsMarkAllRead => 'Alle gelesen';

  @override
  String get notificationsToday => 'Heute';

  @override
  String get notificationsEarlier => 'Früher';

  @override
  String get notificationsEmpty => 'Alles erledigt';

  @override
  String get notificationsEmptyBody =>
      'Neue Benachrichtigungen erscheinen hier.';

  @override
  String get authSignIn => 'Anmelden';

  @override
  String get authSignUp => 'Registrieren';

  @override
  String get authEmail => 'E-Mail';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authPasswordHelper => 'Mindestens 6 Zeichen';

  @override
  String get authName => 'Vollständiger Name';

  @override
  String get authForgotPassword => 'Passwort vergessen?';

  @override
  String get authNoAccount => 'Noch kein Konto? ';

  @override
  String get authHaveAccount => 'Bereits ein Konto? ';

  @override
  String get authSignInLink => 'Anmelden';

  @override
  String get authSignUpLink => 'Registrieren';

  @override
  String get authWelcomeBack => 'Willkommen\nzurück.';

  @override
  String get authWelcomeSubtitle =>
      'Melde dich an, um deinen nächsten Geheimtipp zu entdecken.';

  @override
  String get authCreateAccount => 'Konto\nerstellen.';

  @override
  String get authCreateSubtitle =>
      'Werde Teil einer Community, die Geheimtipps teilt.';

  @override
  String get authCreateAccountButton => 'Konto erstellen';

  @override
  String get authSignInButton => 'Anmelden';

  @override
  String get authEnterEmailPassword =>
      'Bitte gib deine E-Mail und dein Passwort ein.';

  @override
  String get authEnterName => 'Bitte gib deinen Namen ein.';

  @override
  String get authEnterEmail => 'Bitte gib deine E-Mail ein.';

  @override
  String get authPasswordMinLength =>
      'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get authResetPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get authResetSend => 'Senden';

  @override
  String get authResetSent => 'E-Mail zum Zurücksetzen des Passworts gesendet.';

  @override
  String get authErrorInvalidCredential => 'E-Mail oder Passwort ist falsch.';

  @override
  String get authErrorEmailInUse => 'Diese E-Mail ist bereits registriert.';

  @override
  String get authErrorWeakPassword =>
      'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get authErrorInvalidEmail =>
      'Bitte gib eine gültige E-Mail-Adresse ein.';

  @override
  String get authErrorNoInternet =>
      'Keine Internetverbindung. Bitte versuche es erneut.';

  @override
  String get authErrorSignInFailed =>
      'Anmeldung fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String onboardingGreeting(String name) {
    return 'Hey $name 👋';
  }

  @override
  String get onboardingSubtitle =>
      'Sag uns, was du magst — wir personalisieren deinen Feed.';

  @override
  String get onboardingPlaceTypes => 'Welche Art von Orten?';

  @override
  String get onboardingVibe => 'Was ist deine Stimmung?';

  @override
  String get onboardingStart => 'Losgehen';

  @override
  String get onboardingSkip => 'Vorerst überspringen';

  @override
  String get onboardingDefaultName => 'du';

  @override
  String get placeTypeRestaurants => 'Restaurants';

  @override
  String get placeTypeCafes => 'Cafés';

  @override
  String get placeTypeBars => 'Bars';

  @override
  String get placeTypeViewpoints => 'Aussichtspunkte';

  @override
  String get placeTypeMarkets => 'Märkte';

  @override
  String get placeTypeMuseums => 'Museen';

  @override
  String get placeTypeParks => 'Parks';

  @override
  String get placeTypeHiddenGems => 'Geheimtipps';

  @override
  String get errorGeneric => 'Etwas ist schiefgelaufen';

  @override
  String get errorGenericBody => 'Etwas ist schiefgelaufen.';

  @override
  String get errorRetry => 'Erneut versuchen';

  @override
  String get errorNoConnection => 'Keine Internetverbindung';

  @override
  String get errorNoConnectionBody =>
      'Überprüfe deine Verbindung und versuche es erneut.';

  @override
  String get offlineBanner => 'Keine Internetverbindung';

  @override
  String get offlineBackOnline => 'Wieder online';

  @override
  String get offlineActionUnavailable =>
      'Diese Aktion ist offline nicht möglich.';

  @override
  String get buttonCancel => 'Abbrechen';

  @override
  String get buttonSave => 'Speichern';

  @override
  String get buttonNext => 'Weiter';

  @override
  String get buttonDone => 'Fertig';

  @override
  String get dayMonday => 'Montag';

  @override
  String get dayTuesday => 'Dienstag';

  @override
  String get dayWednesday => 'Mittwoch';

  @override
  String get dayThursday => 'Donnerstag';

  @override
  String get dayFriday => 'Freitag';

  @override
  String get daySaturday => 'Samstag';

  @override
  String get daySunday => 'Sonntag';

  @override
  String get chatScheduleTitle => 'Chat-Zeiten';

  @override
  String get chatScheduleEnforce => 'Zeiten einhalten';

  @override
  String get chatScheduleEnforceSubtitle =>
      'Nachrichten nur in gesetzten Zeiten annehmen';

  @override
  String get chatScheduleFrom => 'Von';

  @override
  String get chatScheduleTo => 'Bis';

  @override
  String get chatScheduleSaved => 'Zeiten gespeichert';

  @override
  String get chatOwnerDisabled => 'Dieser Eigentümer hat den Chat deaktiviert';

  @override
  String get chatOwnerAway => 'Dieser Eigentümer ist im Abwesend-Modus';

  @override
  String get chatOwnerUnavailable =>
      'Eigentümer ist zu dieser Zeit nicht verfügbar';

  @override
  String get authSignInWithGoogle => 'Mit Google anmelden';

  @override
  String get authSignUpWithGoogle => 'Mit Google registrieren';

  @override
  String get stateOfflineTitle => 'Du bist offline';

  @override
  String get stateOfflineBody =>
      'Vieles funktioniert weiterhin — deine gespeicherten Orte und Offline-Tipps sind bereit.';

  @override
  String get stateNoResultsTitle => 'Noch nichts hier';

  @override
  String get stateNoResultsBody =>
      'Versuche andere Stichwörter oder erweitere die Filter.';

  @override
  String get stateEmptyTitle => 'Nichts zu zeigen';

  @override
  String get stateEmptyBody =>
      'Inhalte erscheinen hier, sobald sie verfügbar sind.';

  @override
  String get stateUploadFailedTitle => 'Upload nicht abgeschlossen';

  @override
  String get stateUploadFailedBody =>
      'Wir versuchen es erneut, sobald du wieder online bist. Dein Entwurf ist sicher.';

  @override
  String get stateNotFoundTitle => 'Nicht gefunden';

  @override
  String get stateNotFoundBody =>
      'Dieser Inhalt ist möglicherweise nicht mehr verfügbar.';

  @override
  String get actionRetry => 'Erneut versuchen';

  @override
  String get actionRetryNow => 'Jetzt erneut versuchen';

  @override
  String get actionDiscard => 'Verwerfen';

  @override
  String get actionDismiss => 'Schließen';

  @override
  String get errorNetwork =>
      'Keine Internetverbindung. Bitte überprüfe dein Netzwerk.';

  @override
  String get errorTimeout => 'Zeitüberschreitung. Bitte erneut versuchen.';

  @override
  String get errorUnauthorized => 'Bitte melde dich an, um fortzufahren.';

  @override
  String get errorPermissionDenied => 'Du hast keine Berechtigung dafür.';

  @override
  String get errorNotFound => 'Dieser Inhalt ist nicht mehr verfügbar.';

  @override
  String get errorQuotaExceeded =>
      'Du hast das Limit für diese Aktion erreicht.';

  @override
  String get errorInvalidInput => 'Einige eingegebene Werte sind ungültig.';

  @override
  String get errorUploadFailed =>
      'Upload fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get errorUnknown => 'Ein unerwarteter Fehler ist aufgetreten.';

  @override
  String get validatorRequired => 'Dieses Feld ist erforderlich.';

  @override
  String get validatorEmail => 'Bitte gib eine gültige E-Mail-Adresse ein.';

  @override
  String validatorMinLength(int min) {
    return 'Muss mindestens $min Zeichen lang sein.';
  }

  @override
  String validatorMaxLength(int max) {
    return 'Darf höchstens $max Zeichen lang sein.';
  }

  @override
  String get validatorUrl => 'Bitte gib eine gültige URL ein.';

  @override
  String get toastSavedOffline =>
      'Offline gespeichert — wird synchronisiert, sobald du online bist.';

  @override
  String get toastChangesSynced => 'Änderungen synchronisiert.';
}
