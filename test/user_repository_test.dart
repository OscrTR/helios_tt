import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:helios_tt/models/user_model.dart';
import 'package:helios_tt/repositories/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Générer les mocks pour http.Client
@GenerateMocks([http.Client])
import 'user_repository_test.mocks.dart';

void main() {
  late MockClient mockHttpClient;
  late UserRepository userRepository;

  setUp(() {
    mockHttpClient = MockClient();
    userRepository = UserRepository(httpClient: mockHttpClient);
  });
  group('UserRepository', () {
    group('fetchUsers', () {
      test(
        'retourne une liste de User si la requête HTTP est réussie (code 200)',
        () async {
          // Préparer
          final responsePayload = {
            'results': [
              {
                'name': {'first': 'John', 'last': 'Doe'},
                'email': 'john.doe@example.com',
                'picture': {'large': 'large.jpg', 'thumbnail': 'thumb.jpg'},
                'location': {
                  'street': {'number': 123, 'name': 'Main St'},
                  'city': 'Anytown',
                  'state': 'Anystate',
                  'country': 'Anycountry',
                },
                'phone': '123-456-7890',
              },
            ],
          };
          when(mockHttpClient.get(any)).thenAnswer(
            (_) async => http.Response(json.encode(responsePayload), 200),
          );

          // Agir
          final users = await userRepository.fetchUsers(1);

          // Vérifier
          expect(users, isA<List<User>>());
          expect(users.length, 1);
          expect(users.first.fullName, 'John Doe');
        },
      );

      test('lance une exception si la requête HTTP échoue', () {
        // Préparer
        when(
          mockHttpClient.get(any),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        // Agir & Vérifier
        expect(userRepository.fetchUsers(1), throwsA(isA<Exception>()));
      });
    });
  });
}
