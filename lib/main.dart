import 'package:flutter/material.dart';

import 'services/signup_tip_service.dart';
import 'validation/signup_validators.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Campus Crew',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const SignupPage(),
      );
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  static const _endpoint = String.fromEnvironment('AI_PROXY_URL');
  static const _allowMock = bool.fromEnvironment('USE_MOCK');
  SignupTipService? _service;
  String? _configurationError;
  String? _tip;
  String? _error;
  bool _loading = false;
  MockScenario _scenario = MockScenario.success;

  @override
  void initState() {
    super.initState();
    if (_endpoint.isNotEmpty) {
      try {
        _service = HttpSignupTipService(endpoint: Uri.parse(_endpoint));
      } catch (_) {
        _configurationError = 'Invalid configuration. Supply the instructor HTTPS endpoint.';
      }
    } else if (_allowMock) {
      _service = createMockService(_scenario);
    } else {
      _configurationError = 'The instructor endpoint is not configured. '
          'See README for live setup or the documented mock fallback.';
    }
  }

  Future<void> _getTip() async {
    final service = _service;
    if (_loading || service == null) return;
    setState(() {
      _loading = true;
      _tip = null;
      _error = null;
    });
    try {
      final result = await service.getTip();
      if (!mounted) return;
      setState(() => _tip = result);
    } on TipException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not load a tip. Please retry.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _changeScenario(MockScenario? value) {
    if (value == null || _loading) return;
    _service?.close();
    setState(() {
      _scenario = value;
      _service = createMockService(value);
      _tip = null;
      _error = null;
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('Demo signup complete — your form passed validation!'),
        backgroundColor: Colors.green,
      ));
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _service?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mock = _service?.isMock ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Crew')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.school_outlined, size: 52, color: Colors.deepPurple),
                  const SizedBox(height: 12),
                  Text('Find your campus crew',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  const Text('A demo signup for study groups and campus adventures.',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        key: const Key('name'),
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                        validator: validateName,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('email'),
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('password'),
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: const InputDecoration(
                          labelText: 'Password', prefixIcon: Icon(Icons.lock_outline),
                          helperText: 'At least 6 characters for this classroom demo'),
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          key: const Key('signup'),
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16)),
                          child: const Text('Sign Up'),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  const Text('Demo only: no account is created or stored.',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Signup Coach', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(mock
                              ? 'MOCK AI ADVICE — deterministic example; no live model called.'
                              : 'AI-generated advice — suggestions only.'),
                          const SizedBox(height: 8),
                          const Text('Only a fixed task and topic are sent. '
                              'Your form values stay on this device.'),
                          if (_configurationError != null) ...[
                            const SizedBox(height: 12),
                            Text(_configurationError!),
                          ],
                          if (mock) ...[
                            const SizedBox(height: 16),
                            DropdownButtonFormField<MockScenario>(
                              value: _scenario,
                              isExpanded: true,
                              decoration: const InputDecoration(labelText: 'Mock test scenario'),
                              items: MockScenario.values.map((scenario) => DropdownMenuItem(
                                value: scenario,
                                child: Text(switch (scenario) {
                                  MockScenario.success => 'Successful response',
                                  MockScenario.offline => 'Offline failure',
                                  MockScenario.malformed => 'Malformed JSON',
                                  MockScenario.empty => 'Empty tip',
                                  MockScenario.timeout => '10-second timeout',
                                  MockScenario.serverError => 'HTTP 503 error',
                                }),
                              )).toList(),
                              onChanged: _loading ? null : _changeScenario,
                            ),
                          ],
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _loading || _service == null ? null : _getTip,
                            icon: const Icon(Icons.lightbulb_outline),
                            label: Text(_loading ? 'Getting tip…' : 'Get a signup tip'),
                          ),
                          if (_loading) const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(child: CircularProgressIndicator(
                              semanticsLabel: 'Loading signup tip')),
                          ),
                          if (_tip != null) Semantics(
                            liveRegion: true,
                            child: Text(_tip!, key: const Key('tip-result')),
                          ),
                          if (_error != null) Semantics(
                            liveRegion: true,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(_error!),
                                TextButton(onPressed: _loading ? null : _getTip,
                                  child: const Text('Retry')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
