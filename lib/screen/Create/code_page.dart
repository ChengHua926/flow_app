import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow_app/providers/game_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

class CodePage extends StatefulWidget {
  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  final AudioPlayer jplayer = AudioPlayer();
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  bool isUrlSet = false;

  @override
  void dispose() {
    jplayer.stop(); // Stop the audio playback
    jplayer.dispose();
    isPlaying.dispose();
    super.dispose();
  }

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120.0, bottom: 10.0),
              child: Text(
                "Game Code: $gameCode",
                style: const TextStyle(
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
                    return const Center(child: Text('No students has joined.'));
                  }
                  final players = snapshot.data!.docs;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          '${players.length} students have joined',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            final playerName = players[index].id;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  playerName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            StreamBuilder<Duration>(
              stream: jplayer.positionStream,
              builder: (context, positionSnapshot) {
                final position = positionSnapshot.data ?? Duration.zero;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${position.inMinutes}:${position.inSeconds.remainder(60).toString().padLeft(2, '0')}", // Formatting the position to MM:SS format
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          onChanged: (newValue) {
                            jplayer
                                .seek(Duration(milliseconds: newValue.toInt()));
                          },
                          value: position.inMilliseconds.toDouble(),
                          max: jplayer.duration?.inMilliseconds.toDouble() ??
                              100.0,
                        ),
                      ),
                      StreamBuilder<Duration>(
                        stream: jplayer.durationStream
                            .map((event) => event ?? Duration.zero),
                        builder: (context, durationSnapshot) {
                          final duration =
                              durationSnapshot.data ?? Duration.zero;
                          return Text(
                            "${duration.inMinutes}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}", // Formatting the duration to MM:SS format
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            // StreamBuilder<Duration>(
            //   stream: jplayer.positionStream,
            //   builder: (context, snapshot) {
            //     final position = snapshot.data ?? Duration.zero;
            //     return Slider(
            //       onChanged: (newValue) {
            //         jplayer.seek(Duration(milliseconds: newValue.toInt()));
            //       },
            //       value: position.inMilliseconds.toDouble(),
            //       max: jplayer.duration?.inMilliseconds.toDouble() ?? 100.0,
            //     );
            //   },
            // ),
            ValueListenableBuilder<bool>(
              valueListenable: isPlaying,
              builder: (context, isPlayingValue, child) {
                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () async {
                          if (!isPlayingValue) {
                            if (!isUrlSet) {
                              DocumentSnapshot gameSession =
                                  await FirebaseFirestore.instance
                                      .collection('game sessions')
                                      .doc(gameCode)
                                      .get();

                              String? audioUrl = (gameSession.data()
                                  as Map<String, dynamic>)['audio url'];

                              if (audioUrl != null && audioUrl.isNotEmpty) {
                                await jplayer.setUrl(audioUrl);
                                isUrlSet = true;
                              } else {
                                print("Audio URL not found or is empty");
                                return;
                              }
                            }
                            jplayer.play();
                          } else {
                            jplayer.pause();
                          }
                          isPlaying.value = !isPlayingValue;
                        },
                        backgroundColor: Colors.black,
                        child: Icon(
                            isPlayingValue ? Icons.pause : Icons.play_arrow),
                      ),
                      const SizedBox(height: 10),
                      // const Text(
                      //   "Play",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.black,
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
