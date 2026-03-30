import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lose_it/core/theme/app_theme.dart';
import 'package:lose_it/core/providers/theme_provider.dart';
import 'package:lose_it/router/app_router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // If dynamic colors are available (Android 12+ wallpaper-based),
        // use them. Otherwise fall back to the app's custom theme.
        ThemeData lightTheme;
        ThemeData darkTheme;

        if (lightDynamic != null && darkDynamic != null) {
          // Use the wallpaper-extracted color scheme with our styling
          lightTheme = _buildThemeFromColorScheme(
            lightDynamic.harmonized(),
            Brightness.light,
          );
          darkTheme = _buildThemeFromColorScheme(
            darkDynamic.harmonized(),
            Brightness.dark,
          );
        } else {
          // Fall back to custom theme
          lightTheme = AppTheme.lightTheme();
          darkTheme = AppTheme.darkTheme();
        }

        return MaterialApp.router(
          title: 'loseIT',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          routerConfig: router,
        );
      },
    );
  }

  /// Builds a full ThemeData from a dynamic ColorScheme while keeping
  /// our custom typography, shapes, and component themes.
  ThemeData _buildThemeFromColorScheme(
      ColorScheme colorScheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF121218) : const Color(0xFFF8F9FE);
    final cardColor = isDark ? const Color(0xFF1E1E2C) : Colors.white;
    final onSurface = isDark ? const Color(0xFFE8E8F0) : const Color(0xFF1A1A2E);

    final textTheme = isDark
        ? GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
            .apply(bodyColor: onSurface, displayColor: onSurface)
        : GoogleFonts.interTextTheme()
            .apply(bodyColor: onSurface, displayColor: onSurface);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surfaceColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: cardColor,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? const Color(0xFF2A2A3C) : Colors.grey.shade100,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1A1A28) : const Color(0xFFF1F1F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: isDark
              ? const BorderSide(color: Color(0xFF2A2A3C))
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: GoogleFonts.inter(
          color: isDark ? const Color(0xFF6B6B80) : const Color(0xFF9A9AB0),
          fontSize: 15,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        elevation: 3,
        height: 70,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFF6B6B80) : const Color(0xFF9A9AB0),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary, size: 24);
          }
          return IconThemeData(
            color: isDark ? const Color(0xFF6B6B80) : const Color(0xFF9A9AB0),
            size: 24,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shape: const CircleBorder(),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? const Color(0xFF2A2A3C) : const Color(0xFFE8E8F0),
        thickness: 1,
      ),
    );
  }
}
