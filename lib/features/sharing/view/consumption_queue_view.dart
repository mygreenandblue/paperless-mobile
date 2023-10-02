import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/sharing/cubit/receive_share_cubit.dart';
import 'package:paperless_mobile/features/sharing/view/widgets/file_thumbnail.dart';
import 'package:paperless_mobile/features/sharing/view/widgets/upload_queue_shell.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class ConsumptionQueueView extends StatelessWidget {
  const ConsumptionQueueView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<LocalUserAccount>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Queue"), //TODO: INTL
      ),
      body: Consumer<ConsumptionChangeNotifier>(
        builder: (context, value, child) {
          if (value.pendingFiles.isEmpty) {
            return Center(
              child: Text("No pending files."),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              final file = value.pendingFiles.elementAt(index);
              final filename = p.basename(file.path);
              return ListTile(
                title: Text(filename),
                leading: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FileThumbnail(
                      file: file,
                      fit: BoxFit.cover,
                      width: 75,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    context
                        .read<ConsumptionChangeNotifier>()
                        .discardFile(file, userId: currentUser.id);
                  },
                ),
              );
              return Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(filename, maxLines: 1),
                        SizedBox(
                          height: 56,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ActionChip(
                                label: Text(S.of(context)!.upload),
                                avatar: Icon(Icons.file_upload_outlined),
                                onPressed: () {
                                  consumeLocalFile(
                                    context,
                                    file: file,
                                    userId: currentUser.id,
                                  );
                                },
                              ),
                              SizedBox(width: 8),
                              ActionChip(
                                label: Text(S.of(context)!.discard),
                                avatar: Icon(Icons.delete),
                                onPressed: () {
                                  context
                                      .read<ConsumptionChangeNotifier>()
                                      .discardFile(
                                        file,
                                        userId: currentUser.id,
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).padded(),
                  ),
                ],
              ).padded();
            },
            itemCount: value.pendingFiles.length,
          );
        },
      ),
    );
  }
}
