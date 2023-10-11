import 'package:flow_app/providers/game_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the game code from the provider
    final gameCode = Provider.of<GameCodeProvider>(context).code;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF83a4d4), Color(0xFFb6fbff)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Game Code",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 200, // Adjust as needed
                height: 100, // Adjust as needed
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7), // Translucent white
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    gameCode,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
