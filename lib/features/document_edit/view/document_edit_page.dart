import 'dart:async';

import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:animated_tree_view/tree_view/widgets/expansion_indicator.dart';
import 'package:animated_tree_view/tree_view/widgets/indent.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/bloc/connectivity_cubit.dart';
import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/core/repository/label_repository.dart';
import 'package:edocs_mobile/core/widgets/dialog_utils/pop_with_unsaved_changes.dart';
import 'package:edocs_mobile/core/widgets/form_builder_fields/form_builder_localized_date_picker.dart';
import 'package:edocs_mobile/core/workarounds/colored_chip.dart';
import 'package:edocs_mobile/features/document_edit/cubit/document_edit_cubit.dart';
import 'package:edocs_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:edocs_mobile/features/documents/view/pages/document_view.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/features/labels/tags/view/widgets/tags_form_field.dart';
import 'package:edocs_mobile/features/labels/view/widgets/label_form_field.dart';
import 'package:edocs_mobile/features/labels/view/widgets/custom_searchbar.dart';
import 'package:edocs_mobile/features/logging/data/mirrored_file_output.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/helpers/message_helpers.dart';
import 'package:edocs_mobile/routing/routes/labels_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T itemData);

class DocumentEditPage extends StatefulWidget {
  final DocumentModel documentModel;
  const DocumentEditPage({super.key, required this.documentModel});

  @override
  State<DocumentEditPage> createState() => _DocumentEditPageState();
}

