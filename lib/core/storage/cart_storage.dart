import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartStorage {
  static const String cartKey = 'cart_items';

  static Future<List<Map<String, dynamic>>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartString = prefs.getString(cartKey);

    if (cartString == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(cartString);

    return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
  }

 static Future<void> addToCart({
  required String name,
  required double price,
  required String image,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final cart = await getCart();

  final index = cart.indexWhere((item) => item['name'] == name);

  if (index != -1) {
    cart[index]['quantity'] = (cart[index]['quantity'] ?? 1) + 1;
  } else {
    cart.add({
      'name': name,
      'price': price,
      'image': image,
      'quantity': 1,
    });
  }

  await prefs.setString(cartKey, jsonEncode(cart));
}

  static Future<void> updateQuantity(String name, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();

    final index = cart.indexWhere((item) => item['name'] == name);

    if (index == -1) {
      return;
    }

    if (quantity <= 0) {
      cart.removeAt(index);
    } else {
      cart[index]['quantity'] = quantity;
    }

    await prefs.setString(cartKey, jsonEncode(cart));
  }

  static Future<void> removeFromCart(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();

    cart.removeWhere((item) => item['name'] == name);

    await prefs.setString(cartKey, jsonEncode(cart));
  }

  static Future<int> getCartCount() async {
    final cart = await getCart();

    int count = 0;

    for (final item in cart) {
      count += (item['quantity'] ?? 1) as int;
    }

    return count;
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cartKey);
  }
}
