import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfrxDocumentView extends StatefulWidget {
  final Future<Uint8List> bytes;

  const PdfrxDocumentView({super.key, required this.bytes});

  @override
  State<PdfrxDocumentView> createState() => _PdfrxDocumentViewState();
}

class _PdfrxDocumentViewState extends State<PdfrxDocumentView> {
  @override
  Widget build(BuildContext context) {
    return PdfViewer.asset(
      // snapshot.data!,
      'assets/example/sample.pdf',
      displayParams: PdfViewerParams(
        layoutPages: (pages, params) {
          final height =
              pages.fold(0.0, (prev, page) => max(prev, page.height)) +
                  params.margin * 2;
          final pageLayouts = <Rect>[];
          double x = params.margin;
          for (var page in pages) {
            pageLayouts.add(
              Rect.fromLTWH(
                x,
                (height - page.height) / 2, // center vertically
                page.width,
                page.height,
              ),
            );
            x += page.width + params.margin;
          }
          return PdfPageLayout(
            pageLayouts: pageLayouts,
            documentSize: Size(x, height),
          );
        },
      ),
    );
    return FutureBuilder(
      future: widget.bytes,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return PdfViewer.asset(
          // snapshot.data!,
          'assets/example/sample.pdf',
          displayParams: PdfViewerParams(
            layoutPages: (pages, params) {
              final height =
                  pages.fold(0.0, (prev, page) => max(prev, page.height)) +
                      params.margin * 2;
              final pageLayouts = <Rect>[];
              double x = params.margin;
              for (var page in pages) {
                pageLayouts.add(
                  Rect.fromLTWH(
                    x,
                    (height - page.height) / 2, // center vertically
                    page.width,
                    page.height,
                  ),
                );
                x += page.width + params.margin;
              }
              return PdfPageLayout(
                pageLayouts: pageLayouts,
                documentSize: Size(x, height),
              );
            },
          ),
        );
      },
    );
  }
}
