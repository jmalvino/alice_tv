import 'package:alice_tv/app/screens/widget/circular_progress.dart';
import 'package:alice_tv/app/store/video_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'list/list_por_idade.dart';

class AddVideoPage extends StatefulWidget {
  final VideoStore store;

  const AddVideoPage({super.key, required this.store});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isCheckboxSelected = false;
  bool _linkPred = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        title: GestureDetector(
          onDoubleTap: () {
            setState(() {
              _linkPred = !_linkPred;
            });
          },
          child: const Text(
            'Adicione links do Youtube',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: 'Link do Vídeo'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    _addVideo();
                  },
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Observer(
                builder: (_) {
                  return ListView.builder(
                    itemCount: widget.store.videoData.length,
                    itemBuilder: (context, index) {
                      var reversedVideoData =
                          widget.store.videoData.reversed.toList();

                      String videoLink = reversedVideoData[index]['link']!;
                      String videoId = YoutubePlayer.convertUrlToId(videoLink)!;
                      String thumbnailUrl =
                          'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

                      return Card(
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CachedNetworkImage(
                              imageUrl: thumbnailUrl,
                              placeholder: (context, url) =>
                                  const CircularProgress(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          title: Text('Vídeo ${index + 1}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmation(context, index);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: _linkPred,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CheckboxListTile(
                  title: const Text(
                    'Adicionar links predefinidos',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  value: _isCheckboxSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCheckboxSelected = value ?? false;
                    });
                  },
                ),
              ),
            ),
            Visibility(
              visible: widget.store.videoData.length > 1,
              child: GestureDetector(
                onTap: () {
                  _showDeleteAllConfirmation(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            'Apagar todos os videos',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addVideo() async {
    if (_controller.text.isNotEmpty) {
      await widget.store.addVideo(_controller.text);
      _controller.clear();
    }

    if (_isCheckboxSelected) {
      for (String link in predefinedLinks) {
        bool exists =
            widget.store.videoData.any((video) => video['link'] == link);
        if (!exists) {
          await widget.store.addVideo(link);
        }
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    int originalIndex = widget.store.videoData.length - 1 - index;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content:
              const Text('Você tem certeza que deseja excluir este vídeo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                widget.store.videoData.removeAt(originalIndex);
                widget.store.saveVideos();
                Navigator.of(context).pop();
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content:
              const Text('Você tem certeza que deseja excluir todos os vídeos?'
                  '\nAtenção:\nEssa ação não pode ser desfeita!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                widget.store.videoData.clear();
                widget.store.saveVideos();
                Navigator.of(context).pop();
              },
              child: const Text('Excluir Todos'),
            ),
          ],
        );
      },
    );
  }
}
