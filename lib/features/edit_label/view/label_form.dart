// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';

import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/translation/matching_algorithm_localization_mapper.dart';
import 'package:paperless_mobile/features/labels/view/widgets/custom_searchbar.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

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
  }) : super(key: key);

  @override
  State<LabelForm> createState() => _LabelFormState<T>();
}

class _LabelFormState<T extends Label> extends State<LabelForm<T>> {
  late final GlobalKey<FormBuilderState> _formKey;

  late bool _enableMatchFormField;
  int _parentId = -1;
  String? _selectedWarehouse = '';
  String? _selectedShelf = '';
  Map<String, String> _errors = {};

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey ?? GlobalKey<FormBuilderState>();
    var matchingAlgorithm = (widget.initialValue?.matchingAlgorithm ??
        MatchingAlgorithm.defaultValue);
    _enableMatchFormField = matchingAlgorithm != MatchingAlgorithm.auto &&
        matchingAlgorithm != MatchingAlgorithm.none;
  }

  @override
  Widget build(BuildContext context) {
    List<MatchingAlgorithm> selectableMatchingAlgorithmValues =
        getSelectableMatchingAlgorithmValues(
      context.watch<LocalUserAccount>().hasMultiUserSupport,
    );
    final labelRepository = context.watch<LabelRepository>();
    final currentUser = context.watch<LocalUserAccount>().paperlessUser;
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
        child: ListView(
          children: [
            FormBuilderTextField(
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
            if (widget.type == 'Shelf' && widget.action == 'edit')
              _buildWarehouseFormField(context, labelRepository, currentUser,
                  (p0) => widget.onChangedWarehouse!(p0)),
            if (widget.type == 'Boxcase' && widget.action == 'edit')
              _buildWarehouseFormFiel1(context, labelRepository, currentUser,
                  (p0) => widget.onChangedWarehouse!(p0)),
            if (widget.type == 'Boxcase' && widget.action == 'edit')
              _buildShelfFormField(
                context,
                currentUser,
                (p0) => widget.onChangedShelf!(p0),
                labelRepository,
              ),
            FormBuilderDropdown<int?>(
              name: Label.matchingAlgorithmKey,
              initialValue: (widget.initialValue?.matchingAlgorithm ??
                      MatchingAlgorithm.defaultValue)
                  .value,
              decoration: InputDecoration(
                labelText: S.of(context)!.matchingAlgorithm,
                errorText: _errors[Label.matchingAlgorithmKey],
              ),
              onChanged: (val) {
                setState(() {
                  _errors = {};
                  _enableMatchFormField = val != MatchingAlgorithm.auto.value &&
                      val != MatchingAlgorithm.none.value;
                });
              },
              items: selectableMatchingAlgorithmValues
                  .map(
                    (algo) => DropdownMenuItem<int?>(
                      value: algo.value,
                      child: Text(
                        translateMatchingAlgorithmDescription(context, algo),
                      ),
                    ),
                  )
                  .toList(),
            ),
            if (_enableMatchFormField)
              FormBuilderTextField(
                name: Label.matchKey,
                decoration: InputDecoration(
                  labelText: S.of(context)!.match,
                  errorText: _errors[Label.matchKey],
                ),
                initialValue: widget.initialValue?.match,
                onChanged: (val) => setState(() => _errors = {}),
              ),
            FormBuilderField<bool>(
              name: Label.isInsensitiveKey,
              initialValue: widget.initialValue?.isInsensitive ?? true,
              builder: (field) {
                return CheckboxListTile(
                  value: field.value,
                  title: Text(S.of(context)!.caseIrrelevant),
                  onChanged: (value) => field.didChange(value),
                );
              },
            ),
            ...widget.additionalFields,
          ].padded(),
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

  List<MatchingAlgorithm> getSelectableMatchingAlgorithmValues(
      bool hasMultiUserSupport) {
    var selectableMatchingAlgorithmValues = MatchingAlgorithm.values;
    if (!hasMultiUserSupport) {
      selectableMatchingAlgorithmValues = selectableMatchingAlgorithmValues
          .where((matchingAlgorithm) =>
              matchingAlgorithm != MatchingAlgorithm.none)
          .toList();
    }
    return selectableMatchingAlgorithmValues;
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

        final parsed = widget.fromJsonT(mergedJson);
        final createdLabel = await widget.submitButtonConfig.onSubmit(parsed);
        showSnackBar(
          context,
          S.of(context)!.notiActionSuccess,
        );

        context.pop(createdLabel);
      } on PaperlessApiException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      } on PaperlessFormValidationException catch (exception) {
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
