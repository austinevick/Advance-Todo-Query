import 'dart:convert';

import 'package:http/http.dart';

import '../apikey.dart';

class SpeechToTextRepository {
  final _client = Client();

  Future getTextResponse(String audio) async {
    final response = await _client.post(
        Uri.parse(
          "https://api.openai.com/v1/completions",
        ),
        headers: {
          "Authorization": "Bearer $OPENAI_API_KEY",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": audio,
          "max_tokens": 7,
          "temperature": 0
        }));
    print(jsonDecode(response.body));
  }
}
