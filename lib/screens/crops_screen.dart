import 'package:flutter/material.dart';
import '../data/crops_repository.dart';
import '../models/crop.dart';
import 'crop_detail_screen.dart';

class CropsScreen extends StatefulWidget {
  static const routeName = '/crops';
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  final _ctrl = TextEditingController();
  late Future<List<CropCategory>> _futureCats;
  List<CropInfo> _visible = [];
  List<CropCategory> _cats = [];

  @override
  void initState() {
    super.initState();
    _futureCats = CropsRepository.load();
    _futureCats.then((cats) {
      _cats = cats;
      _visible = cats.expand((c) => c.crops).toList();
      setState(() {});
    });
  }

  Future<void> _onQuery(String q) async {
    final res = await CropsRepository.search(q);
    setState(() => _visible = res);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FutureBuilder<List<CropCategory>>(
      future: _futureCats,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('حدث خطأ في قراءة بيانات المحاصيل'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _ctrl,
                onChanged: _onQuery,
                decoration: InputDecoration(
                  hintText: 'ابحث باسم المحصول أو المرض…',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
              ),
            ),
            Expanded(
              child: _visible.isEmpty
                  ? const Center(child: Text('لا توجد نتائج مطابقة'))
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                itemCount: _visible.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final crop = _visible[i];
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CropDetailScreen(crop: crop),
                        settings: const RouteSettings(name: CropDetailScreen.routeName),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: cs.outlineVariant),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.spa_rounded),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(crop.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text('التربة: ${crop.soil}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: cs.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_left),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
