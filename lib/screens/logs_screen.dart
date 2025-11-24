import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:robofinal/models/log_entry.dart';
import 'package:robofinal/services/mock_admin_service.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> with TickerProviderStateMixin {
  late List<LogEntry> _logs;
  LogType? _selectedFilter;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _logs = MockAdminService.instance.getLogs();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                children: [
                  // Header with Fade Animation
                  FadeTransition(
                    opacity: _fadeController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activity Logs',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Track all robot activities and events',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Filter Chips with Slide Animation
                  SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _slideController,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: _buildFilterChips(),
                  ),
                  const SizedBox(height: 28),

                  // Log Statistics with Slide Animation
                  SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _slideController,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: _buildLogStats(),
                  ),
                  const SizedBox(height: 28),

                  // Logs List Header
                  SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _slideController,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: Text(
                      'Recent Activities',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logs List with Slide Animation
                  ..._filteredLogs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final log = entry.value;
                    final isLast = index == _filteredLogs.length - 1;

                    return Column(
                      children: [
                        SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _slideController,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                          child: _buildLogCard(log, formatter),
                        ),
                        if (!isLast) const SizedBox(height: 12),
                      ],
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: FadeTransition(
        opacity: _fadeController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
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
              'No Logs Found',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Activity logs will appear here',
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
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
          const SizedBox(width: 12),
          _buildFilterChip(
            label: 'Cleaning',
            isSelected: _selectedFilter == LogType.cleaning,
            onTap: () {
              setState(() {
                _selectedFilter = LogType.cleaning;
              });
            },
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            label: 'Disposal',
            isSelected: _selectedFilter == LogType.disposal,
            onTap: () {
              setState(() {
                _selectedFilter = LogType.disposal;
              });
            },
          ),
          const SizedBox(width: 12),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
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
            color: const Color(0xFF8B5CF6),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            '$count',
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(LogEntry log, DateFormat formatter) {
    final logColor = _getLogColor(log.type);
    final logIcon = _getLogIcon(log.type);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [logColor, logColor.withValues(alpha: 0.6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(logIcon, color: Colors.white, size: 24),
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
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatter.format(log.timestamp),
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.5),
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
                  color: logColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: logColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  _getLogTypeLabel(log.type),
                  style: GoogleFonts.poppins(
                    color: logColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getLogColor(LogType type) {
    switch (type) {
      case LogType.cleaning:
        return const Color(0xFF22C55E);
      case LogType.disposal:
        return const Color(0xFF8B5CF6);
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
}
