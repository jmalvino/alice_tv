import 'package:alice_tv/app/screens/add_video_page.dart';
import 'package:alice_tv/app/screens/video_play_page.dart';
import 'package:alice_tv/app/store/video_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatelessWidget {
  final VideoStore store;

  HomePage({required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Vídeos')),
      body: Observer(
        builder: (_) {
          return ListView.builder(
            itemCount: store.videoData.length,
            itemBuilder: (context, index) {
              String videoLink = store.videoData[index]['link']!;
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
                  child: Column(
                    children: [
                      Image.network(thumbnailUrl), // Exibe a miniatura
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddVideoPage(store: store)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}