import 'dart:math';
import 'package:alice_tv/app/screens/add_video_page.dart';
import 'package:alice_tv/app/screens/video_play_page.dart';
import 'package:alice_tv/app/store/video_store.dart';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatefulWidget {
  final VideoStore store;

  const HomePage({super.key, required this.store});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
  }

  void _showMathDialog(BuildContext context) {
    final random = Random();
    int num1 = random.nextInt(10) + 1;
    int num2 = random.nextInt(10) + 1;
    int correctAnswer = num1 + num2;
    final TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Responda para continuar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Qual é a soma de $num1 + $num2?'),
              TextField(
                controller: answerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Sua resposta'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (int.tryParse(answerController.text) == correctAnswer) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddVideoPage(store: widget.store),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resposta incorreta. Tente novamente!')),
                  );
                }
              },
              child: const Text('Verificar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Alice TV',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'AliceTv',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'por Jmalvino',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Adicionar Novo Vídeo'),
              onTap: () {
                _showMathDialog(context);
              },
            ),
          ],
        ),
      ),
      body: isConnected
          ? Observer(
        builder: (_) {
          final videos = widget.store.videoData;
          final recentVideos = videos.length > 10 ? videos.skip(videos.length - 10).toList() : videos.toList();

          return Column(
            children: [
              const Text(
                'Adicionado Recentemente',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentVideos.length,
                  itemBuilder: (context, index) {
                    String videoLink = recentVideos[index]['link']!;
                    String videoId = YoutubePlayer.convertUrlToId(videoLink)!;
                    String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerPage(videoId: videoId),
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.all(8),
                        child: Image.network(thumbnailUrl, fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
              const Text(
                'Assistir',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    String videoLink = videos[index]['link']!;
                    String videoId = YoutubePlayer.convertUrlToId(videoLink)!;
                    String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerPage(videoId: videoId),
                          ),
                        );
                      },
                      child: Card(
                        child: SizedBox(
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(thumbnailUrl, fit: BoxFit.cover),
                              ),
                            ],
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
      )
          : const Center(
        child: Text(
          'Este app só funciona com internet.\nCaso não tenha videos adicione no menu no canto superior esquerdo!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
  }
}