part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

// État initial, quand l'application démarre
class UserInitialState extends UserState {}

// État de chargement, pendant que les données sont récupérées
class UserLoadingState extends UserState {}

// État de succès, quand les données ont été récupérées
class UserLoadedState extends UserState {
  final List<User> users;
  final int page;
  final List<User> filteredUsers;

  const UserLoadedState({
    required this.users,
    required this.page,
    required this.filteredUsers,
  });

  @override
  List<Object> get props => [users, page, filteredUsers];
}

// État d'erreur, si un problème est survenu
class UserErrorState extends UserState {
  final String errorMessage;

  const UserErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
