import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bus_route.dart';
import '../data/routes_data.dart';

class BusProvider extends ChangeNotifier {
  List<BusRoute> _routes = sampleRoutes;
  List<String> _favoriteIds = [];
  String _searchQuery = '';
  String _selectedFilter = 'All';

  List<BusRoute> get routes => _filteredRoutes;
  List<String> get favoriteIds => _favoriteIds;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;

  List<BusRoute> get _filteredRoutes {
    return _routes.where((route) {
      final matchSearch = _searchQuery.isEmpty ||
          route.from.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          route.to.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          route.routeNumber.contains(_searchQuery) ||
          route.stops.any((s) => s.toLowerCase().contains(_searchQuery.toLowerCase()));

      final matchFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Favorites' && _favoriteIds.contains(route.id)) ||
          route.type == _selectedFilter;

      return matchSearch && matchFilter;
    }).toList();
  }

  List<BusRoute> get favoriteRoutes =>
      _routes.where((r) => _favoriteIds.contains(r.id)).toList();

  BusProvider() {
    _loadFavorites();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteIds);
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }
}