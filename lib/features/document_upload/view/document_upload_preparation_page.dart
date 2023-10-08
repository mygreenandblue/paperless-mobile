import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/widgets/future_or_builder.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_upload/cubit/document_upload_cubit.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_correspondent_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_document_type_page.dart';
import 'package:paperless_mobile/features/home/view/model/api_version.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_form_field.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_form_field.dart';
import 'package:paperless_mobile/features/sharing/view/widgets/file_thumbnail.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:provider/provider.dart';

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

  const DocumentUploadPreparationPage({
    Key? key,
    required this.fileBytes,
    this.title,
    this.filename,
    this.fileExtension,
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
  bool _isUploadLoading = false;
  late bool _syncTitleAndFilename;
  bool _showDatePickerDeleteIcon = false;
  final _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _syncTitleAndFilename = widget.filename == null && widget.title == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: true,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0,
        child: FloatingActionButton.extended(
          heroTag: "fab_document_upload",
          onPressed: _onSubmit,
          label: Text(S.of(context)!.upload),
          icon: const Icon(Icons.upload),
        ),
      ),
      body: BlocBuilder<DocumentUploadCubit, DocumentUploadState>(
        builder: (context, state) {
          return FormBuilder(
            key: _formKey,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    leading: BackButton(),
                    pinned: true,
                    expandedHeight: 150,
                    flexibleSpace: FlexibleSpaceBar(
                      background: FutureOrBuilder<Uint8List>(
                        future: widget.fileBytes,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox.shrink();
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
                    bottom: _isUploadLoading
                        ? PreferredSize(
                            child: LinearProgressIndicator(),
                            preferredSize: Size.fromHeight(4.0),
                          )
                        : null,
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
                            FormBuilderDateTimePicker(
                              autovalidateMode: AutovalidateMode.always,
                              format: DateFormat.yMMMMd(
                                  Localizations.localeOf(context).toString()),
                              inputType: InputType.date,
                              name: DocumentModel.createdKey,
                              initialValue: null,
                              onChanged: (value) {
                                setState(() =>
                                    _showDatePickerDeleteIcon = value != null);
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(Icons.calendar_month_outlined),
                                labelText: S.of(context)!.createdAt + " *",
                                suffixIcon: _showDatePickerDeleteIcon
                                    ? IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          _formKey.currentState!
                                              .fields[DocumentModel.createdKey]
                                              ?.didChange(null);
                                        },
                                      )
                                    : null,
                              ),
                            ),
                            // Correspondent
                            if (context
                                .watch<LocalUserAccount>()
                                .paperlessUser
                                .canViewCorrespondents)
                              LabelFormField<Correspondent>(
                                showAnyAssignedOption: false,
                                showNotAssignedOption: false,
                                addLabelPageBuilder: (initialName) =>
                                    MultiProvider(
                                  providers: [
                                    Provider.value(
                                      value: context.read<LabelRepository>(),
                                    ),
                                    Provider.value(
                                      value: context.read<ApiVersion>(),
                                    )
                                  ],
                                  child: AddCorrespondentPage(
                                      initialName: initialName),
                                ),
                                addLabelText: S.of(context)!.addCorrespondent,
                                labelText: S.of(context)!.correspondent + " *",
                                name: DocumentModel.correspondentKey,
                                options: state.correspondents,
                                prefixIcon: const Icon(Icons.person_outline),
                                allowSelectUnassigned: true,
                                canCreateNewLabel: context
                                    .watch<LocalUserAccount>()
                                    .paperlessUser
                                    .canCreateCorrespondents,
                              ),
                            // Document type
                            if (context
                                .watch<LocalUserAccount>()
                                .paperlessUser
                                .canViewDocumentTypes)
                              LabelFormField<DocumentType>(
                                showAnyAssignedOption: false,
                                showNotAssignedOption: false,
                                addLabelPageBuilder: (initialName) =>
                                    MultiProvider(
                                  providers: [
                                    Provider.value(
                                      value: context.read<LabelRepository>(),
                                    ),
                                    Provider.value(
                                      value: context.read<ApiVersion>(),
                                    )
                                  ],
                                  child: AddDocumentTypePage(
                                      initialName: initialName),
                                ),
                                addLabelText: S.of(context)!.addDocumentType,
                                labelText: S.of(context)!.documentType + " *",
                                name: DocumentModel.documentTypeKey,
                                options: state.documentTypes,
                                prefixIcon:
                                    const Icon(Icons.description_outlined),
                                allowSelectUnassigned: true,
                                canCreateNewLabel: context
                                    .watch<LocalUserAccount>()
                                    .paperlessUser
                                    .canCreateDocumentTypes,
                              ),
                            if (context
                                .watch<LocalUserAccount>()
                                .paperlessUser
                                .canViewTags)
                              TagsFormField(
                                name: DocumentModel.tagsKey,
                                allowCreation: true,
                                allowExclude: false,
                                allowOnlySelection: true,
                                options: state.tags,
                              ),
                            Text(
                              "* " + S.of(context)!.uploadInferValuesHint,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.justify,
                            ).padded(),
                            const SizedBox(height: 300),
                          ].padded(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final cubit = context.read<DocumentUploadCubit>();
      try {
        setState(() => _isUploadLoading = true);
        final formValues = _formKey.currentState!.value;

        final correspondentParam =
            formValues[DocumentModel.correspondentKey] as IdQueryParameter?;
        final docTypeParam =
            formValues[DocumentModel.documentTypeKey] as IdQueryParameter?;
        final tagsParam = formValues[DocumentModel.tagsKey] as TagsQuery?;
        final createdAt = formValues[DocumentModel.createdKey] as DateTime?;
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
        final taskId = await cubit.upload(
          await widget.fileBytes,
          filename: _padWithExtension(
            _formKey.currentState?.value[fkFileName],
            widget.fileExtension,
          ),
          userId: Hive.box<GlobalSettings>(HiveBoxes.globalSettings)
              .getValue()!
              .loggedInUserId!,
          title: title,
          documentType: docType,
          correspondent: correspondent,
          tags: tags,
          createdAt: createdAt,
          asn: asn,
        );
        showSnackBar(
          context,
          S.of(context)!.documentSuccessfullyUploadedProcessing,
        );
        context.pop(DocumentUploadResult(true, taskId));
      } on PaperlessApiException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      } on PaperlessFormValidationException catch (exception) {
        setState(() => _errors = exception.validationMessages);
      } catch (unknownError, stackTrace) {
        debugPrint(unknownError.toString());
        showErrorMessage(
            context, const PaperlessApiException.unknown(), stackTrace);
      } finally {
        setState(() {
          _isUploadLoading = false;
        });
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
