import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

String translateSortField(BuildContext context, SortField? sortField) {
  switch (sortField) {
    case SortField.archiveSerialNumber:
      return S.of(context)!.asn;
    case SortField.correspondentName:
      return S.of(context)!.correspondent;
    case SortField.title:
      return S.of(context)!.title;
    case SortField.documentType:
      return S.of(context)!.documentType;
    case SortField.created:
      return S.of(context)!.createdAt;
    case SortField.added:
      return S.of(context)!.addedAt;
    case SortField.modified:
      return S.of(context)!.modifiedAt;
    default:
      return '';
  }
}
