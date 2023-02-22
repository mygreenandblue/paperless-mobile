import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paperless_document_scanner/paperless_document_scanner.dart';
import 'package:paperless_document_scanner/types/edge_detection_result.dart';

import 'edge_painter.dart';
import 'magnifier.dart' as m;
import 'touch_bubble.dart';

class EdgeDetectionShape extends StatefulWidget {
  const EdgeDetectionShape({
    super.key,
    required this.renderedImageSize,
    required this.originalImageSize,
    required this.edgeDetectionResult,
  });

  final Size renderedImageSize;
  final Size originalImageSize;
  final EdgeDetectionResult edgeDetectionResult;

  @override
  State<EdgeDetectionShape> createState() => _EdgeDetectionShapeState();
}

class _EdgeDetectionShapeState extends State<EdgeDetectionShape> {
  late double edgeDraggerSize;

  List<Offset> points = [];

  late Offset _topLeft;
  late Offset _topRight;
  late Offset _bottomLeft;
  late Offset _bottomRight;

  late double renderedImageWidth;
  late double renderedImageHeight;
  late double top;
  late double left;

  Offset? currentDragPosition;

  @override
  void didChangeDependencies() {
    double shortestSide = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    edgeDraggerSize = shortestSide / 12;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    top = 0.0;
    left = 0.0;
    _topLeft = widget.edgeDetectionResult.topLeft;
    _topRight = widget.edgeDetectionResult.topRight;
    _bottomLeft = widget.edgeDetectionResult.bottomLeft;
    _bottomRight = widget.edgeDetectionResult.bottomRight;

    double widthFactor =
        widget.renderedImageSize.width / widget.originalImageSize.width;
    double heightFactor =
        widget.renderedImageSize.height / widget.originalImageSize.height;
    double sizeFactor = min(widthFactor, heightFactor);

    renderedImageHeight = widget.originalImageSize.height * sizeFactor;
    top = ((widget.renderedImageSize.height - renderedImageHeight) / 2);

    renderedImageWidth = widget.originalImageSize.width * sizeFactor;
    left = ((widget.renderedImageSize.width - renderedImageWidth) / 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return m.Magnifier(
      visible: currentDragPosition != null,
      position: currentDragPosition ?? Offset.zero,
      child: Stack(
        children: [
          _buildTouchBubbles(),
          CustomPaint(
            painter: EdgePainter(
              points: points,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          )
        ],
      ),
    );
  }

  Offset _getNewPositionAfterDrag(Offset position) {
    return Offset(
      position.dx / renderedImageWidth,
      position.dy / renderedImageHeight,
    );
  }

  Offset _clampOffset(Offset givenOffset) {
    double absoluteX = givenOffset.dx * renderedImageWidth;
    double absoluteY = givenOffset.dy * renderedImageHeight;

    return Offset(absoluteX.clamp(0.0, renderedImageWidth) / renderedImageWidth,
        absoluteY.clamp(0.0, renderedImageHeight) / renderedImageHeight);
  }

  Widget _buildTouchBubbles() {
    points = [
      Offset(
        left + _topLeft.dx * renderedImageWidth,
        top + _topLeft.dy * renderedImageHeight,
      ),
      Offset(
        left + _topRight.dx * renderedImageWidth,
        top + _topRight.dy * renderedImageHeight,
      ),
      Offset(
        left + _bottomRight.dx * renderedImageWidth,
        top + _bottomRight.dy * renderedImageHeight,
      ),
      Offset(
        left + _bottomLeft.dx * renderedImageWidth,
        top + _bottomLeft.dy * renderedImageHeight,
      ),
      Offset(
        left + _topLeft.dx * renderedImageWidth,
        top + _topLeft.dy * renderedImageHeight,
      ),
    ];

    return SizedBox(
      width: widget.renderedImageSize.width,
      height: widget.renderedImageSize.height,
      child: Stack(
        children: [
          Positioned(
            left: points[0].dx - (edgeDraggerSize / 2),
            top: points[0].dy - (edgeDraggerSize / 2),
            child: TouchBubble(
              size: edgeDraggerSize,
              onDragFinished: () => setState(() => currentDragPosition = null),
              onDrag: (position) {
                setState(
                  () {
                    currentDragPosition = Offset(points[0].dx, points[0].dy);
                    _topLeft = _clampOffset(
                      widget.edgeDetectionResult.topLeft +
                          _getNewPositionAfterDrag(position),
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            left: points[1].dx - (edgeDraggerSize / 2),
            top: points[1].dy - (edgeDraggerSize / 2),
            child: TouchBubble(
              size: edgeDraggerSize,
              onDrag: (position) {
                setState(() {
                  currentDragPosition = Offset(points[1].dx, points[1].dy);
                  _topRight = _clampOffset(
                    widget.edgeDetectionResult.topRight +
                        _getNewPositionAfterDrag(position),
                  );
                });
              },
              onDragFinished: () => setState(() => currentDragPosition = null),
            ),
          ),
          Positioned(
            left: points[2].dx - (edgeDraggerSize / 2),
            top: points[2].dy - (edgeDraggerSize / 2),
            child: TouchBubble(
              size: edgeDraggerSize,
              onDrag: (position) {
                setState(() {
                  currentDragPosition = Offset(points[2].dx, points[2].dy);
                  _bottomRight = _clampOffset(
                    widget.edgeDetectionResult.bottomRight +
                        _getNewPositionAfterDrag(position),
                  );
                });
              },
              onDragFinished: () => setState(() => currentDragPosition = null),
            ),
          ),
          Positioned(
            left: points[3].dx - (edgeDraggerSize / 2),
            top: points[3].dy - (edgeDraggerSize / 2),
            child: TouchBubble(
              size: edgeDraggerSize,
              onDrag: (position) {
                setState(() {
                  _bottomLeft = _clampOffset(
                    widget.edgeDetectionResult.bottomLeft +
                        _getNewPositionAfterDrag(position),
                  );
                  currentDragPosition = Offset(points[3].dx, points[3].dy);
                });
              },
              onDragFinished: () => setState(() => currentDragPosition = null),
            ),
          ),
        ],
      ),
    );
  }
}
