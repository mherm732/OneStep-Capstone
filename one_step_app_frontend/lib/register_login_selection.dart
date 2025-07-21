import 'package:flutter/material.dart';


class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Row(
        children: [
          // Left panel
          Container(
            width: screenWidth * 0.4,
            color: const Color(0xffd5d1bf),
            child: Center(
              child: Text(
                'One Step',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono Nerd Font',
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1d2528),
                ),
              ),
            ),
          ),

          // Right panel
          Expanded(
            child: Container(
              color: const Color(0xff1d2528),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      label: 'Login',
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                    const SizedBox(height: 32),
                    _buildActionButton(
                      label: 'Register',
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffd9f316),
        foregroundColor: const Color(0xff1d2528),
        textStyle: const TextStyle(
          fontFamily: 'JetBrainsMono Nerd Font',
          fontStyle: FontStyle.italic,
          fontSize: 28,
          fontWeight: FontWeight.w300,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
      ),
      child: Text(label),
    );
  }
}
