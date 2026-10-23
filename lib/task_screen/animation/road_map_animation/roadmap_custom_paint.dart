import 'dart:math' show pi;
import 'dart:ui' show Tangent;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    // Flow animation duration is 24 seconds, matching the GSAP duration in JS
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 24))..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 32.w; // 16.w horizontal padding

    // Horizontal layout math: map JS x-coords [40, 234] dynamically to fit screenWidth
    final double scaleX = (screenWidth - 120.w) / 194;
    final double xOffset = 60.w - 40 * scaleX;

    // Vertical layout math: map JS y-coords [1.0002, 209] to fit our Stack height
    final double scaleY = 280.h / 208;
    final double yOffset = 40.h - 1.0002 * scaleY;

    // Center coordinates for each step matching the path's milestones
    final double cx1 = 40 * scaleX + xOffset;
    final double cy1 = 10 * scaleY + yOffset;

    final double cx2 = 225 * scaleX + xOffset; // Peak/apex of the first curve
    final double cy2 = 70 * scaleY + yOffset;

    final double cx3 = 40 * scaleX + xOffset; // End of first curve / start of second
    final double cy3 = 150 * scaleY + yOffset;

    final double cx4 = 235 * scaleX + xOffset; // End of second curve
    final double cy4 = 198 * scaleY + yOffset;

    return Scaffold(
      backgroundColor: const Color(0xFF171d28),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Road Map Animation', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          height: 390.h,
          decoration: BoxDecoration(color: const Color(0xFF171d28), borderRadius: BorderRadius.circular(24.r)),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: RoadmapPainter(
                      progress: controller.value,
                      scaleX: scaleX,
                      xOffset: xOffset,
                      scaleY: scaleY,
                      yOffset: yOffset,
                    ),
                  );
                },
              ),
              _buildStep(
                cx: cx1,
                cy: cy1,
                gradientColors: const [Color(0xFFA78BFA), Color(0xFF7C3AED)],
                shadowColor: const Color(0xFF7C3AED),
                icon: Icons.checklist,
                text: "Browse & Select",
              ),
              _buildStep(
                cx: cx2,
                cy: cy2,
                gradientColors: const [Color(0xFF38BDF8), Color(0xFF0284C7)],
                shadowColor: const Color(0xFF0284C7),
                icon: Icons.badge_outlined,
                text: "Place Your Request",
              ),
              _buildStep(
                cx: cx3,
                cy: cy3,
                gradientColors: const [Color(0xFFF472B6), Color(0xFFDB2777)],
                shadowColor: const Color(0xFFDB2777),
                icon: Icons.phone_in_talk_outlined,
                text: "Get Matched",
              ),
              _buildStep(
                cx: cx4,
                cy: cy4,
                gradientColors: const [Color(0xFFFCA5A5), Color(0xFFEF4444)],
                shadowColor: const Color(0xFFEF4444),
                icon: Icons.verified_outlined,
                text: "Booking Confirmed",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required double cx,
    required double cy,
    required List<Color> gradientColors,
    required Color shadowColor,
    required IconData icon,
    required String text,
  }) {
    return Positioned(
      left: cx - 60.w,
      top: cy - 28.h,
      child: SizedBox(
        width: 120.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 26.w),
            ),
            8.verticalSpace,
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFEF7EE),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class RoadmapPainter extends CustomPainter {
  final double progress;
  final double scaleX;
  final double xOffset;
  final double scaleY;
  final double yOffset;

  RoadmapPainter({
    required this.progress,
    required this.scaleX,
    required this.xOffset,
    required this.scaleY,
    required this.yOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Generate curved mobile path from JS configuration
    final path = Path();
    path.moveTo(40 * scaleX + xOffset, 1.0002 * scaleY + yOffset);
    path.cubicTo(
      150 * scaleX + xOffset, 55 * scaleY + yOffset,
      370 * scaleX + xOffset, 41 * scaleY + yOffset,
      49 * scaleX + xOffset, 140 * scaleY + yOffset,
    );
    path.cubicTo(
      -20 * scaleX + xOffset, 163 * scaleY + yOffset,
      300 * scaleX + xOffset, 200 * scaleY + yOffset,
      234 * scaleX + xOffset, 209 * scaleY + yOffset,
    );

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    // Draw base dashed line matching stroke="#D8D8D8" strokeDasharray="8, 8"
    final basePaint =
    Paint()
      ..color = const Color(0xFFD8D8D8)
      ..strokeWidth = 1.8.w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (var metric in metrics) {
      double distance = 0;
      const dashWidth = 8.0;
      const dashSpace = 8.0;

      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, basePaint);
        distance += dashWidth + dashSpace;
      }
    }

    // Measure exact arc lengths of the two cubic bezier curve segments
    final path1 = Path();
    path1.moveTo(40 * scaleX + xOffset, 1.0002 * scaleY + yOffset);
    path1.cubicTo(
      150 * scaleX + xOffset, 55 * scaleY + yOffset,
      370 * scaleX + xOffset, 41 * scaleY + yOffset,
      49 * scaleX + xOffset, 140 * scaleY + yOffset,
    );
    final double lFirst = path1.computeMetrics().first.length;

    final path2 = Path();
    path2.moveTo(49 * scaleX + xOffset, 140 * scaleY + yOffset);
    path2.cubicTo(
      -20 * scaleX + xOffset, 163 * scaleY + yOffset,
      300 * scaleX + xOffset, 200 * scaleY + yOffset,
      234 * scaleX + xOffset, 209 * scaleY + yOffset,
    );
    final double lSecond = path2.computeMetrics().first.length;

    // Calculate phase lengths
    final double l1 = 0.5 * lFirst; // Phase 1: Step 1 -> Step 2
    final double l2 = 0.5 * lFirst; // Phase 2: Step 2 -> Step 3
    final double l3 = lSecond;      // Phase 3: Step 3 -> Step 4
    final double totalLength = lFirst + lSecond;

    // Colors matching requested transitions
    final Color colorPurple = const Color(0xFF9672FF);
    final Color colorBlue = const Color(0xFF4DDFFD);
    final Color colorPink = const Color(0xFFF094E7);
    final Color colorRed = const Color(0xFFFB7468);

    // Responsive dot radius: Math.max(4, width * 0.008)
    final double dotRadius = (size.width * 0.008).clamp(4.0, 10.0);

    for (int i = 0; i < 9; i++) {
      // Calculate dot progress along path (delayed/offset to space them out evenly)
      final double dotProgress = (progress + (i / 9.0)) % 1.0;
      final double targetOffset = dotProgress * totalLength;

      double accumulatedLength = 0;
      Tangent? tangent;

      for (var metric in metrics) {
        if (targetOffset >= accumulatedLength && targetOffset <= accumulatedLength + metric.length) {
          tangent = metric.getTangentForOffset(targetOffset - accumulatedLength);
          break;
        }
        accumulatedLength += metric.length;
      }

      if (tangent != null) {
        final pos = tangent.position;

        // Draw dot type and color based on its exact phase position
        if (targetOffset < l1) {
          // Phase 1: Step 1 -> Step 2 (Purple -> Blue)
          final double t = targetOffset / l1;
          if (t < 0.375) {
            // First solid dot: Purple
            final paint = Paint()
              ..color = colorPurple
              ..style = PaintingStyle.fill;
            canvas.drawCircle(pos, dotRadius, paint);
          } else if (t < 0.625) {
            // Second split dot: Purple left, Blue right
            _drawSplitDot(canvas, pos, dotRadius, colorPurple, colorBlue);
          } else {
            // Third solid dot: Blue
            final paint = Paint()
              ..color = colorBlue
              ..style = PaintingStyle.fill;
            canvas.drawCircle(pos, dotRadius, paint);
          }
        } else if (targetOffset < l1 + l2) {
          // Phase 2: Step 2 -> Step 3 (Blue -> Pink)
          final double t = (targetOffset - l1) / l2;
          if (t < 0.375) {
            // First solid dot: Blue
            final paint = Paint()
              ..color = colorBlue
              ..style = PaintingStyle.fill;
            canvas.drawCircle(pos, dotRadius, paint);
          } else if (t < 0.625) {
            // Second split dot: Blue left, Pink right
            _drawSplitDot(canvas, pos, dotRadius, colorBlue, colorPink);
          } else {
            // Third solid dot: Pink
            final paint = Paint()
              ..color = colorPink
              ..style = PaintingStyle.fill;
            canvas.drawCircle(pos, dotRadius, paint);
          }
        } else {
          // Phase 3: Step 3 -> Step 4 (Pink -> Red)
          final double t = (targetOffset - l1 - l2) / l3;
          if (t < 0.375) {
            // First solid dot: Pink
            final paint = Paint()
              ..color = colorPink
              ..style = PaintingStyle.fill;
            canvas.drawCircle(pos, dotRadius, paint);
          } else if (t < 0.625) {
            // Second split dot: Pink left, Red right
            _drawSplitDot(canvas, pos, dotRadius, colorPink, colorRed);
          } else {
            // Third solid dot: Red
            final paint = Paint()
              ..color = colorRed
              ..style = PaintingStyle.fill;
            canvas.drawCircle(pos, dotRadius, paint);
          }
        }
      }
    }
  }

  void _drawSplitDot(
      Canvas canvas,
      Offset pos,
      double radius,
      Color leftColor,
      Color rightColor,
      ) {
    final leftPaint = Paint()
      ..color = leftColor
      ..style = PaintingStyle.fill;
    final rightPaint = Paint()
      ..color = rightColor
      ..style = PaintingStyle.fill;

    // Draw left half (pi/2 to 3*pi/2)
    canvas.drawArc(
      Rect.fromCircle(center: pos, radius: radius),
      pi / 2,
      pi,
      true,
      leftPaint,
    );

    // Draw right half (-pi/2 to pi/2)
    canvas.drawArc(
      Rect.fromCircle(center: pos, radius: radius),
      -pi / 2,
      pi,
      true,
      rightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RoadmapPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.scaleX != scaleX ||
        oldDelegate.xOffset != xOffset ||
        oldDelegate.scaleY != scaleY ||
        oldDelegate.yOffset != yOffset;
  }
}