# NCC Campus - ODTÜ KKK Kampüs Mobil Uygulaması

> ODTÜ Kuzey Kıbrıs Kampüsü öğrencileri için tasarlanmış, modern ve kapsamlı kampüs yaşam uygulaması.

## 📱 Özellikler

### GPA Hesaplayıcı
- Ders ekleme/silme ile anlık GPA hesaplama
- ODTÜ harf notu sistemi (AA-FF)
- GPA Simülatörü: "Bu dersten hangi notu almalıyım?" analizi
- Kredi bazlı ağırlıklı ortalama
- Yerel kaydetme (SharedPreferences)

### Kampüs Rehberi
- İşletme listesi (kafeler, restoranlar, marketler, hizmetler)
- Kategori filtreleme ve arama
- Açık/kapalı durumu gösterimi
- Menü ve fiyat bilgileri
- İşletme detay sayfası

### Yemekhane Menüsü
- Günlük yemekhane menüsü (çorba, ana yemek, yan yemek, ekstra)
- Bugünün menüsü vurgulaması
- Tarih bazlı listeleme

### Duyuru & Etkinlikler
- Kampüs duyuruları ve etkinlikleri
- Kategori bazlı filtreleme (etkinlik, duyuru, sınav, genel)
- Aktif/pasif durumu

### Ring Saatleri
- Ders saatleri listesi
- Başlangıç ve bitiş saatleri

### Yorum Sistemi
- İşletmelere anonim yorum yazma
- 5 yıldızlı puanlama sistemi
- Yorum listeleme

### Reklam Sistemi
- Google AdMob entegrasyonu (banner + interstitial)
- Kullanıcı tercihi: reklamlı veya reklamsız kullanım
- Kayıt sırasında reklam tercihi seçimi

### Sınav Takvimi
- Admin panelinden sınav programı PDF yükleme
- PDF otomatik parse edilir (ders kodu, tarih, saat, yer)
- Kullanıcı kendi derslerini seçerek kişisel sınav takvimi oluşturur
- Takvim görünümü (TableCalendar) ile sınavları tarih bazlı gösterim
- Sınav türü filtreleme (MT1, MT2, Final, Quiz, Make-up)
- ICS dosyası export ile telefon takvimine ekleme
- Yerel bildirimler: sınavdan 1 gün önce (20:00) + sınav günü (08:00)
- Aynı dosya adı tekrar yüklenirse eski veriler otomatik silinip yeniden oluşturulur

### Admin Paneli
- **Dashboard**: Genel istatistikler (kullanıcı, işletme, yorum, duyuru sayıları)
- **İşletme Yönetimi**: CRUD + menü öğeleri yönetimi
- **Duyuru/Etkinlik Yönetimi**: CRUD + kategori + aktif/pasif toggle
- **Ring Saatleri Yönetimi**: CRUD
- **Yemekhane Menüsü Yönetimi**: CRUD + tarih seçimi
- **Kullanıcı Yönetimi**: Kullanıcı listesi + rol değiştirme (admin/user)
- **Yorum Yönetimi**: Yorum moderasyonu + silme
- **Sınav Yönetimi**: PDF yükle → otomatik parse → önizleme → kaydet

### Kimlik Doğrulama
- Firebase Authentication (email/password)
- `.edu.tr` email zorunluluğu (kayıt)
- Misafir modu (sınırlı özellikler)
- Admin rol sistemi (Firestore tabanlı)

---

## 🏗️ Proje Yapısı

