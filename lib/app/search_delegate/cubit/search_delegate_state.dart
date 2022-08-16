part of 'search_delegate_cubit.dart';

class SearchDelegateState extends Equatable {
  const SearchDelegateState({
    this.pokemonBox = const [],
  });

  final List<PokemonBox> pokemonBox; 

  @override
  List<Object> get props => [];
}
