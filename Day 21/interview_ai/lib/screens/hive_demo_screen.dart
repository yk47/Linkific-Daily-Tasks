import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive/hive.dart';
import 'package:top_5_packages_app/core/theme/app_theme.dart';

/// Demonstrates Hive NoSQL database features:
/// - Box concept
/// - CRUD operations
/// - Fast and lightweight
class HiveDemoScreen extends StatefulWidget {
  const HiveDemoScreen({super.key});

  @override
  State<HiveDemoScreen> createState() => _HiveDemoScreenState();
}

class _HiveDemoScreenState extends State<HiveDemoScreen> {
  late Box<Map> _notesBox;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<Map> _notes = [];
  bool _isLoaded = false;

  static const List<Color> _noteColors = [
    Color(0xFF6C63FF),
    Color(0xFF4ECDC4),
    Color(0xFFFF6B6B),
    Color(0xFFFFB347),
    Color(0xFF4C9BE8),
  ];

  @override
  void initState() {
    super.initState();
    _initBox();
  }

  Future<void> _initBox() async {
    _notesBox = await Hive.openBox<Map>('demoNotes');
    _loadNotes();
    setState(() => _isLoaded = true);
  }

  void _loadNotes() {
    _notes = _notesBox.values.toList();
  }

  Future<void> _addNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty) return;

    final note = {
      'title': title,
      'content': content,
      'createdAt': DateTime.now().toIso8601String(),
      'colorIndex': DateTime.now().millisecond % _noteColors.length,
    };

    await _notesBox.add(note);
    _titleController.clear();
    _contentController.clear();
    _loadNotes();
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note saved to Hive!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _updateNote(int index) async {
    final key = _notesBox.keyAt(index);
    final note = Map<String, dynamic>.from(_notes[index]);
    note['title'] = note['title'] + ' (updated)';
    await _notesBox.put(key, note);
    _loadNotes();
    setState(() {});
  }

  Future<void> _deleteNote(int index) async {
    final key = _notesBox.keyAt(index);
    await _notesBox.delete(key);
    _loadNotes();
    setState(() {});
  }

  Future<void> _clearAll() async {
    await _notesBox.clear();
    _loadNotes();
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 15, color: AppColors.textPrimary),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text('Hive Database'),
        actions: [
          if (_notes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded,
                  color: AppColors.error, size: 22),
              onPressed: _clearAll,
              tooltip: 'Clear all',
            ),
        ],
      ),
      body: Column(
        children: [
          // Add note form
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ADD NOTE TO HIVE',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _contentController,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Content (optional)',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addNote,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Save to Hive'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mint,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Box info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _InfoChip(
                  label: 'Box',
                  value: 'demoNotes',
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  label: 'Records',
                  value: '${_notes.length}',
                  color: AppColors.mint,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  label: 'Type',
                  value: 'Map',
                  color: AppColors.amber,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Notes list
          Expanded(
            child: _notes.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.storage_rounded,
                            size: 48, color: AppColors.textMuted),
                        SizedBox(height: 12),
                        Text(
                          'No notes in Hive yet.\nAdd one above!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      final colorIndex = note['colorIndex'] ?? 0;
                      final color =
                          _noteColors[colorIndex % _noteColors.length];
                      final date = DateTime.tryParse(
                              note['createdAt']?.toString() ?? '') ??
                          DateTime.now();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note['title'] ?? '',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (note['content']
                                          ?.toString()
                                          .isNotEmpty ==
                                      true) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      note['content'].toString(),
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  const SizedBox(height: 4),
                                  Text(
                                    '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert_rounded,
                                  size: 18, color: AppColors.textMuted),
                              color: AppColors.surface,
                              onSelected: (value) {
                                if (value == 'update') _updateNote(index);
                                if (value == 'delete') _deleteNote(index);
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'update',
                                  child: Text('Update'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete',
                                      style: TextStyle(color: AppColors.error)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}