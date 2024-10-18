import 'package:alice_tv/app/screens/add_video_page.dart';
import 'package:alice_tv/app/store/video_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class HomePage extends StatefulWidget {
  final VideoStore store;

  HomePage({required this.store});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen ? null : AppBar(title: const Text('Lista de Vídeos')),
      body: Observer(
        builder: (_) {
          return ListView.builder(
            itemCount: widget.store.videoData.length,
            itemBuilder: (context, index) {
              String videoLink = widget.store.videoData[index]['link']!;
              String videoId = YoutubePlayer.convertUrlToId(videoLink)!;

              YoutubePlayerController _controller = YoutubePlayerController(
                initialVideoId: videoId,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  hideControls: false,
                  controlsVisibleAtStart: true,
                  enableCaption: false,
                ),
              );

              return Card(
                child: YoutubePlayerBuilder(
                  onEnterFullScreen: () {
                    setState(() {
                      _isFullScreen = true;
                    });
                  },
                  onExitFullScreen: () {
                    setState(() {
                      _isFullScreen = false;
                    });
                  },
                  player: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    onReady: () {
                      // Player pronto
                    },
                  ),
                  builder: (context, player) {
                    return Column(
                      children: [
                        player,
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: _isFullScreen
          ? null
          : FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddVideoPage(store: widget.store)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}