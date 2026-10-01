import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistStorage {
  static const String wishlistKey = 'wishlist_items';

  static Future<List<Map<String, dynamic>>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(wishlistKey);

    if (data == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(data);

    return decoded
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  static Future<bool> isFavorite(String name) async {
    final wishlist = await getWishlist();

    return wishlist.any(
      (item) => item['name'] == name,
    );
  }

  static Future<void> addFavorite({
    required String name,
    required double price,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlist = await getWishlist();

    final exists = wishlist.any(
      (item) => item['name'] == name,
    );

    if (!exists) {
      wishlist.add({
        'name': name,
        'price': price,
      });
    }

    await prefs.setString(
      wishlistKey,
      jsonEncode(wishlist),
    );
  }

  static Future<void> removeFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlist = await getWishlist();

    wishlist.removeWhere(
      (item) => item['name'] == name,
    );

    await prefs.setString(
      wishlistKey,
      jsonEncode(wishlist),
    );
  }

  static Future<void> toggleFavorite({
    required String name,
    required double price,
  }) async {
    final favorite = await isFavorite(name);

    if (favorite) {
      await removeFavorite(name);
    } else {
      await addFavorite(
        name: name,
        price: price,
      );
    }
  }
}