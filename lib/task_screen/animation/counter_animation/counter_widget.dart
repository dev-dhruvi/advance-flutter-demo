import 'package:demo/core/constant/screen_util.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class WrongAnswer extends StatefulWidget {
  const WrongAnswer({super.key});

  @override
  State<WrongAnswer> createState() => _WrongAnswerState();
}

class _WrongAnswerState extends State<WrongAnswer> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    Future.delayed(Duration.zero, () {
      setState(() {
        _getAnimateController();
      });
    });

  }

  ///counter text 3 to 1
  String get timerString {
    Duration duration = animationController.duration! * animationController.value;
    int count = 1;
    count = duration.inSeconds % 60 + 1;
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
    return  Container(
      color: Colors.transparent,
    );
  }


  popDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return  AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  elevation: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.sp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            "Wrong Answer".toUpperCase(),
                            style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white
                            )
                        ),
                        SizedBox(height: 10.sp,),
                        Transform.rotate(
                          angle: animationController.value * 4 * math.pi,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 224.sp,
                              height: 180.sp,
                              child: Image.asset('assets/images/exam_rotation.png'),
                            ),
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Text(
                            timerString,
                            style: TextStyle(fontSize: 45.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        });
  }

  void _getAnimateController() {
    if (animationController.isAnimating) {
      animationController.stop();
    } else {
      popDialog(context);
      animationController.reverse(
        from: animationController.value == 0.0 ? 1.0 : animationController.value,
      );
    }
  }
}


/*class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CounterModel(vsync: this),
      child: const CounterWidget(),
    );
  }
}

class CounterWidget extends StatelessWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final counterModel = Provider.of<CounterModel>(context);

    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Counter App with Animation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: AnimatedBuilder(
                  animation: counterModel.animationController,
                  builder: (context, child) {
                    return InkWell(
                      onTap: () {
                        if (counterModel.animationController.isAnimating) {
                          counterModel.animationController.stop();

                        } else {
                          counterModel.popDialog(context);
                          counterModel.animationController.reverse(
                            from: counterModel.animationController.value == 0.0 ? 1.0 : counterModel.animationController.value,
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.tealAccent, borderRadius: BorderRadius.all(Radius.circular(16.sp))),
                        padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 12.sp),
                        child: Text("Play"),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}*/