class _DocumentEditPageState extends State<DocumentEditPage>
    with TickerProviderStateMixin {
  static const fkTitle = "title";
  static const fkCorrespondent = "correspondent";
  static const fkTags = "tags";
  static const fkDocumentType = "documentType";
  static const fkCreatedDate = "createdAtDate";
  static const fkStoragePath = 'storagePath';
  static const fkContent = 'content';

  final _formKey = GlobalKey<FormBuilderState>();

  bool _isShowingPdf = false;
  bool _enableFiledBoxcase = true;
  int _warehouseId = -1;
  int _shelfId = -1;
  int _boxcaseId = -1;
  String _selectedWarehouse = '';
  String _selectedShelf = '';
  String _selectedBoxcase = '';
  TreeViewController? _controller;
  var _parentFolder;
  int? _selectedItemId;
  bool _selectedRoot = false;
  final Map<String, bool> loadedNodes = {};
  final expandChildrenOnReady = false;
  Map<String, bool> loading = {};

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading['shelf'] = false;
      loading['case'] = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInCubic)
            .drive(Tween<double>(begin: 0, end: 1));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<LocalUserAccount>().edocsUser;

    return BlocBuilder<DocumentEditCubit, DocumentEditState>(
      builder: (context, state) {
        final filteredSuggestions = state.suggestions;
        final warehouse = state.document.warehouse;

        return PopWithUnsavedChanges(
          hasChangesPredicate: () {
            final fkState = _formKey.currentState;
            if (fkState == null) {
              return false;
            }
            final doc = state.document;
            final (
              title,
              correspondent,
              documentType,
              storagePath,
              tags,
              createdAt,
              content,
              folder,
            ) = _currentValues;
            final isContentTouched =
                _formKey.currentState?.fields[fkContent]?.isDirty ?? false;

            return doc.title != title ||
                doc.correspondent != correspondent ||
                doc.documentType != documentType ||
                doc.storagePath != storagePath ||
                !const UnorderedIterableEquality().equals(doc.tags, tags) ||
                doc.created != createdAt ||
                (doc.content != content && isContentTouched) ||
                doc.warehouse != warehouse ||
                doc.folder != folder;
          },
          child: FormBuilder(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text(S.of(context)!.editDocument),
                actions: [
                  IconButton(
                    tooltip: _isShowingPdf
                        ? S.of(context)!.hidePdf
                        : S.of(context)!.showPdf,
                    padding: const EdgeInsets.all(12),
                    icon: AnimatedCrossFade(
                      duration: _animationController.duration!,
                      reverseDuration: _animationController.reverseDuration,
                      crossFadeState: _isShowingPdf
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: const Icon(Icons.visibility_off_outlined),
                      secondChild: const Icon(Icons.visibility_outlined),
                    ),
                    onPressed: () {
                      if (_isShowingPdf) {
                        setState(() {
                          _isShowingPdf = false;
                        });
                        _animationController.reverse();
                      } else {
                        setState(() {
                          _isShowingPdf = true;
                        });
                        _animationController.forward();
                      }
                    },
                  )
                ],
              ),
              body: Stack(
                children: [
                  DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      resizeToAvoidBottomInset: true,
                      floatingActionButton: !_isShowingPdf
                          ? FloatingActionButton.extended(
                              heroTag: "fab_document_edit",
                              onPressed: () => _onSubmit(state.document),
                              icon: const Icon(Icons.save),
                              label: Text(S.of(context)!.saveChanges),
                            )
                          : null,
                      appBar: TabBar(
                        tabs: [
                          Tab(text: S.of(context)!.overview),
                          Tab(text: S.of(context)!.content),
                        ],
                      ),
                      extendBody: true,
                      body: _buildEditForm(
                          context, state, filteredSuggestions, currentUser),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        alignment: Alignment.bottomLeft,
                        scale: _animation.value,
                        child: DocumentView(
                          showAppBar: false,
                          showControls: false,
                          title: state.document.title,
                          bytes: context
                              .read<EdocsDocumentsApi>()
                              .downloadDocument(state.document.id),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding _buildEditForm(
    BuildContext context,
    DocumentEditState state,
    FieldSuggestions? filteredSuggestions,
    UserModel currentUser,
  ) {
    final labelRepository = context.watch<LabelRepository>();
    final selectedWarehouse = labelRepository.warehouses[labelRepository
                .shelfs[labelRepository
                    .boxcases[state.document.warehouse]?.parentWarehouse]
                ?.parentWarehouse ??
            S.of(context)!.selecteWarehouse]
        .toString();
    String? selectedShelf = labelRepository.shelfs[labelRepository
                .boxcases[state.document.warehouse]?.parentWarehouse ??
            S.of(context)!.selectShelf]
        .toString();
    String? selectedBoxcase =
        labelRepository.boxcases[state.document.warehouse].toString();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  _buildTitleFormField(state.document.title).padded(),
                  _buildCreatedAtFormField(
                    state.document.created,
                    filteredSuggestions,
                  ).padded(),
                  if (currentUser.canViewCorrespondents)
                    Column(
                      children: [
                        LabelFormField<Correspondent>(
                          showAnyAssignedOption: false,
                          showNotAssignedOption: false,
                          onAddLabel: (currentInput) => CreateLabelRoute(
                            LabelType.correspondent,
                            name: currentInput,
                          ).push<Correspondent>(context),
                          addLabelText: S.of(context)!.addCorrespondent,
                          labelText: S.of(context)!.correspondent,
                          options: labelRepository.correspondents,
                          initialValue: state.document.correspondent != null
                              ? SetIdQueryParameter(
                                  id: state.document.correspondent!)
                              : const UnsetIdQueryParameter(),
                          name: fkCorrespondent,
                          prefixIcon: const Icon(Icons.person_outlined),
                          allowSelectUnassigned: true,
                          canCreateNewLabel:
                              currentUser.canCreateCorrespondents,
                          suggestions:
                              filteredSuggestions?.correspondents ?? [],
                        ),
                      ],
                    ).padded(),
                  if (currentUser.canViewDocumentTypes)
                    Column(
                      children: [
                        LabelFormField<DocumentType>(
                          showAnyAssignedOption: false,
                          showNotAssignedOption: false,
                          onAddLabel: (currentInput) => CreateLabelRoute(
                            LabelType.documentType,
                            name: currentInput,
                          ).push<DocumentType>(context),
                          canCreateNewLabel: currentUser.canCreateDocumentTypes,
                          addLabelText: S.of(context)!.addDocumentType,
                          labelText: S.of(context)!.documentType,
                          initialValue: state.document.documentType != null
                              ? SetIdQueryParameter(
                                  id: state.document.documentType!)
                              : const UnsetIdQueryParameter(),
                          options: labelRepository.documentTypes,
                          name: _DocumentEditPageState.fkDocumentType,
                          prefixIcon: const Icon(Icons.description_outlined),
                          allowSelectUnassigned: true,
                          suggestions: filteredSuggestions?.documentTypes ?? [],
                        ),
                      ],
                    ).padded(),
                  if (currentUser.canViewStoragePaths)
                    Column(
                      children: [
                        LabelFormField<StoragePath>(
                          showAnyAssignedOption: false,
                          showNotAssignedOption: false,
                          onAddLabel: (currentInput) => CreateLabelRoute(
                            LabelType.storagePath,
                            name: currentInput,
                          ).push<StoragePath>(context),
                          canCreateNewLabel: currentUser.canCreateStoragePaths,
                          addLabelText: S.of(context)!.addStoragePath,
                          labelText: S.of(context)!.storagePath,
                          options: labelRepository.storagePaths,
                          initialValue: state.document.storagePath != null
                              ? SetIdQueryParameter(
                                  id: state.document.storagePath!)
                              : const UnsetIdQueryParameter(),
                          name: fkStoragePath,
                          prefixIcon: const Icon(Icons.folder_outlined),
                          allowSelectUnassigned: true,
                        ),
                      ],
                    ).padded(),
                  if (currentUser.canViewTags)
                    TagsFormField(
                      options: labelRepository.tags,
                      name: fkTags,
                      allowOnlySelection: true,
                      allowCreation: true,
                      allowExclude: false,
                      suggestions: filteredSuggestions?.tags ?? [],
                      initialValue: IdsTagsQuery(
                        include: state.document.tags.toList(),
                      ),
                    ).padded(),
                  if (currentUser.canViewWarehouse)
                    Column(
                      children: [
                        _buildWarehouseFormField(
                          context,
                          labelRepository.warehouses,
                          state.document.warehouse != null
                              ? selectedWarehouse
                              : S.of(context)?.selecteWarehouse,
                          (value) => _findKeyForValue(
                              labelRepository.warehouses,
                              value!,
                              labelRepository,
                              'warehouse',
                              context),
                        )
                      ],
                    ).padded(),
                  if (currentUser.canViewWarehouse)
                    Column(
                      children: [
                        loading['shelf'] == true
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : _buildShelfFormField(
                                context,
                                labelRepository.shelfs,
                                state.document.warehouse != null
                                    ? selectedShelf
                                    : S.of(context)?.selectShelf,
                                (value) => _findKeyForValue(
                                    labelRepository.shelfs,
                                    value!,
                                    labelRepository,
                                    'shelf',
                                    context),
                              )
                      ],
                    ).padded(),
                  if (currentUser.canViewWarehouse)
                    Column(
                      children: [
                        loading['case'] == true
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : _buildBoxcaseFormField(
                                context,
                                labelRepository.boxcases,
                                state.document.warehouse != null
                                    ? selectedBoxcase
                                    : S.of(context)?.selectBriefcase,
                                (value) => _findKeyForValue(
                                    labelRepository.boxcases,
                                    value!,
                                    labelRepository,
                                    'boxcase',
                                    context),
                              )
                      ],
                    ).padded(),
                ]),
              ),
              if (currentUser.canViewWarehouse) _buildFolderTree(context),
              const SliverToBoxAdapter(child: SizedBox(height: 140)),
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
    );
  }

  (String?, int?, int?, int?, List<int>?, DateTime?, String?, int?)
      get _currentValues {
    final fkState = _formKey.currentState!;

    final correspondentParam =
        fkState.getRawValue<IdQueryParameter?>(fkCorrespondent);
    final documentTypeParam =
        fkState.getRawValue<IdQueryParameter?>(fkDocumentType);
    final storagePathParam =
        fkState.getRawValue<IdQueryParameter?>(fkStoragePath);
    final tagsParam = fkState.getRawValue<TagsQuery?>(fkTags);
    final title = fkState.getRawValue<String?>(fkTitle);
    final created = fkState.getRawValue<FormDateTime?>(fkCreatedDate);

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

    final content = fkState.getRawValue<String?>(fkContent);

    return (
      title,
      correspondent,
      documentType,
      storagePath,
      tags,
      created?.toDateTime(),
      content,
      _parentFolder,
    );
  }

  Future<void> _onSubmit(DocumentModel document) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final (
        title,
        correspondent,
        documentType,
        storagePath,
        tags,
        createdAt,
        content,
        folder,
      ) = _currentValues;

      var mergedDocument = document.copyWith(
          warehouse: () => _boxcaseId == -1 ? document.warehouse : _boxcaseId,
          title: title,
          created: createdAt,
          correspondent: () => correspondent,
          documentType: () => documentType,
          storagePath: () => storagePath,
          tags: tags,
          content: content,
          folder: folder);

      try {
        await context.read<DocumentEditCubit>().updateDocument(mergedDocument);
        showSnackBar(context, S.of(context)!.documentSuccessfullyUpdated);
      } on EdocsApiException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      } finally {
        context.pop();
      }
    }
  }

  _buildFolderTree(BuildContext context) {
    return BlocBuilder<DocumentsCubit, DocumentsState>(
      builder: (context, state) {
        context.read<LabelCubit>().buildTreeHasOnlyFolder();
        return BlocBuilder<LabelCubit, LabelState>(
          builder: (context, lbState) {
            return lbState.isLoading
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : lbState.folderTree!.length == 0
                    ? _buildEmptyTree(context)
                    : _buildTree(context, lbState);
          },
        );
      },
    );
  }

  _buildTree(BuildContext context, LabelState lbState) {
    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverTreeView.simple(
        tree: lbState.folderTree!,
        showRootNode: true,
        expansionIndicatorBuilder: (context, node) =>
            ChevronIndicator.rightDown(
          alignment: Alignment.centerRight,
          tree: node,
          padding: const EdgeInsets.all(16),
        ),
        indentation: const Indentation(style: IndentStyle.squareJoint),
        onTreeReady: (controller) {
          _controller = controller;
          if (expandChildrenOnReady)
            controller.expandAllChildren(lbState.folderTree!);
        },
        builder: (context, node) {
          return node.level == 0
              ? Card(
                  color: _selectedRoot
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        _controller?.toggleExpansion(node);
                        _selectedRoot = !_selectedRoot;
                        _parentFolder = null;
                        _parentFolder = -1;
                      });
                    },
                    child: ListTile(
                      title: Text(S.of(context)!.chooseFolder),
                      subtitle: Text(S.of(context)!.rootFolder),
                    ),
                  ),
                )
              : node.data is Folder
                  ? Card(
                      color: widget.documentModel.folder ==
                              node.data.getValue('id')
                          ? Theme.of(context).colorScheme.shadow
                          : node.data.getValue('id') == _selectedItemId
                              ? Theme.of(context).colorScheme.primary
                              : null,
                      child: GestureDetector(
                        onLongPress: () {
                          if (widget.documentModel.id ==
                              node.data.getValue('id')) {
                            null;
                          } else {
                            setState(() {
                              _parentFolder = node.data.getValue('id');
                              _selectedItemId = node.data.getValue('id');
                              _selectedRoot = false;
                            });
                          }
                        },
                        child: ListTile(
                          title: Text(node.data.getValue('name')),
                          subtitle: Text('Level ${node.level}'),
                          onTap: () {
                            _controller?.toggleExpansion(node);
                            if (loadedNodes[node.data.getValue('checksum')] !=
                                true) {
                              context.read<LabelCubit>().loadChildNodes(
                                    node.data.getValue('id'),
                                    node,
                                  );
                              setState(() {
                                loadedNodes[node.data.getValue('checksum')] =
                                    true;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  : const SizedBox();
        },
      ),
    );
  }

  _buildEmptyTree(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context)!.youDidNotAnyFolderYet,
            style: Theme.of(context).textTheme.bodySmall,
          ).padded(),
          TextButton.icon(
            onPressed: () {
              CreateLabelRoute(
                LabelType.folders,
              ).push(context);
            },
            icon: const Icon(Icons.add),
            label: Text(S.of(context)!.newView),
          )
        ],
      ).paddedOnly(left: 16),
    );
  }

  _findKeyForValue(
      Map<int, Object> map,
      String? value,
      LabelRepository labelRepository,
      String type,
      BuildContext context) async {
    if (type == 'warehouse') {
      setState(() {
        loading['shelf'] = true;
      });
    } else {
      setState(() {
        loading['case'] = true;
      });
    }

    map.forEach((key, mapValue) {
      if (mapValue.toString() == value) {
        switch (type) {
          case 'warehouse':
            setState(() {
              _warehouseId = key;
              _selectedWarehouse = value ?? '';
              _enableFiledBoxcase = false;
            });
            break;
          case 'shelf':
            setState(() {
              _shelfId = key;
              _selectedShelf = value ?? '';
              _enableFiledBoxcase = true;
            });
            break;
          case 'boxcase':
            setState(() {
              _boxcaseId = key;
              _selectedBoxcase = value ?? '';
            });
            break;
          default:
            break;
        }
      }
    });

    if (type != 'boxcase') {
      type == 'warehouse'
          ? await labelRepository.findDetailsWarehouse(_warehouseId)
          : await labelRepository.findDetailsShelf(_shelfId);
    }
    if (type == 'warehouse') {
      setState(() {
        loading['shelf'] = false;
      });
    } else {
      setState(() {
        loading['case'] = false;
      });
    }
  }

  Widget _buildWarehouseFormField(
    BuildContext context,
    Map<int, Warehouse> warehouses,
    String? selectedItem,
    Function(String?)? onChanged,
  ) {
    return CustomSearchBar(
      prefixIcon: const Icon(Icons.warehouse_outlined),
      items: warehouses.values.map((value) => value.toString()).toList(),
      selectedItem: _selectedWarehouse.isEmpty
          ? selectedItem == 'null'
              ? S.of(context)!.selecteWarehouse
              : selectedItem
          : _selectedWarehouse,
      onChanged: (value) => {onChanged!(value!)},
      fieldName: S.of(context)!.warehouse,
      hintText: S.of(context)!.selecteWarehouse,
    );
  }

  Widget _buildShelfFormField(
    BuildContext context,
    Map<int, Warehouse> shelfs,
    String? selectedItem,
    Function(String?)? onChanged,
  ) {
    return CustomSearchBar(
      prefixIcon: const Icon(Icons.shelves),
      items: shelfs.values.map((value) => value.toString()).toList(),
      selectedItem: _selectedShelf.isEmpty
          ? selectedItem == 'null'
              ? S.of(context)!.selectShelf
              : selectedItem
          : _selectedShelf,
      onChanged: (value) => {onChanged!(value!)},
      fieldName: S.of(context)!.shelf,
      hintText: S.of(context)!.selectShelf,
    );
  }

  Widget _buildBoxcaseFormField(
    BuildContext context,
    Map<int, Warehouse> boxcases,
    String? selectedItem,
    Function(String?)? onChanged,
  ) {
    return CustomSearchBar(
      prefixIcon: const Icon(Icons.cases_outlined),
      enable: _enableFiledBoxcase,
      items: boxcases.values.map((value) => value.toString()).toList(),
      selectedItem: _selectedBoxcase.isEmpty
          ? selectedItem == 'null'
              ? S.of(context)!.selectBriefcase
              : selectedItem
          : _selectedBoxcase,
      onChanged: (value) => {onChanged!(value!)},
      fieldName: S.of(context)!.briefcase,
      hintText: S.of(context)!.selectBriefcase,
    );
  }

  Widget _buildTitleFormField(String? initialTitle) {
    return FormBuilderTextField(
      name: fkTitle,
      decoration: InputDecoration(
        label: Text(S.of(context)!.title),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _formKey.currentState?.fields[fkTitle]?.didChange(null);
          },
        ),
      ),
      initialValue: initialTitle,
    );
  }

  Widget _buildCreatedAtFormField(
      DateTime? initialCreatedAtDate, FieldSuggestions? filteredSuggestions) {
    return Column(
      children: [
        FormBuilderLocalizedDatePicker(
          name: fkCreatedDate,
          initialValue: initialCreatedAtDate,
          labelText: S.of(context)!.createdAt,
          firstDate: DateTime(1970, 1, 1),
          lastDate: DateTime(2100, 1, 1),
          locale: Localizations.localeOf(context),
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        if (filteredSuggestions?.hasSuggestedDates ?? false)
          _buildSuggestionsSkeleton<DateTime>(
            suggestions: filteredSuggestions!.dates,
            itemBuilder: (context, itemData) => ActionChip(
              label: Text(
                  DateFormat.yMMMMd(Localizations.localeOf(context).toString())
                      .format(itemData)),
              onPressed: () => _formKey.currentState?.fields[fkCreatedDate]
                  ?.didChange(FormDateTime.fromDateTime(itemData)),
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
