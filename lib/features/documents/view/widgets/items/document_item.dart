import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

abstract class DocumentItem extends StatelessWidget {
  final DocumentModel document;
  final void Function(DocumentModel)? onTap;
  final void Function(DocumentModel)? onSelected;
  final bool isSelected;
  final bool isSelectionActive;
  final bool isLabelClickable;
  final bool enableHeroAnimation;

  final void Function(int tagId)? onTagSelected;
  final void Function(int? correspondentId)? onCorrespondentSelected;
  final void Function(int? documentTypeId)? onDocumentTypeSelected;
  final void Function(int? id)? onStoragePathSelected;

  const DocumentItem({
    super.key,
    required this.document,
    this.onTap,
    this.onSelected,
    required this.isSelected,
    required this.isSelectionActive,
    required this.isLabelClickable,
    this.onTagSelected,
    this.onCorrespondentSelected,
    this.onDocumentTypeSelected,
    this.onStoragePathSelected,
    required this.enableHeroAnimation,
  });
}
