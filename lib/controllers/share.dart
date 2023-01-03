import 'package:flutter/material.dart';
import 'package:futminna_project_1/repositories/share.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final shareController = ChangeNotifierProvider<ShareController>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return ShareController(ref, sharedPrefs);
});

class ShareController extends ChangeNotifier {
  final Ref _ref;
  final SharedPreferences? sharedPreferences;
  static const String cart = "cart";
  static const String mapPermission = "map_permission";
  List? carts;

  ShareController(this._ref, this.sharedPreferences);

  Future<void> updateCart(String value) async {
    await _ref.read(sharedUtilityProvider).setCart(value);
    notifyListeners();
  }

  String? getCart() {
    return sharedPreferences!.getString(cart) ?? '';
  }

  Future<void> updateMapPermission(bool value) async {
    await _ref.read(sharedUtilityProvider).setMapPermission(value);
    notifyListeners();
  }

  bool? getMapPermission() {
    return sharedPreferences!.getBool(mapPermission) ?? false;
  }
}
