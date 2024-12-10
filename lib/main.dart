import 'package:alice_tv/app/screens/splash_screen.dart';
import 'package:alice_tv/app/store/video_store.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final videoStore = VideoStore();
  await videoStore.loadVideos();

  runApp(MyApp(store: videoStore));
}

class MyApp extends StatefulWidget {
  final VideoStore store;

  const MyApp({super.key, required this.store});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Vídeos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(store: widget.store),
    );
  }
}
