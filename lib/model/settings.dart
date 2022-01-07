import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  bool inspection;
  bool holding;
  bool display;

  double inspect_max;
  double hold_max;

  Settings({
    required this.inspection,
    required this.holding,
    required this.display,
    required this.inspect_max,
    required this.hold_max,
  });
}
