import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int completedGoals = 0;
  int completedSteps = 0;
  int inProgressGoals = 0;

  @override
  void initState() {
    super.initState();
    _fetchCompletedGoals();
    _fetchCompletedSteps();
    _fetchInProgressGoals();
  }

  Future<void> _fetchCompletedGoals() async {
    const storage = FlutterSecureStorage();
    final t = await storage.read(key: 'jwt');

    if (t == null) {
      print("No token found to get completed goals");
      return;
    }

    final url = Uri.parse('http://192.168.1.121:8080/api/goals/completed');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $t',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> goals = json.decode(response.body);
      setState(() {
        completedGoals = goals.length;
      });
    } else {
      print("Failed to fetch completed goals");
    }
  }

  Future<void> _fetchCompletedSteps() async {
    const storage = FlutterSecureStorage(); 
    final t = await storage.read(key: 'jwt');

    if (t == null) {
      print("No token found to get completed steps");
      return;
    }

    final url = Uri.parse('http://192.168.1.121:8080/api/goals/steps/completed');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $t',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> steps = json.decode(response.body);
      setState(() {
        completedSteps = steps.length;
      });
    } else {
      print("Failed to fetch completed steps");
    }
  }

  Future<void> _fetchInProgressGoals() async {
   const storage = FlutterSecureStorage(); 
    final t = await storage.read(key: 'jwt');

    if (t == null) {
      print("No token found to get in progress goals");
      return;
    }

    final url = Uri.parse('http://192.168.1.121:8080/api/goals/in-progress');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $t',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> inProgressGoalsList = json.decode(response.body);
      setState(() {
        inProgressGoals = inProgressGoalsList.length;
      });
    } else {
      print("Failed to fetch in progress goals");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Progress',
          style: TextStyle(
            fontFamily: 'JetBrainsMono Nerd Font',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xff1d2528),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffd9f316),
        foregroundColor: const Color(0xff1d2528),
        elevation: 0,
      ),
      backgroundColor: const Color(0xffe6e6e6),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel("Your Current Progress"),
            const SizedBox(height: 20),
            _progressBox(title: "Completed Goals", value: "$completedGoals"),
            const SizedBox(height: 16),
            _progressBox(title: "Steps Completed", value: "$completedSteps"),
            const SizedBox(height: 16),
            _progressBox(title: "In-Progress Goals", value: "$inProgressGoals"),
            const SizedBox(height: 40),
            Center(
              child: _buttonBox(
                label: "Back to Dashboard",
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'JetBrainsMono Nerd Font',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Color(0xff1d2528),
      ),
    );
  }

  Widget _progressBox({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xff707070), width: 2),
      ),
      child: Text(
        "$title: $value",
        style: const TextStyle(
          fontFamily: 'JetBrainsMono Nerd Font',
          fontSize: 20,
          color: Color(0xff1d2528),
        ),
      ),
    );
  }

  Widget _buttonBox({required String label, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xffd9f316),
          border: Border.all(color: const Color(0xff1d2528), width: 4),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono Nerd Font',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xff1d2528),
            ),
          ),
        ),
      ),
    );
  }
}
