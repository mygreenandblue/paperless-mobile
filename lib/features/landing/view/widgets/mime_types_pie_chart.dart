import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:edocs_api/edocs_api.dart';

class MimeTypesPieChart extends StatefulWidget {
  final EdocsServerStatisticsModel statistics;

  const MimeTypesPieChart({
    super.key,
    required this.statistics,
  });

  @override
  State<MimeTypesPieChart> createState() => _MimeTypesPieChartState();
}

class _MimeTypesPieChartState extends State<MimeTypesPieChart> {
  static final _mimeTypeNames = {
    "application/pdf": "PDF Document",
    "image/png": "PNG Image",
    "image/jpeg": "JPEG Image",
    "image/tiff": "TIFF Image",
    "image/gif": "GIF Image",
    "image/webp": "WebP Image",
    "text/plain": "Plain Text Document",
    "application/msword": "Microsoft Word Document",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
        "Microsoft Word Document (OpenXML)",
    "application/vnd.ms-powerpoint": "Microsoft PowerPoint Presentation",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation":
        "Microsoft PowerPoint Presentation (OpenXML)",
    "application/vnd.ms-excel": "Microsoft Excel Spreadsheet",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
        "Microsoft Excel Spreadsheet (OpenXML)",
    "application/vnd.oasis.opendocument.text": "ODT Document",
    "application/vnd.oasis.opendocument.presentation": "ODP Presentation",
    "application/vnd.oasis.opendocument.spreadsheet": "ODS Spreadsheet",
  };

  int? _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final colorShades = Colors.lightGreen.values;

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              startDegreeOffset: 90,
              // pieTouchData: PieTouchData(
              //   touchCallback: (event, response) {
              //     setState(() {
              //       if (!event.isInterestedForInteractions ||
              //           response == null ||
              //           response.touchedSection == null) {
              //         _touchedIndex = -1;
              //         return;
              //       }
              //       _touchedIndex =
              //           response.touchedSection!.touchedSectionIndex;
              //     });
              //   },
              // ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: _buildSections(colorShades).toList(),
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (int i = 0; i < widget.statistics.fileTypeCounts.length; i++)
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _touchedIndex = i;
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    _touchedIndex = -1;
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _touchedIndex = -1;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorShades[i % colorShades.length],
                      ),
                      margin: EdgeInsets.only(right: 8),
                      width: 20,
                      height: 20,
                    ),
                    Text(
                      _mimeTypeNames[
                          widget.statistics.fileTypeCounts[i].mimeType]!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Iterable<PieChartSectionData> _buildSections(List<Color> colorShades) sync* {
    for (int i = 0; i < widget.statistics.fileTypeCounts.length; i++) {
      final type = widget.statistics.fileTypeCounts[i];
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 18.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final percentage = type.count / widget.statistics.documentsTotal * 100;
      yield PieChartSectionData(
        color: colorShades[i % colorShades.length],
        value: type.count.toDouble(),
        title: percentage.toStringAsFixed(1) + "%",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }
  }
}

extension AllShades on MaterialColor {
  List<Color> get values => [
        shade200,
        shade600,
        shade300,
        shade100,
        shade800,
        shade400,
        shade900,
        shade500,
        shade700,
      ];
}
