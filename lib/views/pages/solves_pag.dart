import 'package:cubekit/material_color/color_set.dart';
import 'package:cubekit/model/app.dart';
import 'package:cubekit/model/cube.dart';
import 'package:cubekit/model/solve.dart';
import 'package:cubekit/model/solve_db.dart';
import 'package:cubekit/model/solvestate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SolvesPag extends StatefulWidget {
  const SolvesPag({Key? key}) : super(key: key);

  @override
  _SolvesPagState createState() => _SolvesPagState();
}

class _SolvesPagState extends State<SolvesPag> {
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
  List<Solve> liSolves = [];
  List<SolveState> liSolveStates = [
    SolveState(id: 0, name: 'OK'),
    SolveState(id: 1, name: '+2'),
    SolveState(id: 2, name: 'DNF'),
  ];

  List<Color> liColors = [Colors.green, Colors.orange, Colors.red];

  void getLiCube() async {
    var getLiCube = await SolvesDatabase.instance.readAllCubes();
    setState(() {
      liCube = getLiCube;
    });
  }

  void getLiSolves() async {
    var getLiSolves =
        await SolvesDatabase.instance.readAllSolves(App.selectedCubeID);
    setState(() {
      liSolves = getLiSolves;
    });
  }

  void getLiSolveStates() async {
    var getLiSolveStates = await SolvesDatabase.instance.readAllSolveStates();
    setState(() {
      liSolveStates = getLiSolveStates;
    });
  }

  String getMean() {
    if (liSolves.isEmpty) {
      return "00.000";
    }

    int mean = 0;

    for (int i = 0; i < liSolves.length; i++) {
      print(i);
      if (liSolves[i].stateid < 2) {
        if (mean <
            (liSolves[i].length + (liSolves[i].stateid == 1 ? 2000 : 0))) {
          mean = liSolves[i].length + (liSolves[i].stateid == 1 ? 2000 : 0);
        }
      }
    }

    return toTime(mean);
  }

  String getBest() {
    if (liSolves.isEmpty) {
      return "00.000";
    }

    int best = 0;
    bool getfirst = true;

    for (int i = 0; i < liSolves.length; i++) {
      if (liSolves[i].stateid < 2) {
        if (getfirst) {
          getfirst = false;
          best = liSolves[i].length + (liSolves[i].stateid == 1 ? 2000 : 0);
        }
        if (best >
            (liSolves[i].length + (liSolves[i].stateid == 1 ? 2000 : 0))) {
          best = liSolves[i].length + (liSolves[i].stateid == 1 ? 2000 : 0);
        }
      }
    }
    return toTime(best);
  }

  String getAvg() {
    if (liSolves.isEmpty) {
      return "00.000";
    }

    int total = 0;
    int count = 0;

    for (int i = 0; i < liSolves.length; i++) {
      if (liSolves[i].stateid < 2) {
        total += liSolves[i].length + (liSolves[i].stateid == 1 ? 2000 : 0);
        count++;
      }
    }
    if (count == 0) {
      return "00.000";
    }
    return toTime((total / count).round());
  }

  String toTime(int length) {
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    getLiCube();
    getLiSolves();
    getLiSolveStates();
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
                    if (App.selectedCubeID >= 1) {
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
                    ),
                  ],
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(
                      Icons.arrow_right_rounded,
                      color: App.selectedCubeID == liCube.length - 1
                          ? ColorSet.black_header.withOpacity(0.3)
                          : ColorSet.black_content,
                      size: 80,
                    ),
                  ),
                  onTap: () {
                    if (App.selectedCubeID < liCube.length - 1) {
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
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  itemCount: liSolves.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: ColorSet.black_header.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  editSolve(liSolves[index]);
                                },
                                child: Text(
                                  toTime(liSolves[index].length +
                                      (liSolves[index].stateid == 1
                                          ? 2000
                                          : 0)),
                                  style: TextStyle(
                                    color: ColorSet.black_content,
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy - kk:mm:ss')
                                    .format(liSolves[index].time),
                                style: TextStyle(
                                  color:
                                      ColorSet.black_content.withOpacity(0.5),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    liSolves[index].stateid =
                                        (liSolves[index].stateid + 1) % 3;
                                    SolvesDatabase.instance
                                        .update(liSolves[index]);
                                  });
                                },
                                child: Container(
                                    width: 50,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: liColors[liSolves[index].stateid],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        liSolveStates[liSolves[index].stateid]
                                            .name,
                                        style: TextStyle(
                                          color: ColorSet.black_content,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    print('delete');
                                    SolvesDatabase.instance
                                        .delete(liSolves[index].id!);
                                    getLiSolves();
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  margin: EdgeInsets.only(left: 5),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade500,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
                    horizontal: 5,
                    vertical: 5,
                  ),
                  child: Center(
                    child: Text(
                      "Statistic",
                      style: TextStyle(
                        color: ColorSet.black_content,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Best:',
                        style: TextStyle(
                          color: ColorSet.black_content,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        getBest(),
                        style: TextStyle(
                          color: ColorSet.black_content,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mean:',
                        style: TextStyle(
                          color: ColorSet.black_content,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        getMean(),
                        style: TextStyle(
                          color: ColorSet.black_content,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Average:',
                        style: TextStyle(
                          color: ColorSet.black_content,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        getAvg(),
                        style: TextStyle(
                          color: ColorSet.black_content,
                          fontSize: 20,
                        ),
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

  void editSolve(Solve solve) {
    TextEditingController scramble = TextEditingController();
    scramble.text = solve.scramble;
    TextEditingController comment = TextEditingController();
    comment.text = solve.comment;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: ColorSet.black_panel,
        content: Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: scramble,
                cursorColor: ColorSet.black_content,
                style: TextStyle(color: ColorSet.black_content),
                decoration: InputDecoration(
                  hintText: 'Scramble',
                  hintStyle:
                      TextStyle(color: ColorSet.black_content.withOpacity(0.5)),
                  fillColor: ColorSet.black_panel.withOpacity(0.5),
                  focusColor: ColorSet.black_panel.withOpacity(0.5),
                  hoverColor: ColorSet.black_panel.withOpacity(0.5),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                        color: ColorSet.black_content.withOpacity(0.7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                        color: ColorSet.black_content.withOpacity(0.3)),
                  ),
                  helperStyle: const TextStyle(
                    color: ColorSet.black_content,
                  ),
                ),
              ),
            ),
            TextField(
              controller: comment,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorColor: ColorSet.black_content,
              style: TextStyle(color: ColorSet.black_content),
              decoration: InputDecoration(
                hintText: 'Comment',
                hintStyle:
                    TextStyle(color: ColorSet.black_content.withOpacity(0.5)),
                fillColor: ColorSet.black_panel.withOpacity(0.5),
                focusColor: ColorSet.black_panel.withOpacity(0.5),
                hoverColor: ColorSet.black_panel.withOpacity(0.5),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                      color: ColorSet.black_content.withOpacity(0.7)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                      color: ColorSet.black_content.withOpacity(0.3)),
                ),
                helperStyle: const TextStyle(
                  color: ColorSet.black_content,
                ),
              ),
            ),
          ],
        )),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              solve.comment = comment.text;
              solve.scramble = scramble.text;
              SolvesDatabase.instance.update(solve);
              Navigator.pop(context, 'Cancel');
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: ColorSet.black_header.withOpacity(0.1),
              ),
              child: Text(
                'Save',
                style: TextStyle(color: ColorSet.black_content),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: ColorSet.black_header.withOpacity(0.1),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: ColorSet.black_content),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
