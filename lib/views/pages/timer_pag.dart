import 'dart:async';

import 'package:cubekit/material_color/color_set.dart';
import 'package:cubekit/model/app.dart';
import 'package:cubekit/model/cube.dart';
import 'package:cubekit/model/preferences_service.dart';
import 'package:cubekit/model/settings.dart';
import 'package:cubekit/model/solve.dart';
import 'package:cubekit/model/solve_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimerPag extends StatefulWidget {
  const TimerPag({Key? key}) : super(key: key);

  @override
  _TimerPagState createState() => _TimerPagState();
}

class _TimerPagState extends State<TimerPag> {
  // final JavascriptRuntime jsRuntime = getJavascriptRuntime();
  // String scramble = "";
  final _preferencesService = PreferencesService();

  Settings sett = Settings(
    inspection: false,
    holding: false,
    display: true,
    inspect_max: 15000.0,
    hold_max: 500.0,
  );

  List<Cube> liCube = [
    Cube(id: 0, name: "3 x 3 x 3", scramble: '333'),
    Cube(id: 1, name: "3 x 3 x 3", scramble: '333'),
    Cube(id: 2, name: "3 x 3 x 3", scramble: '333'),
    Cube(id: 3, name: "3 x 3 x 3", scramble: '333'),
    Cube(id: 4, name: "3 x 3 x 3", scramble: '333'),
    Cube(id: 5, name: "3 x 3 x 3", scramble: '333'),
    Cube(id: 6, name: "3 x 3 x 3", scramble: '333'),
    Cube(id: 7, name: "3 x 3 x 3", scramble: '333'),
    Cube(id: 8, name: "3 x 3 x 3", scramble: '333'),
    Cube(id: 9, name: "3 x 3 x 3", scramble: '333'),
    Cube(id: 10, name: "3 x 3 x 3", scramble: '333'),
    Cube(id: 11, name: "3 x 3 x 3", scramble: '333'),
  ];

  int length = 0;
  int insplength = 0;
  int holdlength = 0;
  DateTime start = new DateTime.now();
  var inspectholdrun = false;
  var inspecthold = 0;
  Timer? timer, inspholdtimer;
  //0 stopped
  //1 closing
  //2 running
  //3 holding
  //4 inspection

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Color getColorTimer = ColorSet.black_content;
  Future<void> _populateFields() async {
    final settings = await _preferencesService.getSettings();
    setState(() {
      sett = settings;
    });
    await _preferencesService.saveSettings(sett);
  }

  String toTime() {
    if (!sett.display && App.state == 2) return "Solving";
    Duration duration = new Duration(milliseconds: length);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String threeDigits(int n) => n.toString().padLeft(3, "0");
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String threeDigitMilliseconds =
        threeDigits(duration.inMilliseconds.remainder(1000));

    String res = "$twoDigitSeconds.$threeDigitMilliseconds";

    if (int.parse(twoDigitMinutes) >= 1) {
      res = "$twoDigitMinutes:" + res;
    }

    if (int.parse(twoDigitHours) >= 1) {
      res = "$twoDigitHours:" + res;
    }

    return res;
  }

  // void getScramble() async {
  //   final String get_scramble = await addFromJs(jsRuntime, '222');
  //   setState(() {
  //     scramble = get_scramble;
  //     print(scramble);
  //   });
  // }

  void getLiCube() async {
    var getLiCube = await SolvesDatabase.instance.readAllCubes();
    setState(() {
      liCube = getLiCube;
    });
  }

  void updateTimer() {
    setState(() {
      if (App.state == 4) {
        length = insplength;
      } else if (App.state == 2) {
        length = DateTime.now().difference(start).inMilliseconds;
      }
    });
  }

  void tapDown() {
    _populateFields();
    switch (App.state) {
      case 0:
        {
          if (sett.holding) {
            holdlength = 0;
            App.state = 3;
            timer = Timer.periodic(new Duration(milliseconds: 10), (timer) {
              holdlength += 10;
              updateTimer();
              if (holdlength >= sett.hold_max) {
                setState(() {
                  getColorTimer = Colors.green;
                });
              } else {
                setState(() {
                  getColorTimer = Colors.red;
                });
              }
            });
            // timer = setInterval(function () {
            //     milliseconds += 10;
            //     if (milliseconds >= holdtime) {
            //         $("#timerdp").css("color", "green");
            //     }
            //     else {
            //         $("#timerdp").css("color", "red");
            //     }
            // }, 10)
          }
          break;
        }
      case 2:
        {
          // $("#timerdp").css("color", "black");
          updateTimer();
          addSolve();
          setState(() {
            getColorTimer = ColorSet.black_content;
          });
          timer?.cancel();
          App.state = 1;
          break;
        }
      case 4:
        {
          if (sett.holding && !inspectholdrun) {
            inspecthold = int.parse(sett.hold_max.round().toString());
            inspholdtimer =
                Timer.periodic(new Duration(milliseconds: 10), (timer) {
              inspectholdrun = true;
              inspecthold -= 10;
              if (inspecthold > 0) {
                setState(() {
                  getColorTimer = ColorSet.black_content.withOpacity(0.6);
                });
              } else {
                setState(() {
                  getColorTimer = ColorSet.black_content.withOpacity(1);
                });
              }
            });
          }
          break;
        }
    }
  }

