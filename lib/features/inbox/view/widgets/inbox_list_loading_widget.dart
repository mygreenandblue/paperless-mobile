import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/widgets/shimmer_placeholder.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/tags_placeholder.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/text_placeholder.dart';

class InboxListLoadingWidget extends StatelessWidget {
  const InboxListLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildInboxItem().padded(),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    ).paddedOnly(top: 8);
  }

  Widget _buildInboxItem() {
    return ShimmerPlaceholder(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextPlaceholder(length: 150, fontSize: 12),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        width: 90,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: const ColoredBox(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),
                            TextPlaceholder(length: 200, fontSize: 14),
                            Spacer(),
                            TextPlaceholder(length: 120, fontSize: 14),
                            SizedBox(height: 8),
                            TextPlaceholder(length: 170, fontSize: 14),
                            Spacer(),
                            TagsPlaceholder(count: 3, dense: true),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: IntrinsicHeight(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 40,
                            child: ColoredBox(
                              color: Colors.white,
                            ),
                          ).padded(),
                          const VerticalDivider(
                            indent: 12,
                            endIndent: 12,
                          ),
                          SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  width: 200,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
