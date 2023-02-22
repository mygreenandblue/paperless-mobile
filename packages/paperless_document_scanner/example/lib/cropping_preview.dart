import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paperless_document_scanner/types/edge_detection_result.dart';

import 'edge_detection_shape/edge_detection_shape.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.imagePath,
    required this.edgeDetectionResult,
  });

  final String imagePath;
  final EdgeDetectionResult? edgeDetectionResult;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  GlobalKey imageWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext mainContext) {
    return Center(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Center(child: Text('Loading ...')),
          Image.file(File(widget.imagePath),
              fit: BoxFit.contain, key: imageWidgetKey),
          FutureBuilder<ui.Image>(
              future: loadUiImage(widget.imagePath),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Loading..."),
                  );
                } else {
                  return _getEdgePaint(snapshot.data!, context);
                }
              }),
        ],
      ),
    );
  }

  Widget _getEdgePaint(
    ui.Image image,
    BuildContext context,
  ) {
    if (widget.edgeDetectionResult == null) return Container();

    final keyContext = imageWidgetKey.currentContext;

    if (keyContext == null) {
      return Container();
    }

    final box = keyContext.findRenderObject() as RenderBox;

    return EdgeDetectionShape(
      originalImageSize: Size(
        image.width.toDouble(),
        image.height.toDouble(),
      ),
      renderedImageSize: Size(box.size.width, box.size.height),
      edgeDetectionResult: widget.edgeDetectionResult!,
    );
  }

  Future<ui.Image> loadUiImage(String imageAssetPath) async {
    final Uint8List data = await File(imageAssetPath).readAsBytes();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image image) {
      return completer.complete(image);
    });
    return completer.future;
  }
}
