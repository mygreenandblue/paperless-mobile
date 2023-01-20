import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/generated/l10n.dart';

String translateMatchingAlgorithmDescription(
  BuildContext context,
  MatchingAlgorithm algorithm,
) {
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

String translateMatchingAlgorithmName(
  BuildContext context,
  MatchingAlgorithm algorithm,
) {
  switch (algorithm) {
    case MatchingAlgorithm.anyWord:
      return S.of(context).matchingAlgorithmAnyName;
    case MatchingAlgorithm.allWords:
      return S.of(context).matchingAlgorithmAllName;
    case MatchingAlgorithm.exactMatch:
      return S.of(context).matchingAlgorithmExactName;
    case MatchingAlgorithm.regex:
      return S.of(context).matchingAlgorithmRegexName;
    case MatchingAlgorithm.fuzzy:
      return S.of(context).matchingAlgorithmFuzzyName;
    case MatchingAlgorithm.auto:
      return S.of(context).matchingAlgorithmAutoName;
  }
}
