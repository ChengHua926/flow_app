// // ... (rest of your imports)

// class CodePage extends StatefulWidget {
//   @override
//   _CodePageState createState() => _CodePageState();
// }

// class _CodePageState extends State<CodePage> {
//   // ... (rest of your class variables)

//   @override
//   Widget build(BuildContext context) {
//     // ... (rest of your build method)

//     return Scaffold(
//       // ... (rest of your Scaffold)

//       child: Column(
//         children: [
//           // ... (rest of your Column children)

//           StreamBuilder<Duration>(
//             stream: jplayer.positionStream,
//             builder: (context, positionSnapshot) {
//               final position = positionSnapshot.data ?? Duration.zero;
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "${position.inMinutes}:${position.inSeconds.remainder(60).toString().padLeft(2, '0')}", // Formatting the position to MM:SS format
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Expanded(
//                       child: Slider(
//                         onChanged: (newValue) {
//                           jplayer.seek(Duration(milliseconds: newValue.toInt()));
//                         },
//                         value: position.inMilliseconds.toDouble(),
//                         max: jplayer.duration?.inMilliseconds.toDouble() ?? 100.0,
//                       ),
//                     ),
//                     StreamBuilder<Duration>(
//                       stream: jplayer.durationStream.map((event) => event ?? Duration.zero),
//                       builder: (context, durationSnapshot) {
//                         final duration = durationSnapshot.data ?? Duration.zero;
//                         return Text(
//                           "${duration.inMinutes}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}", // Formatting the duration to MM:SS format
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),

//           // ... (rest of your Column children)
//         ],
//       ),
//     );
//   }
// }
