import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helios_tt/models/user_model.dart';
import '../bloc/user_bloc.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // On déclenche le premier chargement
    context.read<UserBloc>().add(FetchUsersEvent());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<UserBloc>().add(FetchUsersEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // On déclenche le chargement un peu avant d'atteindre le bas
    return currentScroll >= (maxScroll * 0.9);
  }

  // Fonction appelée lors de la saisie dans le champ de recherche
  void _onSearchChanged(String query) {
    // Le debounce évite de lancer une recherche à chaque caractère tapé
    // On attend 500ms d'inactivité avant de lancer l'événement.
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<UserBloc>().add(SearchUsersEvent(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Helios TT')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Rechercher par nom',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInitialState || state is UserLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is UserErrorState) {
                  return Center(child: Text('Erreur: ${state.errorMessage}'));
                }
                if (state is UserLoadedState) {
                  if (state.users.isEmpty) {
                    return const Center(
                      child: Text('Aucun utilisateur trouvé'),
                    );
                  }
                  final isFiltered = state.filteredUsers.isNotEmpty;
                  final listLength =
                      isFiltered
                          ? state.filteredUsers.length
                          : state.users.length + 1;
                  // +1 pour l'indicateur de chargement
                  final listItems =
                      isFiltered ? state.filteredUsers : state.users;
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: listLength,
                    itemBuilder: (context, index) {
                      if (!isFiltered && index >= state.users.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final User user = listItems[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.pictureThumbnail),
                        ),
                        title: Text(user.fullName),
                        subtitle: Text(user.email),
                        onTap: () {
                          // TODO
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => UserDetailScreen(user: user),
                          //   ),
                          // );
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text('État non géré'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
