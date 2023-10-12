import 'package:flow_app/providers/game_code.dart';
import 'package:flow_app/screen/Join/username_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final TextEditingController _gameCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: TextField(
                  controller: _gameCodeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.7),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'GAME CODE',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Update the joinCode in the provider
                  Provider.of<JoinGameCodeProvider>(context, listen: false)
                      .updateCode(_gameCodeController.text);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          UserNamePage(), // Use the Firebase URL here
                    ),
                  );
                  // Additional logic can be added here, like navigating to another page or validating the game code
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('CONTINUE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
