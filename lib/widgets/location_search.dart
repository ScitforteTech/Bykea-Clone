import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../services/places_service.dart';
import 'dart:async';

class LocationSearch extends StatefulWidget {
  final Function(String address, LatLng location) onLocationSelected;
  final String hint;

  const LocationSearch({
    Key? key,
    required this.onLocationSelected,
    required this.hint,
  }) : super(key: key);

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  List<PlaceSearchResult> _searchResults = [];
  final _debouncer = Debouncer(milliseconds: 500);

  void _onSearchChanged(String query) {
    _debouncer.run(() async {
      if (query.isEmpty) {
        setState(() => _searchResults = []);
        return;
      }
      final results = await PlacesService.searchPlaces(query);
      setState(() => _searchResults = results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
          onChanged: _onSearchChanged,
        ),
        if (_searchResults.isNotEmpty)
          Container(
            height: 200,
            color: Colors.white,
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  title: Text(result.displayName),
                  onTap: () {
                    widget.onLocationSelected(
                      result.displayName,
                      LatLng(result.lat, result.lon),
                    );
                    setState(() => _searchResults = []);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
