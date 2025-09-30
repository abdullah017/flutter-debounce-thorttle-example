import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../utils/debouncer.dart';

class DebounceSearchPage extends ConsumerStatefulWidget {
  const DebounceSearchPage({Key? key}) : super(key: key);
  @override
  ConsumerState<DebounceSearchPage> createState() => _DebounceSearchPageState();
}

class _DebounceSearchPageState extends ConsumerState<DebounceSearchPage> {
  // 500ms bekleme süreli bir Debouncer.
  final _debouncer = Debouncer(milliseconds: 500);
  final _searchQueryProvider = StateProvider<String>((ref) => '');

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(_searchQueryProvider);
    final searchResult = ref.watch(searchProvider(searchQuery));

    return Scaffold(
      appBar: AppBar(title: const Text('Debounce Arama')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Aramak için yazın...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Her tuş vuruşunda, debouncer'ı çalıştır.
                // Sadece kullanıcı 500ms duraksadığında provider'ı güncelleyecek.
                _debouncer.run(() {
                  ref.read(_searchQueryProvider.notifier).state = value;
                });
              },
            ),
          ),
          Expanded(
            child: searchResult.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return const Center(child: Text('Sonuç bulunamadı.'));
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(posts[index].title),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}