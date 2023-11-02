import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';
import 'package:flutter_aplayer/setting/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class QueueDialog extends StatelessWidget {
  const QueueDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);

    return StreamBuilder(
        stream: Rx.combineLatest2(audioHandler.mediaItem, audioHandler.queue,
            (mediaItem, queue) {
          return QueueData(mediaItem: mediaItem, queue: queue);
        }),
        builder: (context, snapshot) {
          final queue = snapshot.data?.queue;
          return Container(
            width: double.infinity,
            height: 350,
            color: appTheme.bgColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Text(
                    '播放队列(${queue?.length ?? 0})',
                    style: TextStyle(
                        fontSize: 18,
                        color: appTheme.primaryTextColor,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                queue == null
                    ? const Spacer()
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final mediaItem = queue[index];
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  audioHandler.playMediaItem(mediaItem);
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              mediaItem.title,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: snapshot.data?.mediaItem
                                                      ?.id ==
                                                      mediaItem.id.toString()
                                                      ? appTheme.theme.colorScheme
                                                      .secondary
                                                      : appTheme.primaryTextColor,
                                                  fontSize: 14),
                                            ),
                                            Text(mediaItem.artist ?? "",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color:
                                                    appTheme.secondaryTextColor,
                                                    fontSize: 10))
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          audioHandler.removeQueueItem(mediaItem);
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 20,
                                        ))
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: queue.length ?? 0,
                        ),
                      )
              ],
            ),
          );
        });
  }
}

class QueueData {
  final MediaItem? mediaItem;
  final List<MediaItem> queue;

  QueueData({required this.mediaItem, required this.queue});
}
