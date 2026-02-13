# 🚕 Erzurum Taksi Sürücü Uygulaması

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart"/>
  <img src="https://img.shields.io/badge/SignalR-Realtime-512BD4?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge"/>
</p>

<p align="center">
  Erzurum Büyükşehir Belediyesi Taksi Sistemi'nin sürücü tarafı uygulaması.<br/>
  Gerçek zamanlı müşteri talep yönetimi, kolay giriş ve sade sürücü paneli.
</p>

---

## 📱 Ekranlar

| Ekran | Açıklama |
|-------|----------|
| 🔑 Giriş | Email & şifre ile sürücü girişi |
| 📝 Kayıt | Kişisel bilgi, araç bilgisi ve durak seçimi |
| ✅ Doğrulama | 6 haneli email doğrulama kodu |
| 🚖 Sürücü Paneli | Anlık istek alma, müsaitlik yönetimi |

---

## ✨ Özellikler

### 🟢 Sürücü Paneli
- **Müsaitlik Butonu** — Büyük dokunmatik butonla aktif/pasif geçiş
- **Canlı Bağlantı Durumu** — SignalR bağlantısı anlık gösterilir
- **Gelen İstek Popup'ı** — Tahmini kazanç, kabul/red seçeneği
- **Sefer Sayacı** — O günkü kabul edilen sefer sayısı
- **Karanlık / Açık Tema** — Tek dokunuşla tema değiştirme
- **Araç & Durak Bilgisi** — Plaka ve bağlı olunan durak görünümü

### 📡 Gerçek Zamanlı Sistem
- SignalR ile anlık müşteri talep bildirimi
- Başka sürücü alırsa otomatik popup kapanır (`RequestClosed`)
- Bağlantı kesilirse otomatik yeniden bağlanma (`withAutomaticReconnect`)

### 🔐 Kimlik Doğrulama
- Email & şifre ile güvenli giriş
- Kayıt sonrası 6 haneli email doğrulama
- `SharedPreferences` ile oturum kalıcılığı — uygulamayı kapatıp açınca tekrar giriş gerekmez

---

## 🛠️ Proje Yapısı

```
taxi_driver_app/
├── lib/
│   ├── main.dart                   # Uygulama girişi & SplashScreen
│   ├── models/
│   │   ├── driver.dart             # Sürücü modeli
│   │   └── taxi_request.dart       # Müşteri istek modeli
│   ├── screens/
│   │   ├── login_screen.dart       # Giriş ekranı
│   │   ├── signup_screen.dart      # Kayıt ekranı
│   │   ├── verification_screen.dart# Email doğrulama
│   │   └── dashboard_screen.dart   # Ana sürücü paneli
│   ├── services/
│   │   ├── auth_service.dart       # Login / Signup / Verify API
│   │   └── signalr_service.dart    # SignalR hub yönetimi
│   └── widgets/
│       ├── animated_button.dart    # Dokunma animasyonlu buton
│       └── glass_container.dart    # Glassmorphism kart bileşeni
```

---

## 📦 Kullanılan Paketler

| Paket | Amaç |
|-------|------|
| `signalr_netcore` | Gerçek zamanlı sürücü-müşteri iletişimi |
| `http` | REST API istekleri |
| `shared_preferences` | Oturum bilgisi saklama |
| `pin_code_fields` | 6 haneli doğrulama kodu girişi |
| `glassmorphism` | Cam efektli UI bileşenleri |

---

## 🔄 Uygulama Akışı

```
Uygulama Açılır
      │
      ▼
SplashScreen (2s)
      │
      ├── Kayıtlı sürücü var mı?
      │         │
      │    EVET ▼           HAYIR
      │   Dashboard ──────► LoginScreen
      │
LoginScreen
      │
      ├── Giriş başarılı ──► Dashboard
      └── Kayıt ol ────────► SignupScreen
                                  │
                                  ▼
                           VerificationScreen
                                  │
                                  ▼
                            LoginScreen
                                  │
                                  ▼
                            DashboardScreen
                                  │
                          ┌───────┴────────┐
                          │                │
                    Müsaitim          Meşgulüm
                     (Online)         (Offline)
                          │
                    Gelen İstek Popup
                          │
                    ┌─────┴──────┐
                    │            │
                  Kabul         Red
                    │
              Sürücü yola çıkar
```

---

## 🚀 Kurulum

### Gereksinimler
- Flutter 3.x
- Dart 3.x
- Android Studio veya VS Code

### Adımlar

```bash
# Repoyu klonla
git clone https://github.com/erzurum-bb/taxi-driver-app.git
cd taxi-driver-app

# Bağımlılıkları yükle
flutter pub get

# Çalıştır
flutter run
```

### Backend Bağlantısı

`lib/services/auth_service.dart` ve `lib/services/signalr_service.dart` dosyalarındaki URL'yi kendi sunucunla değiştir:

```dart
// auth_service.dart
static const String baseUrl = 'https://YOUR_SERVER/api/auth';

// signalr_service.dart
static const String hubUrl = 'https://YOUR_SERVER/taxiHub';
```

---

## 🔌 API Endpointleri

| Method | Endpoint | Açıklama |
|--------|----------|----------|
| `POST` | `/api/auth/signup` | Sürücü kaydı |
| `POST` | `/api/auth/verify` | Email doğrulama |
| `POST` | `/api/auth/login` | Sürücü girişi |

### SignalR Hub Metodları

| Metod | Yön | Açıklama |
|-------|-----|----------|
| `RegisterDriver` | Client → Server | Sürücü sisteme kayıt olur |
| `AcceptRequest` | Client → Server | İstek kabul edilir |
| `RejectRequest` | Client → Server | İstek reddedilir |
| `NewTaxiRequest` | Server → Client | Yeni müşteri isteği geldi |
| `RequestClosed` | Server → Client | İstek başkası tarafından alındı |
| `DriverRegistered` | Server → Client | Kayıt onayı |

---

## 🎨 Tema

Uygulama **dark/light** tema desteğine sahiptir. Sürücü panelinde sağ üstteki toggle ile anında değiştirilir.

| | Dark | Light |
|--|------|-------|
| Arkaplan | `#111111` | `#FFF8F0` |
| Kart | `#1C1C1E` | `#FFFFFF` |
| Vurgu | `#FF6F00` | `#FF6F00` |

---

