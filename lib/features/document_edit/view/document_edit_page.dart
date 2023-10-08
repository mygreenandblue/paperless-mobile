import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/pop_with_unsaved_changes.dart';
import 'package:paperless_mobile/core/workarounds/colored_chip.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_edit/cubit/document_edit_cubit.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_correspondent_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_document_type_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_storage_path_page.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_form_field.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_form_field.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class DocumentEditPage extends StatefulWidget {
  const DocumentEditPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DocumentEditPage> createState() => _DocumentEditPageState();
}

class _DocumentEditPageState extends State<DocumentEditPage> {
  static const fkTitle = "title";
  static const fkCorrespondent = "correspondent";
  static const fkTags = "tags";
  static const fkDocumentType = "documentType";
  static const fkCreatedDate = "createdAtDate";
  static const fkStoragePath = 'storagePath';
  static const fkContent = 'content';

  final GlobalKey<FormBuilderState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<LocalUserAccount>().paperlessUser;
    return PopWithUnsavedChanges(
      hasChangesPredicate: () => _formKey.currentState?.isDirty ?? false,
      child: BlocBuilder<DocumentEditCubit, DocumentEditState>(
        builder: (context, state) {
          final filteredSuggestions = state.suggestions?.documentDifference(
              context.read<DocumentEditCubit>().state.document);
          return DefaultTabController(
            length: 2,
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                floatingActionButton: FloatingActionButton.extended(
                  heroTag: "fab_document_edit",
                  onPressed: () => _onSubmit(state.document),
                  icon: const Icon(Icons.save),
                  label: Text(S.of(context)!.saveChanges),
                ),
                appBar: AppBar(
                  title: Text(S.of(context)!.editDocument),
                  bottom: TabBar(
                    tabs: [
                      Tab(text: S.of(context)!.overview),
                      Tab(text: S.of(context)!.content)
                    ],
                  ),
                ),
                extendBody: true,
                body: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 8,
                    left: 8,
                    right: 8,
                  ),
                  child: FormBuilder(
                    key: _formKey,
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            _buildTitleFormField(state.document.title).padded(),
                            _buildCreatedAtFormField(
                              state.document.created,
                              filteredSuggestions,
                            ).padded(),
                            // Correspondent form field
                            if (currentUser.canViewCorrespondents)
                              Column(
                                children: [
                                  LabelFormField<Correspondent>(
                                    showAnyAssignedOption: false,
                                    showNotAssignedOption: false,
                                    addLabelPageBuilder: (initialValue) =>
                                        RepositoryProvider.value(
                                      value: context.read<LabelRepository>(),
                                      child: AddCorrespondentPage(
                                        initialName: initialValue,
                                      ),
                                    ),
                                    addLabelText:
                                        S.of(context)!.addCorrespondent,
                                    labelText: S.of(context)!.correspondent,
                                    options: context
                                        .watch<DocumentEditCubit>()
                                        .state
                                        .correspondents,
                                    initialValue: state
                                                .document.correspondent !=
                                            null
                                        ? SetIdQueryParameter(
                                            id: state.document.correspondent!)
                                        : const UnsetIdQueryParameter(),
                                    name: fkCorrespondent,
                                    prefixIcon:
                                        const Icon(Icons.person_outlined),
                                    allowSelectUnassigned: true,
                                    canCreateNewLabel:
                                        currentUser.canCreateCorrespondents,
                                  ),
                                  if (filteredSuggestions
                                          ?.hasSuggestedCorrespondents ??
                                      false)
                                    _buildSuggestionsSkeleton<int>(
                                      suggestions:
                                          filteredSuggestions!.correspondents,
                                      itemBuilder: (context, itemData) =>
                                          ActionChip(
                                        label: Text(state
                                            .correspondents[itemData]!.name),
                                        onPressed: () {
                                          _formKey.currentState
                                              ?.fields[fkCorrespondent]
                                              ?.didChange(
                                            SetIdQueryParameter(id: itemData),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ).padded(),
                            // DocumentType form field
                            if (currentUser.canViewDocumentTypes)
                              Column(
                                children: [
                                  LabelFormField<DocumentType>(
                                    showAnyAssignedOption: false,
                                    showNotAssignedOption: false,
                                    addLabelPageBuilder: (currentInput) =>
                                        RepositoryProvider.value(
                                      value: context.read<LabelRepository>(),
                                      child: AddDocumentTypePage(
                                        initialName: currentInput,
                                      ),
                                    ),
                                    canCreateNewLabel:
                                        currentUser.canCreateDocumentTypes,
                                    addLabelText:
                                        S.of(context)!.addDocumentType,
                                    labelText: S.of(context)!.documentType,
                                    initialValue: state.document.documentType !=
                                            null
                                        ? SetIdQueryParameter(
                                            id: state.document.documentType!)
                                        : const UnsetIdQueryParameter(),
                                    options: state.documentTypes,
                                    name: _DocumentEditPageState.fkDocumentType,
                                    prefixIcon:
                                        const Icon(Icons.description_outlined),
                                    allowSelectUnassigned: true,
                                  ),
                                  if (filteredSuggestions
                                          ?.hasSuggestedDocumentTypes ??
                                      false)
                                    _buildSuggestionsSkeleton<int>(
                                      suggestions:
                                          filteredSuggestions!.documentTypes,
                                      itemBuilder: (context, itemData) =>
                                          ActionChip(
                                        label: Text(state
                                            .documentTypes[itemData]!.name),
                                        onPressed: () => _formKey.currentState
                                            ?.fields[fkDocumentType]
                                            ?.didChange(
                                          SetIdQueryParameter(id: itemData),
                                        ),
                                      ),
                                    ),
                                ],
                              ).padded(),
                            // StoragePath form field
                            if (currentUser.canViewStoragePaths)
                              Column(
                                children: [
                                  LabelFormField<StoragePath>(
                                    showAnyAssignedOption: false,
                                    showNotAssignedOption: false,
                                    addLabelPageBuilder: (initialValue) =>
                                        RepositoryProvider.value(
                                      value: context.read<LabelRepository>(),
                                      child: AddStoragePathPage(
                                          initialName: initialValue),
                                    ),
                                    canCreateNewLabel:
                                        currentUser.canCreateStoragePaths,
                                    addLabelText: S.of(context)!.addStoragePath,
                                    labelText: S.of(context)!.storagePath,
                                    options: state.storagePaths,
                                    initialValue:
                                        state.document.storagePath != null
                                            ? SetIdQueryParameter(
                                                id: state.document.storagePath!)
                                            : const UnsetIdQueryParameter(),
                                    name: fkStoragePath,
                                    prefixIcon:
                                        const Icon(Icons.folder_outlined),
                                    allowSelectUnassigned: true,
                                  ),
                                ],
                              ).padded(),
                            // Tag form field
                            if (currentUser.canViewTags)
                              TagsFormField(
                                options: state.tags,
                                name: fkTags,
                                allowOnlySelection: true,
                                allowCreation: true,
                                allowExclude: false,
                                initialValue: IdsTagsQuery(
                                  include: state.document.tags.toList(),
                                ),
                              ).padded(),
                            if (filteredSuggestions?.tags
                                    .toSet()
                                    .difference(state.document.tags.toSet())
                                    .isNotEmpty ??
                                false)
                              _buildSuggestionsSkeleton<int>(
                                suggestions:
                                    (filteredSuggestions?.tags.toSet() ?? {}),
                                itemBuilder: (context, itemData) {
                                  final tag = state.tags[itemData]!;
                                  return ActionChip(
                                    label: Text(
                                      tag.name,
                                      style: TextStyle(color: tag.textColor),
                                    ),
                                    backgroundColor: tag.color,
                                    onPressed: () {
                                      final currentTags = _formKey.currentState
                                          ?.fields[fkTags]?.value as TagsQuery;
                                      _formKey.currentState?.fields[fkTags]
                                          ?.didChange(
                                        switch (currentTags) {
                                          IdsTagsQuery(
                                            include: var i,
                                            exclude: var e
                                          ) =>
                                            IdsTagsQuery(
                                              include: [...i, itemData],
                                              exclude: e,
                                            ),
                                          _ => IdsTagsQuery(include: [itemData])
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            // Prevent tags from being hidden by fab
                            const SizedBox(height: 64),
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                name: fkContent,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                initialValue: state.document.content,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                              const SizedBox(height: 84),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }

  Future<void> _onSubmit(DocumentModel document) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;

      final correspondentParam = values[fkCorrespondent] as IdQueryParameter?;
      final documentTypeParam = values[fkDocumentType] as IdQueryParameter?;
      final storagePathParam = values[fkStoragePath] as IdQueryParameter?;
      final tagsParam = values[fkTags] as TagsQuery?;

      final correspondent = switch (correspondentParam) {
        SetIdQueryParameter(id: var id) => id,
        _ => null,
      };
      final documentType = switch (documentTypeParam) {
        SetIdQueryParameter(id: var id) => id,
        _ => null,
      };
      final storagePath = switch (storagePathParam) {
        SetIdQueryParameter(id: var id) => id,
        _ => null,
      };
      final tags = switch (tagsParam) {
        IdsTagsQuery(include: var i) => i,
        _ => null,
      };
      var mergedDocument = document.copyWith(
        title: values[fkTitle],
        created: values[fkCreatedDate],
        correspondent: () => correspondent,
        documentType: () => documentType,
        storagePath: () => storagePath,
        tags: tags,
        content: values[fkContent],
      );

      try {
        await context.read<DocumentEditCubit>().updateDocument(mergedDocument);
        showSnackBar(context, S.of(context)!.documentSuccessfullyUpdated);
      } on PaperlessApiException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      } finally {
        context.pop();
      }
    }
  }

  Widget _buildTitleFormField(String? initialTitle) {
    return FormBuilderTextField(
      name: fkTitle,
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return S.of(context)!.thisFieldIsRequired;
        }
        return null;
      },
      decoration: InputDecoration(
        label: Text(S.of(context)!.title),
      ),
      initialValue: initialTitle,
    );
  }

  Widget _buildCreatedAtFormField(
      DateTime? initialCreatedAtDate, FieldSuggestions? filteredSuggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormBuilderDateTimePicker(
          inputType: InputType.date,
          name: fkCreatedDate,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.calendar_month_outlined),
            label: Text(S.of(context)!.createdAt),
          ),
          initialValue: initialCreatedAtDate,
          format: DateFormat.yMMMMd(Localizations.localeOf(context).toString()),
          initialEntryMode: DatePickerEntryMode.calendar,
        ),
        if (filteredSuggestions?.hasSuggestedDates ?? false)
          _buildSuggestionsSkeleton<DateTime>(
            suggestions: filteredSuggestions!.dates,
            itemBuilder: (context, itemData) => ActionChip(
              label: Text(
                  DateFormat.yMMMMd(Localizations.localeOf(context).toString())
                      .format(itemData)),
              onPressed: () => _formKey.currentState?.fields[fkCreatedDate]
                  ?.didChange(itemData),
            ),
          ),
      ],
    );
  }

  ///
  /// Item builder is typically some sort of [Chip].
  ///
  Widget _buildSuggestionsSkeleton<T>({
    required Iterable<T> suggestions,
    required ItemBuilder<T> itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context)!.suggestions,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            itemBuilder: (context, index) => ColoredChipWrapper(
              child: itemBuilder(context, suggestions.elementAt(index)),
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 4.0),
          ),
        ),
      ],
    ).padded();
  }
}

// class SampleWidget extends StatefulWidget {
//   const SampleWidget({super.key});

//   @override
//   State<SampleWidget> createState() => _SampleWidgetState();
// }

// class _SampleWidgetState extends State<SampleWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<OptionsBloc, OptionsState>(
//       builder: (context, state) {
//         return OptionsFormField(
//           options: state.options,
//           onAddOption: (option) {
//             // This will call the repository and will cause a new state containing the new option to be emitted.
//             context.read<OptionsBloc>().addOption(option);
//           },
//         );
//       },
//     );
//   }
// }

// class OptionsFormField extends StatefulWidget {
//   final List<Option> options;
//   final void Function(Option option) onAddOption;

//   const OptionsFormField({
//     super.key,
//     required this.options,
//     required this.onAddOption,
//   });

//   @override
//   State<OptionsFormField> createState() => _OptionsFormFieldState();
// }

// class _OptionsFormFieldState extends State<OptionsFormField> {
//   final TextEditingController _controller;
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       onTap: () async {
//         // User creates new option...
//         final Option option = await showOptionCreationForm();
//         widget.onAddOption(option);
//       },
//     );
//   }
// }
