part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.statusHome = statusHomePage.none,
    this.listPokemon = const [],
  });

  final statusHomePage statusHome;
  final List<PokemonBox> listPokemon;

  HomeState copyWith({
    statusHomePage? statusHome,
    List<PokemonBox>? listPokemon,
  }) =>
    HomeState(
      statusHome : statusHome ?? this.statusHome,
      listPokemon : listPokemon ?? this.listPokemon,
    );

  @override
  List<Object> get props => [ statusHome, listPokemon ];
}

