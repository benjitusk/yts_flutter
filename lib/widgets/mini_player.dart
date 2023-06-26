import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/audio_manager.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            StreamBuilder(
                stream: AudioManager.instance.mediaStateStream,
                builder: (context, mediaState) {
                  return (mediaState.data?.mediaItem?.artUri != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                              mediaState.data!.mediaItem!.artUri!.toString(),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child,
                                      loadingProgress) =>
                                  loadingProgress == null
                                      ? child
                                      : CircularProgressIndicator(
                                          // value: loadingProgress.expectedTotalBytes != null
                                          //     ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          //     : null,
                                          )),
                        )
                      : Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        );
                }),
            SizedBox(width: 10),
            StreamBuilder(
              stream: AudioManager.instance.mediaStateStream,
              builder: (context, snapshot) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data?.mediaItem?.title ?? "--",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    snapshot.data?.mediaItem?.artist ?? "--",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            StreamBuilder(
                stream: AudioManager.instance.playerStateStream,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data?.playing ?? false;
                  return IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () => AudioManager.instance.togglePlayPause(),
                  );
                }),
            // IconButton(
            //   icon: Icon(Icons.skip_next),
            //   onPressed: () {},
            // ),
          ],
        ),
        StreamBuilder(
            stream: AudioManager.instance.mediaStateStream,
            builder: (context, snapshot) {
              final position = snapshot.data?.position ?? Duration.zero;
              final duration =
                  snapshot.data?.mediaItem?.duration ?? Duration.zero;
              if (duration == Duration.zero || position >= duration) {
                return SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 4,
                  child: OverflowBox(
                      maxWidth: MediaQuery.of(context).size.width,
                      child: LinearProgressIndicator(
                        value: (position.inMilliseconds > 0 &&
                                position.inMilliseconds <
                                    duration.inMilliseconds)
                            ? position.inMilliseconds / duration.inMilliseconds
                            : 0.0,
                      )),
                ),
              );
            }),
      ],
    );
  }
}
