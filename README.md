# Lokalnie

Tablica ogłoszeń sąsiedzkich.

## Testy

```bash
flutter test
```

## Reguły Firebase

- `firestore.rules` — odczyt/zapis dla `request.auth != null`, walidacja ogłoszeń (w tym opcjonalne `imageBase64`), zgłoszeń treści i tokenu FCM w `users/{uid}`

Wdrożenie: `firebase deploy --only firestore:rules --project lokalnie-bff8b`

## Prywatność

Zobacz `PRIVACY_POLICY.md` oraz ekran **Ustawienia → Polityka prywatności i regulamin**.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
