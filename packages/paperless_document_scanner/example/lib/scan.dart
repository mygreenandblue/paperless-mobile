import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:paperless_document_scanner/types/edge_detection_result.dart';

import 'camera_view.dart';
import 'cropping_preview.dart';
import 'edge_detector.dart';
import 'image_view.dart';

class Scan extends StatefulWidget {
  const Scan({
    super.key,
    required,
    required this.cameras,
  });
  final List<CameraDescription> cameras;
  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  late final CameraController controller;
  String? imagePath;
  String? croppedImagePath;
  EdgeDetectionResult? edgeDetectionResult;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.veryHigh,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );
    () async {
      await controller.initialize();
      log(controller.value.toString());
    }();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _getMainWidget(),
          _getBottomBar(),
        ],
      ),
    );
  }

  Widget _getMainWidget() {
    if (croppedImagePath != null) {
      return ImageView(imagePath: croppedImagePath!);
    }

    if (imagePath == null && edgeDetectionResult == null) {
      return CameraView(controller: controller);
    }

    return ImagePreview(
      imagePath: imagePath!,
      edgeDetectionResult: edgeDetectionResult,
    );
  }

  Widget _getButtonRow() {
    if (imagePath != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () async {
            if (croppedImagePath == null) {
              return _processImage(imagePath!, edgeDetectionResult!);
            }

            setState(() {
              imagePath = null;
              edgeDetectionResult = null;
              croppedImagePath = null;
            });
          },
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          foregroundColor: Colors.white,
          onPressed: onTakePictureButtonPressed,
          child: const Icon(Icons.camera_alt),
        ),
      ],
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      throw Exception("Select camera first!");
    }

    final file = await controller.takePicture();

    return file.path;
  }

  Future _detectEdges(String filePath) async {
    if (!mounted) {
      return;
    }

    setState(() {
      imagePath = filePath;
    });

    EdgeDetectionResult result =
        await EdgeDetector().detectEdgesFromFile(filePath);

    setState(() {
      edgeDetectionResult = result;
    });
  }

  Future _processImage(
      String filePath, EdgeDetectionResult edgeDetectionResult) async {
    if (!mounted) {
      return;
    }

    bool result = await EdgeDetector()
        .processImageFromFile(filePath, edgeDetectionResult);

    if (result == false) {
      return;
    }

    setState(() {
      imageCache.clearLiveImages();
      imageCache.clear();
      croppedImagePath = imagePath;
    });
  }

  void onTakePictureButtonPressed() async {
    String filePath = await takePicture();

    log('Picture saved to $filePath');

    await _detectEdges(filePath);
  }

  Padding _getBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Align(alignment: Alignment.bottomCenter, child: _getButtonRow()),
    );
  }
}
