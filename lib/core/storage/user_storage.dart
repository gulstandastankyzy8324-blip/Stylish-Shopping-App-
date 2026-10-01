import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static Future<void> saveUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('name') ?? '';
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('email') ?? '';
  }

  static Future<String> getPassword() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('password') ?? '';
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', value);
  }

  static Future<void> saveProfile({
    required String name,
    required String email,
    required String address,
    required String city,
    required String country,
    required String pincode,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('address', address);
    await prefs.setString('city', city);
    await prefs.setString('country', country);
    await prefs.setString('pincode', pincode);
  }

  static Future<String> getAddress() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('address') ?? '';
  }

  static Future<String> getCity() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('city') ?? '';
  }

  static Future<String> getCountry() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('country') ?? '';
  }

  static Future<String> getPincode() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('pincode') ?? '';
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', false);
  }

  static Future<void> updatePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  static Future<void> setOnboardingSeen(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingSeen', value);
  }

  static Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingSeen') ?? false;
  }

  static Future<void> saveAvatar(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_avatar', path);
  }

  static Future<String?> getAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_avatar');
  }

  static Future<void> removeAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_avatar');
  }
}
