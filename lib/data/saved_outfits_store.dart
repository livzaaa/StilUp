import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SavedOutfitsStore {
  static const String _key = 'saved_outfits';
  static const String _favoriteInspoKey = 'favorite_inspo';

  static final List<Map<String, String>> savedOutfits = [];

  static final List<String> favoriteInspoImages = [];

  static Future<void> loadOutfits() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // KAYITLI KOMBİNLER

      final data = prefs.getStringList(_key) ?? [];

      savedOutfits.clear();

      for (final item in data) {
        final decoded = jsonDecode(item) as Map<String, dynamic>;

        savedOutfits.add(
          decoded.map((key, value) => MapEntry(key, value.toString())),
        );
      }

      // FAVORİ FİKİRLER

      final favoriteIdeas = prefs.getStringList(_favoriteInspoKey) ?? [];

      favoriteInspoImages.clear();

      favoriteInspoImages.addAll(favoriteIdeas);
    } catch (e) {
      savedOutfits.clear();
      favoriteInspoImages.clear();
    }
  }

  static Future<void> addOutfit(Map<String, String> outfit) async {
    final newOutfit = Map<String, String>.from(outfit);

    newOutfit['CreatedAt'] = DateTime.now().millisecondsSinceEpoch.toString();

    final alreadyExists = savedOutfits.any(
      (item) =>
          item['KombinAdi'] == newOutfit['KombinAdi'] &&
          item['Stil'] == newOutfit['Stil'],
    );

    if (!alreadyExists) {
      savedOutfits.insert(0, newOutfit);

      await _save();
    }
  }

  static Future<void> updateOutfit(
    int index,
    Map<String, String> updatedOutfit,
  ) async {
    if (index < 0 || index >= savedOutfits.length) {
      return;
    }

    savedOutfits[index] = Map<String, String>.from(updatedOutfit);

    await _save();
  }

  static Future<void> removeOutfit(int index) async {
    if (index >= 0 && index < savedOutfits.length) {
      savedOutfits.removeAt(index);

      await _save();
    }
  }

  static Future<void> clearAllOutfits() async {
    savedOutfits.clear();

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }

  static Future<void> toggleFavorite(int index) async {
    if (index < 0 || index >= savedOutfits.length) {
      return;
    }

    final current = savedOutfits[index]['Favori'] == 'true';

    savedOutfits[index]['Favori'] = (!current).toString();

    await _save();
  }

  static bool isFavorite(Map<String, String> outfit) {
    return outfit['Favori'] == 'true';
  }

  static List<Map<String, String>> get favoriteOutfits {
    return savedOutfits.where((item) {
      return item['Favori'] == 'true';
    }).toList();
  }

  static int get totalOutfits {
    return savedOutfits.length;
  }

  static Map<String, String>? get latestOutfit {
    if (savedOutfits.isEmpty) {
      return null;
    }

    return savedOutfits.first;
  }

  // FAVORİ FİKİRLER

  static Future<void> toggleFavoriteInspo(String imagePath) async {
    if (favoriteInspoImages.contains(imagePath)) {
      favoriteInspoImages.remove(imagePath);
    } else {
      favoriteInspoImages.add(imagePath);
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(_favoriteInspoKey, favoriteInspoImages);
  }

  static bool isFavoriteInspo(String imagePath) {
    return favoriteInspoImages.contains(imagePath);
  }

  static Future<void> clearFavoriteInspo() async {
    favoriteInspoImages.clear();

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_favoriteInspoKey);
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    final data = savedOutfits.map((item) {
      return jsonEncode(item);
    }).toList();

    await prefs.setStringList(_key, data);
  }
}
