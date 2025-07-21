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
    await _fetchCurrentStep();
  }

  Future<void> _fetchCurrentStep() async {
    if (token == null) return;

    final url = Uri.parse('http://192.168.1.121:8080/steps/goal/${widget.goalId}/current');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final step = json.decode(response.body);
      setState(() {
        currentStep = step;
        isLoading = false;
      });
    } else {
      setState(() {
        currentStep = null;
        isLoading = false;
      });
    }
  }

  Future<void> _putToEndpoint(String endpoint) async {
    if (token == null) return;
    final url = Uri.parse('http://192.168.1.121:8080$endpoint');

    try {
      final response = await http.put(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        _showSnackBar('Action successful');
        _fetchCurrentStep();
      } else {
        _showSnackBar('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Failed to connect to server');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToManualStepCreation() {
    _showSnackBar('Manual Step Creation not implemented yet.');
  }

  void _generateStepPlaceholder() {
    _showSnackBar('Generate Step not implemented yet.');
  }

  Widget _buildRectBox(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'JetBrainsMono Nerd Font',
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback? onPressed, {bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffd9f316),
          foregroundColor: const Color(0xff1d2528),
          textStyle: const TextStyle(
            fontFamily: 'JetBrainsMono Nerd Font',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentStepText = currentStep != null
        ? currentStep!['stepDescription'] ?? 'No description'
        : 'No steps have been created for this goal.';

    final String statusText = currentStep != null
        ? currentStep!['status'] ?? 'Unknown'
        : 'None';

    return Scaffold(
      backgroundColor: const Color(0xffe6e6e6),
      appBar: AppBar(
        backgroundColor: const Color(0xff1d2528),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.goalTitle,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono Nerd Font',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
    body: isLoading
    ? const Center(child: CircularProgressIndicator())
    : Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black87, width: 2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRectBox('Goal Description', widget.goalDescription),
                _buildRectBox('Current Step', currentStep != null ? currentStep!['stepDescription'] ?? 'No description' : 'No steps have been created for this goal.'),
                _buildRectBox('Step Status', currentStep != null ? currentStep!['status'] ?? 'Unknown' : 'None'),
                const SizedBox(height: 16),
                _buildButton(
                  'Mark Step as Complete',
                  currentStep != null
                      ? () => _putToEndpoint('/steps/update/mark-complete/${currentStep!['stepId']}')
                      : null,
                  enabled: currentStep != null,
                ),
                _buildButton(
                  'Skip Step',
                  currentStep != null
                      ? () => _putToEndpoint('/steps/skip/${currentStep!['stepId']}')
                      : null,
                  enabled: currentStep != null,
                ),
                _buildButton('Create Manual Step', _navigateToManualStepCreation),
                _buildButton('Generate Step', _generateStepPlaceholder),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