```
lib/
├── main.dart                          # Uygulama giriş noktası
├── core/
│   ├── theme/
│   │   └── app_theme.dart             # Dark tema, renkler, stiller
│   ├── l10n/
│   │   └── app_localizations.dart     # TR/EN çeviri (100+ anahtar)
│   ├── providers/
│   │   ├── auth_provider.dart         # Firebase Auth + rol yönetimi
│   │   ├── ad_provider.dart           # Reklam tercihi yönetimi
│   │   ├── gpa_provider.dart          # GPA hesaplama mantığı
│   │   ├── locale_provider.dart       # TR/EN dil değiştirme
│   │   └── exam_provider.dart         # Sınav takvimi state + ICS export
│   ├── models/
│   │   ├── user_model.dart            # AppUser modeli (Firestore)
│   │   ├── business_model.dart        # Business + MenuItem (Firestore)
│   │   ├── campus_models.dart         # Announcement, RingSchedule, CafeteriaMenu, Review
│   │   ├── social_models.dart         # Confession, MarketplaceListing, CarpoolRide
│   │   ├── exam_model.dart            # Exam + ExamScheduleFile (Firestore)
│   │   └── business.dart              # Legacy model (sample data için)
│   ├── services/
│   │   ├── firestore_service.dart     # Firestore CRUD operasyonları
│   │   ├── ad_service.dart            # AdMob singleton servisi
│   │   ├── exam_parser_service.dart   # PDF parse + sınav verisi çıkarma
│   │   └── notification_service.dart  # Yerel bildirim zamanlama
│   └── data/
│       ├── sample_data.dart           # Örnek veri (offline fallback)
│       └── department_data.dart       # Bölüm ve ders verileri (GPA için)
├── screens/
│   ├── splash_screen.dart             # Animasyonlu açılış
│   ├── welcome_screen.dart            # Kayıt/Giriş/Misafir seçimi
│   ├── home_screen.dart               # Ana ekran + bottom nav (4 tab)
│   ├── auth/
│   │   ├── login_screen.dart          # Email/şifre giriş
│   │   └── register_screen.dart       # .edu.tr kayıt + reklam tercihi
│   ├── gpa/
│   │   ├── gpa_screen.dart            # GPA hesaplayıcı
│   │   └── gpa_simulator_screen.dart  # GPA simülatörü
│   ├── campus/
│   │   ├── campus_directory_screen.dart # İşletme rehberi
│   │   ├── business_detail_screen.dart  # İşletme detay
│   │   ├── announcements_screen.dart    # Duyurular
│   │   ├── ring_schedule_screen.dart    # Ring saatleri
│   │   ├── cafeteria_screen.dart        # Yemekhane menüsü
│   │   ├── transportation_screen.dart   # Ulaşım servisleri
│   │   ├── this_week_screen.dart        # Kampüste bu hafta
│   │   └── reviews_screen.dart          # Yorum sayfası
│   ├── social/
│   │   ├── confessions_screen.dart      # Anonim itiraflar
│   │   ├── marketplace_screen.dart      # İkinci el pazar
│   │   └── carpool_screen.dart          # Araç paylaşım
│   ├── exams/
│   │   └── exams_screen.dart            # Sınav takvimi + ders seçimi
│   ├── profile/
│   │   └── profile_screen.dart          # Profil + ayarlar
│   └── admin/
│       ├── admin_dashboard_screen.dart     # Admin ana ekranı
│       ├── admin_businesses_screen.dart    # İşletme CRUD
│       ├── admin_announcements_screen.dart # Duyuru CRUD
│       ├── admin_ring_schedule_screen.dart # Ring saati CRUD
│       ├── admin_cafeteria_screen.dart     # Yemekhane CRUD
│       ├── admin_users_screen.dart         # Kullanıcı yönetimi
│       ├── admin_reviews_screen.dart       # Yorum moderasyonu
│       └── admin_exams_screen.dart         # Sınav PDF yükleme + yönetim
└── widgets/
    └── ad_banner_widget.dart          # AdMob banner widget
```

---

## 🛠️ Teknoloji Stack

