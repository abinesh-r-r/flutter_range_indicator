import 'package:flutter/material.dart';
import '../models/range_model.dart';

/// A dynamic horizontal bar widget that visualizes ranges with an indicator
class RangeBar extends StatelessWidget {
  final List<RangeModel> ranges;
  final double? inputValue;
  final double minValue;
  final double maxValue;

  const RangeBar({
    super.key,
    required this.ranges,
    required this.inputValue,
    required this.minValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    if (ranges.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: 100, // Increased height for labels and indicator
          child: CustomPaint(
            painter: _RangeBarPainter(
              ranges: ranges,
              inputValue: inputValue,
              minValue: minValue,
              maxValue: maxValue,
            ),
          ),
        );
      },
    );
  }
}

class _RangeBarPainter extends CustomPainter {
  final List<RangeModel> ranges;
  final double? inputValue;
  final double minValue;
  final double maxValue;

  _RangeBarPainter({
    required this.ranges,
    required this.inputValue,
    required this.minValue,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double horizontalPadding = 16.0;
    final double barHeight = 28.0;
    final double barTop = 35.0; // Space for top labels
    final double width = size.width;
    final double drawWidth = width - (horizontalPadding * 2);
    final double totalSpan = maxValue - minValue;

    if (totalSpan <= 0) return;

    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Define the bar area as a rounded rectangle
    RRect barRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(horizontalPadding, barTop, drawWidth, barHeight),
      Radius.circular(barHeight / 2),
    );

    // 1. Draw Background Bar (ensures rounded ends are visible even if segments don't cover them)
    paint.color = Colors.grey.shade200;
    canvas.drawRRect(barRect, paint);

    // 2. Draw the bar segments
    canvas.save();
    canvas.clipRRect(barRect);

    double lastMax = minValue;
    for (var range in ranges) {
      // Use absolute positioning to ensure alignment with labels and indicator
      final double startX =
          horizontalPadding + ((lastMax - minValue) / totalSpan) * drawWidth;
      final double endX =
          horizontalPadding + ((range.max - minValue) / totalSpan) * drawWidth;

      paint.color = range.color;
      canvas.drawRect(
        Rect.fromLTWH(
            startX, barTop, (endX - startX).clamp(0, drawWidth), barHeight),
        paint,
      );

      lastMax = range.max;
    }
    canvas.restore();

    // Draw Labels with alternating positions
    final textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    // Collect all boundary values
    List<double> boundaries = [minValue];
    for (var range in ranges) {
      boundaries.add(range.max);
    }

    for (int i = 0; i < boundaries.length; i++) {
      final double value = boundaries[i];
      final double positionX =
          horizontalPadding + ((value - minValue) / totalSpan) * drawWidth;

      // Alternate: Even indices (0, 2, 4...) -> Below, Odd indices (1, 3, 5...) -> Above
      final bool isAbove = (i % 2 != 0);
      final double positionY = isAbove ? barTop - 24 : barTop + barHeight + 8;

      // Align text: First left, Last right, others center
      TextAlign align = TextAlign.center;
      if (i == 0)
        align = TextAlign.left;
      else if (i == boundaries.length - 1) align = TextAlign.right;

      // Format value to remove decimal if it's an integer
      String labelText = value % 1 == 0 ? value.toInt().toString() : value.toString();
      _drawText(canvas, labelText, Offset(positionX, positionY), textStyle,
          align: align);
    }

    // Draw Indicator (Triangle) only if inputValue is not null
    if (inputValue != null) {
      final double clampedValue = inputValue!.clamp(minValue, maxValue);
      final double indicatorX =
          horizontalPadding + ((clampedValue - minValue) / totalSpan) * drawWidth;
      final double triangleTop = barTop + barHeight + 2;
      final double triangleSize = 20.0;

      final Path trianglePath = Path();
      trianglePath.moveTo(indicatorX, triangleTop); // Top point
      trianglePath.lineTo(indicatorX - triangleSize / 2,
          triangleTop + triangleSize); // Bottom left
      trianglePath.lineTo(indicatorX + triangleSize / 2,
          triangleTop + triangleSize); // Bottom right
      trianglePath.close();

      paint.color = Colors.black;
      canvas.drawPath(trianglePath, paint);

      // Draw Current Value Label below triangle
      final valueTextStyle = const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

      // Format input value to show up to 2 decimal places if needed
      String valueText = inputValue! % 1 == 0 
          ? inputValue!.toInt().toString() 
          : inputValue!.toStringAsFixed(2).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");

      _drawText(canvas, valueText,
          Offset(indicatorX, triangleTop + triangleSize + 4), valueTextStyle,
          align: TextAlign.center);
    }
  }

  void _drawText(Canvas canvas, String text, Offset position, TextStyle style,
      {TextAlign align = TextAlign.center}) {
    final TextSpan span = TextSpan(text: text, style: style);
    final TextPainter tp = TextPainter(
      text: span,
      textAlign: align,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    double x = position.dx;
    if (align == TextAlign.center) {
      x -= tp.width / 2;
    } else if (align == TextAlign.right) {
      x -= tp.width;
    }

    tp.paint(canvas, Offset(x, position.dy));
  }

  @override
  bool shouldRepaint(covariant _RangeBarPainter oldDelegate) {
    return oldDelegate.inputValue != inputValue ||
        oldDelegate.ranges != ranges ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue;
  }
}
