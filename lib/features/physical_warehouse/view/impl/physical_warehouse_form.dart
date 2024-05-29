// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';

import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/repository/warehouse_repository.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/physical_warehouse/cubit/warehouse_edit/warehouse_edit_cubit.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/form/physical_warehouse_form_field.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routing/routes/physical_warehouse_route.dart';
import 'package:paperless_mobile/routing/routes/shells/authenticated_route.dart';

class PhysicalWarehouseForm<T extends WarehouseModel> extends StatefulWidget {
  /// List of additionally rendered form fields.
  final String action;
  final String type;
  final bool autofocusNameField;
  final T? initialValue;

  final WarehouseFilter initialFilter;
  final Widget? iconButtonSubmit;
  final Widget? labelButtonSubmit;

  /// FromJson method to parse the form field values into a label instance.
  final T Function(Map<String, dynamic> json) fromJsonT;
  final GlobalKey<FormBuilderState>? formKey;

  const PhysicalWarehouseForm(
      {Key? key,
      required this.type,
      required this.autofocusNameField,
      this.initialValue,
      required this.initialFilter,
      required this.fromJsonT,
      this.formKey,
      this.iconButtonSubmit,
      this.labelButtonSubmit,
      required this.action})
      : super(key: key);

  @override
  State<PhysicalWarehouseForm> createState() => _PhysicalWarehouseFormState();
}

class _PhysicalWarehouseFormState<T extends Label>
    extends State<PhysicalWarehouseForm> {
  late final GlobalKey<FormBuilderState> _formKey;

  Map<String, String> _errors = {};

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey ?? GlobalKey<FormBuilderState>();
  }

  @override
  Widget build(BuildContext context) {
    final warehouseRepository = context.watch<WarehouseRepository>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        icon: widget.iconButtonSubmit,
        label: widget.labelButtonSubmit ?? const SizedBox(),
        onPressed: () => _onSubmit(),
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView(
          children: [
            FormBuilderTextField(
              // autofocus: widget.autofocusNameField,
              name: Label.nameKey,
              initialValue: widget.initialValue?.name,
              decoration: InputDecoration(
                labelText: widget.type == 'Warehouse'
                    ? S.of(context)!.warehouseName
                    : widget.type == 'Shelf'
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
            if (widget.type == 'Shelf')
              _buildWarehouseFormField(context, warehouseRepository.warehouses),
            if (widget.type == 'Boxcase')
              _buildWarehouseFormField(context, warehouseRepository.shelfs),
          ].padded(),
        ),
      ),
    );
  }

  Widget _buildWarehouseFormField(
      BuildContext context, Map<int, WarehouseModel> warehouses) {
    return WarehouseFormField<WarehouseModel>(
      name: WarehouseModel.parentWarehouseKey,
      options: warehouses,
      labelText: widget.type == 'Shelf'
          ? S.of(context)!.warehouse
          : S.of(context)!.shelf,
      initialValue: widget.initialFilter.warehousesId,
      prefixIcon: widget.type == 'Shelf'
          ? const Icon(Icons.warehouse)
          : const Icon(Icons.shelves),
      allowSelectUnassigned: false,
      canCreateNewWarehouse: true,
      onAddWarehouse: (currentInput) => CreatePhysicalWarehouseRoute(
              type: widget.type == 'Shelf' ? 'Warehouse' : 'Shelf')
          .push<WarehouseModel>(context),
      addWarehouseText: widget.type == 'Shelf'
          ? S.of(context)!.addWarehouse
          : S.of(context)!.addShelf,
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final formValues = _formKey.currentState!.value;
        final name = formValues[WarehouseModel.nameKey] as String;
        final parentWarehouse = formValues[WarehouseModel.parentWarehouseKey];
        final parentWarehouseId = switch (parentWarehouse) {
          SetIdQueryParameter(id: var id) => id,
          _ => null,
        };
        print(parentWarehouseId);
        if (widget.action == 'create') {
          await context.read<WarehouseEditCubit>().addWarehouse(
              name: name,
              parentWarehouse: parentWarehouseId,
              type: widget.type);
          showSnackBar(
              context, S.of(context)!.documentSuccessfullyUploadedProcessing);
        } else {
          await context.read<WarehouseEditCubit>().update(
              name: name,
              parentWarehouse: parentWarehouseId,
              type: widget.type,
              id: widget.initialValue!.id);
          showSnackBar(context, S.of(context)!.documentSuccessfullyUpdated);
        }

        context.pop(true);
      } on PaperlessFormValidationException catch (exception) {
        setState(() => _errors = exception.validationMessages);
      } catch (error, stackTrace) {
        logger.fe(
          "An unknown error occurred during document upload.",
          className: runtimeType.toString(),
          methodName: "_onSubmit",
          error: error,
          stackTrace: stackTrace,
        );
        showErrorMessage(
          context,
          const PaperlessApiException.unknown(),
          stackTrace,
        );
      }
    }
  }
}
