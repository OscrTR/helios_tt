import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:helios_tt/repositories/user_repository.dart';
import 'package:helios_tt/models/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserInitialState()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<SearchUsersEvent>(_onSearchUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      // Si c'est un chargement initial
      if (state is UserInitialState || state is UserErrorState) {
        final pageNumber = 1;
        emit(UserLoadingState());
        final users = await _userRepository.fetchUsers(pageNumber);
        emit(
          UserLoadedState(users: users, page: pageNumber, filteredUsers: []),
        );
        return;
      }

      // Si c'est un chargement pour la pagination
      if (state is UserLoadedState) {
        final currentState = state as UserLoadedState;
        final pageNumber = currentState.page + 1;
        List<User> currentUsers = currentState.users;

        final users = await _userRepository.fetchUsers(pageNumber);

        List<User> newUsers = List.from(currentUsers);
        for (var user in users) {
          newUsers.add(user);
        }
        emit(
          UserLoadedState(users: newUsers, page: pageNumber, filteredUsers: []),
        );
      }
    } catch (e) {
      emit(UserErrorState(errorMessage: e.toString()));
    }
  }

  void _onSearchUsers(SearchUsersEvent event, Emitter<UserState> emit) {
    if (state is UserLoadedState) {
      final currentState = state as UserLoadedState;
      final List<User> currentUsers = currentState.users;
      final currentPage = currentState.page;

      if (event.query.isEmpty) {
        // Si la recherche est vide, afficher tous les utilisateurs
        emit(
          UserLoadedState(
            users: currentUsers,
            page: currentPage,
            filteredUsers: [],
          ),
        );
      } else {
        // Sinon, filtrer la liste complète
        final filteredUsers =
            currentUsers.where((user) {
              return user.fullName.toLowerCase().contains(
                event.query.toLowerCase(),
              );
            }).toList();
        emit(
          UserLoadedState(
            users: currentUsers,
            page: currentPage,
            filteredUsers: filteredUsers,
          ),
        );
      }
    }
  }
}
