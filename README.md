# Dishcovery 🍽️

Aplikacja mobilna na zaliczenie przedmiotu **Tworzenie Aplikacji Mobilnych** (Flutter).

## Opis

Dishcovery pozwala przeglądać przepisy kulinarne z całego świata przy użyciu
bezpłatnego API [TheMealDB](https://www.themealdb.com/).
Aplikacja działa również **offline** — ulubione przepisy są zapisywane lokalnie.

## Funkcjonalności

- 📋 Przeglądanie kategorii posiłków
- 🍗 Lista posiłków w wybranej kategorii
- 📖 Szczegóły przepisu (składniki, instrukcja)
- ❤️ Ulubione — zapis lokalny, dostępne bez internetu
- 🔍 Wyszukiwarka przepisów po nazwie
- 🔄 Manualne odświeżenie danych (pull-to-refresh)

## Technologie

| Warstwa | Technologia |
|---------|-------------|
| Framework | Flutter |
| REST API | TheMealDB |
| Analityka | Firebase Analytics |
| Raporty błędów | Firebase Crashlytics |

## Firebase Events

| Nazwa eventu | Kiedy |
|---|---|
| `category_selected` | Kliknięcie kategorii |
| `meal_viewed` | Wejście w szczegóły przepisu |
| `favorite_toggled` | Dodanie / usunięcie z ulubionych |