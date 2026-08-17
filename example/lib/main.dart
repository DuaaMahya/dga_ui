import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'settings.dart';

void main() => runApp(const DgaGalleryApp());

class DgaGalleryApp extends StatefulWidget {
  const DgaGalleryApp({super.key});

  @override
  State<DgaGalleryApp> createState() => _DgaGalleryAppState();
}

class _DgaGalleryAppState extends State<DgaGalleryApp> {
  final _settings = GallerySettings();

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GallerySettingsScope(
      notifier: _settings,
      child: ListenableBuilder(
        listenable: _settings,
        builder: (context, _) {
          final theme = _settings.dark
              ? const DgaThemeData.dark()
              : const DgaThemeData.light();
          return MaterialApp(
            title: 'DGA UI Gallery',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              brightness: _settings.dark ? Brightness.dark : Brightness.light,
              scaffoldBackgroundColor: theme.colors.backgroundWhite,
              colorScheme: ColorScheme.fromSeed(
                seedColor: DgaPrimitives.saFlag600Primary,
                brightness: _settings.dark ? Brightness.dark : Brightness.light,
              ),
            ),
            builder: (context, child) => DgaTheme(
              data: theme,
              child: Directionality(
                textDirection: _settings.textDirection,
                child: child!,
              ),
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
