import 'package:flutter/material.dart';

class HomeDashboardScreen extends StatelessWidget {
  final List<String> userGoals = ['Goal 1', 'Goal 2'];

   HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffe6e6e6),
      body: Row(
        children: [
          // Left Panel - Goal List and Creation
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffd5d1bf),
              border: Border.all(
                color: const Color(0xff1d2528),
                width: 5.0,
                ), 
              ),
            width: screenWidth * 0.50,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _labelText('Your Goals'),
                const SizedBox(height: 24),
                ...userGoals.map((goal) => _goalBox(goal)).toList(),
                const SizedBox(
                  height: 32 ),
                _buttonBox(
                  label: 'Create New Goal',
                  onPressed: () {
                    // TODO: Navigate to goal creation screen
                  },
                ),
              ],
            ),
          ),

          // Right Panel - Progress Summary
          Expanded(
            child: Container(
             decoration: BoxDecoration(
              color: const Color(0xffd5d1bf),
              border: Border.all(
                color: const Color(0xff1d2528),
                width: 5.0,
                ), 
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: _buttonBox(
                      label: 'View Progress',
                      onPressed: () {
                        // TODO: Navigate to progress screen
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

 /* Widget _titleText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'JetBrainsMono Nerd Font',
        fontSize: 52,
        color: Color(0xff1d2528),
        fontWeight: FontWeight.w700,
      ),
    );
  } */

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

  Widget _goalBox(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xffe6e6e6),
        border: Border.all(color: const Color(0xff707070)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono Nerd Font',
          fontSize: 28,
          color: Color(0xff1d2528),
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
          border: Border.all(color: const Color(0xff1d2528), width: 4),
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
