import 'package:alice_tv/app/store/video_store.dart';
import 'package:flutter/material.dart';

class AddVideoPage extends StatelessWidget {
  final VideoStore store;
  final TextEditingController _controller = TextEditingController();

  AddVideoPage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Vídeo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Link do Vídeo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                store.addVideo(_controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
