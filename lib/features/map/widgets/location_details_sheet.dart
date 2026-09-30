import 'package:flutter/material.dart';

import '../models/favorite_location.dart';

class LocationDetailsSheet extends StatelessWidget {
  final FavoriteLocation location;

  const LocationDetailsSheet({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Favorite Location', style: textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('ID: ${location.id}'),
            const SizedBox(height: 4),
            Text('Name: ${location.name}'),
            const SizedBox(height: 12),
            Text('Latitude: ${location.latitude}'),
            const SizedBox(height: 4),
            Text('Longitude: ${location.longitude}'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}