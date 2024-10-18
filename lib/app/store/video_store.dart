import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
part 'video_store.g.dart';

class VideoStore = _VideoStoreBase with _$VideoStore;

abstract class _VideoStoreBase with Store {
  @observable
  ObservableList<Map<String, String>> videoData = ObservableList<Map<String, String>>();

  final String apiKey = 'API_KEY';

  @action
  Future<void> loadVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> videoLinks = prefs.getStringList('videos') ?? [];
    videoData.clear();

    for (String link in videoLinks) {
      String videoId = YoutubePlayer.convertUrlToId(link)!;
      String title = await fetchVideoTitle(videoId);
      videoData.add({'link': link, 'title': title});
    }
  }

  @action
  Future<void> addVideo(String videoLink) async {
    String videoId = YoutubePlayer.convertUrlToId(videoLink)!;
    String title = await fetchVideoTitle(videoId);

    videoData.add({'link': videoLink, 'title': title});

    await saveVideos();
  }

  @action
  Future<void> saveVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedLinks = videoData.map((data) => data['link']!).toList();
    await prefs.setStringList('videos', savedLinks);
  }

  Future<String> fetchVideoTitle(String videoId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$videoId&key=$apiKey'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['items'].isNotEmpty) {
          return data['items'][0]['snippet']['title'];
        } else {
          throw Exception('Vídeo não encontrado.');
        }
      } else {
        throw Exception('Falha ao carregar o título do vídeo. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
      return 'Título indisponível';
    }
  }

}