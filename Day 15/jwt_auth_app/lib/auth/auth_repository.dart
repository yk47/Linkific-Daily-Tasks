import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _reqresApiKey = 'reqres_7a94c5e129cc4c36bae212d5dda06e38';
const String _reqresSuccessEmail = 'eve.holt@reqres.in';
const String _reqresLoginPassword = 'cityslicka';
const String _reqresRegisterPassword = 'pistol';

@immutable
class AuthUser {
  const AuthUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
  });

  final int? id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;

  String get displayName {
    final parts = [
      firstName,
      lastName,
    ].where((value) => value.trim().isNotEmpty);
    final joined = parts.join(' ').trim();
    if (joined.isNotEmpty) {
      return joined;
    }
    if (username.trim().isNotEmpty) {
      return username;
    }
    return email;
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: _readInt(json, const ['id', 'userId']),
      username: _readString(json, const ['username', 'login', 'name', 'email']),
      email: _readString(json, const ['email', 'username', 'login']),
      firstName: _readString(json, const [
        'firstName',
        'first_name',
        'givenName',
      ]),
      lastName: _readString(json, const [
        'lastName',
        'last_name',
        'familyName',
      ]),
      image: _readString(json, const ['image', 'avatar', 'photo']),
    );
  }

  factory AuthUser.fromEmail({
    required String email,
    String firstName = '',
    String lastName = '',
    String username = '',
  }) {
    final localPart = email.split('@').first;
    return AuthUser(
      id: null,
      username: username.isNotEmpty ? username : localPart,
      email: email,
      firstName: firstName,
      lastName: lastName,
      image: '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
    };
  }
}

