import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/hooks/ct_notifier.dart';

import '../../../../core/infrastructure/extensions/build_context_extensions.dart';
import '../../../../core/infrastructure/loggers/app_logger/app_log_entry.dart';
import '../../../../core/infrastructure/providers/app_logger_provider.dart';

class DebugLogsScreen extends HookConsumerWidget {
  const DebugLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final filterLevelNotifier = useCTNotifier('ALL');
    final searchQueryNotifier = useCTNotifier('');

    final filterLevel = useValueListenable(filterLevelNotifier);
    final searchQuery = useValueListenable(searchQueryNotifier);

    List<AppLogEntry> getFilteredLogs(List<AppLogEntry> logs) {
      var filteredLogs = logs;

      // Filter by level
      if (filterLevel != 'ALL') {
        filteredLogs = filteredLogs
            .where((log) => log.level == filterLevel)
            .toList();
      }

      // Filter by search query
      if (searchQuery.isNotEmpty) {
        filteredLogs = filteredLogs.where((log) {
          final query = searchQuery.toLowerCase();
          return log.message.toLowerCase().contains(query) ||
              log.loggerName.toLowerCase().contains(query) ||
              log.level.toLowerCase().contains(query);
        }).toList();
      }

      return filteredLogs;
    }

    void copyLogsToClipboard() {
      final logger = ref.read(appLoggerProvider);
      final logs = getFilteredLogs(logger.logs);
      final buffer = StringBuffer();

      for (final log in logs) {
        buffer.writeln(
          '[${DateFormat('HH:mm:ss.SSS').format(log.timestamp)}] [${log.level}] [${log.loggerName}] ${log.message}',
        );
      }

      Clipboard.setData(ClipboardData(text: buffer.toString()));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.debugPanelLogsCopied),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    void clearLogs() {
      final logger = ref.read(appLoggerProvider);
      logger.clearLogs();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logs cleared'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }

    String formatTimestamp(DateTime timestamp) {
      return DateFormat('HH:mm:ss.SSS').format(timestamp);
    }

    Color getLevelColor(String level) {
      switch (level) {
        case 'ERROR':
          return Colors.red.shade300;
        case 'WARNING':
          return Colors.orange.shade300;
        case 'INFO':
          return Colors.green.shade300;
        case 'DEBUG':
          return Colors.grey.shade400;
        default:
          return Colors.white70;
      }
    }

    final theme = Theme.of(context);
    final l10n = context.l10n;
    final logger = ref.watch(appLoggerProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.debugPanelTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => searchQueryNotifier.value = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search logs...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list, color: Colors.grey.shade300),
                  onSelected: (value) => filterLevelNotifier.value = value,
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'ALL', child: Text('All')),
                    const PopupMenuItem(value: 'ERROR', child: Text('Error')),
                    const PopupMenuItem(
                      value: 'WARNING',
                      child: Text('Warning'),
                    ),
                    const PopupMenuItem(value: 'INFO', child: Text('Info')),
                    const PopupMenuItem(value: 'DEBUG', child: Text('Debug')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<AppLogEntry>(
        stream: logger.logStream,
        builder: (context, snapshot) {
          // Get all current logs and filter them
          final logs = getFilteredLogs(logger.logs);

          return Column(
            children: [
              // Action buttons
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: logs.isEmpty ? null : copyLogsToClipboard,
                        icon: const Icon(Icons.copy, size: 18),
                        label: Text(l10n.debugPanelCopyLogs),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF4F39F6,
                          ).withValues(alpha: 0.2),
                          foregroundColor: const Color(0xFF4F39F6),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: const Color(
                                0xFF4F39F6,
                              ).withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: logs.isEmpty ? null : clearLogs,
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: Text(l10n.debugPanelClearLogs),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600.withValues(
                            alpha: 0.2,
                          ),
                          foregroundColor: Colors.red.shade400,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.red.shade400.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Logs list
              Expanded(
                child: logs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bug_report_outlined,
                              size: 64,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.debugPanelNoLogs,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.debugPanelLogsAppearMessage,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            final log = logs[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SelectableText(
                                '[${formatTimestamp(log.timestamp)}] [${log.level}] [${log.loggerName}] ${log.message}',
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontSize: 12,
                                  color: getLevelColor(log.level),
                                  height: 1.4,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
