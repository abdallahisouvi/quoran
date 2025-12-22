import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const QuranAudioApp());
}

class QuranAudioApp extends StatelessWidget {
  const QuranAudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(primarySwatch: Colors.green),
      darkTheme: ThemeData.dark(),
      home: const SurahListScreen(),
    );
  }
}

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final AudioPlayer player = AudioPlayer();

  List surahs = [];
  int currentIndex = -1;
  bool isPlaying = false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    loadSurahs();

    player.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });

    player.onPositionChanged.listen((p) {
      setState(() => position = p);
    });

    player.onPlayerComplete.listen((event) {
      playNext();
    });
  }

  Future<void> loadSurahs() async {
    final data = await rootBundle.loadString('assets/data/surahs.json');
    setState(() {
      surahs = json.decode(data);
    });
  }

  Future<void> playSurah(int index) async {
    currentIndex = index;
    await player.play(
      AssetSource('audio/${surahs[index]['id']}.mp3'),
    );
    setState(() => isPlaying = true);
  }

  Future<void> pauseSurah() async {
    await player.pause();
    setState(() => isPlaying = false);
  }

  Future<void> stopSurah() async {
    await player.stop();
    setState(() {
      isPlaying = false;
      position = Duration.zero;
    });
  }

  void playNext() {
    if (currentIndex + 1 < surahs.length) {
      playSurah(currentIndex + 1);
    }
  }

  String formatTime(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📖 المصحف الصوتي')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(surahs[index]['name']),
                  leading: Icon(
                    currentIndex == index && isPlaying
                        ? Icons.volume_up
                        : Icons.play_arrow,
                  ),
                  onTap: () => playSurah(index),
                );
              },
            ),
          ),

          if (currentIndex != -1)
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // شريط التقدم
                  Slider(
                    value: position.inSeconds.toDouble(),
                    max: duration.inSeconds.toDouble() == 0
                        ? 1
                        : duration.inSeconds.toDouble(),
                    onChanged: (value) async {
                      await player.seek(
                        Duration(seconds: value.toInt()),
                      );
                    },
                  ),

                  // الوقت
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(position)),
                      Text(formatTime(duration)),
                    ],
                  ),

                  // أزرار التحكم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 34,
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: () {
                          isPlaying
                              ? pauseSurah()
                              : playSurah(currentIndex);
                        },
                      ),
                      IconButton(
                        iconSize: 34,
                        icon: const Icon(Icons.stop),
                        onPressed: stopSurah,
                      ),
                      IconButton(
                        iconSize: 34,
                        icon: const Icon(Icons.skip_next),
                        onPressed: playNext,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
