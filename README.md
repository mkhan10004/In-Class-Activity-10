# Campus Crew — Flutter Signup Form Quest

**Course:** CSC 4360 — Mobile Application Development  
**Activity:** In-Class Activity 10  
**Track:** Undergraduate  
**Required task:** Task A — AI Signup Coach

## Student

**Name:** Muhammad Samad Khan  


## Work and Evidence

I ran the app and captured screenshots of the form validation, successful signup,
and the mock Signup Coach's success and failure states. My screenshots document
empty-field errors, invalid email, a short password, successful submission,
a successful mock tip, simulated offline failure, malformed JSON, empty output,
HTTP 503, and a timeout error.

The source code and this README were generated with ChatGPT assistance. This
record distinguishes my demonstrated testing from independent code authorship;
it does not claim that I personally wrote every part of the generated code.

## Overview

Campus Crew is a themed Flutter signup demonstration for a pretend campus club.
It includes a name, email, and password form, local input validation, a green
success message, and a signup-tip feature. It does not create or store accounts.
The undergraduate version requires the core form and Task A; Tasks B and C are
not required.

## Features

- Required name; whitespace-only names are rejected.
- Basic email-format validation.
- Hidden password with the assignment's six-character minimum.
- Green success SnackBar only when every field passes validation.
- Purple Campus Crew theme and a scrollable layout.
- Signup Coach with loading, result, friendly error, and retry states.
- Ten-second request timeout and handling for non-200, invalid JSON, and empty tips.
- Advice shown as plain text, trimmed to a maximum of 240 Unicode code points.
- Explicitly labeled deterministic mock for permitted fallback testing.
- Text controllers and the HTTP client are disposed when the page closes.

## Setup

Open a terminal inside the extracted `signup_app` folder. Flutter, Android tools,
Python 3, and an Android device/emulator must be available.

```powershell
flutter doctor
flutter devices
python tool/bootstrap.py
```

On Windows, use `py tool/bootstrap.py` if needed. Bootstrap generates Android
platform files using the installed Flutter SDK, adds Internet permission to the
main manifest, and downloads dependencies. If the project has already been set
up, use `flutter pub get` to refresh dependencies.

## Run the App

### Instructor service

Use the instructor-provided HTTPS endpoint when available. Replace
`INSTRUCTOR_HTTPS_ENDPOINT` with the exact URL, including its route.

```powershell
flutter run --dart-define=AI_PROXY_URL=INSTRUCTOR_HTTPS_ENDPOINT
```

This reference sends JSON and Accept headers only. Follow the instructor's
access instructions if additional course-specific access is required. Never put
provider API keys in the Flutter app, build arguments, URLs, or repository.

### Documented mock fallback

Use this mode only when the instructor service is unavailable:

```powershell
flutter run --dart-define=USE_MOCK=true
```

The app displays **MOCK AI ADVICE — deterministic example; no live model called**.
Its scenario selector provides success, offline failure, malformed JSON, empty
tip, timeout, and HTTP 503 responses. Mock mode does not make a network request.
The same service interface and response-handling logic are used in both modes.

**Mode shown in evidence:** Deterministic mock; no live model called.  
**If mock: actual reason the instructor service was unavailable:** [Complete.]  
**Date confirmed:** [Complete.]

Missing the URL in the assignment attachment alone is not proof that the course
service is unavailable. With neither setting supplied, the app shows a
configuration message and disables the tip action. A supplied live URL takes
precedence over the mock setting.

## Request, Response, and Privacy

The live service sends an HTTPS POST with exactly this JSON body:

```json
{"task":"signup_tip","topic":"password_help"}
```

The expected HTTP 200 response is:

```json
{"tip":"A non-empty signup suggestion."}
```

Names, emails, passwords, and other form values are not passed to the tip
service. The request method accepts no form values. Advice is displayed with a
Flutter `Text` widget, without HTML or Markdown interpretation. Local validators
alone decide whether the form passes; a successful AI response cannot approve
invalid input, and a failed AI request cannot block a valid form.

## Source Files

