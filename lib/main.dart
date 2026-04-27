import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/navigation/app_route_observer.dart';
import 'core/navigation/app_root_keys.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_strings.dart';
import 'core/di/injection_container.dart' as di;
import 'core/providers/localization_provider.dart';
import 'core/splash/splash_page.dart';
import 'core/widgets/support_whatsapp_overlay.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'l10n/app_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, defaultTargetPlatform;

import 'firebase_options.dart';

Future<void> _initFirebase() async {
  try {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
      case TargetPlatform.iOS:
        await Firebase.initializeApp();
      default:
        break;
    }
  } catch (e, st) {
    debugPrint('Firebase.initializeApp failed: $e\n$st');
  }
}

TextTheme _buildTextTheme(Locale locale) {
  final isArabic = locale.languageCode == 'ar';
  final fontFamily = isArabic ? 'Cairo' : 'Poppins';

  return TextTheme(
    displayLarge: GoogleFonts.getFont(
      fontFamily,
      fontSize: 57,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: GoogleFonts.getFont(
      fontFamily,
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: GoogleFonts.getFont(
      fontFamily,
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: GoogleFonts.getFont(
      fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.getFont(
      fontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.getFont(
      fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.getFont(
      fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.getFont(
      fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: GoogleFonts.getFont(
      fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.getFont(
      fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.getFont(
      fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.getFont(
      fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: GoogleFonts.getFont(
      fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: GoogleFonts.getFont(
      fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: GoogleFonts.getFont(
      fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initFirebase();
  await di.init();

  await di.getIt<CartRepository>().ensureCart();

  final localizationProvider = LocalizationProvider();
  await localizationProvider.init();

  runApp(MyApp(localizationProvider: localizationProvider));
}

class MyApp extends StatefulWidget {
  final LocalizationProvider localizationProvider;

  const MyApp({required this.localizationProvider, super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.localizationProvider.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    widget.localizationProvider.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.localizationProvider.getLocale();

    return ChangeNotifierProvider<LocalizationProvider>.value(
      value: widget.localizationProvider,
      child: BlocProvider<AuthCubit>(
        create: (_) => di.getIt<AuthCubit>(),
        child: MaterialApp(
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          navigatorObservers: [appRouteObserver],
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) return supportedLocales.first;
            for (final supported in supportedLocales) {
              if (supported.languageCode == locale.languageCode) {
                return supported;
              }
            }
            return supportedLocales.first;
          },
          builder: (context, child) {
            return SupportWhatsAppOverlay(
              child: child ?? const SizedBox.shrink(),
            );
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppConstants.primaryColor,
            ),
            useMaterial3: true,
            textTheme: _buildTextTheme(locale),
            appBarTheme: AppBarTheme(
              titleTextStyle: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: GoogleFonts.poppins(),
              hintStyle: GoogleFonts.poppins(),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          home: SafeArea(top: false, bottom: true, child: const SplashPage()),
        ),
      ),
    );
  }
}
