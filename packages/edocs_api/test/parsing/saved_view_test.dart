import 'package:flutter_test/flutter_test.dart';
import 'package:edocs_api/edocs_api.dart';

void main() {
  group('Parsing [SavedView] to [DocumentFilter]:', () {
    test('Values are correctly parsed if set.', () {
      expect(
        SavedView.fromJson({
          "id": 1,
          "name": "test_name",
          "show_on_dashboard": false,
          "show_in_sidebar": false,
          "sort_field": SortField.created.name,
          "sort_reverse": true,
          "filter_rules": [
            {
              'rule_type': FilterRule.correspondentRule,
              'value': "42",
            },
            {
              'rule_type': FilterRule.documentTypeRule,
              'value': "69",
            },
            {
              'rule_type': FilterRule.includeTagsRule,
              'value': "1",
            },
            {
              'rule_type': FilterRule.includeTagsRule,
              'value': "2",
            },
            {
              'rule_type': FilterRule.excludeTagsRule,
              'value': "3",
            },
            {
              'rule_type': FilterRule.excludeTagsRule,
              'value': "4",
            },
            {
              'rule_type': FilterRule.extendedRule,
              'value': "Never gonna give you up",
            },
            {
              'rule_type': FilterRule.storagePathRule,
              'value': "14",
            },
            {
              'rule_type': FilterRule.createdBeforeRule,
              'value': "2022-10-27",
            },
            {
              'rule_type': FilterRule.createdAfterRule,
              'value': "2022-09-27",
            },
            {
              'rule_type': FilterRule.addedBeforeRule,
              'value': "2022-09-26",
            },
            {
              'rule_type': FilterRule.addedAfterRule,
              'value': "2000-01-01",
            }
          ]
        }).toDocumentFilter(),
        equals(
          DocumentFilter(
            correspondent: const SetIdQueryParameter(id: 42),
            documentType: const SetIdQueryParameter(id: 69),
            storagePath: const SetIdQueryParameter(id: 14),
            tags: const IdsTagsQuery(
              include: [1, 2],
              exclude: [3, 4],
            ),
            created: AbsoluteDateRangeQuery(
              before: DateTime.parse("2022-10-27"),
              after: DateTime.parse("2022-09-27"),
            ),
            added: AbsoluteDateRangeQuery(
              before: DateTime.parse("2022-09-26"),
              after: DateTime.parse("2000-01-01"),
            ),
            sortField: SortField.created,
            sortOrder: SortOrder.descending,
            query: const TextQuery.extended("Never gonna give you up"),
            selectedView: 1,
          ),
        ),
      );
    });

    test('Values are correctly parsed if unset.', () {
      expect(
        SavedView.fromJson({
          "id": 1,
          "name": "test_name",
          "show_on_dashboard": false,
          "show_in_sidebar": false,
          "sort_field": SortField.created.name,
          "sort_reverse": true,
          "filter_rules": [],
        }).toDocumentFilter(),
        equals(
          const DocumentFilter(
            selectedView: 1,
          ),
        ),
      );
    });

    test('Values are correctly parsed if not assigned.', () {
      final actual = SavedView.fromJson({
        "id": 1,
        "name": "test_name",
        "show_on_dashboard": false,
        "show_in_sidebar": false,
        "sort_field": SortField.created.name,
        "sort_reverse": true,
        "filter_rules": [
          {
            'rule_type': FilterRule.correspondentRule,
            'value': null,
          },
          {
            'rule_type': FilterRule.documentTypeRule,
            'value': null,
          },
          {
            'rule_type': FilterRule.hasAnyTag,
            'value': false.toString(),
          },
          {
            'rule_type': FilterRule.storagePathRule,
            'value': null,
          },
        ],
      }).toDocumentFilter();
      const expected = DocumentFilter(
        correspondent: NotAssignedIdQueryParameter(),
        documentType: NotAssignedIdQueryParameter(),
        storagePath: NotAssignedIdQueryParameter(),
        tags: NotAssignedTagsQuery(),
        selectedView: 1,
      );
      expect(
        actual,
        equals(expected),
      );
    });
  });

  group('Validate parsing logic from [DocumentFilter] to [SavedView]:', () {
    test('Values are correctly parsed if set.', () {
      expect(
        SavedView.fromDocumentFilter(
          DocumentFilter(
            selectedView: 1,
            correspondent: const SetIdQueryParameter(id: 1),
            documentType: const SetIdQueryParameter(id: 2),
            storagePath: const SetIdQueryParameter(id: 3),
            tags: const IdsTagsQuery(
              include: [4, 5],
              exclude: [6, 7, 8],
            ),
            sortField: SortField.added,
            sortOrder: SortOrder.ascending,
            created: AbsoluteDateRangeQuery(
              before: DateTime.parse("2020-04-01"),
              after: DateTime.parse("2020-02-01"),
            ),
            added: AbsoluteDateRangeQuery(
              before: DateTime.parse("2020-03-01"),
              after: DateTime.parse("2020-01-01"),
            ),
            query: const TextQuery.title("Never gonna let you down"),
          ),
          name: "test_name",
          showInSidebar: false,
          showOnDashboard: false,
        ),
        equals(
          SavedView(
            id: 1,
            name: "test_name",
            showOnDashboard: false,
            showInSidebar: false,
            sortField: SortField.added,
            sortReverse: false,
            filterRules: [
              FilterRule(FilterRule.correspondentRule, "1"),
              FilterRule(FilterRule.documentTypeRule, "2"),
              FilterRule(FilterRule.storagePathRule, "3"),
              FilterRule(FilterRule.includeTagsRule, "4"),
              FilterRule(FilterRule.includeTagsRule, "5"),
              FilterRule(FilterRule.excludeTagsRule, "6"),
              FilterRule(FilterRule.excludeTagsRule, "7"),
              FilterRule(FilterRule.excludeTagsRule, "8"),
              FilterRule(FilterRule.addedAfterRule, "2020-01-01"),
              FilterRule(FilterRule.addedBeforeRule, "2020-03-01"),
              FilterRule(FilterRule.createdAfterRule, "2020-02-01"),
              FilterRule(FilterRule.createdBeforeRule, "2020-04-01"),
              FilterRule(FilterRule.titleRule, "Never gonna let you down"),
            ],
          ),
        ),
      );
    });

    test('Values are correctly parsed if unset.', () {
      expect(
        SavedView.fromDocumentFilter(
          const DocumentFilter(
            correspondent: UnsetIdQueryParameter(),
            documentType: UnsetIdQueryParameter(),
            storagePath: UnsetIdQueryParameter(),
            tags: IdsTagsQuery(),
            sortField: SortField.created,
            sortOrder: SortOrder.descending,
            added: UnsetDateRangeQuery(),
            created: UnsetDateRangeQuery(),
            query: TextQuery(),
          ),
          name: "test_name",
          showInSidebar: false,
          showOnDashboard: false,
        ),
        equals(
          SavedView(
            name: "test_name",
            showOnDashboard: false,
            showInSidebar: false,
            sortField: SortField.created,
            sortReverse: true,
            filterRules: [],
          ),
        ),
      );
    });

    test('Values are correctly parsed if not assigned.', () {
      expect(
        SavedView.fromDocumentFilter(
          const DocumentFilter(
            correspondent: NotAssignedIdQueryParameter(),
            documentType: NotAssignedIdQueryParameter(),
            storagePath: NotAssignedIdQueryParameter(),
            tags: NotAssignedTagsQuery(),
            sortField: SortField.created,
            sortOrder: SortOrder.ascending,
          ),
          name: "test_name",
          showInSidebar: false,
          showOnDashboard: false,
        ),
        equals(
          SavedView(
            name: "test_name",
            showOnDashboard: false,
            showInSidebar: false,
            sortField: SortField.created,
            sortReverse: false,
            filterRules: [
              FilterRule(FilterRule.correspondentRule, null),
              FilterRule(FilterRule.documentTypeRule, null),
              FilterRule(FilterRule.storagePathRule, null),
              FilterRule(FilterRule.hasAnyTag, false.toString()),
            ],
          ),
        ),
      );
    });
  });
}
