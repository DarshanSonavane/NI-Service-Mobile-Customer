import 'dart:convert';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class Mediadisplayscreen extends StatefulWidget {
  final String base64Data;
  final bool isVideo;
  final String title;

  const Mediadisplayscreen(
      {super.key,
      required this.base64Data,
      required this.isVideo,
      required this.title});

  @override
  State<Mediadisplayscreen> createState() => _MediadisplayscreenState();
}

class _MediadisplayscreenState extends State<Mediadisplayscreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoLoaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _initializeVideo();
    }
  }

  _initializeVideo() async {
    try {
      final bytes = base64Decode(widget.base64Data
          .replaceRange(0, widget.base64Data.indexOf(',') + 1, ''));
      final directory = await getTemporaryDirectory();
      final tempFile = File('${directory.path}/temp_video.mp4');
      await tempFile.writeAsBytes(bytes);
      _videoPlayerController = VideoPlayerController.file(tempFile);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        autoInitialize: true,
        draggableProgressBar: false,
        showControls: true,
        allowMuting: true,
        looping: true,
      );
      setState(() {
        _isVideoLoaded = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing video: $e');
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: widget.isVideo
            ? (_isVideoLoaded
                ? Chewie(controller: _chewieController)
                : const CircularProgressIndicator())
            : Image.memory(base64Decode(widget.base64Data
                .replaceRange(0, widget.base64Data.indexOf(',') + 1, ''))),
      ),
    );
  }
}
