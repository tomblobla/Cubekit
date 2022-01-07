import 'package:cubekit/material_color/color_set.dart';
import 'package:cubekit/model/preferences_service.dart';
import 'package:cubekit/model/settings.dart';
import 'package:cubekit/views/pages/timer_pag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SettPag extends StatefulWidget {
  const SettPag({Key? key}) : super(key: key);

  @override
  _SettPagState createState() => _SettPagState();
}

class _SettPagState extends State<SettPag> {
  final _preferencesService = PreferencesService();
  Settings sett = Settings(
    inspection: false,
    holding: false,
    display: true,
    inspect_max: 15000.0,
    hold_max: 500.0,
  );

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() async {
    final settings = await _preferencesService.getSettings();
    setState(() {
      sett = settings;
    });
    await _preferencesService.saveSettings(sett);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorSet.black_panel,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: new BoxDecoration(
                      color: ColorSet.black_content.withOpacity(0.01),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0),
                      )),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Center(
                    child: Text(
                      "Inspection",
                      style: TextStyle(
                        color: ColorSet.black_content,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Off/On',
                        style: TextStyle(
                          color: ColorSet.black_content,
                          fontSize: 20,
                        ),
                      ),
                      FlutterSwitch(
                        activeColor: ColorSet.black_header,
                        inactiveColor: ColorSet.black_header.withOpacity(0.2),
                        width: 35.0,
                        height: 20.0,
                        value: sett.inspection,
                        toggleSize: 15.0,
                        borderRadius: 30.0,
                        padding: 3.0,
                        onToggle: (val) {
                          setState(() {
                            sett.inspection = val;
                            _saveSettings();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SfSlider(
                    min: 0,
                    max: 15000,
                    value: sett.inspect_max,
                    activeColor: ColorSet.black_header,
                    inactiveColor: ColorSet.black_header.withOpacity(0.2),
                    interval: 500,
                    stepSize: 500,
                    enableTooltip: true,
                    onChanged: (dynamic value) {
                      setState(() {
                        sett.inspect_max = value;
                        _saveSettings();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorSet.black_panel,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: new BoxDecoration(
                      color: ColorSet.black_content.withOpacity(0.01),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0),
                      )),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Center(
                    child: Text(
                      "Holding",
                      style: TextStyle(
                        color: ColorSet.black_content,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Off/On',
                        style: TextStyle(
                          color: ColorSet.black_content,
                          fontSize: 20,
                        ),
                      ),
                      FlutterSwitch(
                        activeColor: ColorSet.black_header,
                        inactiveColor: ColorSet.black_header.withOpacity(0.2),
                        width: 35.0,
                        height: 20.0,
                        value: sett.holding,
                        toggleSize: 15.0,
                        borderRadius: 30.0,
                        padding: 3.0,
                        onToggle: (val) {
                          setState(() {
                            sett.holding = val;
                            _saveSettings();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SfSlider(
                    min: 0,
                    max: 500,
                    value: sett.hold_max,
                    activeColor: ColorSet.black_header,
                    inactiveColor: ColorSet.black_header.withOpacity(0.2),
                    interval: 10,
                    stepSize: 10,
                    enableTooltip: true,
                    onChanged: (dynamic value) {
                      setState(() {
                        sett.hold_max = value;
                        _saveSettings();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorSet.black_panel,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: new BoxDecoration(
                      color: ColorSet.black_content.withOpacity(0.01),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0),
                      )),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Center(
                    child: Text(
                      "Display",
                      style: TextStyle(
                        color: ColorSet.black_content,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Off/On',
                        style: TextStyle(
                          color: ColorSet.black_content,
                          fontSize: 20,
                        ),
                      ),
                      FlutterSwitch(
                        activeColor: ColorSet.black_header,
                        inactiveColor: ColorSet.black_header.withOpacity(0.2),
                        width: 35.0,
                        height: 20.0,
                        value: sett.display,
                        toggleSize: 15.0,
                        borderRadius: 30.0,
                        padding: 3.0,
                        onToggle: (val) {
                          setState(() {
                            sett.display = val;
                            _saveSettings();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    final newSettings = sett;

    print(newSettings);
    _preferencesService.saveSettings(newSettings);
  }
}
