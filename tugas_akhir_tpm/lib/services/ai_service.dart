import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static String? get apiKey => dotenv.env['GEMINI_API_KEY'];

  static Future<Map<String, dynamic>> analyzeFace(
      Map<String, dynamic> data) async {
    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");

   final prompt = """
You are a professional color analyst.

User face data:
${jsonEncode(data)}

Return JSON only with:
- season
- best_colors (hex array)
- avoid_colors (hex array)
- styling_tips (short paragraph)
- glow_tips (array of 4 short tips)
- confidence (0-1)

No explanation. Only JSON.
""";

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.7,
          // Memaksa output dalam format JSON (opsional tapi disarankan)
          "responseMimeType": "application/json" 
        }
      }),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      
      // Struktur respon Gemini: candidates -> content -> parts -> text
      String content = decoded['candidates'][0]['content']['parts'][0]['text'];
      
      // Membersihkan teks jika AI tidak sengaja memberikan markdown ```json ... ```
      content = content.replaceAll('```json', '').replaceAll('```', '').trim();
      
      return json.decode(content);
    } else {
      throw Exception("Failed to connect to Gemini: ${response.body}");
    }
  }
}