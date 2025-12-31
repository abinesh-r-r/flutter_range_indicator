import 'package:flutter/material.dart';
import '../models/range_model.dart';

/// A dynamic horizontal bar widget that visualizes ranges with an indicator
class RangeBar extends StatelessWidget {
  final List<RangeModel> ranges;
  final int inputValue;
  final int minValue;
  final int maxValue;

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

    final totalSpan = maxValue - minValue;
    if (totalSpan == 0) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        const barHeight = 40.0;

        // Calculate indicator position (clamped to bar bounds)
        final clampedValue = inputValue.clamp(minValue, maxValue);
        final indicatorPosition = ((clampedValue - minValue) / totalSpan) * barWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bar visualization
            Stack(
              children: [
                // Background bar with sections
                Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Row(
                    children: _buildSections(barWidth, totalSpan),
                  ),
                ),
                // Indicator line
                Positioned(
                  left: indicatorPosition.clamp(0.0, barWidth - 2),
                  child: Container(
                    width: 2,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Labels below the bar
            _buildLabels(barWidth, totalSpan),
          ],
        );
      },
    );
  }

  /// Build individual range sections
  List<Widget> _buildSections(double barWidth, int totalSpan) {
    if (ranges.isEmpty || totalSpan == 0) {
      return [];
    }

    return ranges.map((range) {
      final sectionWidth = (range.span / totalSpan) * barWidth;
      return Container(
        width: sectionWidth,
        decoration: BoxDecoration(
          color: range.color,
          borderRadius: _getBorderRadiusForSection(range, ranges),
        ),
      );
    }).toList();
  }

  /// Get border radius for section (rounded corners on first and last sections)
  BorderRadius _getBorderRadiusForSection(RangeModel range, List<RangeModel> allRanges) {
    final isFirst = range == allRanges.first;
    final isLast = range == allRanges.last;

    if (isFirst && isLast) {
      return BorderRadius.circular(8);
    } else if (isFirst) {
      return const BorderRadius.only(
        topLeft: Radius.circular(8),
        bottomLeft: Radius.circular(8),
      );
    } else if (isLast) {
      return const BorderRadius.only(
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      );
    }
    return BorderRadius.zero;
  }

  /// Build labels below the bar
  Widget _buildLabels(double barWidth, int totalSpan) {
    if (ranges.isEmpty || totalSpan == 0) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Min value label
        Text(
          '$minValue',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Max value label
        Text(
          '$maxValue',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

