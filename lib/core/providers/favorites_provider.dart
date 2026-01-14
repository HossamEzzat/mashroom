import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _favoritesKey = 'favorite_mushrooms';
  List<String> _favoriteNames = [];

  List<String> get favoriteNames => _favoriteNames;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteNames = prefs.getStringList(_favoritesKey) ?? [];
    notifyListeners();
  }

  Future<void> toggleFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favoriteNames.contains(name)) {
      _favoriteNames.remove(name);
    } else {
      _favoriteNames.add(name);
    }
    await prefs.setStringList(_favoritesKey, _favoriteNames);
    notifyListeners();
  }

  bool isFavorite(String name) {
    return _favoriteNames.contains(name);
  }
}
