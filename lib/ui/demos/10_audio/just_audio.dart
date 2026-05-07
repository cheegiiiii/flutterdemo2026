import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart'; // Already in your pubspec!

class AudioApp extends StatefulWidget {
  const AudioApp({super.key});

  @override
  State<AudioApp> createState() => _AudioAppState();
}

class _AudioAppState extends State<AudioApp> {
  late AudioPlayer player;
  late AudioPlayer player2;
  bool isLoaded = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player2 = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      // 1. Verify files ACTUALLY exist in the assets bundle!
      // If the files are missing, it will display a red error in the UI safely.
      try {
        await rootBundle.load('assets/audio/cow.mp3');
        await rootBundle.load('assets/audio/horse.mp3');
      } catch (e) {
        if (mounted) {
          setState(() {
            errorMessage =
                "Missing Files: Please ensure cow.mp3 and horse.mp3 "
                "actually exist inside your flutter_demo_2026/assets/audio/ folder.";
          });
        }
        return;
      }

      // 2. Bypass just_audio's localhost HTTP proxy entirely
      // This guarantees no macOS App Sandbox/ATS network blocks.
      await _loadDirectly(player, 'assets/audio/cow.mp3');
      await _loadDirectly(player2, 'assets/audio/horse.mp3');

      if (mounted) {
        setState(() => isLoaded = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => errorMessage = "Error loading audio: $e");
      }
    }
  }

  // Copies the asset to a temporary local file, allowing us to use
  // setFilePath() which doesn't require a local web server / network permissions.
  Future<void> _loadDirectly(AudioPlayer p, String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${assetPath.replaceAll('/', '_')}');
    await file.writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
    );
    await p.setFilePath(file.path);
  }

  @override
  void dispose() {
    player.dispose();
    player2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10. Audio')),
      body: Center(
        child: errorMessage.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
            : !isLoaded
            ? const CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await player.seek(Duration.zero);
                      player.play();
                    },
                    child: const Text('Cow'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await player2.seek(Duration.zero);
                      player2.play();
                    },
                    child: const Text('Horse'),
                  ),
                ],
              ),
      ),
    );
  }
}