@immutable
class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final AuthUser user;
  final String accessToken;
  final String refreshToken;

  AuthSession copyWith({
    AuthUser? user,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthSession(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory AuthSession.fromJson(
    Map<String, dynamic> json, {
    AuthSession? fallback,
  }) {
    return AuthSession(
      user: AuthUser.fromJson(json),
      accessToken: _readString(json, const ['accessToken', 'token']),
      refreshToken: _readString(json, const [
        'refreshToken',
        'refresh_token',
      ], fallback: fallback?.refreshToken ?? ''),
    );
  }

  factory AuthSession.fromStoredJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return AuthSession(
      user: AuthUser.fromJson(
        userJson is Map<String, dynamic>
            ? userJson
            : <String, dynamic>{
                'email': _readString(json, const ['email']),
                'username': _readString(json, const ['username']),
                'firstName': _readString(json, const ['firstName']),
                'lastName': _readString(json, const ['lastName']),
                'image': _readString(json, const ['image']),
              },
      ),
      accessToken: _readString(json, const ['accessToken', 'token']),
      refreshToken: _readString(json, const ['refreshToken', 'refresh_token']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

class AuthApiException implements Exception {
  const AuthApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class AuthStorage {
  AuthStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String _sessionKey = 'jwt_auth_session';
  final FlutterSecureStorage _secureStorage;

  Future<AuthSession?> readSession() async {
    final rawValue = await _secureStorage.read(key: _sessionKey);
    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(rawValue);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return AuthSession.fromStoredJson(decoded);
  }

  Future<void> saveSession(AuthSession session) {
    return _secureStorage.write(
      key: _sessionKey,
      value: jsonEncode(session.toJson()),
    );
  }

  Future<void> clearSession() {
    return _secureStorage.delete(key: _sessionKey);
  }
}

class ApiService {
  ApiService({
    String baseUrl = 'https://reqres.in',
    String apiKey = _reqresApiKey,
    AuthSession? session,
    Dio? dio,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 15),
               sendTimeout: const Duration(seconds: 15),
               headers: <String, dynamic>{
                 'Content-Type': 'application/json',
                 'x-api-key': apiKey,
               },
             ),
           ) {
    _session = session;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final attachAuth = options.extra['attachAuth'] as bool? ?? true;
          final accessToken = _session?.accessToken;
          if (attachAuth && accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  AuthSession? _session;

  void setSession(AuthSession? session) {
    _session = session;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _postJson(
      '/api/login',
      data: <String, dynamic>{'email': email, 'password': password},
      attachAuth: false,
    );
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) {
    return _postJson(
      '/api/register',
      data: <String, dynamic>{'email': email, 'password': password},
      attachAuth: false,
    );
  }

  Future<Map<String, dynamic>> _postJson(
    String path, {
    required Map<String, dynamic> data,
    required bool attachAuth,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        options: Options(extra: <String, dynamic>{'attachAuth': attachAuth}),
      );
      return _asMap(response.data);
    } on DioException catch (error) {
      throw _toAuthException(error);
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is String && data.isNotEmpty) {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    }

    throw const AuthApiException('Unexpected API response.');
  }

  AuthApiException _toAuthException(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final responseData = response?.data;
    String? message;

    if (responseData is Map<String, dynamic>) {
      final dynamic detail = responseData['message'] ?? responseData['error'];
      if (detail is String && detail.isNotEmpty) {
        message = detail;
      } else if (detail is List && detail.isNotEmpty) {
        message = detail.join(', ');
      }
    }

    message ??= switch (error.type) {
      DioExceptionType.connectionTimeout => 'Connection timed out. Try again.',
      DioExceptionType.sendTimeout => 'Request timed out. Try again.',
      DioExceptionType.receiveTimeout => 'Server took too long to respond.',
      DioExceptionType.connectionError => 'No internet connection detected.',
      DioExceptionType.cancel => 'Request was cancelled.',
      _ =>
        statusCode == 401
            ? 'Session expired. Sign in again.'
            : 'Authentication request failed.',
    };

    return AuthApiException(message, statusCode: statusCode);
  }
}

class AuthRepository {
  AuthRepository({AuthStorage? storage, ApiService? apiService})
    : _storage = storage ?? AuthStorage(),
      _apiService = apiService ?? ApiService();

  final AuthStorage _storage;
  final ApiService _apiService;
  AuthSession? _currentSession;

  AuthSession? get currentSession => _currentSession;

  Future<AuthSession?> bootstrap() async {
    final storedSession = await _storage.readSession();
    if (storedSession == null) {
      _currentSession = null;
      _apiService.setSession(null);
      return null;
    }

    _currentSession = storedSession;
    _apiService.setSession(storedSession);
    return storedSession.accessToken.isEmpty ? null : storedSession;
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    if (email != _reqresSuccessEmail || password != _reqresLoginPassword) {
      throw const AuthApiException(
        'Only the ReqRes demo login is enabled in this app. Use eve.holt@reqres.in with cityslicka.',
      );
    }

    final payload = await _apiService.login(email: email, password: password);
    final session = AuthSession(
      user: AuthUser.fromEmail(email: email),
      accessToken: _readString(payload, const ['token']),
      refreshToken: '',
    );
    return _persistSession(session);
  }

  Future<AuthSession> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    if (email != _reqresSuccessEmail || password != _reqresRegisterPassword) {
      throw const AuthApiException(
        'Only the ReqRes demo registration is enabled in this app. Use eve.holt@reqres.in with pistol.',
      );
    }

    final payload = await _apiService.register(
      email: email,
      password: password,
    );
    final session = AuthSession(
      user: AuthUser.fromEmail(
        email: email,
        firstName: firstName,
        lastName: lastName,
      ),
      accessToken: _readString(payload, const ['token']),
      refreshToken: '',
    );
    return _persistSession(session);
  }

  Future<AuthSession> syncProfile() async {
    return _requireSession();
  }

  Future<void> logout() async {
    _currentSession = null;
    _apiService.setSession(null);
    await _storage.clearSession();
  }

  AuthSession _requireSession() {
    final session = _currentSession;
    if (session == null) {
      throw const AuthApiException('No active authentication session.');
    }
    return session;
  }

  Future<AuthSession> _persistSession(AuthSession session) async {
    _currentSession = session;
    _apiService.setSession(session);
    await _storage.saveSession(session);
    return session;
  }
}

class AuthController extends ChangeNotifier {
  AuthController({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;
  bool _isBootstrapping = false;
  bool _isSubmitting = false;
  AuthSession? _session;

  bool get isBootstrapping => _isBootstrapping;
  bool get isSubmitting => _isSubmitting;
  bool get isAuthenticated => _session != null;
  AuthSession? get session => _session;
  AuthUser? get user => _session?.user;

  Future<void> bootstrap() async {
    _isBootstrapping = true;
    notifyListeners();
    try {
      _session = await _repository.bootstrap();
    } finally {
      _isBootstrapping = false;
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) {
    return _runAuthAction(() async {
      _session = await _repository.login(email: email, password: password);
    });
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    return _runAuthAction(() async {
      _session = await _repository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
    });
  }

  Future<void> logout() async {
    _isSubmitting = true;
    notifyListeners();
    try {
      await _repository.logout();
      _session = null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> _runAuthAction(Future<void> Function() action) async {
    _isSubmitting = true;
    notifyListeners();
    try {
      await action();
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}

String _readString(
  Map<String, dynamic> json,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    final dynamic value = json[key];
    if (value == null) {
      continue;
    }

    final text = value.toString().trim();
    if (text.isNotEmpty) {
      return text;
    }
  }

  return fallback;
}

int? _readInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final dynamic value = json[key];
    if (value is int) {
      return value;
    }

    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
  }

  return null;
}
