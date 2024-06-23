import 'dart:async';
import 'dart:typed_data';

import 'package:edocs_mobile/features/labels/folder/folder_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';
import 'package:edocs_mobile/core/database/tables/global_settings.dart';
import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/core/repository/label_repository.dart';
import 'package:edocs_mobile/core/widgets/form_builder_fields/form_builder_localized_date_picker.dart';
import 'package:edocs_mobile/core/widgets/future_or_builder.dart';
import 'package:edocs_mobile/features/document_upload/cubit/document_upload_cubit.dart';
import 'package:edocs_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/features/labels/tags/view/widgets/tags_form_field.dart';
import 'package:edocs_mobile/features/labels/view/widgets/label_form_field.dart';
import 'package:edocs_mobile/features/logging/data/logger.dart';
import 'package:edocs_mobile/features/labels/view/widgets/custom_searchbar.dart';
import 'package:edocs_mobile/features/sharing/view/widgets/file_thumbnail.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/helpers/message_helpers.dart';
import 'package:edocs_mobile/routing/routes/labels_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';

class DocumentUploadResult {
  final bool success;
  final String? taskId;

  DocumentUploadResult(this.success, this.taskId);
}

class DocumentUploadPreparationPage extends StatefulWidget {
  final FutureOr<Uint8List> fileBytes;
  final String? title;
  final String? filename;
  final String? fileExtension;
  final int? initFolderId;

  const DocumentUploadPreparationPage({
    Key? key,
    required this.fileBytes,
    this.title,
    this.filename,
    this.fileExtension,
    this.initFolderId,
  }) : super(key: key);

  @override
  State<DocumentUploadPreparationPage> createState() =>
      _DocumentUploadPreparationPageState();
}

