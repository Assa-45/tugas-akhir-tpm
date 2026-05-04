import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../services/location_service.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Makeup', 'Skincare', 'Clothes'];
  String? _selectedStoreName;

  List<_StoreData> _stores = [];
  List<Marker> _markers = [];

  final MapController _mapController = MapController();

  double _userLat = 0;
  double _userLng = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGeoJsonStores();
  }

  Future<void> loadGeoJsonStores() async {
    try {
      /// ambil lokasi user
      final position = await LocationService.getCurrentLocation();
      _userLat = position.latitude;
      _userLng = position.longitude;

      /// load geojson
      final String data = await rootBundle
          .loadString('assets/data/beauty_stores.geojson');

      final jsonResult = json.decode(data);
      final features = jsonResult['features'];

      /// mapping ke store
      final stores = features.map<_StoreData>((f) {
        final props = f['properties'];
        final coords = f['geometry']['coordinates'];

        final lat = coords[1];
        final lon = coords[0];

        final distance = Geolocator.distanceBetween(
              _userLat,
              _userLng,
              lat,
              lon,
            ) /
            1000;

        final category = mapCategory(props['shop']);

        return _StoreData(
          props['name'] ?? "Unknown Store",
          category,
          distance.toStringAsFixed(1),
          "Unknown",
          true,
          getIcon(category),
          getColor(category),
          lat,
          lon,
        );
      }).toList();
      stores.sort((a, b) => double.parse(a.distance).compareTo(double.parse(b.distance)));

      /// marker
      final markers = stores.map<Marker>((store) {
        final isSelected = _selectedStoreName == store.name;

        return Marker(
          width: isSelected ? 70 : 60,
          height: isSelected ? 70 : 60,
          point: LatLng(store.lat, store.lng),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedStoreName = store.name;
              });

              _mapController.move(
                LatLng(store.lat, store.lng),
                16,
              );

              _showStoreDetail(context, store);
            },
            child: Icon(
              Icons.location_on,
              size: isSelected ? 44 : 36,
              color: getMarkerColor(store.category, isSelected),
            ),
          ),
        );
      }).toList();

      setState(() {
        _stores = stores;
        _markers = markers;
        isLoading = false;
      });
    } catch (e) {
      print("GeoJSON error: $e");
      setState(() => isLoading = false);
    }
  }

  // marker color
  Color getMarkerColor(String category, bool isSelected) {
    Color base;

    switch (category) {
      case "Makeup":
        base = const Color(0xFFE57373); // coral
        break;
      case "Skincare":
        base = const Color(0xFF64B5F6); // soft blue
        break;
      case "Clothes":
        base = const Color(0xFFBA68C8); // lavender
        break;
      default:
        base = const Color(0xFF81C784); // soft green
    }

    return isSelected ? base.withOpacity(1.0) : base.withOpacity(0.75);
  }

  String mapCategory(String? raw) {
    switch (raw) {
      case "cosmetics":
        return "Makeup";
      case "beauty":
        return "Skincare";
      case "clothes":
        return "Clothes";
      default:
        return "Others";
    }
  }

  IconData getIcon(String category) {
    switch (category) {
      case "Makeup":
        return Icons.face_retouching_natural_outlined;
      case "Skincare":
        return Icons.spa_outlined;
      case "Clothes":
        return Icons.style_outlined;
      default:
        return Icons.storefront_outlined;
    }
  }

  Color getColor(String category) {
    switch (category) {
      case "Makeup":
        return AppColors.primaryLight;
      case "Skincare":
        return AppColors.accentLight;
      case "Clothes":
        return AppColors.secondaryLight;
      default:
        return AppColors.primaryLight;
    }
  }

  List<_StoreData> get _filteredStores {
    if (_selectedFilter == 0) return _stores;
    final filter = _filters[_selectedFilter];
    return _stores.where((s) => s.category == filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: Text("Loading nearby stores..."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(title: const Text("Nearby Stores")),
      body: Column(
        children: [
          /// MAP
          Container(
            height: 300,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(_userLat, _userLng),
                initialZoom: 14,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    /// marker user
                    Marker(
                      width: 40,
                      height: 40,
                      point: LatLng(_userLat, _userLng),
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                    ),

                    /// marker store
                    ..._markers,
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// FILTER
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final selected = _selectedFilter == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = index),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.accent
                          : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          /// LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredStores.length,
              itemBuilder: (context, index) {
                final store = _filteredStores[index];

                return StoreCard(
                  name: store.name,
                  category: store.category,
                  distance: store.distance,
                  hours: store.hours,
                  isOpen: store.isOpen,
                  iconBg: store.iconBg,
                  icon: store.icon,
                  onTap: () {
                    setState(() {
                      _selectedStoreName = store.name;
                    });

                    _mapController.move(
                      LatLng(store.lat, store.lng),
                      16,
                    );

                    _showStoreDetail(context, store);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showStoreDetail(BuildContext context, _StoreData store) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(store.name, style: const TextStyle(fontSize: 18)),
            Text("${store.distance} km away"),
          ],
        ),
      ),
    );
  }
}

/// MODEL UI
class _StoreData {
  final String name, category, distance, hours;
  final bool isOpen;
  final IconData icon;
  final Color iconBg;
  final double lat, lng;

  const _StoreData(
    this.name,
    this.category,
    this.distance,
    this.hours,
    this.isOpen,
    this.icon,
    this.iconBg,
    this.lat,
    this.lng,
  );
}