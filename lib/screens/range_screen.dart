import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/range_provider.dart';
import '../widgets/range_bar.dart';
import 'package:flutter/cupertino.dart';

/// Main screen displaying the TextField and RangeBar
class RangeScreen extends StatelessWidget {
  const RangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (didPop) return;
        _showExitConfirmationDialog(context);
      },
      child: Scaffold(
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
                onPressed: () => _showExitConfirmationDialog(context),
                tooltip: 'Close App',
              ),
            ),
          ],
        ),
        body: Consumer<RangeProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 30,
                  color: Color.fromARGB(255, 134, 130, 130),
                ),
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
      ),
    );
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to exit?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
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
              'Unable to Load Data...',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (provider.error != null &&
                (provider.error!.contains('SocketException') ||
                    provider.error!.contains('timeout') ||
                    provider.error!.contains('Network is unreachable') ||
                    provider.error!.contains('Failed host lookup')))
              Text(
                'Please check your internet connection',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                  const Text(
                    'Enter Value',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ValueTextField(
                    initialValue: provider.inputValue,
                    onValueChanged: (value) => provider.updateInputValue(value),
                  ),
                  const SizedBox(height: 16),
                  // Current value info
                  if (provider.inputValue != null)
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
                                        color: currentColor ??
                                            Colors.grey.shade700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Value: ${provider.inputValue! % 1 == 0 ? provider.inputValue!.toInt() : provider.inputValue}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
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
                  const Text(
                    'Range Visualization',
                    style: TextStyle(
                      fontSize: 18,
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
                    '${range.min % 1 == 0 ? range.min.toInt() : range.min} - ${range.max % 1 == 0 ? range.max.toInt() : range.max}',
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
  final double? initialValue;
  final ValueChanged<double?> onValueChanged;

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
      text: widget.initialValue != null
          ? (widget.initialValue! % 1 == 0
              ? widget.initialValue!.toInt().toString()
              : widget.initialValue.toString())
          : '',
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(_ValueTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        !_isUpdatingFromProvider) {
      _controller.text = widget.initialValue != null
          ? (widget.initialValue! % 1 == 0
              ? widget.initialValue!.toInt().toString()
              : widget.initialValue.toString())
          : '';
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
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        LengthLimitingTextInputFormatter(7), // Allows for "9999.99"
      ],
      decoration: InputDecoration(
        // labelText: 'Enter Value',
        // labelStyle: const TextStyle(
        //   fontSize: 20,
        //   // fontWeight: FontWeight.bold,
        // ),
        hintText: 'Enter a value to see the range',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _controller.clear();
                  _isUpdatingFromProvider = true;
                  widget.onValueChanged(null);
                  Future.microtask(() => _isUpdatingFromProvider = false);
                },
              )
            : null,
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          _isUpdatingFromProvider = true;
          widget.onValueChanged(null);
          Future.microtask(() => _isUpdatingFromProvider = false);
          return;
        }

        // Handle trailing decimal point
        if (value.endsWith('.')) return;

        final doubleValue = double.tryParse(value);
        if (doubleValue != null) {
          // Check if value is less than 10000000
          if (doubleValue >= 10000000) {
            return;
          }

          _isUpdatingFromProvider = true;
          widget.onValueChanged(doubleValue);
          // Reset flag after a microtask to allow provider update
          Future.microtask(() => _isUpdatingFromProvider = false);
        }
      },
    );
  }
}
