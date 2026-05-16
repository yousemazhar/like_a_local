import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../theme/tokens.dart';
import '../../../../theme/typography.dart';

class MediaItem {
  const MediaItem.photo(this.url) : isVideo = false;
  const MediaItem.video(this.url) : isVideo = true;

  final String url;
  final bool isVideo;
}

class PlaceMediaGallery extends StatefulWidget {
  const PlaceMediaGallery({
    super.key,
    required this.photoUrls,
    required this.videoUrls,
    this.height = 420,
    this.photoFit = BoxFit.cover,
    this.interactive = false,
  });

  final List<String> photoUrls;
  final List<String> videoUrls;
  final double height;
  final BoxFit photoFit;
  final bool interactive;

  List<MediaItem> get items => [
        ...photoUrls.map(MediaItem.photo),
        ...videoUrls.map(MediaItem.video),
      ];

  @override
  State<PlaceMediaGallery> createState() => _PlaceMediaGalleryState();
}

class _PlaceMediaGalleryState extends State<PlaceMediaGallery> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) {
      return const _HeroPlaceholder();
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: items.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (context, index) {
            final item = items[index];
            if (item.isVideo) {
              return _VideoPage(url: item.url);
            }
            final image = CachedNetworkImage(
              imageUrl: item.url,
              fit: widget.interactive ? BoxFit.contain : widget.photoFit,
              placeholder: (_, __) => const ColoredBox(color: LALColors.c100),
              errorWidget: (_, __, ___) => const _HeroPlaceholder(),
            );
            if (!widget.interactive) return image;
            return InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              clipBehavior: Clip.none,
              child: SizedBox.expand(child: image),
            );
          },
        ),
        if (items.length > 1)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: LALRadii.pillBorder,
              ),
              child: Text(
                '${_page + 1} / ${items.length}',
                style: LALTypography.labelSmall.copyWith(
                  color: LALColors.surface,
                ),
              ),
            ),
          ),
        if (items.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < items.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _page ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _page
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: LALRadii.pillBorder,
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _VideoPage extends StatefulWidget {
  const _VideoPage({required this.url});

  final String url;

  @override
  State<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<_VideoPage> {
  VideoPlayerController? _video;
  ChewieController? _chewie;
  bool _ready = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final v = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await v.initialize();
      if (!mounted) {
        await v.dispose();
        return;
      }
      final c = ChewieController(
        videoPlayerController: v,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: LALColors.accent,
          handleColor: LALColors.accent,
          bufferedColor: Colors.white24,
          backgroundColor: Colors.white12,
        ),
      );
      setState(() {
        _video = v;
        _chewie = c;
        _ready = true;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  void dispose() {
    _chewie?.dispose();
    _video?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return const _HeroPlaceholder();
    }
    if (!_ready || _chewie == null) {
      return Container(
        color: LALColors.c900,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      );
    }
    return ColoredBox(
      color: Colors.black,
      child: Chewie(controller: _chewie!),
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LALColors.c100,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 48,
        color: LALColors.c400,
      ),
    );
  }
}
