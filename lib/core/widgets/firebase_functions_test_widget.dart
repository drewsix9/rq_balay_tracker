import 'package:flutter/material.dart';

import '../logger/app_logger.dart';
import '../services/firebase_functions_service.dart';

class FirebaseFunctionsTestWidget extends StatefulWidget {
  const FirebaseFunctionsTestWidget({super.key});

  @override
  State<FirebaseFunctionsTestWidget> createState() =>
      _FirebaseFunctionsTestWidgetState();
}

class _FirebaseFunctionsTestWidgetState
    extends State<FirebaseFunctionsTestWidget> {
  bool _isLoading = false;
  String _testResult = '';
  String _errorMessage = '';

  Future<void> _testFirebaseFunctions() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
      _errorMessage = '';
    });

    try {
      final result = await FirebaseFunctionsService.instance
          .testFirebaseFunctions(
            message: 'Test message from RQ Balay Tracker app!',
          );

      setState(() {
        _testResult = '✅ Success!\n\n${result.toString()}';
      });

      AppLogger.d('Test completed successfully: $result');
    } catch (e) {
      setState(() {
        _errorMessage = '❌ Error: $e';
      });
      AppLogger.e('Test failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testPublicFunction() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
      _errorMessage = '';
    });

    try {
      final result = await FirebaseFunctionsService.instance
          .testFirebaseFunctionsPublic(
            message: 'Public test from RQ Balay Tracker app!',
          );

      setState(() {
        _testResult = '✅ Public Test Success!\n\n${result.toString()}';
      });

      AppLogger.d('Public test completed successfully: $result');
    } catch (e) {
      setState(() {
        _errorMessage = '❌ Public Test Error: $e';
      });
      AppLogger.e('Public test failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Firebase Functions Test',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testFirebaseFunctions,
                    child: const Text('Test (Authenticated)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testPublicFunction,
                    child: const Text('Test (Public)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_testResult.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  _testResult,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              )
            else if (_errorMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
