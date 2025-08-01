import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:one_step_app_flutter/screens/goal_details_screen.dart';
import 'package:one_step_app_flutter/screens/progress_screen.dart';
import 'GoalCreationScreen.dart';
import '../widgets/appbar_with_logout.dart';

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
        Uri.parse('http://192.168.1.11:8080/api/goals/user'),
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
                'goalStatus': goal['goalStatus']?.toString() ?? 'Incomplete',
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
    final url = 'http://192.168.1.11:8080/api/goals/steps/$goalId';

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
  return Scaffold(
    appBar: buildAppBarWithLogout(context, 'Dashboard'),
    backgroundColor: const Color(0xffe6e6e6),
    body: SingleChildScrollView( child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center (
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _labelText('Your Goals'),
          const SizedBox(height: 24),
          if (isLoading)
            const CircularProgressIndicator()
          else if (userGoals.isEmpty)
            const Text("No goals found. Start by creating one.")
          else
            ...userGoals.map((goal) => _goalRow(goal)).toList(),
          const SizedBox(height: 32),
          _buttonBox(
            label: 'Create New Goal',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GoalCreationScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _buttonBox(
            label: 'View Progress',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProgressScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    ),
   ),
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
            child: _statusBox(goal['goalStatus'] ?? ''),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1, 
            child: _deleteBox(goal['goalId'] ?? ''),
          )
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

  Widget _deleteBox(String goalId) {
  return GestureDetector(
    onTap: () async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this goal?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'jwt');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No auth token found")),
        );
        return;
      }

      final url = Uri.parse('http://192.168.1.11:8080/api/goals/$goalId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          userGoals.removeWhere((goal) => goal['goalId'] == goalId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Goal deleted successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete goal: ${response.statusCode}")),
        );
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xffd9f316),
        border: Border.all(color: const Color(0xff707070)),
      ),
      child: const Center(
        child: Text(
          'Delete Goal',
          style: TextStyle(
            fontFamily: 'JetBrainsMono Nerd Font',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff1d2528),
          ),
        ),
      ),
    ),
  );
}

}
