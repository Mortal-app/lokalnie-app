# Polityka prywatności — Lokalnie

Aplikacja **Lokalnie** (`pl.patryk.lokalnie`) to tablica ogłoszeń sąsiedzkich.
Nie sprzedajemy danych, nie prowadzimy reklamowej analityki i nie zbieramy
numerów kart płatniczych.

Ostatnia aktualizacja: 22 listopada 2026.

## Jakie dane przetwarzamy

### Na urządzeniu (SharedPreferences)
- nazwa profilu, ustawienia motywu, języka i powiadomień
- kopia ogłoszeń, ulubione i historia wyszukiwania
- szkice formularzy (dodawanie ogłoszenia, szybkie zgłoszenie)
- historia wiadomości sąsiedzkich i notatek głosowych — lokalnie, nie w chmurze
- lokalny status konta Fachowca PRO oraz flagi bezpieczeństwa treści

Te dane znikają po odinstalowaniu aplikacji albo po wyczyszczeniu danych
w ustawieniach systemu / w Ustawieniach aplikacji (pamięć podręczna).

### Firebase Auth
- anonimowy identyfikator sesji (`uid`), bez adresu e-mail i hasła
- służy do rozpoznania Twoich ogłoszeń, zgłoszeń treści i uprawnień zapisu

### Cloud Firestore
- ogłoszenia i zgłoszenia usterki (tytuł, kategoria, opis, lokalizacja tekstowa, opcjonalne współrzędne GPS, status aktualne/zakończone, identyfikator autora)
- opcjonalna miniaturka zdjęcia (skompresowana, Base64, poniżej 150 KB) w polu dokumentu ogłoszenia — bez płatnego Firebase Storage
- zgłoszenia nieodpowiednich treści (`content_reports`)
- dokument `users/{uid}`: token FCM urządzenia oraz status subskrypcji `isPro` (identyfikator produktu `lokalnie_pro_monthly` i data ważności, jeśli dotyczy)

Wiadomości czatu sąsiedzkiego **nie** są zapisywane w Firestore — zostają na urządzeniu.

### Firebase Cloud Messaging (FCM)
- token urządzenia, aby dostarczać powiadomienia z okolicy
- otwarcie powiadomienia może przenieść do ogłoszenia (`announcementId`) albo zakładki (`route`)
- powiadomienia można wyłączyć w Profilu

### Lokalizacja, aparat i mikrofon
- GPS jest opcjonalny (szybkie zgłoszenie). Bez zgody systemu nie pobieramy pozycji. Brak GPS nie podstawia dzielnicy — wpis może zostać jako „Twoja okolica”.
- zdjęcie z aparatu lub galerii jest opcjonalne; miniaturka trafia do ogłoszenia tylko jeśli je dodasz
- mikrofon służy wyłącznie do opcjonalnej notatki głosowej w czacie i nie wysyłamy jej do Firebase

### Google Play Billing (Konto PRO)
- subskrypcja `lokalnie_pro_monthly` jest rozliczana przez oficjalny Google Play Billing (`in_app_purchase`)
- aplikacja **nie zbiera i nie przechowuje danych kart płatniczych** — płatność obsługuje Google Play
- po zakupie zapisujemy tylko uprawnienie `isPro` (lokalnie i w `users/{uid}`), żeby odblokować katalog fachowca

### Podmioty przetwarzające i czego nie zbieramy
- Google (Firebase Auth, Firestore, FCM oraz Play Billing) przetwarza dane w imieniu aplikacji, aby tablica, powiadomienia i zakupy działały
- nie sprzedajemy danych, nie włączamy reklamowej analityki ani identyfikatorów reklamowych
- nie wymagamy konta Google do przeglądania tablicy — sesja Auth jest anonimowa

## Twoje prawa, RODO i usuwanie danych

- własne ogłoszenia: edycja, oznaczenie jako zakończone i usunięcie w **Profil → Moje ogłoszenia** oraz w szczegółach wpisu
- zgłoszenie cudzej treści: przycisk **Zgłoś treść** / **Zgłoś nadużycie**
- kopia lokalna: Ustawienia → wyczyszczenie pamięci aplikacji albo odinstalowanie
- w sprawach danych osobowych (wgląd, sprostowanie, usunięcie, RODO) napisz na adres poniżej — to kontakt twórcy aplikacji Lokalnie

Administrator danych: twórca aplikacji Lokalnie (`pl.patryk.lokalnie`).
Kontakt RODO / dane osobowe: sfgame1818@gmail.com

## Publiczny link do Google Play (HTML)

Gotowa strona: [`docs/privacy-policy.html`](docs/privacy-policy.html).
Google Play Console wymaga publicznego URL-a https (nie pliku z dysku).

Aktualny adres GitHub Pages:

`https://mortal-app.github.io/lokalnie-app/privacy-policy.html`

### GitHub Pages

1. Repozytorium: [Mortal-app/lokalnie-app](https://github.com/Mortal-app/lokalnie-app).
2. Plik: `docs/privacy-policy.html`.
3. W repozytorium: **Settings → Pages → Build and deployment**.
4. Source: **Deploy from a branch**, branch `main`, folder `/docs`.
5. Ten URL wklejasz w Play Console jako **Privacy policy**.
