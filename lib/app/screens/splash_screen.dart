import 'package:alice_tv/app/screens/home_page.dart';
import 'package:alice_tv/app/store/video_store.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VideoStore store;
  const SplashScreen({super.key, required this.store});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(
        const Duration(seconds: 4));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          store: VideoStore(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
            child: Image.asset('assets/images/logo_alice_tv.png')),
      ),
    );
  }
}
