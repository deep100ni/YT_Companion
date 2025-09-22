import 'package:flutter/material.dart';
import '../services/api_key_service.dart';

class ApiKeyCard extends StatefulWidget {
  const ApiKeyCard({super.key});

  @override
  State<ApiKeyCard> createState() => _ApiKeyCardState();
}

class _ApiKeyCardState extends State<ApiKeyCard> {
  final _apiKeyController = TextEditingController();
  final _apiKeyService = ApiKeyService();
  String? _savedApiKey;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final apiKey = await _apiKeyService.getApiKey();
    if (apiKey != null) {
      setState(() {
        _savedApiKey = apiKey;
        _apiKeyController.text = apiKey;
      });
    }
  }

  Future<void> _saveApiKey() async {
    if (_apiKeyController.text.isNotEmpty) {
      await _apiKeyService.saveApiKey(_apiKeyController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("API Key Saved!")),
      );
      setState(() {
        _savedApiKey = _apiKeyController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Gemini API Key",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                hintText: "Enter your API Key",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveApiKey,
              child: const Text("Save Key"),
            ),
            if (_savedApiKey != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Current Key: ...${_savedApiKey!.substring(_savedApiKey!.length - 4)}",
                  style: const TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}