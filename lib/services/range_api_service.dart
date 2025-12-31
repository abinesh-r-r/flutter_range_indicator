import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/range_model.dart';

/// Service class for fetching range data from the API
class RangeApiService {
  static const String baseUrl =
      'https://nd-assignment.azurewebsites.net/api/get-ranges';
  static const String bearerToken =
      'eb3dae0a10614a7e719277e07e268b12aeb3af6d7a4655472608451b321f5a95';

  /// Fetch ranges from the API
  /// Returns a list of RangeModel objects
  /// Throws an exception if the API call fails
  Future<List<RangeModel>> fetchRanges() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception(
              'Request timeout. Please check your internet connection.');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => RangeModel.fromJson(json)).toList()
          ..sort((a, b) => a.min.compareTo(b.min)); // Sort by min value
      } else {
        throw Exception(
            'Failed to load ranges: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      if (e is FormatException) {
        rethrow;
      }
      throw Exception('Error fetching ranges: ${e.toString()}');
    }
  }
}
