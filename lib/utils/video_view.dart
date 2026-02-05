// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, depend_on_referenced_packages, avoid_print, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/global.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class VideoViewFix extends StatefulWidget {
  String url;
  bool play;
  bool mute;
  VideoViewFix({
    super.key,
    required this.url,
    required this.play,
    required this.mute,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<VideoViewFix>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  VideoPlayerController? controller;
  Future<void>? initializeVideoPlayerFuture;
  Duration? duration, position;
  late AnimationController _animationController;
  bool isPlay = true;
  double videoProgress = 0.0;
  late SliderThemeData sliderThemeData;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url.toString()),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    initializeVideoPlayerFuture = controller!.initialize();
    controller!.addListener(_videoListener);
    controller!.play();
    controller!.setLooping(true);
    controller!.setVolume(1.0);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  void _videoListener() {
    if (mounted) {
      setState(() {
        videoProgress =
            controller!.value.position.inMilliseconds /
            controller!.value.duration.inMilliseconds;
        videoProgress = videoProgress.clamp(0.0, 1.0);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    sliderThemeData = SliderTheme.of(context).copyWith(trackHeight: 5.0);
  }

  void play() {
    controller!.play();
    setState(() {});
  }

  void pause() {
    controller!.pause();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller?.removeListener(_videoListener);
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.black,
      body: FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            bool isPortrait = controller!.value.aspectRatio < 1;
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (controller!.value.isPlaying) {
                  pause();
                  isPlay = false;
                  _animationController.reverse();
                  setState(() {});
                } else {
                  play();
                  _animationController.animateBack(
                    1,
                    duration: const Duration(milliseconds: 500),
                  );
                  Future.delayed(const Duration(milliseconds: 500), () {
                    isPlay = true;
                    setState(() {});
                  });
                }
              },
              child: Container(
                color: Appcolors.appBgColor.transparent,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    controller!.value.isInitialized
                        ? isPortrait
                              ? FittedBox(
                                  fit: BoxFit.cover,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: SizedBox(
                                    width: controller!.value.size.width,
                                    height: controller!.value.size.height,
                                    child: Center(
                                      child: AspectRatio(
                                        aspectRatio:
                                            controller!.value.aspectRatio,
                                        child: VideoPlayer(controller!),
                                        // )
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: AspectRatio(
                                    aspectRatio: controller!.value.aspectRatio,
                                    child: VideoPlayer(controller!),
                                  ),
                                )
                        : Center(child: commonLoading()),
                    isPlay == true
                        ? const SizedBox()
                        : Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Appcolors.black.withOpacity(0.46),
                              ),
                              child: AnimatedIcon(
                                progress: _animationController,
                                icon: AnimatedIcons.play_pause,
                                color: Appcolors.white,
                                size: 35,
                              ).paddingAll(15),
                            ),
                          ),
                    Positioned(
                      // left: 25,
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            [
                                  controller!.value.position.inMinutes,
                                  controller!.value.position.inSeconds,
                                ]
                                .map(
                                  (seg) => seg
                                      .remainder(60)
                                      .toString()
                                      .padLeft(2, '0'),
                                )
                                .join(':'),
                            style: TextStyle(color: Appcolors.white),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: SliderTheme(
                              data: sliderThemeData.copyWith(
                                inactiveTrackColor: Appcolors.white.withOpacity(
                                  0.15,
                                ),
                                activeTrackColor: Appcolors.color53ABFD,
                                trackHeight: 3.0,
                                thumbColor:
                                    Appcolors.appPriSecColor.appPrimblue,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 7.0,
                                ),
                                overlayColor: Appcolors
                                    .appPriSecColor
                                    .appPrimblue
                                    .withAlpha(32),
                                overlayShape: SliderComponentShape.noOverlay,
                                //  const RoundSliderOverlayShape(overlayRadius: 0.0),
                              ),
                              child: Slider(
                                value: videoProgress,
                                onChanged: (double value) {},
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            [
                                  controller!.value.duration.inMinutes,
                                  controller!.value.duration.inSeconds,
                                ]
                                .map(
                                  (seg) => seg
                                      .remainder(60)
                                      .toString()
                                      .padLeft(2, '0'),
                                )
                                .join(':'),
                            style: TextStyle(color: Appcolors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: commonLoading());
          }
        },
      ),
    );
  }
}
