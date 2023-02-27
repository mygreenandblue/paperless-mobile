import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;
import 'package:paperless_document_scanner/paperless_document_scanner.dart';
import 'package:paperless_document_scanner/types/edge_detection_result.dart';
import 'package:paperless_document_scanner_example/edge_detection_shape/edge_detection_shape.dart';
import 'package:paperless_document_scanner_example/edge_detector.dart';
import 'scan.dart';

late final List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const EdgeDetectionApp());
}

class EdgeDetectionApp extends StatefulWidget {
  const EdgeDetectionApp({super.key});

  @override
  State<EdgeDetectionApp> createState() => _EdgeDetectionAppState();
}

class _EdgeDetectionAppState extends State<EdgeDetectionApp> {
  CameraImage? _image;
  EdgeDetectionResult? _shape;
  late final CameraController _controller;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      cameras
          .where((element) => element.lensDirection == CameraLensDirection.back)
          .first,
      ResolutionPreset.low,
      enableAudio: false,
    );
    _controller.initialize().then(
          (_) => _controller.startImageStream((image) {
            final img = convertYUV420toImageColor(image);
            EdgeDetection.detectEdges(img).then((value) {
              setState(() => _shape = value);
            });
          }),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  Uint8List convertYUV420toImageColor(CameraImage image) {
    const shift = (0xFF << 24);
    final int width = image.width;
    final int height = image.height;
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

  // Image convertYUV420toImageColor(CameraImage image) {
  //   final int width = image.width;
  //   final int height = image.height;
  //   final int uvRowStride = image.planes[1].bytesPerRow;
  //   final int uvPixelStride = image.planes[1].bytesPerPixel!;

  //   // imgLib -> Image package from https://pub.dartlang.org/packages/image
  //   var img = imglib.Image(
  //     width: width,
  //     height: height,
  //   ); // Create Image buffer

  //   // Fill image buffer with plane[0] from YUV420_888
  //   for (int x = 0; x < width; x++) {
  //     for (int y = 0; y < height; y++) {
  //       final int uvIndex =
  //           uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
  //       final int index = y * width + x;

  //       final yp = image.planes[0].bytes[index];
  //       final up = image.planes[1].bytes[uvIndex];
  //       final vp = image.planes[2].bytes[uvIndex];
  //       // Calculate pixel color
  //       int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
  //       int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
  //           .round()
  //           .clamp(0, 255);
  //       int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
  //       // color: 0x FF  FF  FF  FF
  //       //           A   B   G   R
  //       if (img.isBoundsSafe(height - y, x)) {
  //         img.setPixelRgba(height - y, x, r, g, b, shift);
  //       }
  //     }
  //   }

  //   imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0);
  //   final png = pngEncoder.encode(img);
  //   return Image.memory(png);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                  "${_shape?.topLeft},${_shape?.topRight},${_shape?.bottomRight},${_shape?.bottomLeft}"),
            ),
            Center(
              child: CameraPreview(_controller),
            ),
          ],
        ),
      ),
    );
  }
}
