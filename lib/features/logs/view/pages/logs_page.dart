import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/features/logs/cubit/logs_cubit.dart';
import 'package:paperless_mobile/features/logs/model/paperless_log.dart';
import 'package:paperless_mobile/features/logs/view/widgets/logs_loading_widget.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> with TickerProviderStateMixin {
  static const _logRegex =
      r"\[(?<timestamp>.*)\]\s+\[?<level>.*)\]\s+[(?<source>.*)]\s+(?<message>.*)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LogsCubit, LogsState>(
          builder: (context, state) {
            return DefaultTabController(
              length: state.logs.length,
              initialIndex: 1,
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  BlocConsumer<LogsCubit, LogsState>(
                    listenWhen: (previous, current) =>
                        !previous.hasLoaded && current.hasLoaded,
                    listener: (context, state) {
                      if (state.types.isNotEmpty) {
                        context.read<LogsCubit>().updateLogs(
                              state.types[1],
                            );
                      }
                    },
                    builder: (context, state) {
                      return SliverAppBar(
                        pinned: true,
                        title: Text("Logs"), //TODO: INTL
                        bottom: state.hasLoaded &&
                                !state.isLoading &&
                                state.logs.values.isNotEmpty
                            ? TabBar(
                                isScrollable: true,
                                onTap: (index) {
                                  context
                                      .read<LogsCubit>()
                                      .updateLogs(state.types[index]);
                                },
                                tabs: state.types
                                    .map((e) => Tab(text: e))
                                    .toList(),
                              )
                            : null,
                      );
                    },
                  ),
                ],
                body: BlocBuilder<LogsCubit, LogsState>(
                  builder: (context, state) {
                    if (!state.hasLoaded) {
                      if (state.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Center(
                        child: Text("No logs available."), //TODO: INTL
                      );
                    }

                    return TabBarView(
                      children: state.logs.keys
                          .map((e) => _buildLogView(state.logs[e]!))
                          .toList(),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogView(PaperlessLog log) {
    if (!log.hasLoaded && log.isLoading) {
      return const LogsLoadingWidget();
    }
    return ListView.builder(
      itemCount: log.log.length,
      itemBuilder: (context, index) =>
          _buildLogItem(log.log[log.log.length - 1 - index]),
    );
  }

  Widget _buildLogItem(String entry) {
    late TextStyle style = TextStyle(
      fontFamily: "Roboto Mono",
      color: Colors.grey[800],
    );
    if (entry.contains('DEBUG')) {
      style = style.apply(
        color: Colors.grey,
      );
    } else if (entry.contains('INFO')) {
      style = style.apply(
        color: Theme.of(context).colorScheme.onBackground,
      );
    } else if (entry.contains('ERROR')) {
      style = style.apply(
        color: Theme.of(context).colorScheme.error,
      );
    }
    return Text(
      entry,
      style: style,
    );
  }
}
