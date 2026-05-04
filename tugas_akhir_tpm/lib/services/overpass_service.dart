import 'dart:convert';
import 'package:http/http.dart' as http;

class OverpassService {
  static Future<List<Map<String, dynamic>>> getNearbyBeautyStores(
      double lat, double lon) async {
    final query = '''
    [out:json];
    (
      node["shop"="cosmetics"](around:1000,$lat,$lon);
      node["shop"="beauty"](around:1000,$lat,$lon);
      node["shop"="perfume"](around:1000,$lat,$lon);
    );
    out;
    ''';

    final url = Uri.parse("https://overpass-api.de/api/interpreter");

    final response = await http.post(
      url,
      body: query,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['elements'] as List).map((e) {
        return {
          "name": e['tags']?['name'] ?? "Unknown",
          "lat": e['lat'],
          "lon": e['lon'],
          "category": e['tags']?['shop'] ?? "unknown",
        };
      }).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }
}