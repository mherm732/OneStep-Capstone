import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:one_step_app_flutter/screens/HomeDashboardScreen.dart';
import 'step_creation_screen.dart';

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
    final t = await storage.read(key: 'jwt');
    if (token == null) return;

    final url = Uri.parse('http://192.168.1.121:8080/api/goals/steps/${widget.goalId}/current');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $t',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final step = json.decode(response.body);
      setState(() {
        currentStep = step;
        isLoading = false;
        token = t;
      });
    } else {
      setState(() {
        currentStep = null;
        isLoading = false;
        token = t;
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
        await _fetchCurrentStep();
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
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => StepCreationScreen(
        goalId: widget.goalId, 
        title: widget. goalTitle, 
        description: widget.goalDescription)
      ),
    ).then((_){
    _fetchCurrentStep();  
  });
  }

  void _navigateToHomeDashboard(){
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => HomeDashboardScreen()));
  }

  Future<void> _generateStepFromAI() async {
  if (token == null) {
    _showSnackBar('No token found. Please log in again.');
    return;
  }

  final url = Uri.parse('http://192.168.1.121:8080/ai/generateStep?goalId=${widget.goalId}');

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      _showSnackBar('Step generated successfully!');
      await _fetchCurrentStep(); 
    } else {
      _showSnackBar('Failed to generate step: ${response.statusCode}');
    }
  } catch (e) {
    print('Error calling generateStep: $e');
    _showSnackBar('Server error while generating step.');
  }
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
     bool hasActiveStep = currentStep != null;
     String currentStepText = hasActiveStep
        ? currentStep!['stepDescription'] ?? 'No description'
        : 'No steps have been created for this goal.';

     String statusText = hasActiveStep
        ? currentStep!['status'] ?? 'Unknown'
        : 'None';

    return Scaffold(
      backgroundColor: const Color(0xffe6e6e6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(icon: const Icon(Icons.home_filled),
        onPressed: () {
          Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context) => const HomeDashboardScreen()),
            );
          },
        ),
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
                _buildRectBox('Current Step',currentStepText),
                _buildRectBox('Step Status', statusText),
                if (!hasActiveStep) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'You have completed or skipped all steps.\nYou can create a new step or mark this goal as complete.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'JetBrainsMono Nerd Font',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildButton('Create Manual Step', _navigateToManualStepCreation),
                  _buildButton('Generate Step', _generateStepFromAI),
                  _buildButton('Mark Goal as Complete', () {
                    _putToEndpoint('/api/goals/update/complete/${widget.goalId}'); 
                    _navigateToHomeDashboard();
                  }),
                 ] else ...[
                  _buildButton(
                    'Mark Step as Complete',
                    () => _putToEndpoint('/api/goals/steps/update/mark-complete/${currentStep!['stepId']}'),
                  ),
                  _buildButton(
                    'Skip Step',
                    () => _putToEndpoint('/api/goals/steps/skip/${currentStep!['stepId']}'),
                  ),
                  _buildButton('Create Manual Step', _navigateToManualStepCreation),
                  _buildButton('Generate Step', _generateStepFromAI),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
