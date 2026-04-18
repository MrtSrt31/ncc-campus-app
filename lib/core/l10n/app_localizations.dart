import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isTr => locale.languageCode == 'tr';

  String get appTitle => isTr ? 'NCC Campus' : 'NCC Campus';

  // ── Navigation ──
  String get navHome => isTr ? 'Ana Sayfa' : 'Home';
  String get navGpa => isTr ? 'GPA' : 'GPA';
  String get navCampus => isTr ? 'Kampüs' : 'Campus';
  String get navProfile => isTr ? 'Profil' : 'Profile';

  // ── Home ──
  String greeting(String name) =>
      isTr ? 'Merhaba, $name 👋' : 'Hello, $name 👋';
  String get greetingGuest => isTr ? 'Merhaba 👋' : 'Hello 👋';
  String get welcomeSubtitle =>
      isTr ? 'NCC Campus\'a hoş geldin' : 'Welcome to NCC Campus';
  String get quickAccess => isTr ? 'Hızlı Erişim' : 'Quick Access';
  String get comingSoon => isTr ? 'Yakında Geliyor' : 'Coming Soon';
  String get soon => isTr ? 'Yakında' : 'Soon';

  // ── Quick Actions ──
  String get gpaCalculate => isTr ? 'GPA Hesapla' : 'Calculate GPA';
  String get gpaCalculateSub => isTr ? 'Ortalamanı hesapla' : 'Calculate your GPA';
  String get simulator => isTr ? 'Simülatör' : 'Simulator';
  String get simulatorSub => isTr ? 'Not simülasyonu' : 'Grade simulation';
  String get businesses => isTr ? 'İşletmeler' : 'Businesses';
  String get businessesSub => isTr ? 'Kampüs rehberi' : 'Campus guide';
  String get cafeteria => isTr ? 'Yemekhane' : 'Cafeteria';
  String get cafeteriaSub => isTr ? 'Günlük menü' : 'Daily menu';
  String get announcements => isTr ? 'Duyurular' : 'Announcements';
  String get announcementsSub => isTr ? 'Kampüs haberleri' : 'Campus news';
  String get ringSchedule => isTr ? 'Ring Saatleri' : 'Ring Schedule';
  String get ringScheduleSub => isTr ? 'Ders saatleri' : 'Class hours';
  String get transportation => isTr ? 'Ulaşım' : 'Transportation';
  String get transportationSub =>
      isTr ? 'Servis saatleri' : 'Service schedules';
  String get thisWeek => isTr ? 'Bu Hafta' : 'This Week';
  String get thisWeekSub =>
      isTr ? 'Kampüste bu hafta' : 'This week on campus';
  String get confessions => isTr ? 'İtiraflar' : 'Confessions';
  String get confessionsSub =>
      isTr ? 'Anonim paylaşım' : 'Anonymous posts';
  String get marketplace => isTr ? 'İkinci El' : 'Marketplace';
  String get marketplaceSub =>
      isTr ? 'Al-sat platformu' : 'Buy & sell';
  String get carpool => isTr ? 'Araç Paylaşım' : 'Carpool';
  String get carpoolSub =>
      isTr ? 'Yolculuk paylaş' : 'Share rides';
  String get adminPanel => isTr ? 'Admin Panel' : 'Admin Panel';
  String get adminPanelSub => isTr ? 'Yönetim paneli' : 'Management';

  // ── GPA ──
  String get gpaTitle => isTr ? 'GPA Hesapla' : 'Calculate GPA';
  String get overallGpa => isTr ? 'Genel Ortalama' : 'Overall GPA';
  String get courses => isTr ? 'Ders' : 'Course';
  String get credit => isTr ? 'Kredi' : 'Credit';
  String get addCourse => isTr ? 'Ders Ekle' : 'Add Course';
  String get courseName => isTr ? 'Ders Adı' : 'Course Name';
  String get creditHint => isTr ? 'Kredi (ör: 3)' : 'Credits (e.g. 3)';
  String get add => isTr ? 'Ekle' : 'Add';
  String get deleteAll => isTr ? 'Tümünü Sil' : 'Clear All';
  String get noCourses =>
      isTr ? 'Henüz ders eklenmedi' : 'No courses added yet';
  String get addCoursesHint =>
      isTr ? 'Derslerini ekleyerek GPA\'nı hesapla' : 'Add courses to calculate your GPA';
  String get fillAllFields =>
      isTr ? 'Tüm alanları doğru doldurun' : 'Fill all fields correctly';
  String get selectDepartment => isTr ? 'Bölüm Seç' : 'Select Department';
  String get selectCourse => isTr ? 'Ders Seç' : 'Select Course';
  String get orManual => isTr ? 'veya manuel gir' : 'or enter manually';
  String get semester => isTr ? 'Dönem' : 'Semester';

  // ── GPA Simulator ──
  String get gpaSimulator => isTr ? 'GPA Simülatör' : 'GPA Simulator';
  String get simulate => isTr ? 'Simüle Et' : 'Simulate';
  String get targetGpa => isTr ? 'Hedef GPA' : 'Target GPA';
  String get minimumGrade => isTr ? 'Gereken Minimum Not' : 'Minimum Grade Required';
  String get newGpa => isTr ? 'Yeni GPA' : 'New GPA';
  String get currentGpa => isTr ? 'Mevcut GPA' : 'Current GPA';
  String get calculate => isTr ? 'Hesapla' : 'Calculate';
  String get estimatedGpa => isTr ? 'Tahmini GPA' : 'Estimated GPA';
  String get ifIGetGrade => isTr ? '"Bu dersten ... alırsam?"' : '"If I get ... in this course?"';
  String get targetGpaQuestion => isTr ? '"Hedef GPA için minimum not?"' : '"Minimum grade for target GPA?"';
  String get targetGpaHint => isTr ? 'Hedef GPA (ör: 3.00)' : 'Target GPA (e.g. 3.00)';
  String coursesCredits(int count, String credits) => isTr ? '$count ders • $credits kredi' : '$count courses • $credits credits';

  // ── Campus Directory ──
  String get campusDirectory => isTr ? 'Kampüs Rehberi' : 'Campus Directory';
  String get searchBusiness => isTr ? 'İşletme Ara...' : 'Search business...';
  String get all => isTr ? 'Tümü' : 'All';
  String get cafe => isTr ? 'Kafe' : 'Cafe';
  String get restaurant => isTr ? 'Restoran' : 'Restaurant';
  String get market => isTr ? 'Market' : 'Market';
  String get service => isTr ? 'Hizmet' : 'Service';
  String get open => isTr ? 'Açık' : 'Open';
  String get closed => isTr ? 'Kapalı' : 'Closed';
  String get noBusinessFound => isTr ? 'İşletme bulunamadı' : 'No business found';
  String get onlyOpenOnes => isTr ? 'Sadece açık olanlar' : 'Only open ones';

  // ── Cafeteria ──
  String get cafeteriaMenu => isTr ? 'Yemekhane Menüsü' : 'Cafeteria Menu';
  String get noMenuYet => isTr ? 'Menü henüz eklenmedi' : 'No menu added yet';
  String get today => isTr ? 'Bugün' : 'Today';
  String get soup => isTr ? 'Çorba' : 'Soup';
  String get mainCourseName => isTr ? 'Ana Yemek' : 'Main Course';
  String get sideDish => isTr ? 'Yan Yemek' : 'Side Dish';
  String get extra => isTr ? 'Ekstra' : 'Extra';

  // ── Transportation ──
  String get transportationTitle =>
      isTr ? 'Ulaşım Servisleri' : 'Transportation Services';
  String get semesterSchedule =>
      isTr ? 'Güz, İlkbahar ve Yaz Okulu' : 'Fall, Spring & Summer School';
  String get holidaySchedule =>
      isTr ? 'Şubat, Yaz ve Resmi Tatiller' : 'Feb, Summer & Holidays';
  String get campusToTerminal =>
      isTr ? 'ODTÜ KKK → Terminal' : 'METU NCC → Terminal';
  String get terminalToCampus =>
      isTr ? 'Terminal → ODTÜ KKK' : 'Terminal → METU NCC';

  // ── This Week ──
  String get thisWeekTitle =>
      isTr ? 'Kampüste Bu Hafta' : 'This Week on Campus';
  String get noEvents =>
      isTr ? 'Bu hafta etkinlik bulunmuyor' : 'No events this week';

  // ── Confessions ──
  String get confessionsTitle => isTr ? 'İtiraflar' : 'Confessions';
  String get writeConfession =>
      isTr ? 'İtirafını yaz...' : 'Write your confession...';
  String get postAnonymously =>
      isTr ? 'Anonim Paylaş' : 'Post Anonymously';
  String get anonymous => isTr ? 'Anonim' : 'Anonymous';
  String get noConfessions =>
      isTr ? 'Henüz itiraf yok' : 'No confessions yet';
  String get confessionHint =>
      isTr ? 'İlk itirafı sen paylaş!' : 'Be the first to confess!';
  String get like => isTr ? 'Beğen' : 'Like';
  String get report => isTr ? 'Şikayet Et' : 'Report';
  String get confessionEmpty =>
      isTr ? 'İtiraf boş olamaz' : 'Confession cannot be empty';

  // ── Marketplace ──
  String get marketplaceTitle => isTr ? 'İkinci El Pazar' : 'Marketplace';
  String get addListing => isTr ? 'İlan Ekle' : 'Add Listing';
  String get title => isTr ? 'Başlık' : 'Title';
  String get description => isTr ? 'Açıklama' : 'Description';
  String get price => isTr ? 'Fiyat' : 'Price';
  String get category => isTr ? 'Kategori' : 'Category';
  String get noListings =>
      isTr ? 'Henüz ilan yok' : 'No listings yet';
  String get listingHint =>
      isTr ? 'İlk ilanı sen ekle!' : 'Be the first to list!';
  String get books => isTr ? 'Kitap' : 'Books';
  String get electronics => isTr ? 'Elektronik' : 'Electronics';
  String get clothing => isTr ? 'Giyim' : 'Clothing';
  String get furniture => isTr ? 'Mobilya' : 'Furniture';
  String get other => isTr ? 'Diğer' : 'Other';
  String get contact => isTr ? 'İletişim' : 'Contact';
  String get sold => isTr ? 'Satıldı' : 'Sold';
  String get forSale => isTr ? 'Satılık' : 'For Sale';
  String get tl => '₺';

  // ── Carpool ──
  String get carpoolTitle => isTr ? 'Araç Paylaşım' : 'Carpool';
  String get addRide => isTr ? 'Yolculuk Ekle' : 'Add Ride';
  String get from => isTr ? 'Nereden' : 'From';
  String get to => isTr ? 'Nereye' : 'To';
  String get date => isTr ? 'Tarih' : 'Date';
  String get time => isTr ? 'Saat' : 'Time';
  String get seats => isTr ? 'Koltuk' : 'Seats';
  String get noRides =>
      isTr ? 'Henüz yolculuk yok' : 'No rides yet';
  String get rideHint =>
      isTr ? 'İlk yolculuğu sen paylaş!' : 'Share the first ride!';
  String get availableSeats => isTr ? 'Boş Koltuk' : 'Available Seats';
  String get join => isTr ? 'Katıl' : 'Join';
  String get full => isTr ? 'Dolu' : 'Full';
  String get note => isTr ? 'Not' : 'Note';

  // ── Auth ──
  String get login => isTr ? 'Giriş Yap' : 'Log In';
  String get register => isTr ? 'Kayıt Ol' : 'Sign Up';
  String get email => isTr ? 'E-posta' : 'Email';
  String get password => isTr ? 'Şifre' : 'Password';
  String get name => isTr ? 'Ad Soyad' : 'Full Name';
  String get continueAsGuest =>
      isTr ? 'Misafir olarak devam et' : 'Continue as Guest';
  String get noAccount =>
      isTr ? 'Hesabın yok mu? ' : 'Don\'t have an account? ';
  String get haveAccount =>
      isTr ? 'Hesabın var mı? ' : 'Already have an account? ';
  String get eduWarning =>
      isTr ? 'Sadece .edu.tr uzantılı e-postalar kabul edilir' : 'Only .edu.tr emails are accepted';
  String get logout => isTr ? 'Çıkış Yap' : 'Log Out';

  // ── Profile ──
  String get profile => isTr ? 'Profil' : 'Profile';
  String get settings => isTr ? 'Ayarlar' : 'Settings';
  String get language => isTr ? 'Dil' : 'Language';
  String get turkish => isTr ? 'Türkçe' : 'Turkish';
  String get english => isTr ? 'İngilizce' : 'English';
  String get showAds => isTr ? 'Reklamları Göster' : 'Show Ads';
  String get guest => isTr ? 'Misafir' : 'Guest';

  // ── Splash / Welcome ──
  String get welcomeTitle =>
      isTr ? 'NCC Campus' : 'NCC Campus';
  String get welcomeDesc =>
      isTr
          ? 'ODTÜ Kuzey Kıbrıs Kampüsü için her şey tek uygulamada'
          : 'Everything for METU NCC Campus in one app';
  String get getStarted => isTr ? 'Başla' : 'Get Started';

  // ── Reviews ──
  String get reviews => isTr ? 'Değerlendirmeler' : 'Reviews';
  String get writeReview => isTr ? 'Değerlendirme Yaz' : 'Write a Review';
  String get noReviews =>
      isTr ? 'Henüz değerlendirme yok' : 'No reviews yet';

  // ── Admin ──
  String get adminDashboard => isTr ? 'Admin Panel' : 'Admin Dashboard';
  String get users => isTr ? 'Kullanıcılar' : 'Users';
  String get manageBusinesses => isTr ? 'İşletme Yönetimi' : 'Manage Businesses';
  String get manageAnnouncements => isTr ? 'Duyuru Yönetimi' : 'Manage Announcements';
  String get manageCafeteria => isTr ? 'Yemekhane Yönetimi' : 'Manage Cafeteria';
  String get manageRing => isTr ? 'Ring Yönetimi' : 'Ring Schedule';
  String get manageReviews => isTr ? 'Değerlendirme Yönetimi' : 'Manage Reviews';

  // ── Misc ──
  String get cancel => isTr ? 'İptal' : 'Cancel';
  String get save => isTr ? 'Kaydet' : 'Save';
  String get delete => isTr ? 'Sil' : 'Delete';
  String get edit => isTr ? 'Düzenle' : 'Edit';
  String get search => isTr ? 'Ara' : 'Search';
  String get loading => isTr ? 'Yükleniyor...' : 'Loading...';
  String get error => isTr ? 'Hata' : 'Error';
  String get success => isTr ? 'Başarılı' : 'Success';
  String get loginRequired =>
      isTr ? 'Bu özellik için giriş yapmalısınız' : 'Login required for this feature';
  String get aiAssistant => isTr ? 'AI Ders Yardımcısı' : 'AI Study Assistant';
  String get aiAssistantSub => isTr ? 'Akıllı ders önerileri' : 'Smart course recommendations';
  String get campusMap => isTr ? 'Kampüs Haritası' : 'Campus Map';
  String get campusMapSub => isTr ? 'İnteraktif kampüs rehberi' : 'Interactive campus guide';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['tr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
