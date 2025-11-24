import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:robofinal/models/log_entry.dart';
import 'package:robofinal/services/mock_admin_service.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  late List<LogEntry> _logs;
  LogType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _logs = MockAdminService.instance.getLogs();
  }

  List<LogEntry> get _filteredLogs {
    if (_selectedFilter == null) {
      return _logs;
    }
    return _logs.where((log) => log.type == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM dd, yyyy HH:mm');

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF020617), Color(0xFF0F172A), Color(0xFF0EA5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _logs = MockAdminService.instance.getLogs();
          });
        },
        child: _filteredLogs.isEmpty
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Activity Logs',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Track all robot activities and events',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Filter Chips
                  _buildFilterChips(),
                  const SizedBox(height: 20),

                  // Log Statistics
                  _buildLogStats(),
                  const SizedBox(height: 20),

                  // Logs List
                  ..._filteredLogs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final log = entry.value;
                    final isLast = index == _filteredLogs.length - 1;

                    return Column(
                      children: [
                        _buildLogCard(log, formatter),
                        if (!isLast) const SizedBox(height: 12),
                      ],
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Icon(
              Icons.history_outlined,
              size: 64,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No logs found',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Activity logs will appear here',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            label: 'All',
            isSelected: _selectedFilter == null,
            onTap: () {
              setState(() {
                _selectedFilter = null;
              });
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Cleaning',
            isSelected: _selectedFilter == LogType.cleaning,
            onTap: () {
              setState(() {
                _selectedFilter = LogType.cleaning;
              });
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Disposal',
            isSelected: _selectedFilter == LogType.disposal,
            onTap: () {
              setState(() {
                _selectedFilter = LogType.disposal;
              });
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Errors',
            isSelected: _selectedFilter == LogType.error,
            onTap: () {
              setState(() {
                _selectedFilter = LogType.error;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF22C55E), Color(0xFF0EA5E9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildLogStats() {
    final cleaningLogs = _logs.where((l) => l.type == LogType.cleaning).length;
    final disposalLogs = _logs.where((l) => l.type == LogType.disposal).length;
    final errorLogs = _logs.where((l) => l.type == LogType.error).length;

    return Row(
      children: [
        Expanded(
          child: _buildStatBox(
            icon: Icons.cleaning_services,
            label: 'Cleaning',
            count: cleaningLogs,
            color: const Color(0xFF22C55E),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatBox(
            icon: Icons.delete_sweep,
            label: 'Disposal',
            count: disposalLogs,
            color: const Color(0xFF0EA5E9),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatBox(
            icon: Icons.error_outline,
            label: 'Errors',
            count: errorLogs,
            color: const Color(0xFFEF4444),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(LogEntry log, DateFormat formatter) {
    final color = _getLogColor(log.type);
    final icon = _getLogIcon(log.type);
    final typeLabel = _getLogTypeLabel(log.type);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.description,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatter.format(log.timestamp),
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.5)),
                ),
                child: Text(
                  typeLabel,
                  style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          if (log.classroom != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Location: ${log.classroom}',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
          if (log.duration != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Duration: ${_formatDuration(log.duration!)}',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getLogColor(LogType type) {
    switch (type) {
      case LogType.cleaning:
        return const Color(0xFF22C55E);
      case LogType.disposal:
        return const Color(0xFF0EA5E9);
      case LogType.error:
        return const Color(0xFFEF4444);
    }
  }

  IconData _getLogIcon(LogType type) {
    switch (type) {
      case LogType.cleaning:
        return Icons.cleaning_services;
      case LogType.disposal:
        return Icons.delete_sweep;
      case LogType.error:
        return Icons.error_outline;
    }
  }

  String _getLogTypeLabel(LogType type) {
    switch (type) {
      case LogType.cleaning:
        return 'CLEANING';
      case LogType.disposal:
        return 'DISPOSAL';
      case LogType.error:
        return 'ERROR';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '$minutes min ${seconds}s';
    }
    return '${duration.inSeconds}s';
  }
}
