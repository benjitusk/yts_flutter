import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/utils.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () => AudioManager.instance.showMediaPlayer(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              StreamBuilder(
                  stream: AudioManager.instance.mediaItem,
                  builder: (context, mediaState) {
                    return (mediaState.data?.artUri != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                                mediaState.data!.artUri!.toString(),
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
                stream: AudioManager.instance.mediaItem,
                builder: (context, snapshot) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 20,
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: AutoMarqueeText(
                          snapshot.data?.title ?? "--",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    Text(
                      snapshot.data?.artist ?? "--",
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
              stream: AudioManager.instance.playTimeData,
              builder: (context, snapshot) {
                final position = snapshot.data?.position ?? Duration.zero;
                final duration = snapshot.data?.duration ?? Duration.zero;
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
                              ? position.inMilliseconds /
                                  duration.inMilliseconds
                              : 0.0,
                        )),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
