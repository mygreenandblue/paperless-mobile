import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/features/labels/cubit/label_state.dart';
import 'package:paperless_mobile/features/labels/cubit/providers/tag_bloc_provider.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tag_widget.dart';

class TagsWidget extends StatelessWidget {
  final Iterable<int> tagIds;
  final bool isMultiLine;
  final void Function(int tagId)? onTagSelected;
  final bool isClickable;
  final bool showShortNames;
  final bool dense;

  const TagsWidget({
    Key? key,
    required this.tagIds,
    this.isMultiLine = true,
    this.isClickable = true,
    this.onTagSelected,
    this.showShortNames = false,
    this.dense = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TagBlocProvider(
      child: BlocBuilder<LabelCubit<Tag>, LabelState<Tag>>(
        builder: (context, state) {
          final children = tagIds
              .where((id) => state.labels.containsKey(id))
              .map(
                (id) => TagWidget(
                  tag: state.getLabel(id)!,
                  isClickable: isClickable,
                  onSelected: () => onTagSelected?.call(id),
                  showShortName: showShortNames,
                  dense: dense,
                ),
              )
              .toList();
          if (isMultiLine) {
            return Wrap(
              runAlignment: WrapAlignment.start,
              children: children,
              runSpacing: 4,
              spacing: 4,
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: children),
            );
          }
        },
      ),
    );
  }
}
