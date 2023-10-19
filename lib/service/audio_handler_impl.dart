import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_aplayer/extension.dart';
import 'package:flutter_audio/core.dart';
import 'package:just_audio/just_audio.dart';

class AudioHandlerImpl extends BaseAudioHandler with QueueHandler, SeekHandler {
  late AudioPlayer _player;
  Song? _currentSong;
  final List<Song> _songs = <Song>[];

  AudioHandlerImpl() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _player = AudioPlayer();
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      final queueIndex = _currentSong != null ? _songs.indexOf(_currentSong!) : 0;

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
  }

  setQueue(List<Song> songs) {
    this._songs.addAll(songs);
    updateQueue(songs.map((e) => e.toMediaItem()).toList());
  }

  Future<void> setSong(Song song) async {
    _currentSong = song;
    mediaItem.add(song.toMediaItem());
    await _player.setAudioSource(ProgressiveAudioSource(Uri.parse(song.uri)));
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _songs.length) {
      return;
    }
    await setSong(_songs[index]);
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
