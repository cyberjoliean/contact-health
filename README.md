# Contact Health

`Contact Health` — мобильное приложение для анализа, очистки и резервного копирования контактной книги.

> В текущем репозитории находится стартовый Flutter-каркас (domain/data/presentation) и пример экрана Dashboard.

## Требования для сборки Android

- Flutter SDK `>=3.22.0`
- Dart SDK (в составе Flutter)
- Android Studio (последняя стабильная)
- Android SDK Platform 34+
- Android SDK Build-Tools
- JDK 17
- Устройство Android или эмулятор

Проверка окружения:

```bash
flutter doctor -v
```

Исправьте все ошибки из раздела Android Toolchain перед сборкой.

## Как подготовить проект к Android-сборке

Сейчас в репозитории нет полного Flutter bootstrap (`pubspec.yaml`, `android/`, и т.д.).

1. Создайте Flutter-проект в текущей папке (или рядом) и перенесите текущий `lib/`:

```bash
flutter create .
```

2. Установите зависимости:

```bash
flutter pub add flutter_contacts
flutter pub add http
flutter pub add path_provider
```

3. Для Android добавьте permissions в `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.WRITE_CONTACTS" />
<uses-permission android:name="android.permission.INTERNET" />
```

> `READ_CONTACTS` обязателен для анализа; `INTERNET` — для Telegram backup.

## Debug-сборка Android (APK)

```bash
flutter clean
flutter pub get
flutter build apk --debug
```

Готовый файл:

- `build/app/outputs/flutter-apk/app-debug.apk`

## Release-сборка Android (APK)

```bash
flutter clean
flutter pub get
flutter build apk --release
```

Готовый файл:

- `build/app/outputs/flutter-apk/app-release.apk`

## Release-сборка Android App Bundle (Google Play)

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

Готовый файл:

- `build/app/outputs/bundle/release/app-release.aab`

## Подпись release-сборки

1. Создайте keystore:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Создайте `android/key.properties`:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=<path-to-keystore>/upload-keystore.jks
```

3. Подключите подпись в `android/app/build.gradle` (если не настроено).

## Установка APK на устройство

```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

## Частые проблемы

- **`flutter: command not found`**
  - Flutter не установлен или не добавлен в `PATH`.
- **Gradle/JDK mismatch**
  - Используйте JDK 17 и совместимую версию Gradle/Android Gradle Plugin.
- **Permission denied for contacts**
  - Проверьте runtime permission в приложении и `AndroidManifest.xml`.

## Быстрый чек перед релизом

- [ ] Контакты читаются только после явного разрешения пользователя.
- [ ] Экспорт в Telegram запускается только после подтверждения пользователя.
- [ ] Локальная аналитика работает без отправки данных на сервер.
- [ ] Успешная сборка `apk --release` и `appbundle --release`.
