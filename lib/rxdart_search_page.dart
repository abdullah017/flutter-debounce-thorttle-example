import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer_thorttler_rxdart_example/data/post_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../providers/search_provider.dart';

class RxDartSearchPage extends ConsumerStatefulWidget {
  const RxDartSearchPage({Key? key}) : super(key: key);
  @override
  ConsumerState<RxDartSearchPage> createState() => _RxDartSearchPageState();
}

class _RxDartSearchPageState extends ConsumerState<RxDartSearchPage> {
  // 1. Girdi olaylarını yakalamak için bir StreamController oluştur.
  // PublishSubject, rxdart'tan gelir ve birden fazla dinleyicisi olabilen bir StreamController'dır.
  final _searchSubject = PublishSubject<String>();

  // 2. Arama sonuçlarını tutmak için bir StateProvider oluştur.
  // Bu, provider'ın UI'da dinlenmesini ve güncellenmesini sağlar.
  final _searchResultProvider = StateProvider<AsyncValue<List<Post>>>(
    (ref) => const AsyncValue.data([]),
  );

  StreamSubscription? _searchSubscription;

  @override
  void initState() {
    super.initState();
    _listenToSearchStream();
  }

  void _listenToSearchStream() {
    _searchSubscription = _searchSubject
        // 3. rxdart'ın sihirli operatörleri zinciri
        .stream
        // Kullanıcı 500ms yazmayı bırakana kadar bekle
        .debounceTime(const Duration(milliseconds: 500))
        // Art arda aynı arama terimi gelirse, yenisini görmezden gel
        .distinct()
        // Her yeni arama terimi geldiğinde, API isteğini tetikle.
        // switchMap, önceki API isteği henüz tamamlanmadıysa onu iptal eder
        // ve yenisini başlatır. Bu, çok hızlı yazan kullanıcılar için mükemmeldir.
        .switchMap<AsyncValue<List<Post>>>((query) async* {
          // Arama başlamadan önce UI'a yükleme durumunu bildir.
          yield const AsyncValue<List<Post>>.loading();
          try {
            // query boşsa, API'yi çağırmak yerine boş bir sonuç döndür.
            if (query.isEmpty) {
              yield const AsyncValue.data([]);
            } else {
              // Riverpod'dan servis'i oku ve API'yi çağır.
              final result = await ref
                  .read(postServiceProvider)
                  .searchPosts(query);
              yield AsyncValue.data(result);
            }
          } catch (e, s) {
            yield AsyncValue.error(e, s);
          }
        })
        // 4. Sonuçları dinle ve UI'ın state'ini güncelle.
        .listen((result) {
          ref.read(_searchResultProvider.notifier).state = result;
        });
  }

  @override
  Widget build(BuildContext context) {
    // UI, searchResultProvider'ı dinler.
    final searchResult = ref.watch(_searchResultProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Debounce (rxdart)')),
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
                // 5. Her tuş vuruşunda, yeni değeri stream'e ekle.
                _searchSubject.add(value);
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
                  itemBuilder: (context, index) =>
                      ListTile(title: Text(posts[index].title)),
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
    // 6. Controller'ları ve subscription'ları temizlemeyi unutma!
    _searchSubject.close();
    _searchSubscription?.cancel();
    super.dispose();
  }
}
