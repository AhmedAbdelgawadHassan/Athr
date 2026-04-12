<div align="center">

<h1>أثر · Athr</h1>

<p><em>صدقة جارية على روح من أحببت</em></p>

<p>
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat&logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=flat&logo=dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=flat" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat" />
</p>

</div>

---

## About

**Athr (أثر)** is a calm, feature-rich Islamic mobile app built with Flutter — dedicated as an ongoing charity (*Sadaqa Jariya*) for the souls of loved ones who have passed away.

> *"When a person dies, his deeds come to an end except for three: Sadaqa Jariya, knowledge which is beneficial, or a virtuous child who prays for him."*
> — Sahih Muslim

---

## Features

### 📖 Quran
- Full Mushaf with Uthmani script
- Audio recitation with multiple reciters
- Ayah-by-ayah Tafsir (Ibn Kathir / Al-Saadi)
- Bookmarks & last-read position saved
- Full-text search across the Quran
- Quran completion plan tracker

### 📿 Adhkar & Duas
- Morning, evening, sleep & post-prayer Adhkar
- Digital Tasbih counter with haptic feedback
- 99+ duas for every occasion (travel, eating, healing…)
- Favourites list & sharing as beautiful cards
- Reminder notifications for Adhkar times

### 🕌 Prayer & Worship
- Accurate prayer times via GPS or city
- Adhan with multiple voice options
- Daily prayer tracker (mark prayed / missed)
- Qibla compass
- Fasting tracker (Ramadan + recommended days)
- Weekly & monthly worship statistics

### 📚 Islamic Content
- Ayah of the Day + Hadith of the Day
- Articles in Fiqh, Seerah & Tazkiyah
- 99 Names of Allah with meanings
- Hijri calendar with Islamic occasions highlighted

### ⚙️ Experience
- Dark navy UI — easy on the eyes
- Adjustable font size (great for all ages)
- Full offline support
- Home screen widget (Ayah of the Day / next prayer)
- RTL Arabic-first interface
- Do-not-disturb mode (keeps Adhan active)

---

## Screenshots

> Coming soon.

---

## Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / Xcode

### Installation

```bash
# Clone the repo
git clone https://github.com/your-username/athr.git

# Navigate to project
cd athr

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter / Dart |
| State Management | Bloc |
| Local Storage | Hive |
| Audio | just_audio |
| Prayer Times | adhan-dart |
| Quran Data | quran package |
| Compass | flutter_compass |
| Notifications | flutter_local_notifications |

---

## Project Structure

```
lib/
├── core/           # Theme, constants, utilities
├── features/
│   ├── quran/
│   ├── adhkar/
│   ├── prayer/
│   ├── qibla/
│   ├── articles/
│   └── settings/
└── shared/         # Widgets, models, services
```

---

## Contributing

Contributions are welcome. Please open an issue first to discuss what you'd like to change.

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

<div align="center">

*اللهم اجعله صدقة جارية تنفع أرواح من أحببنا*

Made with 🤍 as a Sadaqa Jariya

</div>