  void tapUp() {
    switch (App.state) {
      case 0:
        {
          setState(() {
            getColorTimer = Colors.green;
          });
          if (sett.inspection) {
            insplength = int.parse(sett.inspect_max.round().toString());
            App.state = 4;
            timer = Timer.periodic(new Duration(milliseconds: 10), (timer2) {
              updateTimer();
              if (insplength <= 0) {
                timer2.cancel();
                App.state = 2;
                insplength = 0;
                setState(() {
                  getColorTimer = ColorSet.black_content;
                });
                start = DateTime.now();
                timer = Timer.periodic(new Duration(milliseconds: 0), (timer) {
                  updateTimer();
                });
              }

              insplength -= 10;
            });
            break;
          }
          setState(() {
            getColorTimer = ColorSet.black_content;
          });
          App.state = 2;
          start = DateTime.now();
          timer = Timer.periodic(new Duration(milliseconds: 0), (timer) {
            updateTimer();
          });
          break;
        }
      case 1:
        {
          App.state = 0;

          break;
        }
      case 3:
        {
          timer?.cancel();
          if (holdlength >= sett.hold_max) {
            setState(() {
              getColorTimer = Colors.green;
            });

            if (sett.inspection) {
              insplength = int.parse(sett.inspect_max.round().toString());
              App.state = 4;

              timer = Timer.periodic(new Duration(milliseconds: 10), (timer2) {
                updateTimer();
                if (insplength <= 0) {
                  timer2.cancel();
                  App.state = 2;
                  insplength = 0;
                  setState(() {
                    getColorTimer = ColorSet.black_content;
                  });
                  start = DateTime.now();
                  timer =
                      Timer.periodic(new Duration(milliseconds: 0), (timer) {
                    updateTimer();
                  });
                }

                insplength -= 10;
              });

              break;
            }

            App.state = 2;
            setState(() {
              getColorTimer = ColorSet.black_content;
            });
            start = DateTime.now();
            timer = Timer.periodic(new Duration(milliseconds: 0), (timer) {
              updateTimer();
            });
          } else if (sett.holding) {
            App.state = 0;
            start = DateTime.now();
            setState(() {
              getColorTimer = ColorSet.black_content;
            });
          }
          break;
        }
      case 4:
        {
          if (sett.holding) {
            inspectholdrun = !inspectholdrun;
            inspholdtimer?.cancel();
            setState(() {
              getColorTimer = Colors.green;
            });
            if (inspecthold > 0) {
              inspecthold = 0;
              break;
            }
          }

          timer?.cancel();
          App.state = 2;
          setState(() {
            getColorTimer = ColorSet.black_content;
          });
          start = DateTime.now();
          timer = Timer.periodic(new Duration(milliseconds: 0), (timer) {
            updateTimer();
          });

          break;
        }
    }

    _populateFields();
  }

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  @override
  Widget build(BuildContext context) {
    getLiCube();
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
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
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.arrow_left_rounded,
                    color: App.selectedCubeID == 0
                        ? ColorSet.black_header.withOpacity(0.3)
                        : ColorSet.black_content,
                    size: 80,
                  ),
                  onTap: () {
                    if (App.selectedCubeID >= 1 && App.state == 0) {
                      setState(() {
                        App.selectedCubeID--;
                      });
                    }
                  },
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/${liCube[App.selectedCubeID].scramble}.svg',
                      color: ColorSet.black_content,
                      width: 80,
                    ),
                    Text(
                      liCube[App.selectedCubeID].name,
                      style: TextStyle(
                        color: ColorSet.black_content,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  child: Icon(
                    Icons.arrow_right_rounded,
                    color: App.selectedCubeID == liCube.length - 1
                        ? ColorSet.black_header.withOpacity(0.3)
                        : ColorSet.black_content,
                    size: 80,
                  ),
                  onTap: () {
                    if (App.selectedCubeID < liCube.length - 1 &&
                        App.state == 0) {
                      setState(() {
                        App.selectedCubeID++;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorSet.black_panel,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: GestureDetector(
                onTapDown: (tapdownDetails) {
                  print('tapdown $App.state');
                  tapDown();
                  print('tapdown $App.state');
                },
                onTapUp: (tapupDetails) {
                  print('tapup $App.state');
                  tapUp();
                  print('tapup $App.state');
                },
                child: Column(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              toTime(),
                              style: TextStyle(
                                color: getColorTimer,
                                fontSize: 60,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addSolve() async {
    Solve solve = Solve(
      cubeid: App.selectedCubeID,
      stateid: 0,
      length: length,
      scramble: '',
      comment: '',
      time: DateTime.now(),
    );

    Solve res = await SolvesDatabase.instance.create(solve);

    print(res.id);
    _populateFields();
  }

  // Future<String> addFromJs(JavascriptRuntime jsRuntime, String cubename) async {
  //   String jsname = cubename;
  //   if (cubename == '555' ||
  //       cubename == '666' ||
  //       cubename == '777' ||
  //       cubename == '444') jsname = "NNN";
  //   String scramboJs = await rootBundle.loadString("assets/js/scrambo.js");
  //   String requireJs = await rootBundle.loadString("assets/js/require.js");
  //   String utilJs = await rootBundle.loadString("assets/js/util.js");
  //   final jsResult = jsRuntime.evaluate('''
  //         $requireJs
  //         $scramboJs
  //         (new Scrambo()).type('$cubename').get();
  //       ''');

  //   return jsResult.stringResult;
  // }
}
