// lib/core/widgets/map_picker.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class MapPicker extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPicker({super.key, this.initialLocation});

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final MapController _mapController = MapController();
  
  // Default to a central point if no initial is provided (e.g. New Delhi)
  late LatLng _currentCenter;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _currentCenter = widget.initialLocation ?? const LatLng(28.6139, 77.2090);
    
    // Automatically try to get location if we don't have an initial one
    if (widget.initialLocation == null) {
      _locateMe();
    }
  }

  Future<void> _locateMe() async {
    setState(() => _isLoadingLocation = true);
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      
      final newLoc = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _currentCenter = newLoc;
      });
      
      _mapController.move(newLoc, 15.0);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // The Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 15.0,
              onPositionChanged: (MapCamera camera, bool hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _currentCenter = camera.center;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.couponapp.seller',
                // Optional styling could be applied via tile provider if needed,
                // but standard OSM maps are free and require no key.
              ),
              // Attribution is required by OSM
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),

          // Central Marker Overlay
          // Instead of rendering a marker via flutter_map, we put an overlay in the exact center
          // of the screen so it acts as a "crosshair" to select the location beneath it.
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.0), // Shift up to point at the center
              child: Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 48,
              ),
            ),
          ),

          // Custom App Bar Overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.onSurface),
              ),
            ),
          ),

          // Floating GPS Button
          Positioned(
            right: 16,
            bottom: 120,
            child: FloatingActionButton(
              heroTag: 'gps_btn',
              backgroundColor: AppColors.surfaceContainerLowest,
              foregroundColor: AppColors.primary,
              onPressed: _isLoadingLocation ? null : _locateMe,
              child: _isLoadingLocation 
                  ? const SizedBox(
                      width: 24, 
                      height: 24, 
                      child: CircularProgressIndicator(strokeWidth: 2)
                    )
                  : const Icon(Icons.my_location),
            ),
          ),

          // Bottom Confirmation Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Coordinates',
                      style: AppTextStyles.labelSM.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_currentCenter.latitude.toStringAsFixed(5)}, ${_currentCenter.longitude.toStringAsFixed(5)}',
                      style: AppTextStyles.headlineSM,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Return the selected LatLng to the previous screen
                            Navigator.of(context).pop(_currentCenter);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Confirm Location',
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
