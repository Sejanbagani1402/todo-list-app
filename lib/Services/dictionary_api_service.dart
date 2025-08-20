import 'package:app/models/definition.dart';

import 'api_service.dart';

class DictionaryApiService {
  final ApiService apiService;
  DictionaryApiService()
    : apiService = ApiService(
        baseUrl: "https://api.dictionaryapi.dev/api/v2/entries/en",
      );
  Future<List<dynamic>> getDefinitions(String word) async {
    final response = await apiService.request<List<dynamic>>(
      endpoint: "/$word",
      method: DioMethod.get,
    );
    final List<dynamic> data = response.data ?? [];
    return data
        .expand((entry) => entry["meanings"] as List)
        .expand((meaning) => meaning["definitions"] as List)
        .map((d) => Definition.fromJson(d))
        .toList();
  }
}
