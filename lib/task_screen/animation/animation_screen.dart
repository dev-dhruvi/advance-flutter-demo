import 'package:demo/my_dashboard_screen/widget/common_navigator.dart';
import 'package:demo/task_screen/animation/clock_loader/clock_loader_design.dart';
import 'package:demo/task_screen/animation/counter_animation/counter_widget.dart';
import 'package:demo/task_screen/animation/custom_stepper/custom_stepper.dart';
import 'package:flutter/material.dart';

import 'road_map_animation/roadmap_custom_paint.dart';
import 'widget/anime_grid_view_item.dart';

class AnimationHomeScreen extends StatelessWidget {
  const AnimationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text('Animation Zone'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AnimeGridviewItem(
                title: "Counter Animation",
                onTap: () {
                  CommonNavigator.navigateTo(context, className: const WrongAnswer());
                },
              ),
              AnimeGridviewItem(
                title: "Clock Loader",
                onTap: () {
                  CommonNavigator.navigateTo(context, className: const ClockLoader());
                },
              ),
              AnimeGridviewItem(
                title: "Road Map",
                onTap: () {
                  CommonNavigator.navigateTo(context, className: const RoadmapScreen());
                },
              ),
              AnimeGridviewItem(
                title: "Custom Stepper",
                onTap: () {
                  CommonNavigator.navigateTo(context, className: const CustomStepper());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
