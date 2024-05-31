//Location: i18n/app_localization_delegate.dart
// Importing necessary libraries
import 'package:blackox/i18n/app_localization.dart';
import 'package:flutter/material.dart';


// Class for handling localization delegate
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // Constructor
  const AppLocalizationsDelegate();


  // Method to check if a locale is supported
  @override
  bool isSupported(Locale locale) {
    // Currently only English and Spanish are supported
    return ['en', 'es'].contains(locale.languageCode);
  }


  // Method to load the localized strings for a locale
  @override
  Future<AppLocalizations> load(Locale locale) {
    // Create an instance of AppLocalizations for the given locale
    AppLocalizations localizations = AppLocalizations(locale);
    // Load the localized strings and return the AppLocalizations instance
    return localizations.load().then((bool _) {
      return localizations;
    });
  }


  // Method to decide if the delegate should be reloaded
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}