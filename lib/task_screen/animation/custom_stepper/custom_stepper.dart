
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ------------------------------------------------------------
// DEMO STEP MODEL
// ------------------------------------------------------------

class CustomStepper extends StatelessWidget {
  const CustomStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text("How It Works"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              BookingHowItWorksDemo(),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingDemoStepContent {
  final String stepNo;
  final Color color;
  final Color shadowColor;
  final String title;
  final String content;

  const BookingDemoStepContent({
    required this.stepNo,
    required this.color,
    required this.shadowColor,
    required this.title,
    required this.content,
  });
}

// ------------------------------------------------------------
// DEMO CONTROLLER
// Separate from JoinAsPanditController
// ------------------------------------------------------------

class BookingHowItWorksDemoController extends GetxController {
  final RxInt currentStepIndex = 0.obs;

  late final PageController stepPageController;

  late final List<BookingDemoStepContent> stepContent;

  @override
  void onInit() {
    super.onInit();

    stepPageController = PageController();


    stepContent = [
      BookingDemoStepContent(
        stepNo: '01',
        color: const Color(0xFF996AFD),
        shadowColor: const Color(0xFF3A1093),
        title: 'Register Your Account',
        content:
        'Create your partner account using your name, mobile number, and email address. '
            'Complete your basic profile to begin your restaurant registration journey.',
      ),
      BookingDemoStepContent(
        stepNo: '02',
        color: const Color(0xFFFF994C),
        shadowColor: const Color(0xFFA64903),
        title: 'Add Your Restaurant',
        content:
        'Share your restaurant name, business address, contact details, and operating hours. '
            'Upload the required documents to help us verify your business.',
      ),
      BookingDemoStepContent(
        stepNo: '03',
        color: const Color(0xFF61DCF8),
        shadowColor: const Color(0xFF1A839A),
        title: 'Set Up Your Menu',
        content:
        'Showcase your best dishes by adding food names, descriptions, prices, and attractive photos. '
            'Keep your menu and item availability updated for customers.',
      ),
      BookingDemoStepContent(
        stepNo: '04',
        color: const Color(0xFF74B669),
        shadowColor: const Color(0xFF17580C),
        title: 'Start Receiving Orders',
        content:
        'Once your restaurant is verified and your profile is ready, go live on the platform. '
            'Start receiving online orders, preparing meals, and serving more customers.',
      ),
    ];
  }

  void goToStep(int index) {
    if (index < 0 || index >= stepContent.length) return;

    stepPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    stepPageController.dispose();
    super.onClose();
  }
}

// ------------------------------------------------------------
// MAIN DEMO SECTION
// Add BookingHowItWorksDemo() wherever you want to preview it.
// ------------------------------------------------------------

class BookingHowItWorksDemo extends StatefulWidget {
  const BookingHowItWorksDemo({super.key});

  @override
  State<BookingHowItWorksDemo> createState() =>
      _BookingHowItWorksDemoState();
}

class _BookingHowItWorksDemoState extends State<BookingHowItWorksDemo> {
  late final BookingHowItWorksDemoController controller;
  final String controllerTag = 'bookingHowItWorksDemo';

  @override
  void initState() {
    super.initState();

    controller = Get.put(
      BookingHowItWorksDemoController(),
      tag: controllerTag,
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<BookingHowItWorksDemoController>(
      tag: controllerTag,
    )) {
      Get.delete<BookingHowItWorksDemoController>(
        tag: controllerTag,
      );
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF9D9D9D).withValues(alpha: 0.1),
      ),
      padding: EdgeInsets.symmetric(vertical: 27.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Text(
              'Step-By-Step Guide',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(
              'Join our delivery platform in a few simple steps. Register your restaurant, showcase your menu, and start serving customers online.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                color: Color(0xFF1E1E1E).withValues(alpha: 0.7),
              ),
            ),
          ),
          15.verticalSpace,
          BookingHowItWorksDemoSection(controller: controller),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE VIEW + STEP INDICATORS
// ------------------------------------------------------------

class BookingHowItWorksDemoSection extends StatelessWidget {
  final BookingHowItWorksDemoController controller;

  const BookingHowItWorksDemoSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 440.h,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: controller.stepPageController,
            itemCount: controller.stepContent.length,
            onPageChanged: (index) {
              controller.currentStepIndex.value = index;
            },
            itemBuilder: (context, index) {
              final step = controller.stepContent[index];

              return BookingDemoCustomStepper(
                stepList: step,
                color: step.color,
                stepNo: step.stepNo,
                title: step.title,
                content: step.content,
                shadowColor: step.shadowColor,
              );
            },
          ),
        ),
        Obx(
              () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controller.stepContent.asMap().entries.map((entry) {
              final isSelected =
                  controller.currentStepIndex.value == entry.key;

              return GestureDetector(
                onTap: () => controller.goToStep(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: isSelected ? 14.w : 6.w,
                  height: 6.h,
                  margin: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 2.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Color(0xFF1E1E1E).withValues(
                      alpha: isSelected ? 0.9 : 0.4,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// CUSTOM STEPPER
// Preserves your original design and card styling.
// ------------------------------------------------------------

class BookingDemoCustomStepper extends StatelessWidget {
  final BookingDemoStepContent? stepList;
  final Color color;
  final Color shadowColor;
  final String stepNo;
  final String title;
  final String content;

  const BookingDemoCustomStepper({
    super.key,
    this.stepList,
    required this.color,
    required this.shadowColor,
    required this.stepNo,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 65.h,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Transform.rotate(
                      angle: 3.14159 / 2,
                      child: DottedLine(
                        lineLength: 30.h,
                        dashColor: color,
                      ),
                    ),
                  ),
                  Center(
                    child: SvgPicture.string(
                      AppImageString.icStepper,
                      colorFilter: ColorFilter.mode(
                        color,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      height: 38.h,
                      width: 38.w,
                      margin: EdgeInsets.only(bottom: 10.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            offset: const Offset(2.94, 2.94),
                            blurRadius: 7.35,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        stepNo,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
            child: Center(
              child: Transform.rotate(
                angle: 3.14159 / 2,
                child: DottedLine(
                  lineLength: 20.h,
                  dashColor: color,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: stepList?.stepNo == '01'
                          ? Get.width * 0.1
                          : Get.width * 0.01,
                      right: stepList?.stepNo == '06'
                          ? Get.width * 0.1
                          : 0,
                    ),
                    child: MySeparator(
                      color: color.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 15.h,
                    width: 15.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          12.verticalSpace,
          Container(
            height: 190.h,
            width: Get.width * 0.8,
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border.all(color: color),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  offset: const Offset(0, 2.32),
                  blurRadius: 10.r,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  30.verticalSpace,
                  Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF233500),
                    ),
                  ),
                  15.verticalSpace,
                  Expanded(
                    child: Text(
                      content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({super.key, this.height = 1, this.color = Colors.black});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Draw a dotted line.
///
/// Basic line settings
/// * [direction]
/// * [alignment]
/// * [lineLength]
/// * [lineThickness]
/// Dash settings
/// * [dashLength]
/// * [dashColor]
/// * [dashGradient]
/// * [dashRadius]
/// Dash gap settings
/// * [dashGapLength]
/// * [dashGapColor]
/// * [dashGapRadius]
/// * [dashGapGradient]
class DottedLine extends StatelessWidget {
  /// Creates dotted line with the given parameters
  const DottedLine({
    super.key,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.center,
    this.lineLength = double.infinity,
    this.lineThickness = 1.0,
    this.dashLength = 4.0,
    this.dashColor = Colors.black,
    this.dashGradient,
    this.dashGapLength = 4.0,
    this.dashGapColor = Colors.transparent,
    this.dashGapGradient,
    this.dashRadius = 0.0,
    this.dashGapRadius = 0.0,
  })  : assert(
  dashGradient == null || dashGradient.length == 2,
  'The dashGradient must have only two colors.\n'
      'The beginning color and the ending color of the gradient.'),
        assert(
        dashGapGradient == null || dashGapGradient.length == 2,
        'The dashGapGradient must have only two colors.\n'
            'The beginning color and the ending color of the gradient.');

  /// The direction of the entire dotted line. Default [Axis.horizontal].
  final Axis direction;

  /// The alignment of the entire dotted line. Default [WrapAlignment.center].
  final WrapAlignment alignment;

  /// The length of the entire dotted line. Default [double.infinity].
  final double lineLength;

  /// The thickness of the entire dotted line. Default (1.0).
  final double lineThickness;

  /// The length of the dash. Default (4.0).
  final double dashLength;

  /// The color of the dash. Default [Colors.black].
  ///
  /// This is ignored if [dashGradient] is non-null.
  final Color dashColor;

  /// The gradient colors of the dash. Default null.
  /// The first color is beginning color, the second one is ending color.
  ///
  /// If this is specified, [dashColor] has no effect.
  final List<Color>? dashGradient;

  /// The radius of the dash. Default (0.0).
  final double dashRadius;

  /// The length of the dash gap. Default (4.0).
  final double dashGapLength;

  /// The color of the dash gap. Default [Colors.transparent].
  ///
  /// This is ignored if [dashGapGradient] is non-null.
  final Color dashGapColor;

  /// The gradient colors of the dash gap. Default null.
  /// The first color is beginning color, the second one is ending color.
  ///
  /// If this is specified, [dashGapColor] has no effect.
  final List<Color>? dashGapGradient;

  /// The radius of the dash gap. Default (0.0).
  final double dashGapRadius;

  @override
  Widget build(BuildContext context) {
    final isHorizontal = direction == Axis.horizontal;

    return SizedBox(
      width: isHorizontal ? lineLength : lineThickness,
      height: isHorizontal ? lineThickness : lineLength,
      child: LayoutBuilder(builder: (context, constraints) {
        final lineLength = _getLineLength(constraints, isHorizontal);
        final dashAndDashGapCount = _calculateDashAndDashGapCount(lineLength);
        final dashCount = dashAndDashGapCount[0];
        final dashGapCount = dashAndDashGapCount[1];

        return Wrap(
          direction: direction,
          alignment: alignment,
          children: List.generate(dashCount + dashGapCount, (index) {
            if (index % 2 == 0) {
              final dashColor = _getDashColor(dashCount, index ~/ 2);
              final dash = _buildDash(isHorizontal, dashColor);
              return dash;
            } else {
              final dashGapColor = _getDashGapColor(dashGapCount, index ~/ 2);
              final dashGap = _buildDashGap(isHorizontal, dashGapColor);
              return dashGap;
            }
          }).toList(growable: false),
        );
      }),
    );
  }

  /// If [lineLength] is [double.infinity],
  /// get the maximum value of the parent widget.
  /// And if the value is specified, use the specified value.
  double _getLineLength(BoxConstraints constraints, bool isHorizontal) {
    return lineLength == double.infinity
        ? isHorizontal
        ? constraints.maxWidth
        : constraints.maxHeight
        : lineLength;
  }

  /// Calculate the count of (dash + dashGap).
  ///
  /// example1) [lineLength] is 10, [dashLength] is 1, [dashGapLength] is 1.
  /// "- - - - - "
  /// example2) [lineLength] is 10, [dashLength] is 1, [dashGapLength] is 2.
  /// "-  -  -  -"
  List<int> _calculateDashAndDashGapCount(double lineLength) {
    var dashAndDashGapLength = dashLength + dashGapLength;
    var dashCount = lineLength ~/ dashAndDashGapLength;
    var dashGapCount = lineLength ~/ dashAndDashGapLength;
    if (dashLength <= lineLength % dashAndDashGapLength) {
      dashCount += 1;
    }
    return [dashCount, dashGapCount];
  }

  Widget _buildDash(bool isHorizontal, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(dashRadius),
      ),
      width: isHorizontal ? dashLength : lineThickness,
      height: isHorizontal ? lineThickness : dashLength,
    );
  }

  Color _getDashColor(int maxDashCount, int index) {
    return dashGradient == null
        ? dashColor
        : _calculateGradientColor(
      dashGradient![0],
      dashGradient![1],
      maxDashCount,
      index,
    );
  }

  Widget _buildDashGap(bool isHorizontal, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(dashGapRadius),
      ),
      width: isHorizontal ? dashGapLength : lineThickness,
      height: isHorizontal ? lineThickness : dashGapLength,
    );
  }

  Color _getDashGapColor(int maxDashGapCount, int index) {
    return dashGapGradient == null
        ? dashGapColor
        : _calculateGradientColor(
      dashGapGradient![0],
      dashGapGradient![1],
      maxDashGapCount,
      index,
    );
  }

  Color _calculateGradientColor(
      Color startColor,
      Color endColor,
      int maxItemCount,
      int index,
      ) {

    final startAlpha = (startColor.a * 255.0).round().clamp(0, 255);
    final startRed = (startColor.r * 255.0).round().clamp(0, 255);
    final startGreen = (startColor.g * 255.0).round().clamp(0, 255);
    final startBlue = (startColor.b * 255.0).round().clamp(0, 255);

    final endAlpha = (endColor.a * 255.0).round().clamp(0, 255);
    final endRed = (endColor.r * 255.0).round().clamp(0, 255);
    final endGreen = (endColor.g * 255.0).round().clamp(0, 255);
    final endBlue = (endColor.b * 255.0).round().clamp(0, 255);

    var diffAlpha = (endAlpha - startAlpha);
    var diffRed = (endRed - startRed);
    var diffGreen = (endGreen - startGreen);
    var diffBlue = (endBlue - startBlue);

    var amountOfChangeInAlphaPerItem = diffAlpha ~/ maxItemCount;
    var amountOfChangeInRedPerItem = diffRed ~/ maxItemCount;
    var amountOfChangeInGreenPerItem = diffGreen ~/ maxItemCount;
    var amountOfChangeInBluePerItem = diffBlue ~/ maxItemCount;

    return Color.fromARGB(
      startAlpha + amountOfChangeInAlphaPerItem * index,
      startRed + amountOfChangeInRedPerItem * index,
      startGreen + amountOfChangeInGreenPerItem * index,
      startBlue + amountOfChangeInBluePerItem * index,
    );
  }
}

class AppImageString{
  static const String icStepper = '''
  <svg width="57" height="69" viewBox="0 0 57 69" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M-1.77181e-06 28.3056C-2.48432e-06 12.0052 13.7859 -1.08226 30.3363 0.0720812C44.556 1.06466 55.9524 12.7772 56.5774 27.0189C57.0626 37.9374 51.3497 47.5691 42.6665 52.6938C36.3286 56.4289 31.2186 61.9285 28.3585 68.7075L28.2997 68.8398L28.2409 68.7001C25.4102 61.9947 20.4179 56.4509 14.1241 52.7967C5.67613 47.9 -1.31447e-06 38.7682 -1.77213e-06 28.2983L-1.77181e-06 28.3056Z" fill="#996AFD"/>
  </svg>

  ''';
}