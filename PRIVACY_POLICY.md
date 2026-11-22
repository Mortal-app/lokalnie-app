# Polityka prywatności — Lokalnie

Aplikacja **Lokalnie** (`pl.patryk.lokalnie`) to tablica ogłoszeń sąsiedzkich.
Nie sprzedajemy danych i nie prowadzimy reklamowej analityki.

## Jakie dane przetwarzamy

### Na urządzeniu (SharedPreferences)
- nazwa profilu, ustawienia motywu i języka
- kopia ogłoszeń, ulubione, historia czatów
- szkice formularzy i flagi bezpieczeństwa treści

Te dane znikają po odinstalowaniu aplikacji albo po wyczyszczeniu danych w ustawieniach.

### Firebase Auth
- anonimowy identyfikator sesji (`uid`)
- służy do rozpoznania Twoich ogłoszeń i uprawnień zapisu

### Cloud Firestore
- ogłoszenia i zgłoszenia usterki (tytuł, kategoria, opis, lokalizacja tekstowa, opcjonalne współrzędne GPS)
- opcjonalna miniaturka zdjęcia (skompresowana, Base64, poniżej 150 KB) w polu dokumentu ogłoszenia
- zgłoszenia nieodpowiednich treści (`content_reports`)
- token FCM urządzenia w dokumencie `users/{uid}`

### Firebase Cloud Messaging (FCM)
- token urządzenia, aby dostarczać powiadomienia z okolicy
- otwarcie powiadomienia może przenieść do ogłoszenia (`announcementId`) albo zakładki (`route`)

### Lokalizacja i aparat
- GPS jest opcjonalny (szybkie zgłoszenie)
- zdjęcie jest opcjonalne; bez zgody systemu nie jest pobierane

## Twoje prawa i usuwanie danych

- własne ogłoszenia: edycja i usunięcie w **Profil → Moje ogłoszenia** oraz w szczegółach wpisu
- zgłoszenie cudzej treści: przycisk **Zgłoś treść** / **Zgłoś nadużycie**
- kopia lokalna: Ustawienia → wyczyszczenie pamięci aplikacji albo odinstalowanie

Kontakt: administracja@lokalniewidzew.app

## Publiczny link do Google Play (HTML)

Gotowa strona: [`docs/privacy-policy.html`](docs/privacy-policy.html).
Google Play Console wymaga publicznego URL-a https (nie pliku z dysku).

### GitHub Pages (ok. 3 minuty, za darmo)

1. Utwórz publiczne repozytorium na GitHubie (albo użyj istniejącego).
2. Wgraj `docs/privacy-policy.html` do folderu `docs/` (możesz zmienić nazwę na `index.html` w `docs/`, jeśli chcesz najkrótszy adres).
3. W repozytorium: **Settings → Pages → Build and deployment**.
4. Source: **Deploy from a branch**, branch `main`, folder `/docs`.
5. Po chwili adres będzie wyglądał tak:
   `https://<twoj-nick>.github.io/<nazwa-repo>/privacy-policy.html`
   (albo bez nazwy pliku, jeśli wgrałeś `docs/index.html`).
6. Ten URL wklejasz w Play Console jako **Privacy policy**.

### Inny darmowy hosting statyczny

Możesz wrzucić ten sam plik HTML na Cloudflare Pages, Netlify albo Firebase Hosting (plan Spark). Wystarczy jeden plik `.html` i https.
