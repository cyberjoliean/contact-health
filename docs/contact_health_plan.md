# Contact Health — архитектура и продуктовый дизайн

## 1) Архитектура приложения

Рекомендуемая архитектура: **Clean Architecture + Feature-first**.

- **Presentation**: экраны, виджеты, стейт-менеджмент (Riverpod/BLoC).
- **Domain**: сущности (`ContactRecord`), use-case и логика расчёта `ContactHealthScore`.
- **Data**: работа с контактами устройства, локальной базой SQLite, экспортом в Telegram.

### Поток данных

1. Пользователь даёт разрешение на контакты.
2. `DeviceContactsService` читает контакты локально.
3. `ContactAnalyzer` считает метрики и дубликаты.
4. `ContactHealthScoreCalculator` считает индекс 0–100.
5. Результаты сохраняются в SQLite для истории и трендов.
6. При экспорте пользователь вручную подтверждает действие.
7. `TelegramBackupService` формирует JSON и отправляет файл в Bot API.

---

## 2) Структура проекта (Flutter)

```text
lib/
  app.dart
  main.dart

  core/
    constants/
    theme/
    utils/

  data/
    models/
      contact_record_dto.dart
    repositories/
      contacts_repository_impl.dart
    services/
      device_contacts_service.dart
      telegram_backup_service.dart
      local_database_service.dart

  domain/
    entities/
      contact_record.dart
      health_metrics.dart
    repositories/
      contacts_repository.dart
    services/
      contact_health_score_calculator.dart
      duplicate_detector.dart
    usecases/
      scan_contacts_usecase.dart
      export_contacts_usecase.dart

  presentation/
    screens/
      onboarding_screen.dart
      home_screen.dart
      analytics_screen.dart
      cleanup_screen.dart
      backup_screen.dart
      settings_screen.dart
    widgets/
      health_score_card.dart
      quick_actions.dart
      recommendation_tile.dart
```

---

## 3) Product/UX заметки

### Onboarding
- Объяснение ценности: «Найдите дубликаты и пустые контакты за 10 секунд».
- Явный запрос разрешения с объяснением, зачем доступ.

### Home (Dashboard)
- Большой круговой индикатор `Contact Health Score`.
- KPI-карточки: общее количество контактов, заполненность, дубликаты.
- Блок «Быстрые рекомендации» (до 3 действий).

### Analytics
- Breakdown по проблемам качества данных.
- График распределения контактов по странам.
- Тренд изменения score (если хранить историю).

### Cleanup
- Merge duplicates (с превью полей, которые будут объединены).
- Remove empty contacts.
- Fill suggestions (например, добавить email/photo для часто используемых).

### Backup / Export
- Поля `Bot Token` и `Chat ID`.
- Превью размера файла + время последнего бэкапа.
- Обязательное подтверждение перед отправкой.

### Settings
- Конфиденциальность, политика обработки данных.
- Переключатель: сохранять ли локальную историю аналитики.

---

## 4) Формула Contact Health Score (пример)

Итоговый балл 0–100 считается по штрафам:

- base = 100
- `missingNamePenalty = 20 * (missingName / total)`
- `missingPhonePenalty = 20 * (missingPhone / total)`
- `missingEmailPenalty = 10 * (missingEmail / total)`
- `missingPhotoPenalty = 10 * (missingPhoto / total)`
- `duplicatesPenalty = 25 * (duplicates / total)`
- `emptyContactsPenalty = 15 * (emptyContacts / total)`

`score = clamp(100 - sum(penalties), 0, 100)`

Где `emptyContacts` — записи без имени и без телефонов/email.
