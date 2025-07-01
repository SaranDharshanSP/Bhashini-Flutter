import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Q&A App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const QAScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QAScreen extends StatefulWidget {
  const QAScreen({super.key});

  @override
  State<QAScreen> createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  final TextEditingController _questionController = TextEditingController();
  String _answer = '';
  bool _isLoading = false;
  String _error = '';

  Future<void> _askQuestion() async {
    if (_questionController.text.trim().isEmpty) {
      setState(() {
        _error = 'Please enter a question';
        _answer = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
      _answer = '';
    });

    final response = await ApiService.askQuestion(_questionController.text.trim());

    setState(() {
      _isLoading = false;
      if (response['success']) {
        _answer = response['data']['answer'] ?? 'No answer received';
      } else {
        _error = response['error'] ?? 'Failed to get answer';
      }
    });
  }

  void _clearAll() {
    setState(() {
      _questionController.clear();
      _answer = '';
      _error = '';
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('AI Q&A Assistant'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Greeting Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.psychology,
                    size: 48,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome to AI Q&A!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ask me any question and I\'ll provide you with a concise answer in 3-4 sentences.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blue.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Question Input Section
            Text(
              'Your Question:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _questionController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Type your question here...The question could be anything',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _askQuestion,
                    icon: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.send),
                    label: Text(_isLoading ? 'Getting Answer...' : 'Ask Question'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Answer Section
            if (_answer.isNotEmpty || _error.isNotEmpty) ...[
              Text(
                'Answer:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _error.isNotEmpty ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _error.isNotEmpty ? Colors.red.shade200 : Colors.green.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _error.isNotEmpty ? Icons.error : Icons.check_circle,
                          color: _error.isNotEmpty ? Colors.red.shade600 : Colors.green.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _error.isNotEmpty ? 'Error' : 'AI Response',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _error.isNotEmpty ? Colors.red.shade800 : Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error.isNotEmpty ? _error : _answer,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: _error.isNotEmpty ? Colors.red.shade700 : Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.amber.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Setup Instructions:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. Make sure your Flask server is running on port 5000\n'
                        '2. For Android emulator: Use 10.0.2.2:5000\n'
                        '3. For physical device: Use your computer\'s IP address\n'
                        '4. Update the apiUrl in the code accordingly',
                    style: TextStyle(
                      color: Colors.amber.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
