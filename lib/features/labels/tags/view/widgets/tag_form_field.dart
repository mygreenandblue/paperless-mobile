// import 'dart:developer';

// import 'package:animations/animations.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:paperless_api/paperless_api.dart';
// import 'package:paperless_mobile/core/widgets/material/chips_input.dart';
// import 'package:paperless_mobile/core/workarounds/colored_chip.dart';
// import 'package:paperless_mobile/extensions/flutter_extensions.dart';
// import 'package:paperless_mobile/features/labels/view/widgets/fullscreen_label_form.dart';
// import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

// ///
// /// Form field allowing to select labels (i.e. correspondent, documentType)
// /// [T] is the label type (e.g. [DocumentType], [Correspondent], ...)
// ///
// class TagsFormField<T extends Label> extends StatelessWidget {
//   final Widget prefixIcon;
//   final Map<int, T> options;
//   final IdQueryParameter? initialValue;
//   final String name;
//   final String labelText;
//   final FormFieldValidator? validator;
//   final Widget Function(String? initialName)? addLabelPageBuilder;
//   final void Function(IdQueryParameter?)? onChanged;
//   final bool showNotAssignedOption;
//   final bool showAnyAssignedOption;
//   final List<T> suggestions;
//   final String? addLabelText;

//   const TagsFormField({
//     Key? key,
//     required this.name,
//     required this.options,
//     required this.labelText,
//     required this.prefixIcon,
//     this.initialValue,
//     this.validator,
//     this.addLabelPageBuilder,
//     this.onChanged,
//     this.showNotAssignedOption = true,
//     this.showAnyAssignedOption = true,
//     this.suggestions = const [],
//     this.addLabelText,
//   }) : super(key: key);

//   String _buildText(BuildContext context, IdQueryParameter? value) {
//     if (value?.isSet ?? false) {
//       return options[value!.id]?.name ?? 'undefined';
//     } else if (value?.onlyNotAssigned ?? false) {
//       return S.of(context)!.notAssigned;
//     } else if (value?.onlyAssigned ?? false) {
//       return S.of(context)!.anyAssigned;
//     }
//     return '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEnabled = options.values.any((e) => (e.documentCount ?? 0) > 0) ||
//         addLabelPageBuilder != null;
//     return FormBuilderField<IdQueryParameter>(
//       name: name,
//       initialValue: initialValue,
//       onChanged: onChanged,
//       enabled: isEnabled,
//       builder: (field) {
//         final controller = TextEditingController(
//           text: _buildText(context, field.value),
//         );
//         final displayedSuggestions =
//             suggestions.whereNot((e) => e.id == field.value?.id).toList();

//         return Column(
//           children: [
//             OpenContainer<IdQueryParameter>(
//               middleColor: Theme.of(context).colorScheme.background,
//               closedColor: Theme.of(context).colorScheme.background,
//               openColor: Theme.of(context).colorScheme.background,
//               closedShape: InputBorder.none,
//               openElevation: 0,
//               closedElevation: 0,
//               closedBuilder: (context, openForm) => Container(
//                 margin: const EdgeInsets.only(top: 4),
//                 child: 
//               ),
//               openBuilder: (context, closeForm) => FullscreenLabelForm<T>(
//                 addNewLabelText: addLabelText,
//                 leadingIcon: prefixIcon,
//                 onCreateNewLabel: addLabelPageBuilder != null
//                     ? (initialName) {
//                         return Navigator.of(context).push<T>(
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 addLabelPageBuilder!(initialName),
//                           ),
//                         );
//                       }
//                     : null,
//                 options: options,
//                 onSubmit: closeForm,
//                 initialValue: field.value,
//                 showAnyAssignedOption: showAnyAssignedOption,
//                 showNotAssignedOption: showNotAssignedOption,
//               ),
//               onClosed: (data) {
//                 if (data != null) {
//                   field.didChange(data);
//                 }
//               },
//             ),
//             if (displayedSuggestions.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     S.of(context)!.suggestions,
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                   SizedBox(
//                     height: 48,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: displayedSuggestions.length,
//                       itemBuilder: (context, index) {
//                         final suggestion =
//                             displayedSuggestions.elementAt(index);
//                         return ColoredChipWrapper(
//                           child: ActionChip(
//                             label: Text(suggestion.name),
//                             onPressed: () => field.didChange(
//                               IdQueryParameter.fromId(suggestion.id),
//                             ),
//                           ),
//                         );
//                       },
//                       separatorBuilder: (BuildContext context, int index) =>
//                           const SizedBox(width: 4.0),
//                     ),
//                   ),
//                 ],
//               ).padded(),
//           ],
//         );
//       },
//     );
//   }
// }
