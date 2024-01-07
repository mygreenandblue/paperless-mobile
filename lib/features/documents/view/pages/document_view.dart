import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:pdfrx/pdfrx.dart';

class DocumentView extends StatefulWidget {
  final Future<Uint8List> documentBytes;
  final String? title;
  final bool showAppBar;
  final bool showControls;
  const DocumentView({
    super.key,
    required this.documentBytes,
    this.showAppBar = true,
    this.showControls = true,
    this.title,
  });

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  final PdfViewerController _controller = PdfViewerController();
  int _currentPage = 1;
  int? _totalPages;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) {
        if (_controller.pageNumber != null) {
          setState(() {
            _currentPage = _controller.pageNumber!;
          });
        }
        setState(() {
          _totalPages = _controller.pages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageTransitionDuration = MediaQuery.disableAnimationsOf(context)
        ? 0.milliseconds
        : 100.milliseconds;
    final canGoToNextPage = _totalPages != null && _currentPage < _totalPages!;
    final canGoToPreviousPage = _totalPages != null && _currentPage > 1;
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: widget.title != null ? Text(widget.title!) : null,
            )
          : null,
      bottomNavigationBar: widget.showControls
          ? BottomAppBar(
              child: Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        IconButton.filled(
                          onPressed: canGoToPreviousPage
                              ? () async {
                                  await _controller.goToPage(
                                    pageNumber: _currentPage - 1,
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.arrow_left),
                        ),
                        const SizedBox(width: 16),
                        IconButton.filled(
                          onPressed: canGoToNextPage
                              ? () async {
                                  await _controller.goToPage(
                                    pageNumber: _currentPage + 1,
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.arrow_right),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      if (_totalPages == null) {
                        return const Text("-/-");
                      }
                      return Text(
                        "$_currentPage/$_totalPages",
                        style: Theme.of(context).textTheme.titleMedium,
                      ).padded();
                    },
                  ),
                ],
              ),
            )
          : null,
      body: FutureBuilder<Uint8List>(
        future: widget.documentBytes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return PdfViewer.data(
            snapshot.data!,
            controller: _controller,
            anchor: PdfPageAnchor.all,
            displayParams: PdfViewerParams(
              backgroundColor: Theme.of(context).colorScheme.background,
              margin: 0,
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
            // controller: _controller,
            // onDocumentLoaded: (document) {
            //   if (mounted) {
            //     setState(() {
            //       _totalPages = document.pagesCount;
            //     });
            //   }
            // },
            // onPageChanged: (page) {
            //   if (mounted) {
            //     setState(() {
            //       _currentPage = page;
            //     });
            //   }
            // },
          );
        },
      ),
    );
  }
}
