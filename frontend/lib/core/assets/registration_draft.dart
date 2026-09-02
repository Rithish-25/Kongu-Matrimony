import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationDraft {
  RegistrationDraft._();

  static const String _kDraftDataKey = 'registration_draft_data';
  static const String _kDraftStepKey = 'registration_draft_step';
  static const String _kDraftExistsKey = 'registration_draft_exists';

  /// Save the current form state data and the page/step index.
  static Future<void> saveDraft(Map<String, String> data, int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDraftDataKey, jsonEncode(data));
    await prefs.setInt(_kDraftStepKey, step);
    await prefs.setBool(_kDraftExistsKey, true);
  }

  /// Load draft form data. Returns empty map if none exists.
  static Future<Map<String, String>> loadDraftData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kDraftDataKey);
    if (jsonStr == null) return {};
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonStr);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (_) {
      return {};
    }
  }

  /// Load the draft's current page/step index (0-based).
  static Future<int> loadDraftStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kDraftStepKey) ?? 0;
  }

  /// Check if a draft exists and is active.
  static Future<bool> hasDraft() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kDraftExistsKey) ?? false;
  }

  /// Clear all draft data on completion or reset.
  static Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kDraftDataKey);
    await prefs.remove(_kDraftStepKey);
    await prefs.remove(_kDraftExistsKey);
  }

  static const String _kProfileDetailsKey = 'user_profile_details';

  // In-memory runtime cache to persist accounts across logouts/session state resets
  static final Map<String, Map<String, String>> _runtimeCache = {};

  /// Save completed/saved profile details.
  static Future<void> saveProfileDetails(Map<String, String> data) async {
    final mobile = data['mobile'];
    if (mobile != null) {
      _runtimeCache[mobile] = data;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kProfileDetailsKey, jsonEncode(data));
  }

  /// Load completed/saved profile details.
  static Future<Map<String, String>> loadProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kProfileDetailsKey);
    if (jsonStr != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(jsonStr);
        final data = decoded.map((key, value) => MapEntry(key, value.toString()));
        final mobile = data['mobile'];
        if (mobile != null) {
          _runtimeCache[mobile] = data;
        }
        return data;
      } catch (_) {}
    }
    if (_runtimeCache.isNotEmpty) {
      return _runtimeCache.values.last;
    }
    return {};
  }

  /// Clear profile details on logout.
  static Future<void> clearProfileDetails() async {
    _runtimeCache.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kProfileDetailsKey);
  }
}
