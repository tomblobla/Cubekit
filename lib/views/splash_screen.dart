import 'package:flutter/material.dart';
import '../material_color/color_set.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_indicators/progress_indicators.dart';

class SplashScr extends StatefulWidget {
  const SplashScr({Key? key}) : super(key: key);

  @override
  _SplashScrState createState() => _SplashScrState();
}

class _SplashScrState extends State<SplashScr> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  void _navigatetohome() async {
    await Future.delayed(
      const Duration(milliseconds: 1500),
      () {},
    );

    Navigator.pushNamed(context, '/main_scr');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 125, vertical: 100),
                child: ShowUpAnimation(
                  delayStart: Duration(milliseconds: 10),
                  animationDuration: Duration(seconds: 1),
                  curve: Curves.elasticOut,
                  direction: Direction.vertical,
                  offset: 0.5,
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/imgs/logo.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ],
                  ),
                ),
              ),
              ShowUpAnimation(
                  delayStart: Duration(milliseconds: 300),
                  animationDuration: Duration(milliseconds: 1000),
                  curve: Curves.bounceIn,
                  direction: Direction.vertical,
                  offset: 0.5,
                  child: Column(
                    children: [
                      SpinKitThreeInOut(
                        color: ColorSet.black_content,
                        size: 30.0,
                      ),
                      JumpingText(
                        'Loading',
                        style: TextStyle(
                          color: ColorSet.black_content,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
