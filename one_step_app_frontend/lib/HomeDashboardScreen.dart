import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:one_step_app_flutter/goal_details_screen.dart';
import 'GoalCreationScreen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  String? token;
  List<Map<String, String>> userGoals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchGoals();
  }

  Future<void> _loadTokenAndFetchGoals() async {
    final secureStorage = FlutterSecureStorage();
    final storedToken = await secureStorage.read(key: 'jwt');

    print('Retrieved token from SecuredStorage: $storedToken');

    if (storedToken == null) {
      print('No token found — user is not authenticated');
      return;
    }

    setState(() {
      token = storedToken;
    });

    await fetchGoals();
  }

  Future<void> fetchGoals() async {
    if (token == null) {
      print('Token is null, aborting fetchGoals');
      return;
    }

    print('Using token: $token');

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.121:8080/api/goals/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('GET /api/goals/user response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          userGoals = data.map((goal) => {
                'goalId': goal['goalId'].toString(),
                'title': goal['title']?.toString() ?? 'Untitled',
                'status': goal['status']?.toString() ?? 'Incomplete',
                'description': goal['description']?.toString() ?? '',
              }).toList();
          isLoading = false;
        });
      } else {
        print('Failed to fetch goals: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching goals: $e');
    }
  }

  Future<Map<String, String>> fetchCurrentStep(String goalId) async {
    final url = 'http://192.168.1.121:8080/api/goals/steps/$goalId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> steps = jsonDecode(response.body);

        if (steps.isEmpty) {
          return {'title': 'No steps', 'status': 'N/A'};
        }

        final current = steps.firstWhere(
          (s) => s['status'] != 'Complete',
          orElse: () => steps.first,
        );

        return {
          'title': current['title'] ?? 'Step',
          'status': current['status'] ?? 'PENDING',
        };
      } else {
        print('Failed to fetch steps for goal $goalId');
      }
    } catch (e) {
      print('Error fetching steps: $e');
    }

    return {'title': 'Unknown', 'status': 'Unknown'};
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffe6e6e6),
      body: Row(
        children: [
          // Left Panel
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffd5d1bf),
              border: Border.all(color: const Color(0xff1d2528), width: 5.0),
            ),
            width: screenWidth * 0.50,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _labelText('Your Goals'),
                const SizedBox(height: 24),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  ...userGoals.map((goal) => _goalRow(goal)).toList(),
                const SizedBox(height: 32),
                _buttonBox(
                  label: 'Create New Goal',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GoalCreationScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Right Panel - Progress
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffd5d1bf),
                border: Border.all(color: const Color(0xff1d2528), width: 5.0),
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buttonBox(
                    label: 'View Progress',
                    onPressed: () {
                      // TODO: Navigate to progress screen
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'JetBrainsMono Nerd Font',
        fontSize: 36,
        color: Color(0xff1d2528),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _goalRow(Map<String, String> goal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _goalBox(goal),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: _statusBox(goal['status'] ?? ''),
          ),
        ],
      ),
    );
  }

 Widget _goalBox(Map<String, String> goal) {
  final goalId = goal['goalId'];
  final goalTitle = goal['title'];
  final goalDescription = goal['description'];

  return GestureDetector(
    onTap: () {
      print('Tapped goalId: $goalId');
      if (goalId == null || goalTitle == null || goalDescription == null) {
        print(' Null value passed to GoalDetailsScreen');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Goal data missing")),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoalDetailsScreen(
            goalId: goalId,
            goalTitle: goalTitle,
            goalDescription: goalDescription,
          ),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xffe6e6e6),
        border: Border.all(color: const Color(0xff707070)),
      ),
      child: Text(
        goalTitle ?? 'Untitled',
        style: const TextStyle(
          fontFamily: 'JetBrainsMono Nerd Font',
          fontSize: 20,
          color: Color(0xff1d2528),
        ),
      ),
    ),
  );
}


  Widget _statusBox(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xffd9f316),
        border: Border.all(color: const Color(0xff707070)),
      ),
      child: Center(
        child: Text(
          status,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono Nerd Font',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff1d2528),
          ),
        ),
      ),
    );
  }

  Widget _buttonBox({required String label, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 320,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xffd9f316),
          border: Border.all(color: Color(0xff1d2528), width: 4),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono Nerd Font',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff1d2528),
            ),
          ),
        ),
      ),
    );
  }
}
