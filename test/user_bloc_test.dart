import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helios_tt/bloc/user_bloc.dart';
import 'package:helios_tt/models/user_model.dart';
import 'package:helios_tt/repositories/user_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Générer le mock pour UserRepository
@GenerateMocks([UserRepository])
import 'user_bloc_test.mocks.dart';

void main() {
  group('UserBloc', () {
    late MockUserRepository mockUserRepository;
    late UserBloc userBloc;

    // Un utilisateur factice pour les tests
    final tUser = User(
      fullName: 'Test User',
      email: 'test@example.com',
      pictureLarge: 'large.jpg',
      pictureThumbnail: 'thumb.jpg',
      location: 'Test Location',
      phone: '12345',
    );

    setUp(() {
      mockUserRepository = MockUserRepository();
      userBloc = UserBloc(mockUserRepository);
    });

    tearDown(() {
      userBloc.close();
    });

    test('l\'état initial est UserInitialState', () {
      expect(userBloc.state, UserInitialState());
    });

    group('FetchUsersEvent', () {
      blocTest<UserBloc, UserState>(
        'émet [UserLoadingState, UserLoadedState] quand fetchUsers réussit (chargement initial)',
        build: () {
          when(
            mockUserRepository.fetchUsers(any),
          ).thenAnswer((_) async => [tUser]);
          return userBloc;
        },
        act: (bloc) => bloc.add(FetchUsersEvent()),
        expect:
            () => [
              UserLoadingState(),
              UserLoadedState(users: [tUser], page: 1, filteredUsers: []),
            ],
      );

      blocTest<UserBloc, UserState>(
        'émet [UserErrorState] quand fetchUsers échoue',
        build: () {
          when(
            mockUserRepository.fetchUsers(any),
          ).thenThrow(Exception('Failed to fetch'));
          return userBloc;
        },
        act: (bloc) => bloc.add(FetchUsersEvent()),
        expect: () => [UserLoadingState(), isA<UserErrorState>()],
      );
    });

    group('SearchUsersEvent', () {
      blocTest<UserBloc, UserState>(
        'émet [UserLoadedState] avec des utilisateurs filtrés',
        build: () => userBloc,
        // "Seed" le bloc avec un état initial pour le test
        seed:
            () => UserLoadedState(
              users: [
                tUser,
                User(
                  fullName: 'Another User',
                  email: '',
                  pictureLarge: '',
                  pictureThumbnail: '',
                  location: '',
                  phone: '',
                ),
              ],
              page: 1,
              filteredUsers: [],
            ),
        act: (bloc) => bloc.add(SearchUsersEvent('Test')),
        expect:
            () => [
              isA<UserLoadedState>().having(
                (state) => state.filteredUsers,
                'filteredUsers',
                [tUser],
              ),
            ],
      );

      blocTest<UserBloc, UserState>(
        'émet [UserLoadedState] avec une liste filtrée vide si la recherche est vide',
        build: () => userBloc,
        seed:
            () => UserLoadedState(
              users: [tUser],
              page: 1,
              filteredUsers: [tUser],
            ),
        act: (bloc) => bloc.add(SearchUsersEvent('')),
        expect:
            () => [
              isA<UserLoadedState>().having(
                (state) => state.filteredUsers,
                'filteredUsers',
                [],
              ),
            ],
      );
    });
  });
}
