// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VideoStore on _VideoStoreBase, Store {
  late final _$videoDataAtom =
      Atom(name: '_VideoStoreBase.videoData', context: context);

  @override
  ObservableList<Map<String, String>> get videoData {
    _$videoDataAtom.reportRead();
    return super.videoData;
  }

  @override
  set videoData(ObservableList<Map<String, String>> value) {
    _$videoDataAtom.reportWrite(value, super.videoData, () {
      super.videoData = value;
    });
  }

  late final _$loadVideosAsyncAction =
      AsyncAction('_VideoStoreBase.loadVideos', context: context);

  @override
  Future<void> loadVideos() {
    return _$loadVideosAsyncAction.run(() => super.loadVideos());
  }

  late final _$addVideoAsyncAction =
      AsyncAction('_VideoStoreBase.addVideo', context: context);

  @override
  Future<void> addVideo(String videoLink) {
    return _$addVideoAsyncAction.run(() => super.addVideo(videoLink));
  }

  @override
  String toString() {
    return '''
videoData: ${videoData}
    ''';
  }
}
