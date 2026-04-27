import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get appName;

  /// App version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appVersion;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @exitConfirm.
  ///
  /// In en, this message translates to:
  /// **'are you sure exit?'**
  String get exitConfirm;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @confirmLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get confirmLogoutTitle;

  /// No description provided for @confirmLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogoutMessage;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get restaurants;

  /// No description provided for @sellers.
  ///
  /// In en, this message translates to:
  /// **'Sellers'**
  String get sellers;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @guestModeTitle.
  ///
  /// In en, this message translates to:
  /// **'You are in guest mode'**
  String get guestModeTitle;

  /// No description provided for @guestModeMessage.
  ///
  /// In en, this message translates to:
  /// **'You must sign in to access this page.'**
  String get guestModeMessage;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reOrder.
  ///
  /// In en, this message translates to:
  /// **'Re-Order'**
  String get reOrder;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @myAddress.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get myAddress;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'ADDRESS'**
  String get address;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'STREET'**
  String get street;

  /// No description provided for @postCode.
  ///
  /// In en, this message translates to:
  /// **'POST CODE'**
  String get postCode;

  /// No description provided for @apartment.
  ///
  /// In en, this message translates to:
  /// **'APARTMENT'**
  String get apartment;

  /// No description provided for @labelAs.
  ///
  /// In en, this message translates to:
  /// **'LABEL AS'**
  String get labelAs;

  /// No description provided for @home2.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get home2;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'WORK'**
  String get work;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'OTHER'**
  String get other;

  /// No description provided for @saveLocation.
  ///
  /// In en, this message translates to:
  /// **'SAVE LOCATION'**
  String get saveLocation;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddress;

  /// No description provided for @areYouSureDeleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get areYouSureDeleteAddress;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Food Details'**
  String get productDetails;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'EDIT'**
  String get edit;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'INGREDIENTS'**
  String get ingredients;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'ADD TO CART'**
  String get addToCart;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @cartSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your cart'**
  String get cartSignInTitle;

  /// No description provided for @cartSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in or create an account to manage your cart and checkout.'**
  String get cartSignInSubtitle;

  /// No description provided for @cartSignedInToast.
  ///
  /// In en, this message translates to:
  /// **'You\'re signed in'**
  String get cartSignedInToast;

  /// No description provided for @removeFromCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from cart'**
  String get removeFromCartTitle;

  /// No description provided for @removeFromCartMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove this item from your cart?'**
  String get removeFromCartMessage;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errorNoInternet;

  /// No description provided for @errorNetworkTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Check your internet and try again.'**
  String get errorNetworkTimeout;

  /// No description provided for @errorServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Our servers are busy. Please try again in a moment.'**
  String get errorServerUnavailable;

  /// No description provided for @errorRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t complete that request. Please try again.'**
  String get errorRequestFailed;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that.'**
  String get errorNotFound;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session expired or sign-in is required. Please log in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access to do that.'**
  String get errorForbidden;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Wait a moment and try again.'**
  String get errorTooManyRequests;

  /// No description provided for @errorSecureConnection.
  ///
  /// In en, this message translates to:
  /// **'Secure connection issue. Please try again later.'**
  String get errorSecureConnection;

  /// No description provided for @errorSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorSomethingWrong;

  /// No description provided for @drawer.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get drawer;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password to sign in'**
  String get loginSubtitle;

  /// No description provided for @emailUpper.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get emailUpper;

  /// No description provided for @passwordUpper.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get passwordUpper;

  /// No description provided for @logInButton.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get logInButton;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE AS GUEST'**
  String get continueAsGuest;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUpUpper.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get signUpUpper;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessful;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please sign up to get started'**
  String get signUpSubtitle;

  /// No description provided for @firstNameUpper.
  ///
  /// In en, this message translates to:
  /// **'FIRST NAME'**
  String get firstNameUpper;

  /// No description provided for @lastNameUpper.
  ///
  /// In en, this message translates to:
  /// **'LAST NAME'**
  String get lastNameUpper;

  /// No description provided for @retypePasswordUpper.
  ///
  /// In en, this message translates to:
  /// **'RE-TYPE PASSWORD'**
  String get retypePasswordUpper;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get signUpButton;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreatedSuccess;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email to reset password'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'SEND CODE'**
  String get sendCode;

  /// No description provided for @verificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verificationTitle;

  /// No description provided for @verificationSentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We have sent a 6-digit code to your phone'**
  String get verificationSentSubtitle;

  /// No description provided for @codeUpper.
  ///
  /// In en, this message translates to:
  /// **'CODE'**
  String get codeUpper;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resendInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds} sec'**
  String resendInSeconds(int seconds);

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'VERIFY'**
  String get verifyButton;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get validationPasswordRequired;

  /// No description provided for @validationFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get validationFirstNameRequired;

  /// No description provided for @validationLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get validationLastNameRequired;

  /// No description provided for @validationPasswordMin6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validationPasswordMin6;

  /// No description provided for @validationConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get validationConfirmPassword;

  /// No description provided for @validationPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsMismatch;

  /// No description provided for @hintEmailExample.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com'**
  String get hintEmailExample;

  /// No description provided for @hintPasswordEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get hintPasswordEnter;

  /// No description provided for @hintReenterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get hintReenterPassword;

  /// No description provided for @hintNameExample.
  ///
  /// In en, this message translates to:
  /// **'Mohamed'**
  String get hintNameExample;

  /// No description provided for @couldNotOpenWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp. Please try again later.'**
  String get couldNotOpenWhatsApp;

  /// No description provided for @completeSixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 6-digit code'**
  String get completeSixDigitCode;

  /// No description provided for @verificationCodeResent.
  ///
  /// In en, this message translates to:
  /// **'Verification code resent'**
  String get verificationCodeResent;

  /// No description provided for @cartNotFound.
  ///
  /// In en, this message translates to:
  /// **'Cart not found. Please try again.'**
  String get cartNotFound;

  /// No description provided for @pleaseSignInValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please sign in with a valid email.'**
  String get pleaseSignInValidEmail;

  /// No description provided for @settingsPageBody.
  ///
  /// In en, this message translates to:
  /// **'Settings page'**
  String get settingsPageBody;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @fullNameUpper.
  ///
  /// In en, this message translates to:
  /// **'FULL NAME'**
  String get fullNameUpper;

  /// No description provided for @phoneNumberUpper.
  ///
  /// In en, this message translates to:
  /// **'PHONE NUMBER'**
  String get phoneNumberUpper;

  /// No description provided for @saveUpper.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get saveUpper;

  /// No description provided for @pickLocationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pick a location on the map and fill address details.'**
  String get pickLocationOnMap;

  /// No description provided for @streetBuildingLabel.
  ///
  /// In en, this message translates to:
  /// **'STREET / BUILDING'**
  String get streetBuildingLabel;

  /// No description provided for @cityUpper.
  ///
  /// In en, this message translates to:
  /// **'CITY'**
  String get cityUpper;

  /// No description provided for @phoneUpper.
  ///
  /// In en, this message translates to:
  /// **'PHONE'**
  String get phoneUpper;

  /// No description provided for @postCodeOptionalUpper.
  ///
  /// In en, this message translates to:
  /// **'POST CODE (OPTIONAL)'**
  String get postCodeOptionalUpper;

  /// No description provided for @apartmentOptionalUpper.
  ///
  /// In en, this message translates to:
  /// **'APARTMENT (OPTIONAL)'**
  String get apartmentOptionalUpper;

  /// No description provided for @apartmentShortUpper.
  ///
  /// In en, this message translates to:
  /// **'APARTMENT'**
  String get apartmentShortUpper;

  /// No description provided for @apartmentFloorHint.
  ///
  /// In en, this message translates to:
  /// **'Apt / floor'**
  String get apartmentFloorHint;

  /// No description provided for @apartmentNumberExample.
  ///
  /// In en, this message translates to:
  /// **'345'**
  String get apartmentNumberExample;

  /// No description provided for @pleaseFillStreetCityPhone.
  ///
  /// In en, this message translates to:
  /// **'Please fill street, city, and phone'**
  String get pleaseFillStreetCityPhone;

  /// No description provided for @hintStreetExample.
  ///
  /// In en, this message translates to:
  /// **'Street 123'**
  String get hintStreetExample;

  /// No description provided for @hintCityExample.
  ///
  /// In en, this message translates to:
  /// **'City name'**
  String get hintCityExample;

  /// No description provided for @hintPhoneExample.
  ///
  /// In en, this message translates to:
  /// **'+963950000001'**
  String get hintPhoneExample;

  /// No description provided for @optionalHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optionalHint;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected location'**
  String get selectedLocation;

  /// No description provided for @fillFormBelow.
  ///
  /// In en, this message translates to:
  /// **'Fill the form below'**
  String get fillFormBelow;

  /// No description provided for @noSavedAddressesYet.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses yet.\\nTap the button below to add one.'**
  String get noSavedAddressesYet;

  /// No description provided for @addNewAddressUpper.
  ///
  /// In en, this message translates to:
  /// **'ADD NEW ADDRESS'**
  String get addNewAddressUpper;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get orderDetailsTitle;

  /// No description provided for @placedOn.
  ///
  /// In en, this message translates to:
  /// **'Placed on'**
  String get placedOn;

  /// No description provided for @orderItemsSection.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get orderItemsSection;

  /// No description provided for @lineItemsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Line items are not available for this order. Totals below still apply.'**
  String get lineItemsUnavailable;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get orderSummary;

  /// No description provided for @orderTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderTotalLabel;

  /// No description provided for @whereShouldWeDeliver.
  ///
  /// In en, this message translates to:
  /// **'Where should we deliver?'**
  String get whereShouldWeDeliver;

  /// No description provided for @tapAddressToUse.
  ///
  /// In en, this message translates to:
  /// **'Tap an address to use it for this order.'**
  String get tapAddressToUse;

  /// No description provided for @editList.
  ///
  /// In en, this message translates to:
  /// **'Edit list'**
  String get editList;

  /// No description provided for @defaultBadge.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultBadge;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @qtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Qty {qty}'**
  String qtyLabel(int qty);

  /// No description provided for @deliverTo.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get deliverTo;

  /// No description provided for @deliverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll bring your order to this address.'**
  String get deliverSubtitle;

  /// No description provided for @loadingAddresses.
  ///
  /// In en, this message translates to:
  /// **'Loading your addresses…'**
  String get loadingAddresses;

  /// No description provided for @couldNotLoadAddresses.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load addresses'**
  String get couldNotLoadAddresses;

  /// No description provided for @addDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Add a delivery address'**
  String get addDeliveryAddress;

  /// No description provided for @tellUsWhereDelivery.
  ///
  /// In en, this message translates to:
  /// **'Tell us where to deliver so you can finish your order.'**
  String get tellUsWhereDelivery;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addAddress;

  /// No description provided for @totalColon.
  ///
  /// In en, this message translates to:
  /// **'TOTAL:'**
  String get totalColon;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'PLACE ORDER'**
  String get placeOrder;

  /// No description provided for @doneUpper.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get doneUpper;

  /// No description provided for @savedAddressFallback.
  ///
  /// In en, this message translates to:
  /// **'Saved address'**
  String get savedAddressFallback;

  /// No description provided for @payAndConfirm.
  ///
  /// In en, this message translates to:
  /// **'PAY & CONFIRM'**
  String get payAndConfirm;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @paymentSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You successfully made a payment, enjoy our service!'**
  String get paymentSuccessMessage;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'THANK YOU'**
  String get thankYou;

  /// No description provided for @searchDishesHint.
  ///
  /// In en, this message translates to:
  /// **'Search dishes, shops'**
  String get searchDishesHint;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @noSellersAtMoment.
  ///
  /// In en, this message translates to:
  /// **'No sellers at the moment'**
  String get noSellersAtMoment;

  /// No description provided for @noProductsYet.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProductsYet;

  /// No description provided for @noProductsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No products in this category'**
  String get noProductsInCategory;

  /// No description provided for @defaultRestaurantName.
  ///
  /// In en, this message translates to:
  /// **'Spicy Restaurant'**
  String get defaultRestaurantName;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewsCount(int count);

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;

  /// No description provided for @addedMultipleToCart.
  ///
  /// In en, this message translates to:
  /// **'Added {count} items to cart'**
  String addedMultipleToCart(int count);

  /// No description provided for @addNToCart.
  ///
  /// In en, this message translates to:
  /// **'ADD {n} TO CART'**
  String addNToCart(int n);

  /// No description provided for @welcomeHeader.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeHeader;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Your marketplace, simplified'**
  String get welcomeTagline;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Marketplace'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'Discover amazing products from sellers around the world'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Easy Shopping'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Browse, search, and find exactly what you need'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Secure Payments'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'Safe and secure payment methods for all your purchases'**
  String get onboarding3Body;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @filterYourSearch.
  ///
  /// In en, this message translates to:
  /// **'Filter your search'**
  String get filterYourSearch;

  /// No description provided for @offersUpper.
  ///
  /// In en, this message translates to:
  /// **'OFFERS'**
  String get offersUpper;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @deliverTimeUpper.
  ///
  /// In en, this message translates to:
  /// **'DELIVER TIME'**
  String get deliverTimeUpper;

  /// No description provided for @pricingUpper.
  ///
  /// In en, this message translates to:
  /// **'PRICING'**
  String get pricingUpper;

  /// No description provided for @ratingUpper.
  ///
  /// In en, this message translates to:
  /// **'RATING'**
  String get ratingUpper;

  /// No description provided for @filterButton.
  ///
  /// In en, this message translates to:
  /// **'FILTER'**
  String get filterButton;

  /// No description provided for @filterDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get filterDelivery;

  /// No description provided for @filterPickUp.
  ///
  /// In en, this message translates to:
  /// **'Pick Up'**
  String get filterPickUp;

  /// No description provided for @filterOffer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get filterOffer;

  /// No description provided for @time10to15.
  ///
  /// In en, this message translates to:
  /// **'10-15 min'**
  String get time10to15;

  /// No description provided for @time20.
  ///
  /// In en, this message translates to:
  /// **'20 min'**
  String get time20;

  /// No description provided for @time30.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get time30;

  /// No description provided for @searchSellersHint.
  ///
  /// In en, this message translates to:
  /// **'Search sellers'**
  String get searchSellersHint;

  /// No description provided for @categoryBurger.
  ///
  /// In en, this message translates to:
  /// **'BURGER'**
  String get categoryBurger;

  /// No description provided for @popularBurgers.
  ///
  /// In en, this message translates to:
  /// **'Popular Burgers'**
  String get popularBurgers;

  /// No description provided for @noPopularItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No popular items yet.'**
  String get noPopularItemsYet;

  /// No description provided for @openShops.
  ///
  /// In en, this message translates to:
  /// **'Open Shops'**
  String get openShops;

  /// No description provided for @tastyTreatGallery.
  ///
  /// In en, this message translates to:
  /// **'Tasty Treat Gallery'**
  String get tastyTreatGallery;

  /// No description provided for @burgerHaven.
  ///
  /// In en, this message translates to:
  /// **'Burger Haven'**
  String get burgerHaven;

  /// No description provided for @customerFallback.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerFallback;

  /// No description provided for @recentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Recent Keywords'**
  String get recentKeywords;

  /// No description provided for @recentSearchesAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your recent searches will appear here.'**
  String get recentSearchesAppearHere;

  /// No description provided for @noSellersFound.
  ///
  /// In en, this message translates to:
  /// **'No sellers found.'**
  String get noSellersFound;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @noPastOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No past orders yet.'**
  String get noPastOrdersYet;

  /// No description provided for @noActiveOrders.
  ///
  /// In en, this message translates to:
  /// **'No active orders.'**
  String get noActiveOrders;

  /// No description provided for @activeOrdersTab.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeOrdersTab;

  /// No description provided for @pastOrdersTab.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get pastOrdersTab;

  /// No description provided for @failedToLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories'**
  String get failedToLoadCategories;

  /// No description provided for @failedToLoadSellers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load sellers'**
  String get failedToLoadSellers;

  /// No description provided for @failedToLoadOffers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load offers'**
  String get failedToLoadOffers;

  /// No description provided for @failedToLoadOrders.
  ///
  /// In en, this message translates to:
  /// **'Failed to load orders'**
  String get failedToLoadOrders;

  /// No description provided for @failedToLoadAddresses.
  ///
  /// In en, this message translates to:
  /// **'Failed to load addresses'**
  String get failedToLoadAddresses;

  /// No description provided for @failedToLoadProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to load product'**
  String get failedToLoadProduct;

  /// No description provided for @failedToLoadRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Failed to load restaurant'**
  String get failedToLoadRestaurant;

  /// No description provided for @heyGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hey'**
  String get heyGreeting;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @pricingLow.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get pricingLow;

  /// No description provided for @pricingMedium.
  ///
  /// In en, this message translates to:
  /// **'\$\$'**
  String get pricingMedium;

  /// No description provided for @pricingHigh.
  ///
  /// In en, this message translates to:
  /// **'\$\$\$'**
  String get pricingHigh;

  /// No description provided for @deliveryTime30Min.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get deliveryTime30Min;

  /// No description provided for @deliveryTime25Min.
  ///
  /// In en, this message translates to:
  /// **'25 min'**
  String get deliveryTime25Min;

  /// No description provided for @deliveryTime20Min.
  ///
  /// In en, this message translates to:
  /// **'20 min'**
  String get deliveryTime20Min;

  /// No description provided for @deliveryTime15Min.
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get deliveryTime15Min;

  /// No description provided for @freeDeliverySymbol.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freeDeliverySymbol;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'SP'**
  String get currencySymbol;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get orderStatusProcessing;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @orderStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get orderStatusRefunded;

  /// No description provided for @orderStatusFulfilled.
  ///
  /// In en, this message translates to:
  /// **'Fulfilled'**
  String get orderStatusFulfilled;

  /// No description provided for @orderStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get orderStatusArchived;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
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
