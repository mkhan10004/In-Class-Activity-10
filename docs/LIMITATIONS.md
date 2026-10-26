# Limitations and verification status

- Generated source was inspected but not compiled or run: Flutter is absent here.
  The included Dart tests are test definitions, not passing-test claims.
- Android SDK files are generated locally by bootstrap, not bundled. No APK or
  fabricated screenshots are included. The ZIP is source/setup material.
- No instructor URL/access instructions were supplied. Live connectivity and
  service-specific access remain unverified. Mock fallback needs actual justification.
- Timeout stops waiting for a response, but may not cancel underlying network
  processing on all HTTP platforms. The completed late response is not displayed.
- Output is constrained to plain text and length, not semantically moderated.
  Advice can still be incorrect or unhelpful; it cannot control form acceptance.
- The classroom six-character rule is not a production authentication standard.
  Basic email-shape validation does not verify ownership or deliverability.
- There is no account persistence, authentication, password hashing, or backend.
- Tests exercise the service contract and UI; actual device screenshots, APK
  installation, reflection, contribution evidence and live explanation remain.