| File | Purpose |
|---|---|
| `lib/main.dart` | App theme, form, success feedback, and coach UI states |
| `lib/validation/signup_validators.dart` | Local name, email, and password rules |
| `lib/services/signup_tip_service.dart` | HTTPS request, response parsing, timeout, and mock |
| `test/signup_validators_test.dart` | Input validation tests |
| `test/signup_tip_service_test.dart` | Request privacy, response handling, and failure tests |
| `test/signup_widget_test.dart` | Form and mock coach UI tests |
| `tool/bootstrap.py` | Android setup and Internet permission |
| `docs/TEST_CHECKLIST.md` | Detailed manual test checklist |

## Testing

```powershell
dart format lib test
flutter analyze
flutter test --dart-define=USE_MOCK=true
```

I tested the app in deterministic mock mode. The following results are visible
in my supplied screenshots. Password contents are masked, so the exact test
passwords are not recorded here.

| Test | Observed result | Screenshot |
|---|---|---|
| Empty name, email, and password | Required error shown for all three fields | `Screenshot 2026-10-26 185647(1).png` |
| Email without @ | “Please enter a valid email” | `Screenshot 2026-10-26 185707(1).png` |
| Password shorter than six characters | Minimum-six-character error | `Screenshot 2026-10-26 185727(1).png` |
| Valid form submission | Green “Demo signup complete” SnackBar | `Screenshot 2026-10-26 185739(1).png` |
| Successful mock response | Plain-text signup tip with explicit mock label | `Screenshot 2026-10-26 185811(1).png` |
| Simulated offline failure | Friendly connection error and Retry button | `Screenshot 2026-10-26 185922(1).png` |
| Malformed JSON | “The service returned an invalid tip. Please retry.” | `Screenshot 2026-10-26 190419.png` |
| Empty tip | “The service returned an empty tip. Please retry.” | `Screenshot 2026-10-26 190435.png` |
| HTTP 503 | “The tip service is unavailable. Please retry.” and Retry button | `Screenshot 2026-10-26 190510.png` |
| Timeout scenario | “The tip request timed out. Please retry.” | `Screenshot 2026-10-26 190530.png` |

**Evidence date:** October 26, 2026 (if the screenshots were actually captured that day).  
**Device/emulator:** None; the app was run in Chrome, not on an Android device or emulator.  
**Flutter version:** Flutter 3.47.2 (stable); Dart 3.13.2.  

The timeout screenshot confirms the displayed error, but does not measure the
elapsed time. Loading animation, successful retry after failure, live endpoint
connectivity, and APK build/install status are not established by these still
images. Add the screenshot files to the repository to make this evidence
available alongside the README; this document does not embed their image bytes.

Airplane mode does not affect the deterministic mock. Select its Offline failure
scenario for mock evidence; use actual network disconnection when testing live
mode. Capture only dummy data and keep the mock label visible in mock evidence.

## Undergraduate Reflection — Two Questions


### Question 1: Trace the AI tip feature from button tap to displayed text. Which widget/state changes while waiting, and how does the user recover if it fails?

In my app, tapping “Get a signup tip” calls `_getTip()`, which clears the previous
result and sets `_loading` to true while the service request runs. The UI disables
the tip button and shows a progress indicator, then displays the returned tip as
plain text after a successful response. On failure, it displays a friendly error
and a Retry button that calls the same request method again.

### Question 3: Name the exact information your request sends and one piece of information it deliberately does not send. Why?

The live request contains only `{"task":"signup_tip","topic":"password_help"}`,
not the values entered into the form. It leaves out the password, name, and email
because a general signup tip does not require personal information. My screenshots
show mock mode, where no network request or live model call occurs.

### Limitation and Trade-off

My mock tests make response failures easy to reproduce, but they do not show how
a real instructor service behaves or whether live AI tips are consistently
useful. Plain-text rendering and the 240-character limit constrain presentation,
but do not guarantee accurate advice. A useful next step is to test the approved
live service when available and record response quality, latency, and failures.

## Build and Submit the APK

For the instructor service:

```powershell
flutter build apk --release --dart-define=AI_PROXY_URL=INSTRUCTOR_HTTPS_ENDPOINT
```

For an allowed mock fallback:

```powershell
flutter build apk --release --dart-define=USE_MOCK=true
```

Release APK: `build/app/outputs/flutter-apk/app-release.apk`.

