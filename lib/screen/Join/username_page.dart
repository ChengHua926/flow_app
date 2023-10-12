import 'package:firebase_database/firebase_database.dart';
import 'package:flow_app/providers/game_code.dart';
import 'package:flow_app/screen/Join/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class UserNamePage extends StatefulWidget {
  @override
  _UserNamePageState createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final TextEditingController _userNameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Access the JoinGameCodeProvider
    final joinGameCodeProvider =
        Provider.of<JoinGameCodeProvider>(context, listen: false);

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
                  controller: _userNameController,
                  //keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    // Add this style property
                    fontSize: 20, // Adjust the font size as needed
                    fontWeight: FontWeight.bold,
                  ),
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
                    hintText: 'USERNAME',
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
                onPressed: () async {
                  // Get the game code from the provider
                  String gameCode = joinGameCodeProvider.code;

                  // Create a new document under the "players" sub-collection with the username
                  await _firestore
                      .collection('game sessions')
                      .doc(gameCode)
                      .collection('players')
                      .doc(_userNameController.text)
                      .set({});

                  // Fetch the image URL from Firestore based on the game code
                  DocumentSnapshot gameSessionDoc = await _firestore
                      .collection('game sessions')
                      .doc(gameCode)
                      .get();

                  if (gameSessionDoc.exists &&
                      gameSessionDoc.data() is Map<String, dynamic>) {
                    print("exists");
                    Map<String, dynamic> data =
                        gameSessionDoc.data() as Map<String, dynamic>;
                    String imageUrl = data["image url"] ?? "";

                    if (imageUrl.isNotEmpty) {
                      // Set the fetched image URL as the "latestImageUrl" in Firebase Realtime Database
                      final dbRef = FirebaseDatabase.instance
                          .reference(); // Import the necessary package for this
                      await dbRef.child("latestImageUrl").set(imageUrl);
                      print("latest Image URL set successfully");
                    }
                  }

                  // Navigate to webview page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WebViewPage(),
                    ),
                  );
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
                child: const Text('JOIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
