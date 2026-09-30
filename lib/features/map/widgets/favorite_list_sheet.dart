import 'package:flutter/material.dart';

import '../data/favorite_locations.dart';
import '../models/favorite_location.dart';

class FavoriteListSheet extends StatelessWidget {
  final ValueChanged<FavoriteLocation> onSelected;

  const FavoriteListSheet({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              ' Favorite Locations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...favoriteLocations.map(
                (loc) => ListTile(
                  leading: const Text('', style: TextStyle(fontSize: 20)),
              title: Text(loc.name),
              onTap: () => onSelected(loc),
            ),
          ),
        ],
      ),
    );
  }
}