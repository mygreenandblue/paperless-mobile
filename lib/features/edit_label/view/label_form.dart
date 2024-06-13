// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:edocs_api/edocs_api.dart';

import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/core/repository/label_repository.dart';
import 'package:edocs_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/features/labels/view/widgets/custom_searchbar.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/helpers/message_helpers.dart';
import 'package:edocs_mobile/routing/routes/labels_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';

class SubmitButtonConfig<T extends Label> {
  final Widget icon;
  final Widget label;
  final Future<T> Function(T) onSubmit;

  SubmitButtonConfig({
    required this.icon,
    required this.label,
    required this.onSubmit,
  });
}

class LabelForm<T extends Label> extends StatefulWidget {
  final T? initialValue;
  final int? initialWarehouse;
  final Function(String?)? onChangedShelf;
  final Function(String?)? onChangedWarehouse;
  final SubmitButtonConfig<T> submitButtonConfig;
  final int? parentId;
  final int? parentFolder;

  /// FromJson method to parse the form field values into a label instance.
  final T Function(Map<String, dynamic> json) fromJsonT;

  /// List of additionally rendered form fields.
  final List<Widget> additionalFields;
  final String? type;
  final String? action;
  final bool autofocusNameField;
  final GlobalKey<FormBuilderState>? formKey;

  const LabelForm({
    Key? key,
    required this.initialValue,
    this.initialWarehouse,
    this.onChangedShelf,
    this.onChangedWarehouse,
    required this.submitButtonConfig,
    required this.fromJsonT,
    this.additionalFields = const [],
    this.type,
    required this.autofocusNameField,
    this.formKey,
    this.parentId,
    this.action,
    this.parentFolder,
  }) : super(key: key);

  @override
  State<LabelForm> createState() => _LabelFormState<T>();
}

class _LabelFormState<T extends Label> extends State<LabelForm<T>> {
  late final GlobalKey<FormBuilderState> _formKey;

