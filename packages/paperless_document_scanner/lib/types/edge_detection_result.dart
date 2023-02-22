import 'dart:ui';

import 'package:ffi/ffi.dart';
import 'dart:ffi';

class Coordinate extends Struct {
  @Double()
  external double x;

  @Double()
  external double y;

  factory Coordinate.allocate(double x, double y) => malloc<Coordinate>().ref
    ..x = x
    ..y = y;
}

class NativeEdgeDetectionResult extends Struct {
  external Pointer<Coordinate> topLeft;
  external Pointer<Coordinate> topRight;
  external Pointer<Coordinate> bottomLeft;
  external Pointer<Coordinate> bottomRight;

  factory NativeEdgeDetectionResult.allocate(
    Pointer<Coordinate> topLeft,
    Pointer<Coordinate> topRight,
    Pointer<Coordinate> bottomLeft,
    Pointer<Coordinate> bottomRight,
  ) =>
      malloc<NativeEdgeDetectionResult>().ref
        ..topLeft = topLeft
        ..topRight = topRight
        ..bottomLeft = bottomLeft
        ..bottomRight = bottomRight;
}

class EdgeDetectionResult {
  final Offset topLeft;
  final Offset topRight;
  final Offset bottomLeft;
  final Offset bottomRight;

  EdgeDetectionResult({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });
}
