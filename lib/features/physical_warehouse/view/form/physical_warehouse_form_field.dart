import 'package:animations/animations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/workarounds/colored_chip.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/labels/view/widgets/fullscreen_label_form.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/form/fullscreen_form_warehouse.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

///
/// Form field allowing to select labels (i.e. correspondent, documentType)
/// [T] is the label type (e.g. [DocumentType], [Correspondent], ...)
///
class WarehouseFormField<T extends WarehouseModel> extends StatelessWidget {
  final Widget prefixIcon;
  final Map<int, T> options;
  final IdQueryParameter? initialValue;
  final String name;
  final String labelText;
  final FormFieldValidator? validator;
  final Future<T?> Function(String? type)? onAddWarehouse;
  final void Function(IdQueryParameter?)? onChanged;
  final bool showNotAssignedOption;
  final bool showAnyAssignedOption;
  final Iterable<int> suggestions;
  final String? addWarehouseText;
  final bool allowSelectUnassigned;
  final bool canCreateNewWarehouse;

  const WarehouseFormField({
    Key? key,
    required this.name,
    required this.options,
    required this.labelText,
    required this.prefixIcon,
    this.initialValue,
    this.validator,
    this.onAddWarehouse,
    this.onChanged,
    this.showNotAssignedOption = true,
    this.showAnyAssignedOption = true,
    this.suggestions = const [],
    this.addWarehouseText,
    required this.allowSelectUnassigned,
    required this.canCreateNewWarehouse,
  }) : super(key: key);

  String _buildText(BuildContext context, IdQueryParameter? value) {
    return switch (value) {
      UnsetIdQueryParameter() => '',
      NotAssignedIdQueryParameter() => S.of(context)!.notAssigned,
      AnyAssignedIdQueryParameter() => S.of(context)!.anyAssigned,
      SetIdQueryParameter(id: var id) => options[id]?.name ?? '',
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final enabled = options.values.isNotEmpty || onAddWarehouse != null;

    return FormBuilderField<IdQueryParameter>(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      enabled: enabled,
      builder: (field) {
        final controller = TextEditingController(
          text: _buildText(context, field.value),
        );
        final displayedSuggestions = suggestions
            .whereNot(
              (id) =>
                  id ==
                  switch (field.value) {
                    SetIdQueryParameter(id: var id) => id,
                    _ => -1,
                  },
            )
            .toList();

        return Column(
          children: [
            OpenContainer<IdQueryParameter>(
              middleColor: Theme.of(context).colorScheme.background,
              closedColor: Theme.of(context).colorScheme.background,
              openColor: Theme.of(context).colorScheme.background,
              closedShape: InputBorder.none,
              openElevation: 0,
              closedElevation: 0,
              tappable: enabled,
              closedBuilder: (context, openForm) => Container(
                margin: const EdgeInsets.only(top: 6),
                child: TextField(
                  controller: controller,
                  onTap: openForm,
                  readOnly: true,
                  enabled: true,
                  decoration: InputDecoration(
                    prefixIcon: prefixIcon,
                    labelText: labelText,
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () =>
                                field.didChange(const UnsetIdQueryParameter()),
                          )
                        : null,
                  ),
                ),
              ),
              openBuilder: (context, closeForm) => FullscreenWarehouseForm<T>(
                allowSelectUnassigned: allowSelectUnassigned,
                canCreateNewWarehoue: canCreateNewWarehouse,
                addNewWarehouseText: addWarehouseText,
                leadingIcon: prefixIcon,
                onCreateNewWarehouse: onAddWarehouse,
                options: options,
                onSubmit: closeForm,
                initialValue: field.value ?? const UnsetIdQueryParameter(),
                showAnyAssignedOption: showAnyAssignedOption,
                showNotAssignedOption: showNotAssignedOption,
              ),
              onClosed: (data) {
                if (data != null) {
                  field.didChange(data);
                }
              },
            ),
            if (displayedSuggestions.isNotEmpty)
              Column(
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
                      itemCount: displayedSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion =
                            options[displayedSuggestions.elementAt(index)]!;

                        return ColoredChipWrapper(
                          child: ActionChip(
                            label: Text(suggestion.name!),
                            onPressed: () => field.didChange(
                              SetIdQueryParameter(id: suggestion.id!),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(width: 4.0),
                    ),
                  ),
                ],
              ).padded(),
          ],
        );
      },
    );
  }
}
