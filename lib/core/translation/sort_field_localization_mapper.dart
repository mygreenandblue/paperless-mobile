import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/generated/l10n.dart';

String translateSortField(BuildContext context, SortField sortField) {
  switch (sortField) {
    case SortField.archiveSerialNumber:
      return S.of(context).documentArchiveSerialNumberPropertyShortLabel;
    case SortField.correspondentName:
      return S.of(context).documentCorrespondentPropertyLabel;
    case SortField.title:
      return S.of(context).documentTitlePropertyLabel;
    case SortField.documentType:
      return S.of(context).documentDocumentTypePropertyLabel;
    case SortField.created:
      return S.of(context).documentCreatedPropertyLabel;
    case SortField.added:
      return S.of(context).documentAddedPropertyLabel;
    case SortField.modified:
      return S.of(context).documentModifiedPropertyLabel;
  }
}
