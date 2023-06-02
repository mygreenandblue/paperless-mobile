import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

String translateMatchingAlgorithmDescription(
  BuildContext context,
  MatchingAlgorithm algorithm,
) {
  switch (algorithm) {
    case MatchingAlgorithm.anyWord:
      return S.of(context)!.documentContainsAnyOfTheseWords;
    case MatchingAlgorithm.allWords:
      return S.of(context)!.documentContainsAllOfTheseWords;
    case MatchingAlgorithm.exactMatch:
      return S.of(context)!.documentContainsThisString;
    case MatchingAlgorithm.regex:
      return S.of(context)!.documentMatchesThisRegularExpression;
    case MatchingAlgorithm.fuzzy:
      return S.of(context)!.documentContainsAWordSimilarToThisWord;
    case MatchingAlgorithm.auto:
      return S.of(context)!.learnMatchingAutomatically;
    case MatchingAlgorithm.none:
      return S.of(context)!.disableMatching;
  }
}

String translateMatchingAlgorithmName(
  BuildContext context,
  MatchingAlgorithm algorithm,
) {
  switch (algorithm) {
    case MatchingAlgorithm.anyWord:
      return S.of(context)!.any;
    case MatchingAlgorithm.allWords:
      return S.of(context)!.all;
    case MatchingAlgorithm.exactMatch:
      return S.of(context)!.exact;
    case MatchingAlgorithm.regex:
      return S.of(context)!.regularExpression;
    case MatchingAlgorithm.fuzzy:
      return S.of(context)!.fuzzy;
    case MatchingAlgorithm.auto:
      return S.of(context)!.auto;
    case MatchingAlgorithm.none:
      return S.of(context)!.none;
  }
}
