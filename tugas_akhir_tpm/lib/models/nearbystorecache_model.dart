import 'package:hive/hive.dart';

part 'nearbystorecache_model.g.dart';

@HiveType(typeId: 3)
class NearbyStore extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double lat;

  @HiveField(2)
  double lng;

  @HiveField(3)
  double distance;

  NearbyStore({
    required this.name,
    required this.lat,
    required this.lng,
    required this.distance,
  });
}