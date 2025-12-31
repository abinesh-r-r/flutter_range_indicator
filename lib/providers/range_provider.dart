import 'package:flutter/material.dart';
import '../models/range_model.dart';
import '../services/range_api_service.dart';

/// Provider class for managing range data state using ChangeNotifier
class RangeProvider extends ChangeNotifier {
  final RangeApiService _apiService = RangeApiService();

  List<RangeModel> _ranges = [];
  bool _isLoading = false;
  String? _error;
  int? _inputValue;

  List<RangeModel> get ranges => _ranges;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get inputValue => _inputValue;

  /// Get the minimum value from all ranges
  int get minValue {
    if (_ranges.isEmpty) return 0;
    return _ranges.map((r) => r.min).reduce((a, b) => a < b ? a : b);
  }

  /// Get the maximum value from all ranges
  int get maxValue {
    if (_ranges.isEmpty) return 100;
    return _ranges.map((r) => r.max).reduce((a, b) => a > b ? a : b);
  }

  /// Get the meaning of the current input value
  String? get currentMeaning {
    if (_ranges.isEmpty || _inputValue == null) return null;
    for (var range in _ranges) {
      if (range.contains(_inputValue!)) {
        return range.meaning;
      }
    }
    return null;
  }

  /// Get the color of the current input value's range
  Color? get currentColor {
    if (_ranges.isEmpty || _inputValue == null) return null;
    for (var range in _ranges) {
      if (range.contains(_inputValue!)) {
        return range.color;
      }
    }
    return null;
  }

  /// Fetch ranges from the API
  Future<void> fetchRanges() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _ranges = await _apiService.fetchRanges();
      _error = null;
      
      // Set initial input value to null (empty)
      _inputValue = null;
    } catch (e) {
      _error = e.toString();
      _ranges = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update the input value
  void updateInputValue(int? value) {
    _inputValue = value;
    notifyListeners();
  }

  /// Retry fetching ranges
  Future<void> retry() async {
    await fetchRanges();
  }
}

