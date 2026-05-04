import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static String? get _apiKey => dotenv.env['GEMINI_API_KEY'];
  static Future<String> sendMessage(String message) async {
    final uri = Uri.https(
      'generativelanguage.googleapis.com',
      '/v1beta/models/gemini-1.5-flash:generateContent',
      {'key': _apiKey!},
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": message}
            ]
          }
        ]
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      return text ?? "AI tidak merespon 😅";
    } else {
      return "Error ${response.statusCode}: ${response.body}";
    }
  }
}