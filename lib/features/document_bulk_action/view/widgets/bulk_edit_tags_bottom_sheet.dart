import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_bulk_action/cubit/document_bulk_action_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class BulkEditTagsBottomSheet extends StatefulWidget {
  const BulkEditTagsBottomSheet({super.key});

  @override
  State<BulkEditTagsBottomSheet> createState() =>
      _BulkEditTagsBottomSheetState();
}

class _BulkEditTagsBottomSheetState extends State<BulkEditTagsBottomSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _textEditingController = TextEditingController();
  late Set<int> _sharedTags;
  late Set<int> _nonSharedTags;
  final Set<int> _sharedTagsToRemove = {};
  final Set<int> _nonSharedTagsToRemove = {};
  final Set<int> _tagsToAdd = {};

  @override
  void initState() {
    super.initState();
    final state = context.read<DocumentBulkActionCubit>().state;
    _sharedTags = state.selection
        .map((doc) => doc.tags)
        .reduce((previousValue, element) =>
            previousValue.toSet().intersection(element.toSet()))
        .toSet();
    print(_sharedTags.map((e) => e).join(", "));
    _nonSharedTags = state.selection
        .map((doc) => doc.tags)
        .flattened
        .toSet()
        .difference(_sharedTags)
        .toSet();
    print(_nonSharedTags.map((e) => e).join(", "));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBulkActionCubit, DocumentBulkActionState>(
      builder: (context, state) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BlocBuilder<DocumentBulkActionCubit, DocumentBulkActionState>(
            builder: (context, state) {
              print(state);
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Bulk modify tags",
                        style: Theme.of(context).textTheme.titleLarge,
                      ).paddedOnly(bottom: 24),
                      TypeAheadFormField<Tag>(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            labelText: "Tags",
                            hintText: "Start typing to add tags...",
                          ),
                        ),
                        onSuggestionSelected: (suggestion) {
                          setState(() {
                            _tagsToAdd.add(suggestion.id!);
                          });
                          _textEditingController.clear();
                        },
                        itemBuilder: (context, option) {
                          return ListTile(
                            leading: SizedBox(
                              width: 32,
                              height: 32,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: option.color!,
                                ),
                              ),
                            ),
                            title: Text(option.name),
                          );
                        },
                        suggestionsCallback: (pattern) {
                          final searchString = pattern.toLowerCase();
                          return state.tags.entries
                              .where(
                                (tag) => tag.value.name
                                    .toLowerCase()
                                    .contains(searchString),
                              )
                              .map((e) => e.key)
                              .toSet()
                              .difference(_sharedTags)
                              .difference(_nonSharedTags)
                              .map((e) => state.tags[e]!);
                        },
                      ),
                      Text("Shared tags"),
                      Wrap(
                        children: _sharedTags
                            .map(
                              (tag) => RemovableTagWidget(
                                tag: state.tags[tag]!,
                                onDeleted: (tag) {
                                  setState(() {
                                    _sharedTagsToRemove.add(tag);
                                    _sharedTags.remove(tag);
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      Text("Non-shared tags"),
                      Wrap(
                        children: _nonSharedTags
                            .map(
                              (tag) => RemovableTagWidget(
                                tag: state.tags[tag]!,
                                onDeleted: (tag) {
                                  setState(() {
                                    _nonSharedTagsToRemove.add(tag);
                                    _nonSharedTags.remove(tag);
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                      Text("Remove"),
                      Wrap(
                        children: _sharedTagsToRemove.map((tag) {
                              return RemovableTagWidget(
                                tag: state.tags[tag]!,
                                onDeleted: (tag) {
                                  setState(() {
                                    _sharedTagsToRemove.remove(tag);
                                    _sharedTags.add(tag);
                                  });
                                },
                              );
                            }).toList() +
                            _nonSharedTagsToRemove.map((tag) {
                              return RemovableTagWidget(
                                tag: state.tags[tag]!,
                                onDeleted: (tag) {
                                  setState(() {
                                    _nonSharedTagsToRemove.remove(tag);
                                    _nonSharedTags.add(tag);
                                  });
                                },
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text("Add"),
                      Wrap(
                        children: _tagsToAdd
                            .map(
                              (tag) => RemovableTagWidget(
                                  tag: state.tags[tag]!,
                                  onDeleted: (tag) {
                                    setState(() {
                                      _tagsToAdd.remove(tag);
                                    });
                                  }),
                            )
                            .toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const DialogCancelButton(),
                          const SizedBox(width: 16),
                          FilledButton(
                            onPressed: () {
                              if (_formKey.currentState?.saveAndValidate() ??
                                  false) {
                                final value = _formKey.currentState
                                        ?.getRawValue('labelFormField')
                                    as IdsTagsQuery;
                                context
                                    .read<DocumentBulkActionCubit>()
                                    .bulkModifyTags(
                                      addTagIds: value.includedIds,
                                    );
                              }
                            },
                            child: Text(S.of(context)!.apply),
                          ),
                        ],
                      ).padded(8),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class RemovableTagWidget extends StatelessWidget {
  final Tag tag;
  final void Function(int tagId) onDeleted;
  const RemovableTagWidget(
      {super.key, required this.tag, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        tag.name,
        style: TextStyle(
          color: tag.textColor,
        ),
      ),
      onDeleted: () => onDeleted(tag.id!),
      deleteIcon: Icon(Icons.clear),
      backgroundColor: tag.color,
      deleteIconColor: tag.textColor,
      padding: EdgeInsets.zero,
      side: BorderSide.none,
    );
  }
}
