import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GoalDetailsScreen extends StatefulWidget {
  final String goalId;
  final String goalTitle;
  final String goalDescription;

  const GoalDetailsScreen({
    super.key,
    required this.goalId,
    required this.goalTitle,
    required this.goalDescription,
  });

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  Map<String, dynamic>? currentStep;
  bool isLoading = true;
  final storage = FlutterSecureStorage();
  String? token;

  @override
  void initState() {
    super.initState();
    print('GoalDetails init with id: ${widget.goalId}');
    _loadTokenAndFetchStep();
  }

  Future<void> _loadTokenAndFetchStep() async {
    final t = await storage.read(key: 'jwt');
    if (t == null) {
      print('No token found');
      return;
    }
    setState(() {
      token = t;
    });
    _fetchCurrentStep();
  }

  Future<void> _fetchCurrentStep() async {
    if (token == null) return;

    try {
      final goalId = widget.goalId;
      if (goalId.isEmpty) {
        print('Invalid goalId passed to screen');
        return;
      }

      final url = Uri.parse('http://192.168.1.121:8080/api/goals/steps/${widget.goalId}');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final steps = json.decode(response.body);
        final firstIncomplete = steps.firstWhere(
          (step) => step['status'] != 'COMPLETED',
          orElse: () => null,
        );

        setState(() {
          currentStep = firstIncomplete;
          isLoading = false;
        });
      } else {
        print('Failed to fetch steps: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching steps: $e');
    }
  }

  Future<void> _postToEndpoint(String endpoint) async {
    if (token == null) return;

    final url = Uri.parse('http://192.168.1.121:8080$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        _showSnackBar('Action successful');
        _fetchCurrentStep(); // refresh step view
      } else {
        _showSnackBar('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting to $endpoint: $e');
      _showSnackBar('Error connecting to server.');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToManualStepCreation() {
    // Placeholder: Replace with your actual screen
    _showSnackBar("Navigate to manual step creation screen.");
  }

  @override
  Widget build(BuildContext context) {
    print("GoalDetailsScreen opened with ID: ${widget.goalId}");
    return Scaffold(
      appBar: AppBar(title: Text(widget.goalTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Goal: ${widget.goalDescription}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  currentStep != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Current Step:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(currentStep!['stepDescription'] ?? 'No description'),
                            Text("Status: ${currentStep!['status']}"),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => _postToEndpoint('/steps/complete/${widget.goalId}'),
                              child: const Text('Mark Step as Complete'),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => _postToEndpoint('/steps/skip/${widget.goalId}'),
                              child: const Text('Skip Step'),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _navigateToManualStepCreation,
                              child: const Text('Create Manual Step'),
                            ),
                          ],
                        )
                      : const Text('No incomplete steps found.'),
                ],
              ),
      ),
    );
  }
}
