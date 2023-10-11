import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow_app/providers/game_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

class CodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the game code from the provider
    final gameCode = Provider.of<GameCodeProvider>(context).code;
    final AudioPlayer jplayer = AudioPlayer(); // Create a player

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF83a4d4), Color(0xFFb6fbff)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120.0, bottom: 30.0),
              child: Text(
                "Game Code: $gameCode",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('game sessions')
                    .doc(gameCode)
                    .collection('players')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No players found.'));
                  }
                  final players = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final playerName = players[index].id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            playerName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      // Get the game code from the provider
                      final gameCode =
                          Provider.of<GameCodeProvider>(context, listen: false)
                              .code;

                      // Fetch the audioUrl from Firestore
                      DocumentSnapshot gameSession = await FirebaseFirestore
                          .instance
                          .collection('game sessions')
                          .doc(gameCode)
                          .get();

                      String? audioUrl = (gameSession.data()
                          as Map<String, dynamic>)['audio url'];

                      if (audioUrl != null && audioUrl.isNotEmpty) {
                        final duration = await jplayer.setUrl(audioUrl);
                        jplayer.play();
                      } else {
                        print("Audio URL not found or is empty");
                      }
                    },
                    child: Icon(Icons.play_arrow),
                    backgroundColor: Colors.black,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Play",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}