| Teknoloji | Versiyon | Kullanım |
|-----------|----------|----------|
| Flutter | 3.41.7 | UI framework |
| Dart | 3.11.5 | Programlama dili |
| Firebase Core | 3.12.1 | Firebase altyapısı |
| Firebase Auth | 5.5.4 | Kimlik doğrulama |
| Cloud Firestore | 5.6.8 | Veritabanı |
| Firebase Storage | 12.4.4 | Dosya depolama |
| Provider | 6.1.5 | State management |
| SharedPreferences | 2.5.3 | Yerel depolama |
| Google Mobile Ads | 5.3.0 | Reklam sistemi |
| Flutter Rating Bar | 4.0.1 | Yıldız puanlama |
| Cached Network Image | 3.4.1 | Resim cache |
| URL Launcher | 6.3.1 | Harici link açma |
| Image Picker | 1.1.2 | Fotoğraf seçme |
| Intl | 0.20.2 | Tarih formatı |
| Timeago | 3.7.0 | Zaman gösterimi |
| Google Sign In | 6.2.2 | Google ile giriş |
| Table Calendar | 3.1.2 | Takvim görünümü |
| Flutter Local Notifications | 18.0.0 | Yerel bildirimler |
| Syncfusion Flutter PDF | 28.1.33 | PDF metin çıkarma |
| File Picker | 8.1.6 | Dosya seçme |
| Path Provider | 2.1.5 | Geçici dosya yolu |
| Share Plus | 10.1.4 | ICS dosya paylaşımı |
| Timezone | 0.10.0 | Zaman dilimi desteği |

---

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK (>= 3.41.0)
- Dart SDK (>= 3.11.0)
- Firebase projesi
- Android Studio / Xcode (platform bağımlı)

### 1. Projeyi Klonla
```bash
git clone <repo-url>
cd "NCC mobile app"
```

### 2. Bağımlılıkları Yükle
```bash
flutter pub get
```

### 3. Firebase Yapılandırması

#### FlutterFire CLI ile (Önerilen)
```bash
# FlutterFire CLI yükle
dart pub global activate flutterfire_cli

# Firebase projesini yapılandır
flutterfire configure --project=<firebase-project-id>
```

Bu komut otomatik olarak `lib/firebase_options.dart` dosyasını oluşturur.

