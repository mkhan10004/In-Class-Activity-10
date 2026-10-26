# Test checklist — record actual evidence

All device and Flutter test results are **NOT RUN** in this package.
Use dummy form data only, e.g. Demo Student / demo@example.com / demo123.

| ID | Action | Expected behavior | Actual result / evidence |
|---|---|---|---|
| T1 | Submit all fields empty | Three required-field errors; no success | Not run |
| T2 | Name contains only spaces | Name error | Not run |
| T3 | Email `student` or `a@` | Email error; no success | Not run |
| T4 | Password `12345` | Minimum-six-character error | Not run |
| T5 | Demo Student, demo@example.com, demo123 | Green success Snackbar | Not run |
| T6 | Tap tip in success scenario | Loading, then labeled plain-text tip | Not run |
| T7 | Select Offline failure; request tip | Friendly error and Retry; no stale tip | Not run |
| T8 | Retry offline, then select success and request again | Error persists offline; recovers in success mode | Not run |
| T9 | Select malformed JSON, then empty tip | Friendly error for each; Retry available | Not run |
| T10 | Select timeout | Loading ends after about 10 seconds; retry offered | Not run |
| T11 | Select HTTP 503 | Friendly error, even if response body has a tip | Not run |
| T12 | Inspect captured request in service unit test | Exactly task and topic; no form data/secrets | Not run |
| T13 | Service unit test with long tip | Whitespace trimmed, at most 240 code points | Not run |
| T14 | Submit valid form during AI failure | Local signup still succeeds | Not run |
| T15 | Invalid form with successful AI tip | Invalid signup still blocked | Not run |
| T16 | Rapidly tap tip button while loading | Button disabled; no duplicate request | Not run |
| T17 | Small device with keyboard open | Form/coach scroll; no layout overflow | Not run |
| T18 | Build/install APK with selected mode | APK launches and same flow works | Not run |
| T19 | Instructor endpoint if available | Genuine live response; airplane-mode failure; recover online | Not run |

For mock evidence capture the visible MOCK label. Airplane mode does NOT make the
mock fail: select Offline failure for simulated offline evidence. For live mode,
airplane mode or a disconnected emulator provides the real offline test.

Suggested evidence: invalid form screenshot; success Snackbar; labeled tip;
error and retry; build output; APK running on Android. These must come from your
actual run. Never capture real credentials or provider keys.
