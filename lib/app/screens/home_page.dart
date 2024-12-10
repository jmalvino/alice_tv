import 'dart:math';
import 'package:alice_tv/app/screens/add_video_page.dart';
import 'package:alice_tv/app/screens/video_play_page.dart';
import 'package:alice_tv/app/store/video_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatefulWidget {
  final VideoStore store;

  const HomePage({super.key, required this.store});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    await widget.store.loadVideos();
    setState(() {
      isLoading = false;
    });
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
                    const SnackBar(
                        content: Text('Resposta incorreta. Tente novamente!')),
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

  void _showDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String chavePix =
            '00020101021126580014br.gov.bcb.pix013649fdd7d3-0411-4c90-a611-2f349932b2c25204000053039865802BR5919JOAO MALVINO JUNIOR6005SOUSA62070503***63040C15';
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/bancoInter.png",
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 16),
              const Text(
                "CHAVE PIX",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                chavePix,
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: chavePix),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Chave PIX copiada para a área de transferência!"),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text("Copiar Chave PIX"),
              ),
            ],
          ),
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
          '',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[800],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/simb_alice_tv.png",
                        width: MediaQuery.of(context).size.width * .2,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'AliceTv',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        'por Jmalvino',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'v.1.0.0',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title:
                  isLoading ? Container() : const Text('Adicionar Novo Vídeo'),
              onTap: () {
                _showMathDialog(context);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(
                Icons.handshake_outlined,
              ),
              title: isLoading
                  ? Container()
                  : const Text(
                      'Apoe o projeto!',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
              onTap: () {
                _showDonationDialog(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Observer(
              builder: (_) {
                final videos = widget.store.videoData;
                if (videos.isEmpty) {
                  return const Center(
                    child: Text(
                      'Não há vídeos disponíveis.\nAdicione novos vídeos no menu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  );
                }

                final recentVideos = videos.length > 10
                    ? videos.skip(videos.length - 10).toList()
                    : videos.toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Adicionado Recentemente',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recentVideos.length,
                        itemBuilder: (context, index) {
                          String videoLink = recentVideos[index]['link']!;
                          String videoId =
                              YoutubePlayer.convertUrlToId(videoLink)!;
                          String thumbnailUrl =
                              'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VideoPlayerPage(videoId: videoId),
                                ),
                              );
                            },
                            child: Container(
                              width: 200,
                              margin: const EdgeInsets.all(8),
                              child: CachedNetworkImage(
                                imageUrl: thumbnailUrl,
                                placeholder: (context, url) => const SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Assistir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: widget.store.videoData.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                              future: Future.delayed(
                                  const Duration(milliseconds: 100), () async {
                                return widget.store.videoData[index];
                              }),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return const Icon(Icons.error,
                                      color: Colors.red);
                                } else if (snapshot.hasData) {
                                  String videoLink = snapshot.data!['link']!;
                                  String videoId =
                                      YoutubePlayer.convertUrlToId(videoLink)!;
                                  String thumbnailUrl =
                                      'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerPage(videoId: videoId),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: CachedNetworkImage(
                                              imageUrl: thumbnailUrl,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
    );
  }
}