#### Manuel Yapılandırma
1. [Firebase Console](https://console.firebase.google.com/) üzerinden yeni proje oluştur
2. Android uygulaması ekle (package: `com.metuncc.ncc_mobile_app`)
3. `google-services.json` dosyasını `android/app/` klasörüne koy
4. iOS uygulaması ekle
5. `GoogleService-Info.plist` dosyasını `ios/Runner/` klasörüne koy

### 4. Firebase Servislerini Etkinleştir
Firebase Console'dan:
- **Authentication** → Email/Password yöntemini etkinleştir
- **Cloud Firestore** → Veritabanı oluştur (test modunda başlayabilirsin)
- **Storage** → Storage'ı etkinleştir

### 5. Firestore Güvenlik Kuralları
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Kullanıcılar kendi profillerini okuyabilir/yazabilir
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
      allow update: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // İşletmeler: herkes okuyabilir, admin yazabilir
    match /businesses/{doc} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Duyurular: herkes okuyabilir, admin yazabilir
    match /announcements/{doc} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Ring saatleri: herkes okuyabilir, admin yazabilir
    match /ringSchedule/{doc} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Yemekhane: herkes okuyabilir, admin yazabilir
    match /cafeteriaMenu/{doc} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Yorumlar: herkes okuyabilir, giriş yapanlar yazabilir, admin silebilir
    match /reviews/{doc} {
      allow read: if true;
      allow create: if request.auth != null;
      allow delete: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Sınav takvimleri: herkes okuyabilir, admin yazabilir
    match /examSchedules/{doc} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Sınavlar: herkes okuyabilir, admin yazabilir
    match /exams/{doc} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

### 6. İlk Admin Kullanıcısı Oluşturma
1. Uygulamadan `.edu.tr` email ile kayıt ol
2. Firebase Console → Firestore → `users` koleksiyonu
3. Kullanıcının `role` alanını `admin` olarak değiştir
4. Uygulamayı yeniden başlat — admin paneli görünür olacak

### 7. Çalıştır
```bash
# Android
flutter run

# iOS
cd ios && pod install && cd ..
flutter run

# Web (henüz optimize edilmedi)
flutter run -d chrome
```

---

## 📊 Firestore Veritabanı Şeması

### `users` Koleksiyonu
```json
{
  "uid": "string",
  "email": "string",
  "displayName": "string",
  "role": "guest | user | admin",
  "adsEnabled": true,
  "createdAt": "timestamp"
}
```

### `businesses` Koleksiyonu
```json
{
  "name": "string",
  "category": "string",
  "phone": "string",
  "description": "string",
  "imageUrl": "string",
  "openHours": "string",
  "isOpen": true,
  "rating": 4.5,
  "reviewCount": 12,
  "menu": [
    {"name": "Americano", "price": 45.0}
  ]
}
```

### `announcements` Koleksiyonu
```json
{
  "title": "string",
  "description": "string",
  "category": "event | announcement | exam | general",
  "date": "timestamp",
  "isActive": true
}
```

### `ringSchedule` Koleksiyonu
```json
{
  "period": 1,
  "startTime": "08:40",
  "endTime": "09:30"
}
```

### `cafeteriaMenu` Koleksiyonu
```json
{
  "date": "timestamp",
  "soup": ["Mercimek Çorbası"],
  "mainCourse": ["Tavuk Sote"],
  "sideDish": ["Pilav"],
  "extra": ["Ayran"]
}
```

### `reviews` Koleksiyonu
```json
{
  "userId": "string",
  "userName": "Anonim",
  "targetId": "string",
  "targetType": "business",
  "rating": 4.5,
  "comment": "string",
  "createdAt": "timestamp"
}
```

### `examSchedules` Koleksiyonu
```json
{
  "fileName": "Midterm Exam Schedule.pdf",
  "downloadUrl": "https://...",
  "semester": "2025-2026 Spring",
  "examType": "MT1",
  "uploadedAt": "timestamp",
  "isActive": true,
  "examCount": 42
}
```

### `exams` Koleksiyonu
```json
{
  "scheduleId": "string",
  "courseCode": "CNG 315",
  "courseName": "Algorithms",
  "examType": "MT1",
  "date": "timestamp",
  "startTime": "09:00",
  "endTime": "11:00",
  "building": "SZ",
  "room": "18",
  "sections": "1,2"
}
```

---

## 🎨 Tasarım Sistemi

- **Tema**: Dark mode (Notion/Apple ilhamıyla)
- **Arka plan**: `#0D0D0D`
- **Yüzey**: `#1A1A1A`
- **Primary**: `#6C63FF` (mor)
- **Accent**: `#00D9FF` (cyan)
- **Success**: `#00C853`
- **Warning**: `#FFB300`
- **Error**: `#FF5252`
- **Border radius**: 14-20px
- **Font**: Sistem fontu, ağırlıklar 400-800

---

## 📁 Routes

| Route | Ekran |
|-------|-------|
| `/splash` | Açılış animasyonu |
| `/welcome` | Kayıt/Giriş seçimi |
| `/login` | Giriş ekranı |
| `/register` | Kayıt ekranı |
| `/home` | Ana ekran (4-tab) |
| `/gpa` | GPA hesaplayıcı |
| `/gpa-simulator` | GPA simülatörü |
| `/campus` | Kampüs rehberi |
| `/announcements` | Duyurular |
| `/ring-schedule` | Ring saatleri |
| `/cafeteria` | Yemekhane menüsü |
| `/transportation` | Ulaşım servisleri |
| `/this-week` | Kampüste bu hafta |
| `/confessions` | İtiraflar |
| `/marketplace` | İkinci el pazar |
| `/carpool` | Araç paylaşım |
| `/exams` | Sınav takvimi |
| `/profile` | Profil |
| `/admin` | Admin paneli |

---

## 🔑 Reklam (AdMob) Notları

Şu an **test ad unit ID'leri** kullanılıyor. Yayınlamadan önce:
1. [AdMob Console](https://admob.google.com/) üzerinden gerçek ad unit ID'leri oluştur
2. `lib/core/services/ad_service.dart` dosyasındaki ID'leri güncelle
3. Android: `android/app/src/main/AndroidManifest.xml` dosyasına AdMob app ID ekle
4. iOS: `ios/Runner/Info.plist` dosyasına GADApplicationIdentifier ekle

---

## 🤝 Katkıda Bulunma

1. Fork et
2. Feature branch oluştur (`git checkout -b feature/amazing-feature`)
3. Commit et (`git commit -m 'feat: add amazing feature'`)
4. Push et (`git push origin feature/amazing-feature`)
5. Pull Request aç

---

## 📄 Lisans

Bu proje ODTÜ KKK öğrencileri tarafından geliştirilmektedir.