  int _parentId = -1;
  String? _selectedWarehouse = '';
  String? _selectedShelf = '';
  Map<String, String> _errors = {};
  TreeViewController? _controller;
  var _parentFolder;
  int? _selectedItemId;
  bool _selectedRoot = false;
  final Map<String, bool> loadedNodes = {};

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey ?? GlobalKey<FormBuilderState>();
  }

  @override
  Widget build(BuildContext context) {
    final labelRepository = context.watch<LabelRepository>();
    final currentUser = context.watch<LocalUserAccount>().edocsUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "fab_label_form",
        icon: widget.submitButtonConfig.icon,
        label: widget.submitButtonConfig.label,
        onPressed: _onSubmit,
      ),
      body: FormBuilder(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: FormBuilderTextField(
                  autofocus: widget.autofocusNameField,
                  name: Label.nameKey,
                  decoration: InputDecoration(
                    labelText: S.of(context)!.name,
                    errorText: _errors[Label.nameKey],
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return S.of(context)!.thisFieldIsRequired;
                    }
                    return null;
                  },
                  initialValue: widget.initialValue?.name,
                  onChanged: (val) => setState(() => _errors = {}),
                ),
              ),
            ),
            if (widget.type == 'Shelf' && widget.action == 'edit')
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverToBoxAdapter(
                  child: _buildWarehouseFormField(context, labelRepository,
                      currentUser, (p0) => widget.onChangedWarehouse!(p0)),
                ),
              ),
            if (widget.type == 'Boxcase' && widget.action == 'edit')
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverToBoxAdapter(
                  child: _buildWarehouseFormFiel1(context, labelRepository,
                      currentUser, (p0) => widget.onChangedWarehouse!(p0)),
                ),
              ),
            if (widget.type == 'Boxcase' && widget.action == 'edit')
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverToBoxAdapter(
                  child: _buildShelfFormField(
                    context,
                    currentUser,
                    (p0) => widget.onChangedShelf!(p0),
                    labelRepository,
                  ),
                ),
              ),
            if (widget.type == 'Folder') _buildFolderTree(context, currentUser),
            ...widget.additionalFields,
          ],
        ),
      ),
    );
  }

  Widget _buildWarehouseFormField(
    BuildContext context,
    LabelRepository labelRepository,
    UserModel currentUser,
    Function(String?)? onChanged,
  ) {
    final warehouses = labelRepository.warehouses;
    return CustomSearchBar(
      prefixIcon: const Icon(Icons.warehouse_outlined),
      items: warehouses.values.map((value) => value.toString()).toList(),
      selectedItem: _selectedWarehouse != ''
          ? _selectedWarehouse
          : warehouses[widget.initialWarehouse].toString() == 'null'
              ? S.of(context)?.selecteWarehouse
              : warehouses[widget.initialWarehouse].toString(),
      onChanged: (value) async {
        await _findKeyForValue(warehouses, value!, 'w');
        onChanged!(value);
      },
      fieldName: S.of(context)?.warehouse,
      hintText: S.of(context)?.selecteWarehouse,
    );
  }

  Widget _buildWarehouseFormFiel1(
    BuildContext context,
    LabelRepository labelRepository,
    UserModel currentUser,
    Function(String?)? onChanged,
  ) {
    final warehouses = labelRepository.warehouses;
    final shelfs = labelRepository.shelfs;
    return CustomSearchBar(
      prefixIcon: const Icon(Icons.warehouse_outlined),
      items: warehouses.values.map((value) => value.toString()).toList(),
      selectedItem: _selectedWarehouse != ''
          ? _selectedWarehouse
          : warehouses[(shelfs[widget.initialWarehouse])?.parentWarehouse ?? '']
                      .toString() ==
                  'null'
              ? S.of(context)?.selecteWarehouse
              : warehouses[
                      (shelfs[widget.initialWarehouse])?.parentWarehouse ?? '']
                  .toString(),
      onChanged: (value) async {
        _findKeyForValue(warehouses, value!, 'w1');
        onChanged!(value);
      },
      fieldName: S.of(context)?.warehouse,
      hintText: S.of(context)?.selecteWarehouse,
    );
  }

  Widget _buildShelfFormField(
    BuildContext context,
    UserModel currentUser,
    Function(String?)? onChanged,
    LabelRepository labelRepository,
  ) {
    final shelfs = labelRepository.shelfs;

    return CustomSearchBar(
      prefixIcon: const Icon(Icons.shelves),
      items: shelfs.values.map((value) => value.toString()).toList(),
      selectedItem: _selectedShelf != ''
          ? _selectedShelf
          : labelRepository.shelfs[widget.initialWarehouse].toString() == 'null'
              ? S.of(context)?.selectShelf
              : labelRepository.shelfs[widget.initialWarehouse].toString(),
      onChanged: (value) async {
        await _findKeyForValue(shelfs, value!, 'sh');
        onChanged!(value);
      },
      fieldName: S.of(context)?.shelf,
      hintText: S.of(context)?.selectShelf,
    );
  }

  _buildFolderTree(BuildContext context, UserModel currentUSer) {
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
      padding: const EdgeInsets.all(16),
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
                        _selectedItemId = -1;
                      });
                    },
                    child: ListTile(
                      title: Text(S.of(context)!.chooseFolder),
                      subtitle: Text(S.of(context)!.allFolder),
                    ),
                  ),
                )
              : node.data is Folder
                  ? Card(
                      color: widget.initialValue!.id == node.data.getValue('id')
                          ? Theme.of(context).colorScheme.shadow
                          : node.data.getValue('id') == _selectedItemId
                              ? Theme.of(context).colorScheme.primary
                              : null,
                      child: GestureDetector(
                        onLongPress: () {
                          if (widget.initialValue!.id ==
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
                            if (widget.initialValue!.id ==
                                node.data.getValue('id')) {
                              null;
                            } else {
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

  void _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final mergedJson = {
          ...widget.initialValue?.toJson() ?? {},
          ..._formKey.currentState!.value
        };

        mergedJson['type'] = widget.type;
        if (_parentId != -1) {
          mergedJson['parent_warehouse'] = _parentId;
        }
        if (widget.parentId != -1) {
          mergedJson['parent_warehouse'] = widget.parentId;
        }

        if (_parentFolder != -1) {
          mergedJson['parent_folder'] = _parentFolder;
        }

        if (_parentFolder == null) {
          mergedJson['parent_folder'] = null;
        }
        if (widget.parentFolder != -1 && widget.parentFolder != null) {
          mergedJson['parent_folder'] = widget.parentFolder;
        }

        final parsed = widget.fromJsonT(mergedJson);
        final createdLabel = await widget.submitButtonConfig.onSubmit(parsed);
        showSnackBar(
          context,
          S.of(context)!.notiActionSuccess,
        );

        context.pop(createdLabel);
      } on EdocsApiException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      } on edocsFormValidationException catch (exception) {
        setState(() => _errors = exception.validationMessages);
      }
    }
  }

  Future<void> _findKeyForValue(
      Map<int, Object> map, String value, String type) async {
    map.forEach((key, mapValue) {
      if (mapValue.toString() == value) {
        switch (type) {
          case 'w':
            setState(() {
              _selectedWarehouse = value;
              _parentId = key;
            });
            break;
          case 'w1':
            setState(() {
              _selectedWarehouse = value;
            });
            break;
          case 'sh':
            setState(() {
              _parentId = key;
              _selectedShelf = value;
            });
            break;

          default:
            break;
        }
      }
    });
  }
}

final expandChildrenOnReady = false;
