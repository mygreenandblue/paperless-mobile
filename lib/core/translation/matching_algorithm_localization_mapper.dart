import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/generated/l10n.dart';

String translateMatchingAlgorithm(
    BuildContext context, MatchingAlgorithm algorithm) {
  switch (algorithm) {
    case MatchingAlgorithm.anyWord:
      return S.of(context).matchingAlgorithmAnyDescription;
    case MatchingAlgorithm.allWords:
      return S.of(context).matchingAlgorithmAllDescription;
    case MatchingAlgorithm.exactMatch:
      return S.of(context).matchingAlgorithmExactDescription;
    case MatchingAlgorithm.regex:
      return S.of(context).matchingAlgorithmRegexDescription;
    case MatchingAlgorithm.fuzzy:
      return S.of(context).matchingAlgorithmFuzzyDescription;
    case MatchingAlgorithm.auto:
      return S.of(context).matchingAlgorithmAutoDescription;
  }
}