class _DocumentUploadPreparationPageState
    extends State<DocumentUploadPreparationPage> {
  static const fkFileName = "filename";
  static final fileNameDateFormat = DateFormat("yyyy_MM_ddTHH_mm_ss");

  final GlobalKey<FormBuilderState> _formKey = GlobalKey();
  Map<String, String> _errors = {};
  late bool _syncTitleAndFilename;
  final _now = DateTime.now();
  int _warehouseId = -1;
  int _shelfId = -1;
  int _boxcaseId = -1;
  var _parentFolder;
  // int? _selectedItemId;

  final expandChildrenOnReady = false;
  Map<String, bool> loading = {};

  @override
  void initState() {
    super.initState();
    _syncTitleAndFilename = widget.filename == null && widget.title == null;
    setState(() {
      loading['shelf'] = false;
      loading['case'] = false;
    });
    if (widget.initFolderId != null) {
      setState(() {
        _parentFolder = widget.initFolderId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelRepository = context.watch<LabelRepository>();

    return BlocBuilder<DocumentUploadCubit, DocumentUploadState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: false,
          resizeToAvoidBottomInset: true,
          floatingActionButton: Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom == 0,
            child: FloatingActionButton.extended(
              heroTag: "fab_document_upload",
              onPressed: state.uploadProgress == null ? _onSubmit : null,
              label: state.uploadProgress == null
                  ? Text(S.of(context)!.upload)
                  : Text("Uploading..."), //TODO: INTL
              icon: state.uploadProgress == null
                  ? const Icon(Icons.upload)
                  : SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        value: state.uploadProgress,
                      )).padded(4),
            ),
          ),
          body: FormBuilder(
            key: _formKey,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    leading: const BackButton(),
                    pinned: true,
                    expandedHeight: 150,
                    flexibleSpace: FlexibleSpaceBar(
                      background: FutureOrBuilder<Uint8List>(
                        future: widget.fileBytes,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          }
                          return FileThumbnail(
                            bytes: snapshot.data!,
                            fit: BoxFit.fitWidth,
                            width: MediaQuery.sizeOf(context).width,
                          );
                        },
                      ),
                      title: Text(S.of(context)!.prepareDocument),
                      collapseMode: CollapseMode.pin,
                    ),
                  ),
                ),
              ],
              body: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Builder(
                  builder: (context) {
                    return CustomScrollView(
                      slivers: [
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverList.list(
                          children: [
                            // Title
                            FormBuilderTextField(
                              autovalidateMode: AutovalidateMode.always,
                              name: DocumentModel.titleKey,
                              initialValue: widget.title ??
                                  "scan_${fileNameDateFormat.format(_now)}",
                              validator: (value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return S.of(context)!.thisFieldIsRequired;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: S.of(context)!.title,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKey.currentState
                                        ?.fields[DocumentModel.titleKey]
                                        ?.didChange("");
                                    if (_syncTitleAndFilename) {
                                      _formKey.currentState?.fields[fkFileName]
                                          ?.didChange("");
                                    }
                                  },
                                ),
                                errorText: _errors[DocumentModel.titleKey],
                              ),
                              onChanged: (value) {
                                final String transformedValue =
                                    _formatFilename(value ?? '');
                                if (_syncTitleAndFilename) {
                                  _formKey.currentState?.fields[fkFileName]
                                      ?.didChange(transformedValue);
                                }
                              },
                            ),
                            // Filename
                            FormBuilderTextField(
                              autovalidateMode: AutovalidateMode.always,
                              readOnly: _syncTitleAndFilename,
                              enabled: !_syncTitleAndFilename,
                              name: fkFileName,
                              decoration: InputDecoration(
                                labelText: S.of(context)!.fileName,
                                suffixText: widget.fileExtension,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => _formKey
                                      .currentState?.fields[fkFileName]
                                      ?.didChange(''),
                                ),
                              ),
                              initialValue: widget.filename ??
                                  "scan_${fileNameDateFormat.format(_now)}",
                            ),
                            // Synchronize title and filename
                            SwitchListTile(
                              value: _syncTitleAndFilename,
                              onChanged: (value) {
                                setState(
                                  () => _syncTitleAndFilename = value,
                                );
                                if (_syncTitleAndFilename) {
                                  final String transformedValue =
                                      _formatFilename(_formKey
                                          .currentState
                                          ?.fields[DocumentModel.titleKey]
                                          ?.value as String);
                                  if (_syncTitleAndFilename) {
                                    _formKey.currentState?.fields[fkFileName]
                                        ?.didChange(transformedValue);
                                  }
                                }
                              },
                              title: Text(
                                S.of(context)!.synchronizeTitleAndFilename,
                              ),
                            ),
                            // Created at
                            FormBuilderLocalizedDatePicker(
                              name: DocumentModel.createdKey,
                              firstDate: DateTime(1970, 1, 1),
                              lastDate: DateTime(2100, 1, 1),
                              locale: Localizations.localeOf(context),
                              labelText: "${S.of(context)!.createdAt} *",
                              allowUnset: true,
                            ),
                            // Correspondent
                            if (context
                                .watch<LocalUserAccount>()
                                .edocsUser
                                .canViewCorrespondents)
                              LabelFormField<Correspondent>(
                                showAnyAssignedOption: false,
                                showNotAssignedOption: false,
                                onAddLabel: (initialName) => CreateLabelRoute(
                                  LabelType.correspondent,
                                  name: initialName,
                                ).push<Correspondent>(context),
                                addLabelText: S.of(context)!.addCorrespondent,
                                labelText: "${S.of(context)!.correspondent} *",
                                name: DocumentModel.correspondentKey,
                                options: labelRepository.correspondents,
                                prefixIcon: const Icon(Icons.person_outline),
                                allowSelectUnassigned: true,
                                canCreateNewLabel: context
                                    .watch<LocalUserAccount>()
                                    .edocsUser
                                    .canCreateCorrespondents,
                              ),
                            // Document type
                            if (context
                                .watch<LocalUserAccount>()
                                .edocsUser
                                .canViewDocumentTypes)
                              LabelFormField<DocumentType>(
                                showAnyAssignedOption: false,
                                showNotAssignedOption: false,
                                onAddLabel: (initialName) => CreateLabelRoute(
                                  LabelType.documentType,
                                  name: initialName,
                                ).push<DocumentType>(context),
                                addLabelText: S.of(context)!.addDocumentType,
                                labelText: "${S.of(context)!.documentType} *",
                                name: DocumentModel.documentTypeKey,
                                options: labelRepository.documentTypes,
                                prefixIcon:
                                    const Icon(Icons.description_outlined),
                                allowSelectUnassigned: true,
                                canCreateNewLabel: context
                                    .watch<LocalUserAccount>()
                                    .edocsUser
                                    .canCreateDocumentTypes,
                              ),
                            if (context
                                .watch<LocalUserAccount>()
                                .edocsUser
                                .canViewTags)
                              TagsFormField(
                                name: DocumentModel.tagsKey,
                                allowCreation: true,
                                allowExclude: false,
                                allowOnlySelection: true,
                                options: labelRepository.tags,
                              ),

                            // briefcase
                            if (context
                                .watch<LocalUserAccount>()
                                .edocsUser
                                .canViewWarehouse)
                              _buildWarehouseFormField(
                                  context,
                                  labelRepository.warehouses,
                                  (p0) => _findKeyForValue(
                                        labelRepository.warehouses,
                                        p0,
                                        labelRepository,
                                        'warehouse',
                                      ),
                                  labelRepository.shelfs.isEmpty
                                      ? S
                                          .of(context)!
                                          .couldNotFoundShelfPleaseTryAgain
                                      : null),
                            if (context
                                    .watch<LocalUserAccount>()
                                    .edocsUser
                                    .canViewWarehouse &&
                                _warehouseId != -1)
                              loading['shelf'] == true
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : labelRepository.shelfs.isNotEmpty
                                      ? _buildShelfFormField(
                                          context,
                                          labelRepository.shelfs,
                                          (p0) => _findKeyForValue(
                                              labelRepository.shelfs,
                                              p0,
                                              labelRepository,
                                              'shelf'),
                                          labelRepository.shelfs.isEmpty
                                              ? S
                                                  .of(context)!
                                                  .couldNotFoundBoxcasePleaseTryAgain
                                              : null)
                                      : const SizedBox(),
                            if (context
                                    .watch<LocalUserAccount>()
                                    .edocsUser
                                    .canViewWarehouse &&
                                _shelfId != -1)
                              loading['case'] == true
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : labelRepository.boxcases.isNotEmpty
                                      ? _buildBoxcaseFormField(
                                          context,
                                          labelRepository.boxcases,
                                          (p0) => _findKeyForValue(
                                              labelRepository.boxcases,
                                              p0,
                                              labelRepository,
                                              'boxcase'))
                                      : const SizedBox(),
                          ].padded(),
                        ),
                        if (context
                                .watch<LocalUserAccount>()
                                .edocsUser
                                .canViewFolder &&
                            widget.initFolderId == null)
                          _buildFolderTree(context),
                        const SliverPadding(
                          padding: EdgeInsets.all(16),
                          sliver: SliverToBoxAdapter(
                            child: SizedBox(
                              height: 300,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void updateParentValue(int? newValue) {
    setState(() {
      _parentFolder = newValue;
    });
  }

  _buildFolderTree(BuildContext context) {
    return BlocBuilder<DocumentsCubit, DocumentsState>(
      builder: (context, state) {
        context.read<LabelCubit>().buildTreeHasOnlyFolder();
        return BlocBuilder<LabelCubit, LabelState>(
          builder: (context, lbState) {
            return lbState.isLoading
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : lbState.folderTree!.length == 0
                    ? const EmtyFolderTree()
                    : TreeHasOnlyFolder(
                        labelState: lbState,
                        onValueChanged: updateParentValue,
                      );
          },
        );
      },
    );
  }

  _findKeyForValue(Map<int, Object> map, String? value,
      LabelRepository labelRepository, String type) async {
    map.forEach((key, mapValue) {
      if (type == 'warehouse') {
        setState(() {
          loading['shelf'] = true;
        });
      } else {
        setState(() {
          loading['case'] = true;
        });
      }
      if (mapValue.toString() == value) {
        switch (type) {
          case 'warehouse':
            setState(() {
              _warehouseId = key;
            });
            break;
          case 'shelf':
            setState(() {
              _shelfId = key;
            });
            break;
          case 'boxcase':
            setState(() {
              _boxcaseId = key;
              print(_boxcaseId);
            });
            break;
          default:
            break;
        }
      }
    });
    if (type != 'boxcase') {
      type == 'warehouse'
          ? await labelRepository.findDetailsWarehouse(_warehouseId)
          : await labelRepository.findDetailsShelf(_shelfId);
    }
    if (type == 'warehouse') {
      setState(() {
        loading['shelf'] = false;
      });
    } else {
      setState(() {
        loading['case'] = false;
      });
    }
  }

  Widget _buildWarehouseFormField(
    BuildContext context,
    Map<int, Warehouse> warehouses,
    Function(String?)? onChanged,
    String? errorText,
  ) {
    return CustomSearchBar(
      prefixIcon: const Icon(Icons.warehouse_outlined),
      items: warehouses.values.map((value) => value.toString()).toList(),
      onChanged: (value) => {onChanged!(value!)},
      fieldName: S.of(context)?.warehouse,
      hintText: S.of(context)?.selecteWarehouse,
      errorText: errorText,
    );
  }

  Widget _buildShelfFormField(
    BuildContext context,
    Map<int, Warehouse> shelfs,
    Function(String?)? onChanged,
    String? errorText,
  ) {
    return CustomSearchBar(
      prefixIcon: const Icon(Icons.shelves),
      items: shelfs.values.map((value) => value.toString()).toList(),
      onChanged: (value) => {onChanged!(value!)},
      fieldName: S.of(context)?.shelf,
      hintText: S.of(context)?.selectShelf,
      errorText: errorText,
    );
  }

  Widget _buildBoxcaseFormField(
    BuildContext context,
    Map<int, Warehouse> boxcases,
    Function(String?)? onChanged,
  ) {
    return CustomSearchBar(
      prefixIcon: const Icon(Icons.cases_outlined),
      items: boxcases.values.map((value) => value.toString()).toList(),
      onChanged: (value) => {onChanged!(value!)},
      fieldName: S.of(context)?.briefcase,
      hintText: S.of(context)?.selectBriefcase,
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final cubit = context.read<DocumentUploadCubit>();
      try {
        final formValues = _formKey.currentState!.value;

        final correspondentParam =
            formValues[DocumentModel.correspondentKey] as IdQueryParameter?;
        final docTypeParam =
            formValues[DocumentModel.documentTypeKey] as IdQueryParameter?;
        final tagsParam = formValues[DocumentModel.tagsKey] as TagsQuery?;
        final createdAt = formValues[DocumentModel.createdKey] as FormDateTime?;
        final title = formValues[DocumentModel.titleKey] as String;

        final correspondent = switch (correspondentParam) {
          SetIdQueryParameter(id: var id) => id,
          _ => null,
        };
        final docType = switch (docTypeParam) {
          SetIdQueryParameter(id: var id) => id,
          _ => null,
        };
        final tags = switch (tagsParam) {
          IdsTagsQuery(include: var ids) => ids,
          _ => const <int>[],
        };

        final asn = formValues[DocumentModel.asnKey] as int?;
        final taskId = await cubit.upload(await widget.fileBytes,
            filename: _padWithExtension(
              _formKey.currentState?.value[fkFileName],
              widget.fileExtension,
            ),
            userId: Hive.box<GlobalSettings>(HiveBoxes.globalSettings)
                .getValue()!
                .loggedInUserId!,
            warehouse: _boxcaseId != -1 ? _boxcaseId : null,
            title: title,
            documentType: docType,
            correspondent: correspondent,
            tags: tags,
            createdAt: createdAt?.toDateTime(),
            asn: asn,
            folder: _parentFolder);
        showSnackBar(
          context,
          S.of(context)!.documentSuccessfullyUploadedProcessing,
        );
        context.pop(DocumentUploadResult(true, taskId));
      } on edocsFormValidationException catch (exception) {
        setState(() => _errors = exception.validationMessages);
      } catch (error, stackTrace) {
        logger.fe(
          "An unknown error occurred during document upload.",
          className: runtimeType.toString(),
          methodName: "_onSubmit",
          error: error,
          stackTrace: stackTrace,
        );
        showErrorMessage(
          context,
          const EdocsApiException.unknown(),
          stackTrace,
        );
      }
    }
  }

  String _padWithExtension(String source, [String? extension]) {
    final ext = extension ?? '.pdf';
    return source.endsWith(ext) ? source : '$source$ext';
  }

  String _formatFilename(String source) {
    return source.replaceAll(RegExp(r"[\W_]"), "_").toLowerCase();
  }

  // Future<Color> _computeAverageColor() async {
  //   final bitmap = img.decodeImage(await widget.fileBytes);
  //   if (bitmap == null) {
  //     return Colors.black;
  //   }
  //   int redBucket = 0;
  //   int greenBucket = 0;
  //   int blueBucket = 0;
  //   int pixelCount = 0;

  //   for (int y = 0; y < bitmap.height; y++) {
  //     for (int x = 0; x < bitmap.width; x++) {
  //       final c = bitmap.getPixel(x, y);

  //       pixelCount++;
  //       redBucket += c.r.toInt();
  //       greenBucket += c.g.toInt();
  //       blueBucket += c.b.toInt();
  //     }
  //   }

  //   return Color.fromRGBO(
  //     redBucket ~/ pixelCount,
  //     greenBucket ~/ pixelCount,
  //     blueBucket ~/ pixelCount,
  //     1,
  //   );
  // }
}
