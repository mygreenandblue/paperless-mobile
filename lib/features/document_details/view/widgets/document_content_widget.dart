import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/highlighted_text.dart';
import 'package:paperless_mobile/core/widgets/shimmer_placeholder.dart';

class DocumentContentWidget extends StatelessWidget {
  final DocumentModel document;
  final String? queryString;
  const DocumentContentWidget({
    super.key,
    required this.document,
    this.queryString,
  });

  @override
  Widget build(BuildContext context) {
    // if (document == null) {
    //   final widths = [.3, .8, .9, .7, .6, .4, .8, .8, .6, .4];
    //   return SliverToBoxAdapter(
    //     child: ShimmerPlaceholder(
    //       child: Column(
    //         children: [
    //           for (int i = 0; i < 10; i++)
    //             Container(
    //               width: MediaQuery.sizeOf(context).width * widths[i],
    //               height: 14,
    //               color: Colors.white,
    //               margin: EdgeInsets.symmetric(vertical: 4),
    //             ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HighlightedText(
            text: document.content ?? '',
            highlights: queryString != null ? queryString!.split(" ") : [],
            style: Theme.of(context).textTheme.bodyMedium,
            caseSensitive: false,
          ),
        ],
      ),
    );
  }
}
