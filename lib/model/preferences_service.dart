import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';

class PreferencesService {
  Future saveSettings(Settings settings) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool('inspection', settings.inspection);
    await preferences.setBool('holding', settings.holding);
    await preferences.setBool('display', settings.display);
    await preferences.setDouble('inspect_max', settings.inspect_max);
    await preferences.setDouble('hold_max', settings.hold_max);

    print('Saved settings');
  }

  Future<Settings> getSettings() async {
    final preferences = await SharedPreferences.getInstance();

    final bool inspection = preferences.getBool('inspection') ?? false;
    final bool holding = preferences.getBool('holding') ?? false;
    final bool display = preferences.getBool('display') ?? true;
    final double inspect_max = preferences.getDouble('inspect_max') ?? 15000.0;
    final double hold_max = preferences.getDouble('hold_max') ?? 500.0;

    return Settings(
        inspection: inspection,
        holding: holding,
        display: display,
        inspect_max: inspect_max,
        hold_max: hold_max);
  }
}
