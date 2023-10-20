import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_aplayer/abilities.dart';
import 'package:flutter_aplayer/extension.dart';
import 'package:flutter_audio/core.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';

const _keyLastSongId = "key_last_song_id";
const _keyQueue = "key_queue";

class AudioHandlerImpl extends BaseAudioHandler with QueueHandler, SeekHandler {
  late AudioPlayer _player;
  Box? cacheBox = Hive.isBoxOpen("cache") ? Hive.box("cache") : null;
  Song? _currentSong;
  final List<Song> _queue = <Song>[];
  final List<Song> _allSongs = <Song>[];

  AudioHandlerImpl() {
    _init();
  }

  void _restore() async {
    _allSongs.clear();
    _allSongs.addAll(await Abilities.instance.querySongs());

    // restore queue
    var ids = cacheBox?.get(_keyQueue);
    if (ids != null) {
      ids = List.castFrom<dynamic, num>(ids);
      final List<Song> queue = <Song>[];
      for (final id in ids) {
        final song = _allSongs.where((e) => e.id == id).firstOrNull;
        if (song != null) {
          queue.add(song);
        }
      }
      setQueue(queue);

      // restore last song
      final lastSongId = cacheBox?.get(_keyLastSongId, defaultValue: -1);
      final lastSong = lastSongId > 0
          ? queue.where((e) => e.id == lastSongId).firstOrNull
          : null;
      if (lastSong != null) {
        setSong(lastSong);
      }
    }
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _player = AudioPlayer();
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      final queueIndex =
          _currentSong != null ? _queue.indexOf(_currentSong!) : 0;

      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: queueIndex,
      ));
    });

    _restore();
  }

  setQueue(List<Song> songs) {
    _queue.addAll(songs);
    cacheBox?.put(_keyQueue, songs.map((e) => e.id).toList());
    updateQueue(songs.map((e) => e.toMediaItem()).toList());
  }

  Future<void> setSong(Song song) async {
    _currentSong = song;
    mediaItem.add(song.toMediaItem());
    cacheBox?.put(_keyLastSongId, song.id);
    await _player.setAudioSource(ProgressiveAudioSource(Uri.parse(song.uri)));
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _queue.length) {
      return;
    }
    await setSong(_queue[index]);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() {
    return _player.stop();
  }

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) {
    return super.customAction(name, extras);
  }
}
