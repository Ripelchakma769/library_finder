import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/map/screens/map_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Favorite Locations Map',
      theme: AppTheme.light,
      home: const MapScreen(),
    );
  }
}