import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceSearchResult {
  final String displayName;
  final double lat;
  final double lon;

  PlaceSearchResult({
    required this.displayName,
    required this.lat,
    required this.lon,
  });
}

class PlacesService {
  static Future<List<PlaceSearchResult>> searchPlaces(String query) async {
    if (query.length < 3) return [];

    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$query&countrycodes=pk&limit=5'));

    if (response.statusCode == 200) {
      final List results = json.decode(response.body);
      return results
          .map((place) => PlaceSearchResult(
                displayName: place['display_name'],
                lat: double.parse(place['lat']),
                lon: double.parse(place['lon']),
              ))
          .toList();
    }
    return [];
  }
}
