import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:paperless_mobile/core/widgets/shimmer_placeholder.dart';

class LogsLoadingWidget extends StatelessWidget {
  const LogsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final widthMultipliers = [0.8, 0.7, 0.5, 1, 0.9];
    return ListView.builder(
      itemBuilder: (context, index) => ShimmerPlaceholder(
        child: Container(
          width: width * widthMultipliers[index % widthMultipliers.length],
        ),
      ),
    );
  }
}
