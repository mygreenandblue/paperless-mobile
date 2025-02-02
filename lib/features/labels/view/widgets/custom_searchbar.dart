// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class CustomSearchBar extends StatelessWidget {
  final List<String>? items;
  final String? selectedItem;
  final Function(String?)? onChanged;
  final String? fieldName;
  final String? hintText;
  final double? hozizontalPadding, verticalPadiing;
  final bool showSearchBox;
  final double? radius;
  final bool? enable;
  final Widget? prefixIcon;
  final String? errorText;

  const CustomSearchBar({
    super.key,
    this.items,
    this.selectedItem,
    this.onChanged,
    this.fieldName,
    this.hozizontalPadding,
    this.verticalPadiing,
    this.hintText,
    this.showSearchBox = true,
    this.radius,
    this.enable,
    this.prefixIcon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownSearch<String>(
          enabled: enable ?? true,
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            disabledItemFn: (String s) => s.startsWith('I'),
            searchFieldProps: TextFieldProps(
              cursorColor: Theme.of(context).colorScheme.primary,
              decoration: InputDecoration(
                hintText: S.of(context)!.search,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: verticalPadiing ?? 8,
                  horizontal: hozizontalPadding ?? 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
              ),
            ),
            showSearchBox: showSearchBox,
          ),
          items: items ?? [(S.of(context)!.noItemsFound)],
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              errorText: errorText,
              prefixIcon: prefixIcon,
              hintText: hintText,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: verticalPadiing ?? 16,
                horizontal: hozizontalPadding ?? 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 16),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 16),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 16),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
              ),
            ),
          ),
          onChanged: onChanged ?? (value) => print(value),
          selectedItem: selectedItem,
        ),
      ],
    );
  }
}
