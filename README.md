# REC Center – Flutter Interview Project

Welcome! This lightweight repo is your take-home assignment. It lets you
show how you handle state-management (Riverpod), build responsive UI, write
clean tests, and work with GitHub Actions.

---

## 🏆 Goal

Implement a **centralised Home Feed** powered by Riverpod and wire it into the
simple Home Screen provided here. When you are done **all tests must pass**
and the Home page must render fetched data in the browser.

### You will build / complete

1. **`HomeFeedNotifier.load()`** – fetch a list of `Event` & `News` objects
   (mock list, REST call, Firebase – your choice).
2. **`home_screen_assignment.dart`** – make the screen react to the notifier’s
   states (loading / ready / error) and render the data.
3. Ensure `flutter analyze` is clean (zero warnings).
4. Make all tests in `/test` green (`flutter test`).

### Bonus (nice-to-have)

- Dark-mode toggle via Provider.
- ≥600-px wide displays switch to a grid layout for events.
- Persist fetched data with `shared_preferences`.

The rubric gives extra credit for these but they’re optional.

---

## 📥 How you get your copy

This repo is marked as a **template**. Your hiring contact will send you a
link that opens _Create a new repository from this template_.

1. Click **Use this template** → choose **Private** → create your repo.
2. GitHub sets the **creation time** of that repo; the 3-hour timer (see below)
   starts from this moment.
3. You will be added as a collaborator so you can push branches & open PRs.

_You will not see other candidates’ solutions, and they cannot see yours._

---

## 🚀 Quick-start

```bash
# clone YOUR fork
git clone <your-fork-url>
cd rec_center_interview

# install deps
flutter pub get

# run the (failing) tests
flutter test

# start the app in a browser
flutter run -d chrome        # or: flutter run -d ios
```

Once the notifier & screen are implemented the app will hot-reload and the
tests will turn green.

---

## 📑 Running & editing

- **Hot-reload**: while `flutter run` is active press `r`.
- **Analyzer**: `flutter analyze --no-pub` – should stay clean.
- **Device list**: `flutter devices` to see Chrome / iOS simulator / macOS.

---

## ✅ CI & submission

When you are happy with your solution **push** it and open a **Pull-Request**
against `main` in _your fork_ of this repository.

GitHub Actions will run; the PR passes only if **all of these are true**:

1. **Analyzer clean** – `flutter analyze` reports no issues.
2. **Time-limit respected** – the fork is < **3 hours** old (checked in CI).
3. **Tests:** at least **13 tests pass** (out of the baseline **14** shown
   below). One failing test is tolerated so you can leave a stretch goal until
   later, but ≥13 must be green.

A green check ✓ on your PR means you satisfied the automatic gate; a reviewer
will then look at code quality, UX polish, and bonus completion.

---

## ⏱️ Time limit

You have **3 hours** from the moment you forked the repo. The CI step reads
`github.event.pull_request.head.repo.created_at`; if more than 3 hours have
elapsed, the build fails with a helpful message.

Pro tip: finish locally first, then fork → push → PR only when ready; you’ll
have the full 3-hour window.

---

## 🧾 Rubric (internal)

| Item                                        | Points |
| ------------------------------------------- | ------ |
| At least 13/14 tests green & analyzer clean | 40     |
| Clean, idiomatic Riverpod / Flutter         | 25     |
| Correct UI states handled                   | 15     |
| Design polish / responsiveness              | 10     |
| Bonus goals (dark-mode, grid, persistence)  | 10     |

---

## 📚 Need help?

- Flutter docs – <https://docs.flutter.dev/>
- Riverpod docs – <https://riverpod.dev/>
- Ask clarifying questions in your PR description if needed.

Happy coding 🚀

## 🧪 Test suites you must satisfy

The repo ships with **14 guidance tests** (01–14). CI requires that at least
**13 tests pass** – one failure is allowed so you can skip a stretch test if
you run out of time.

| File                                   | Purpose (inline hints in each file)                       |
| -------------------------------------- | --------------------------------------------------------- |
| 01 `event_model_test.dart`             | `isFull`, `copyWith`, JSON round-trip                     |
| 02 `home_feed_notifier_test.dart`      | Default state: `isLoading == true`                        |
| 03 `notifier_crud_test.dart`           | add/update/delete Event & News + cascade                  |
| 04 `event_attendee_test.dart`          | Attendee counter obeys capacity                           |
| 05 `widgets/event_card_test.dart`      | EventCard renders title, location, capacity               |
| 06 `widgets/news_card_test.dart`       | NewsCard renders title, category without ProviderScope    |
| 07 `home_screen_error_test.dart`       | Error banner + Retry button                               |
| 08 `home_screen_integration_test.dart` | Spinner → list transition, headers & cards                |
| 09 `home_screen_refresh_test.dart`     | Pull-to-refresh calls `load()` again                      |
| 10 `settings_notifier_test.dart`       | Text scale, seed color reflected in UI                    |
| 11 `font_family_lato_test.dart`        | Selecting “Lato” updates ThemeData.fontFamily             |
| 12 `remote_api_integration_test.dart`  | addEvent/addNews must hit RemoteApi.create\*              |
| 13 `event_delete_cascade_test.dart`    | deleteEvent cascades to news & hits RemoteApi.deleteEvent |
| 14 `news_update_api_test.dart`         | updateNews updates state & calls RemoteApi.updateNews     |

These new red tests act as a roadmap – read the **reason:** messages attached to each `expect()` for extra hints. Turn the suite green to complete the assignment.

# Run the full suite at any time with:

```bash
# (goldens not used but handy)
flutter test
```
