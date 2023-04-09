import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/workarounds/colored_chip.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class TagQueryFormField extends StatelessWidget {
  final String name;
  final Map<int, Tag> options;
  final TagsQuery? initialValue;

  const TagQueryFormField({
    super.key,
    required this.options,
    this.initialValue,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    log(initialValue.toString());

    return FormBuilderField<TagsQuery?>(
      initialValue: initialValue,
      builder: (field) {
        final isEmpty = (field.value is IdsTagsQuery &&
                (field.value as IdsTagsQuery).ids.isEmpty) ||
            field.value == null;
        final values = _generateOptions(context, field.value, field).toList();
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog.fullscreen(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text("Test"),
                  ),
                ),
              ),
            );
          },
          child: InputDecorator(
            isEmpty: isEmpty,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              labelText: S.of(context)!.tags,
              prefixIcon: const Icon(Icons.label_outline),
            ),
            child: SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 4),
                itemBuilder: (context, index) => values[index],
                itemCount: values.length,
              ),
            ),
          ),
        );
      },
      name: name,
    );
  }

  Iterable<Widget> _generateOptions(
    BuildContext context,
    TagsQuery? query,
    FormFieldState<TagsQuery?> field,
  ) sync* {
    if (query == null) {
      yield Container();
    } else if (query is IdsTagsQuery) {
      for (final e in query.queries) {
        yield _buildTagIdQueryWidget(context, e, field);
      }
    } else if (query is OnlyNotAssignedTagsQuery) {
      yield _buildNotAssignedTagWidget(context, field);
    } else if (query is AnyAssignedTagsQuery) {
      yield _buildAnyAssignedTagWidget(context, field);
    }
  }

  Widget _buildTagIdQueryWidget(
    BuildContext context,
    TagIdQuery e,
    FormFieldState<TagsQuery?> field,
  ) {
    assert(field.value is IdsTagsQuery);
    final formValue = field.value as IdsTagsQuery;
    final tag = options[e.id]!;
    return QueryTagChip(
      onDeleted: () => field.didChange(formValue.withIdsRemoved([e.id])),
      onSelected: () => field.didChange(formValue.withIdQueryToggled(e.id)),
      exclude: e is ExcludeTagIdQuery,
      backgroundColor: tag.color,
      foregroundColor: tag.textColor,
      labelText: tag.name,
    );
  }

  Widget _buildNotAssignedTagWidget(
    BuildContext context,
    FormFieldState<TagsQuery?> field,
  ) {
    return QueryTagChip(
      onDeleted: () => field.didChange(null),
      exclude: false,
      backgroundColor: Colors.grey,
      foregroundColor: Colors.black,
      labelText: S.of(context)!.notAssigned,
    );
  }

  Widget _buildAnyAssignedTagWidget(
      BuildContext context, FormFieldState<TagsQuery?> field) {
    return QueryTagChip(
      onDeleted: () => field.didChange(const IdsTagsQuery()),
      exclude: false,
      backgroundColor: Colors.grey,
      foregroundColor: Colors.black,
      labelText: S.of(context)!.anyAssigned,
    );
  }
}

typedef TagQueryCallback = void Function(Tag tag);

class QueryTagChip extends StatelessWidget {
  final VoidCallback onDeleted;
  final VoidCallback? onSelected;
  final bool exclude;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String labelText;

  const QueryTagChip({
    super.key,
    required this.onDeleted,
    this.onSelected,
    required this.exclude,
    this.backgroundColor,
    this.foregroundColor,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredChipWrapper(
      child: InputChip(
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        padding: const EdgeInsets.all(4),
        selectedColor: backgroundColor,
        visualDensity: const VisualDensity(vertical: -2),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          labelText,
          style: TextStyle(
            color: foregroundColor,
            decorationColor: foregroundColor,
            decoration: exclude ? TextDecoration.lineThrough : null,
          ),
        ),
        onDeleted: onDeleted,
        onPressed: onSelected,
        deleteIconColor: foregroundColor,
        checkmarkColor: foregroundColor,
        backgroundColor: backgroundColor,
        side: BorderSide.none,
      ),
    );
  }
}
