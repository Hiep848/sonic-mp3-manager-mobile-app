import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_controller.dart';

part 'google_sign_in_controller.g.dart';

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(GoogleSignInRef ref) {
  return GoogleSignIn.instance;
}

@riverpod
class GoogleSignInController extends _$GoogleSignInController {
  Completer<void>? _initializationCompleter;

  @override
  Future<void> build() async {
    await _initialize();
  }

  static const String _serverClientId =
      String.fromEnvironment("GOOGLE_SERVER_CLIENT_ID");

  static const List<String> _scopes = <String>[
    'email',
    'profile',
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/documents',
  ];

  Future<void> _initialize() async {
    print('Starting Google Sign-In initialization...');
    if (_initializationCompleter != null &&
        !_initializationCompleter!.isCompleted) {
      return _initializationCompleter!.future;
    }
    if (_initializationCompleter?.isCompleted ?? false) {
      return;
    }

    _initializationCompleter = Completer<void>();
    try {
      final googleSignIn = ref.read(googleSignInProvider);
      await googleSignIn.initialize(
        serverClientId: _serverClientId,
        nonce: "123",
      );
      _initializationCompleter!.complete();
    } catch (e) {
      _initializationCompleter!.completeError(e);
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (_initializationCompleter == null ||
        !_initializationCompleter!.isCompleted) {
      print('Initializing Google Sign-In...');
      await _initialize();
    }
    print('Google Sign-In already initialized.');
  }

  Future<String?> authenticateAndGetServerAuthCode() async {
    await _ensureInitialized();
    print('Google Sign-In is ready.');
    final googleSignIn = ref.read(googleSignInProvider);
    try {
      final GoogleSignInAccount googleUser =
          await googleSignIn.authenticate(scopeHint: ['email']);
      print('Google Sign-In successful: ${googleUser.email}');
      final GoogleSignInServerAuthorization? authorization =
          await googleUser.authorizationClient.authorizeServer(_scopes);
      return authorization?.serverAuthCode;
    } on GoogleSignInException catch (e, stackTrace) {
      print("Google Sign-In Exception: ${e.code.name}, ${e.description} at:");
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> loginViaBackend() async {
    final authCode = await authenticateAndGetServerAuthCode();
    if (authCode == null) {
      await ref.read(googleSignInProvider).signOut();
      throw StateError('Missing serverAuthCode');
    }

    await ref.read(authControllerProvider.notifier).googleLogin(authCode);
  }
}
