import 'package:capachica/core/api/api_client.dart';
import 'package:capachica/features/auth/providers/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:capachica/core/storage/token_storage.dart';
import '../../../test_helper.dart';

// Generar el archivo de mocks
@GenerateMocks([ApiClient])
import 'auth_provider_test.mocks.dart';

void main() {
  late AuthProvider authProvider;
  late MockApiClient mockApiClient;
  late TestSecureStorage testSecureStorage;

  setUpAll(() {
    setupTestSecureStorage();
  });

  setUp(() {
    mockApiClient = MockApiClient();
    testSecureStorage = TestSecureStorage();
    TokenStorage.storage = testSecureStorage;
    authProvider = AuthProvider(mockApiClient);
  });

  group('AuthProvider Tests', () {
    test('Initial state should be unauthenticated', () {
      expect(authProvider.status, equals(AuthStatus.unauthenticated));
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.errorMessage, isNull);
    });

    test('Login success should update state correctly', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/auth/login'),
        data: {
          'access_token': 'test_token',
          'usuario': {
            'id': 1,
            'nombre': 'Test',
            'apellidos': 'User',
            'email': 'test@example.com',
            'roles': ['admin']
          }
        },
        statusCode: 200,
      );

      when(mockApiClient.post('/auth/login', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await authProvider.login('test@example.com', 'password');

      // Assert
      expect(result, isTrue);
      expect(authProvider.status, equals(AuthStatus.authenticated));
      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.errorMessage, isNull);
      expect(authProvider.usuario?.email, equals('test@example.com'));
      expect(authProvider.userRole, equals('admin'));
    });

    test('Login failure should handle error correctly', () async {
      // Arrange
      when(mockApiClient.post('/auth/login', data: anyNamed('data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
          data: {'message': 'Invalid credentials'},
        ),
      ));

      // Act
      final result = await authProvider.login('test@example.com', 'wrong_password');

      // Assert
      expect(result, isFalse);
      expect(authProvider.status, equals(AuthStatus.error));
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.errorMessage, equals('Credenciales incorrectas'));
    });

    test('Register success should update state correctly', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/users/register'),
        data: {
          'token': 'test_token',
          'message': 'User registered successfully'
        },
        statusCode: 201,
      );

      when(mockApiClient.post('/users/register', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await authProvider.register(
        nombre: 'Test',
        apellidos: 'User',
        telefono: '123456789',
        direccion: 'Test Address',
        fotoPerfilUrl: 'test.jpg',
        fechaNacimiento: DateTime(1990, 1, 1),
        subdivisionId: 1,
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result, isTrue);
      expect(authProvider.status, equals(AuthStatus.authenticated));
      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.errorMessage, isNull);
    });

    test('Logout should clear user data', () async {
      // Arrange
      authProvider.setUsuario(Usuario(
        id: 1,
        nombre: 'Test User',
        email: 'test@example.com',
        rol: 'admin',
      ));

      // Act
      await authProvider.logout();

      // Assert
      expect(authProvider.status, equals(AuthStatus.unauthenticated));
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.usuario, isNull);
      expect(authProvider.token, isNull);
      expect(authProvider.userRole, isNull);
    });
  });
} 