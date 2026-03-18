import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final List<String> _favoriteIds = [];
  
  List<String> get favoriteIds => _favoriteIds;
  
  int get count => _favoriteIds.length;
  
  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }
  
  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }
  
  void addFavorite(String productId) {
    if (!_favoriteIds.contains(productId)) {
      _favoriteIds.add(productId);
      notifyListeners();
    }
  }
  
  void removeFavorite(String productId) {
    _favoriteIds.remove(productId);
    notifyListeners();
  }
  
  void clearFavorites() {
    _favoriteIds.clear();
    notifyListeners();
  }
}