// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';

import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/widgets/custom_searchbar.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class PhysicalWarehouseForm<T> extends StatefulWidget {
  /// List of additionally rendered form fields.
  final List<Widget> additionalFields;
  final T? initialValue;
  final String type;
  final String action;
  final bool autofocusNameField;
  final String? initialName;
  final String? initialShelf;
  final String? initialWarehouse;

  const PhysicalWarehouseForm({
    Key? key,
    this.additionalFields = const [],
    this.initialValue,
    required this.type,
    required this.action,
    required this.autofocusNameField,
    this.initialName,
    this.initialShelf,
    this.initialWarehouse,
  }) : super(key: key);

  @override
  State<PhysicalWarehouseForm> createState() => _PhysicalWarehouseFormState();
}

class _PhysicalWarehouseFormState<T extends Label>
    extends State<PhysicalWarehouseForm> {
  Map<String, String> _errors = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(widget.action == 'create' ? Icons.add : Icons.save),
        label: Text(widget.action == 'create'
            ? S.of(context)!.create
            : S.of(context)!.saveChanges),
        onPressed: _onSubmit,
      ),
      body: FormBuilder(
        child: ListView(
          children: [
            FormBuilderTextField(
              autofocus: widget.autofocusNameField,
              name: Label.nameKey,
              initialValue: widget.initialName,
              decoration: InputDecoration(
                labelText: widget.type == 'warehouse'
                    ? S.of(context)!.warehouseName
                    : widget.type == 'shelf'
                        ? S.of(context)!.shelfName
                        : S.of(context)!.briefcaseName,
                errorText: _errors[Label.nameKey],
              ),
              validator: (value) {
                if (value?.trim().isEmpty ?? true) {
                  return S.of(context)!.thisFieldIsRequired;
                }
                return null;
              },
              onChanged: (val) => setState(() => _errors = {}),
            ),
            if (widget.type == 'shelf' || widget.type == 'briefcase')
              CustomSearchBar(
                hintText: widget.type == 'shelf'
                    ? S.of(context)!.warehouseName
                    : S.of(context)!.shelfName,
                selectedItem: widget.type == 'shelf'
                    ? widget.initialWarehouse
                    : widget.initialShelf,
              ),
            if (widget.type == 'briefcase')
              CustomSearchBar(
                hintText: S.of(context)!.warehouseName,
                selectedItem: widget.initialWarehouse,
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
            // FormBuilderDropdown<int?>(
            //   name: Label.matchingAlgorithmKey,
            //   // initialValue: (widget.initialValue?.matchingAlgorithm ??
            //   //         MatchingAlgorithm.defaultValue)
            //   //     .value,
            //   decoration: InputDecoration(
            //     labelText: S.of(context)!.matchingAlgorithm,
            //     errorText: _errors[Label.matchingAlgorithmKey],
            //   ),
            //   onChanged: (val) {
            //     setState(() {
            //       _errors = {};
            //       _enableMatchFormField = val != MatchingAlgorithm.auto.value &&
            //           val != MatchingAlgorithm.none.value;
            //     });
            //   },
            //   items: selectableMatchingAlgorithmValues
            //       .map(
            //         (algo) => DropdownMenuItem<int?>(
            //           child: Text(
            //             translateMatchingAlgorithmDescription(context, algo),
            //           ),
            //           value: algo.value,
            //         ),
            //       )
            //       .toList(),
            // ),
          ].padded(),
        ),
      ),
    );
  }

  void _onSubmit() async {}
}
