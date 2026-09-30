import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/services/location_service.dart';
import '../data/favorite_locations.dart';
import '../models/favorite_location.dart';
import '../widgets/favorite_list_sheet.dart';
import '../widgets/location_details_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  bool _myLocationEnabled = false;
  bool _loadingLocation = false;

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(22.8026, 89.3709),
    zoom: 12,
  );

  late final Set<Marker> _markers = favoriteLocations
      .map(
        (loc) => Marker(
      markerId: MarkerId(loc.id.toString()),
      position: loc.latLng,
      infoWindow: InfoWindow(title: loc.name),
      onTap: () => _showLocationDetails(loc),
    ),
  )
      .toSet();

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _goToMyLocation() async {
    if (_loadingLocation) return;
    setState(() => _loadingLocation = true);

    try {
      final position = await _locationService.getCurrentPosition();
      if (!mounted) return;

      setState(() => _myLocationEnabled = true);

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16,
        ),
      );

      _showSnack(
        'Lat: ${position.latitude.toStringAsFixed(5)}, '
            'Lng: ${position.longitude.toStringAsFixed(5)}',
      );
    } on LocationException catch (e) {
      _handleLocationError(e);
    } catch (e) {
      _showSnack('Could not get location: $e');
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  void _handleLocationError(LocationException e) {
    if (!mounted) return;

    SnackBarAction? action;
    if (e.failure == LocationFailure.serviceDisabled) {
      action = SnackBarAction(
        label: 'GPS Settings',
        onPressed: _locationService.openLocationSettings,
      );
    } else if (e.failure == LocationFailure.deniedForever) {
      action = SnackBarAction(
        label: 'App Settings',
        onPressed: _locationService.openAppSettings,
      );
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(e.message), action: action));
  }

  void _showLocationDetails(FavoriteLocation loc) {
    showModalBottomSheet(
      context: context,
      builder: (_) => LocationDetailsSheet(location: loc),
    );
  }

  void _showFavoriteList() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => FavoriteListSheet(
        onSelected: (loc) {
          Navigator.pop(sheetContext);
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(loc.latLng, 16),
          );
        },
      ),
    );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Map & Location')),
      body: GoogleMap(
        initialCameraPosition: _initialCamera,
        markers: _markers,
        zoomControlsEnabled: true,
        myLocationEnabled: _myLocationEnabled,
        myLocationButtonEnabled: false,
        onMapCreated: (controller) => _mapController = controller,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'favorites',
            onPressed: _showFavoriteList,
            icon: const Icon(Icons.star),
            label: const Text('Favorite Locations'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'my_location',
            onPressed: _goToMyLocation,
            icon: _loadingLocation
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.my_location),
            label: const Text('My Location'),
          ),
        ],
      ),
    );
  }
}