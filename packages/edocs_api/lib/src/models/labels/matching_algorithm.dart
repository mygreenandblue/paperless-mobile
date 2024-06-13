import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum MatchingAlgorithm {
  none(0, "None: Disable matching"),
  anyWord(1, "Any: Match one of the following words"),
  allWords(2, "All: Match all of the following words"),
  exactMatch(3, "Exact: Match the following string"),
  regex(4, "Regex: Match the regular expression"),
  fuzzy(5, "Similar: Match a similar word"),
  auto(6, "Auto: Learn automatic assignment");

  final int value;
  final String name;

  const MatchingAlgorithm(this.value, this.name);

  static const MatchingAlgorithm defaultValue = auto;
}
