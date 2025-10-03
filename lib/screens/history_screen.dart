import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/history_db.dart';
import '../models/diagnosis_record.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = '/history';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<DiagnosisRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = HistoryDb.instance.fetchAll();
  }

  Future<void> _refresh() async {
    setState(() => _future = HistoryDb.instance.fetchAll());
  }

  Future<void> _clearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('مسح السجل'),
        content: const Text('هل متأكد من حذف كل التشخيصات؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف')),
        ],
      ),
    );
    if (ok == true) {
      await HistoryDb.instance.clearAll();
      if (mounted) _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final df = DateFormat('y/MM/dd HH:mm', 'ar');

    return Scaffold(
      appBar: AppBar(
        title: const Text('السجل'),
        actions: [
          IconButton(
            onPressed: _clearAll,
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: 'حذف الكل',
          ),
        ],
      ),
      body: FutureBuilder<List<DiagnosisRecord>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('خطأ: ${snap.error}'));
          }
          final list = snap.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('لا توجد تشخيصات محفوظة بعد'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final r = list[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: cs.outlineVariant),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: cs.primary.withOpacity(.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: r.imagePath.isNotEmpty && File(r.imagePath).existsSync()
                            ? Image.file(File(r.imagePath), fit: BoxFit.cover)
                            : const Icon(Icons.image_not_supported_outlined),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(
                              'ثقة: ${(r.confidence * 100).toStringAsFixed(0)}% — ${df.format(r.createdAt)}',
                              style: TextStyle(color: cs.onSurfaceVariant),
                            ),
                            if (r.notes != null && r.notes!.trim().isNotEmpty)
                              Text(r.notes!, style: TextStyle(color: cs.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
