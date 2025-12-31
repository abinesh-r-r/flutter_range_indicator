import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/range_provider.dart';
import '../widgets/range_bar.dart';

/// Main screen displaying the TextField and RangeBar
class RangeScreen extends StatelessWidget {
  const RangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Range Indicator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => SystemNavigator.pop(),
              tooltip: 'Close App',
            ),
          ),
        ],
      ),
      body: Consumer<RangeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return _buildErrorView(context, provider);
          }

          if (provider.ranges.isEmpty) {
            return const Center(
              child: Text('No ranges available'),
            );
          }

          return _buildMainContent(context, provider);
        },
      ),
    );
  }

  /// Build error view with retry button
  Widget _buildErrorView(BuildContext context, RangeProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Data',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              provider.error ?? 'Unknown error occurred',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build main content with TextField and RangeBar
  Widget _buildMainContent(BuildContext context, RangeProvider provider) {
    final currentMeaning = provider.currentMeaning;
    final currentColor = provider.currentColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input section
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Value',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _ValueTextField(
                    initialValue: provider.inputValue,
                    onValueChanged: (value) => provider.updateInputValue(value),
                  ),
                  const SizedBox(height: 16),
                  // Current value info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: currentColor?.withOpacity(0.1) ??
                          Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: currentColor ?? Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (currentColor != null)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: currentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (currentColor != null) const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   'Current Status',
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .bodySmall
                              //       ?.copyWith(
                              //         color: Colors.grey.shade600,
                              //       ),
                              // ),
                              // const SizedBox(height: 4),
                              Text(
                                currentMeaning ?? 'Out of Range',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          currentColor ?? Colors.grey.shade700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Value: ${provider.inputValue}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Range bar section
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Range Visualization',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  RangeBar(
                    ranges: provider.ranges,
                    inputValue: provider.inputValue,
                    minValue: provider.minValue,
                    maxValue: provider.maxValue,
                  ),
                  const SizedBox(height: 24),
                  // Range legend
                  _buildLegend(context, provider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build legend showing all ranges
  Widget _buildLegend(BuildContext context, RangeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Range Legend',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...provider.ranges.map((range) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: range.color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      range.meaning,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Text(
                    '${range.min} - ${range.max}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

/// Stateful widget to manage TextField controller properly
class _ValueTextField extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onValueChanged;

  const _ValueTextField({
    required this.initialValue,
    required this.onValueChanged,
  });

  @override
  State<_ValueTextField> createState() => _ValueTextFieldState();
}

class _ValueTextFieldState extends State<_ValueTextField> {
  late TextEditingController _controller;
  bool _isUpdatingFromProvider = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue.toString(),
    );
  }

  @override
  void didUpdateWidget(_ValueTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        !_isUpdatingFromProvider) {
      _controller.text = widget.initialValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Enter Value',
        hintText: 'Enter a numeric value',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // prefixIcon: const Icon(Icons.numbers),
      ),
      onChanged: (value) {
        final intValue = int.tryParse(value);
        if (intValue != null) {
          _isUpdatingFromProvider = true;
          widget.onValueChanged(intValue);
          // Reset flag after a microtask to allow provider update
          Future.microtask(() => _isUpdatingFromProvider = false);
        }
      },
    );
  }
}
