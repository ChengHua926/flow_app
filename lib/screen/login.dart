// ignore_for_file: camel_case_types, unused_import

import 'package:flow_app/main.dart';
import 'package:flow_app/providers/game_code.dart';
import 'package:flow_app/screen/image_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StartPage extends StatelessWidget {
  const StartPage({super.key});

Future<void> uploadRandomNumberToFirebase(int randomNumber) async {
  // Use Firestore instance
  final firestoreInstance = FirebaseFirestore.instance;
  print(randomNumber);

  // Reference to the specific game session document using the random number
  final gameSessionDocRef = firestoreInstance.collection('game sessions').doc(randomNumber.toString());

  // Set the game info for this game session
  await gameSessionDocRef.set({
    'image url': '',  // You can update this with the actual imageUrl later
    'audio url': '',  // You can update this with the actual audioUrl later
  });

  // Add "test user" directly as a document under the "players" sub-collection
  await gameSessionDocRef.collection('players').doc('test user').set({
    'joinedAt': DateTime.now(),  // Example field, you can add more fields as needed
  });
}


  int generateRandomNumber() {
    final random = Random();
    final randomNumber = random.nextInt(900000) +
        100000; // Generates a random number between 100000 and 999999

    //print(randomeNumber.toString());
    return randomNumber;
  }

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
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  shadowColor: Colors.black.withOpacity(0.1),
                  elevation: 5.0,
                ),
                onPressed: () async {
                  final randomNumber = generateRandomNumber();
                  await uploadRandomNumberToFirebase(randomNumber);
                  final gameCodeProvider =
                      Provider.of<GameCodeProvider>(context, listen: false);
                  gameCodeProvider.updateCode(randomNumber.toString());
                  print("provider game code: " + gameCodeProvider.code);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage(), // Use the Firebase URL here
                    ),
                  );
                },
                child: const Text('Create'),
              ),
              const SizedBox(
                  height: 20), // Provides some spacing between the buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  shadowColor: Colors.black.withOpacity(0.1),
                  elevation: 5.0,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ImageCardPage(), // Use the Firebase URL here
                    ),
                  );
                },
                child: const Text('History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
