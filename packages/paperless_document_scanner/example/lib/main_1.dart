import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final cam = cameras.first;
  final controller = CameraController(
    cam,
    ResolutionPreset.veryHigh,
    enableAudio: false,
  );
  await controller.initialize();
  runApp(MyWidget(
    controller: controller,
  ));
}

class MyWidget extends StatefulWidget {
  final CameraController controller;
  const MyWidget({super.key, required this.controller});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Uint8List? _currentSnapshot;
  bool _takeSnapshot = false;
  @override
  void initState() {
    super.initState();
    widget.controller.startImageStream((image) async {
      if (_takeSnapshot) {
        _currentSnapshot = convertYUV420toImageColor(image);
        setState(() => _takeSnapshot = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: () {
            setState(() {
              _takeSnapshot = true;
            });
          },
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1 / widget.controller.value.aspectRatio,
                child: CameraPreview(widget.controller),
              ),
              Positioned(
                bottom: 32,
                right: 16,
                child: SizedBox(
                  width: widget.controller.value.previewSize?.width,
                  height: widget.controller.value.previewSize?.height,
                  child: AspectRatio(
                    aspectRatio: 1 / widget.controller.value.aspectRatio,
                    child: _currentSnapshot != null
                        ? Transform.scale(
                            scale: 1,
                            child: Image.memory(
                              _currentSnapshot!,
                              width: widget.controller.value.previewSize?.width,
                              height:
                                  widget.controller.value.previewSize?.height,
                            ),
                          )
                        : Container(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Uint8List convertYUV420toImageColor(CameraImage image) {
  const shift = (0xFF << 24);
  final int width = image.width;
  final int height = image.height;
  print("$width, $height");
  final int uvRowStride = image.planes[1].bytesPerRow;
  final int uvPixelStride = image.planes[1].bytesPerPixel!;

  // imgLib -> Image package from https://pub.dartlang.org/packages/image
  var img = imglib.Image(height: height, width: width); // Create Image buffer

  // Fill image buffer with plane[0] from YUV420_888
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      final int uvIndex =
          uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
      final int index = y * width + x;

      final yp = image.planes[0].bytes[index];
      final up = image.planes[1].bytes[uvIndex];
      final vp = image.planes[2].bytes[uvIndex];
      // Calculate pixel color
      int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
      int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
          .round()
          .clamp(0, 255);
      int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
      // color: 0x FF  FF  FF  FF
      //           A   B   G   R
      if (img.isBoundsSafe(height - y, x)) {
        img.setPixelRgba(height - y, x, r, g, b, shift);
      }
    }
  }

  imglib.JpegEncoder encoder = imglib.JpegEncoder();
  return encoder.encode(img);
}
