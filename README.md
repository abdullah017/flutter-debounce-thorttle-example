
# Flutter Debounce & Throttle Demo

Bu proje, Flutter uygulamalarında sık tetiklenen kullanıcı olaylarını (events) yönetmek için kullanılan iki temel optimizasyon tekniği olan **Debouncing** ve **Throttling**'i gösteren kapsamlı bir demo uygulamasıdır. Amaç, bu tekniklerin uygulamanın performansını, sunucu sağlığını ve kullanıcı deneyimini nasıl iyileştirdiğini somut, karşılaştırılabilir örneklerle göstermektir.

Proje, üç farklı implementasyon senaryosu sunarak, basit bir `Timer` tabanlı çözümden `rxdart` gibi güçlü bir reaktif programlama kütüphanesine kadar olan spektrumu kapsar.

Bu proje, aşağıdaki Medium makalesinin pratik uygulaması olarak geliştirilmiştir:


---

## 🎯 Projenin Amacı ve Öğrettikleri

Kullanıcı etkileşimleri doğası gereği "gürültülü" olabilir. Bir arama çubuğuna yazılan her harf veya bir listenin kaydırıldığı her piksel, bir olay tetikler. Bu olayları olduğu gibi işlemek, "Aşırı Ateşleme" (Over-firing) olarak bilinen ve ciddi performans sorunlarına yol açan bir tuzağa düşmektir.

Bu proje, bu tuzağa düşmemek için gereken temel stratejileri öğretir:

1.  **Debouncing Nedir ve Ne Zaman Kullanılır?** Bir olay akışı durduktan sonra tek bir eylem gerçekleştirerek gereksiz işlemleri (özellikle API çağrılarını) nasıl önleyeceğimizi gösterir.
2.  **Throttling Nedir ve Ne Zaman Kullanılır?** Bir olayın belirli bir zaman aralığında en fazla bir kez tetiklenmesini sağlayarak, yüksek frekanslı olayları (kaydırma, sürükleme vb.) nasıl seyrelteceğimizi gösterir.
3.  **Farklı Implementasyon Yaklaşımları:** Aynı sorunu çözmek için `dart:async`'in temel `Timer`'ını kullanmak ile `rxdart` gibi bir kütüphanenin reaktif `Stream`'lerini kullanmak arasındaki farkları ve avantajları sergiler.

## ✨ Öne Çıkan Senaryolar

Uygulama, üç farklı senaryoyu test edebileceğiniz üç ayrı sayfa içerir:

### Senaryo 1: Debounce (Manuel `Timer` ile Arama)

Bu sayfa, `dart:async`'in `Timer`'ını kullanarak sıfırdan yazdığımız bir `Debouncer` sınıfı ile arama optimizasyonunu gösterir.

-   **Problem:** Kullanıcı her harf yazdığında API isteği göndermek.
-   **Çözüm:** `Debouncer`, kullanıcı yazmayı bıraktıktan 500ms sonra tek bir API isteği gönderilmesini sağlar.
-   **Öğrenim:** Debouncing mantığının temelini ve imperatif (emredici) bir yaklaşımla nasıl uygulanacağını anlamak.
-   **Uygulama Yeri:** `lib/presentation/debounce_search_page.dart`


### Senaryo 2: Debounce (`rxdart` ile Reaktif Arama)

Bu sayfa, aynı arama problemini `rxdart` kütüphanesi ve onun güçlü `Stream` operatörleri ile çözer.

-   **Problem:** Aynı arama problemi, ancak daha reaktif ve güçlü bir çözüm arayışı.
-   **Çözüm:** `debounceTime`, `distinct` ve `switchMap` gibi operatörler kullanılarak bir olay akışı (stream) oluşturulur. Bu yaklaşım, sadece debounce yapmakla kalmaz, aynı zamanda eski ve alakasız kalan API isteklerini otomatik olarak iptal eder.
-   **Öğrenim:** Deklaratif (bildirimsel) ve reaktif programlamanın gücünü görmek. Karmaşık asenkron mantığı daha okunabilir ve yönetilebilir kılmak.
-   **Uygulama Yeri:** `lib/presentation/rxdart_search_page.dart`


### Senaryo 3: Throttle (Manuel `Timer` ile Kaydırma)

Bu sayfa, uzun bir listenin kaydırılması sırasında tetiklenen olayları seyreltmek için `Throttler` sınıfının kullanımını gösterir.

-   **Problem:** Bir `ScrollController` listener'ı, kaydırma sırasında saniyede onlarca kez tetiklenir ve bu, karmaşık hesaplamalar için çok maliyetli olabilir.
-   **Çözüm:** `Throttler`, listener içindeki mantığın her 300ms'de en fazla bir kez çalışmasını garanti eder.
-   **Öğrenim:** Throttling konseptini ve yüksek frekanslı olayları nasıl kontrol altına alacağımızı anlamak.
-   **Uygulama Yeri:** `lib/presentation/throttle_scroll_page.dart`




## 🛠️ Teknolojiler ve Kütüphaneler

-   **[Flutter](https://flutter.dev/)** & **[Dart](https://dart.dev/)**
-   **[flutter_riverpod](https://riverpod.dev/)**: State yönetimi için modern ve test edilebilir bir çözüm.
-   **[http](https://pub.dev/packages/http)**: API istekleri yapmak için standart kütüphane.
-   **[rxdart](https://pub.dev/packages/rxdart)**: Dart diline Reaktif Programlama (Rx) yetenekleri ekleyen güçlü bir kütüphane.
-   **API:** Test verileri için ücretsiz sahte API olan **[JSONPlaceholder](https://jsonplaceholder.typicode.com/)** kullanılmıştır.



## 📂 Proje Yapısı

Proje, konseptlerin kolayca anlaşılabilmesi için basit ve katmanlı bir yapıda düzenlenmiştir:

```
lib/
├── data/
│   ├── post_service.dart     # API çağrı mantığı ve Post modeli
├── presentation/
│   ├── debounce_search_page.dart
│   ├── home_page.dart
│   ├── rxdart_search_page.dart
│   └── throttle_scroll_page.dart
├── providers/
│   └── search_provider.dart  # Riverpod provider'ları
├── utils/
│   ├── debouncer.dart        # Manuel Debouncer sınıfı
│   └── throttler.dart        # Manuel Throttler sınıfı
└── main.dart
```


https://github.com/user-attachments/assets/73eecb7a-f621-4946-b23a-7293682ddff7


