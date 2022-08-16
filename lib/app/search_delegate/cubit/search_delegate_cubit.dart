import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:object_box_pokeapi/data/model/pokemon_model_entity.dart';
import 'package:object_box_pokeapi/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

part 'search_delegate_state.dart';

class SearchDelegateCubit extends Cubit<SearchDelegateState> {
  SearchDelegateCubit() : super(const SearchDelegateState());

  Future<dynamic> searchPokemonByIdPokemon( int idPokemon) async{
    try{
      final storageDirectory = await getApplicationDocumentsDirectory();
      final _store = Store(
        getObjectBoxModel(),
        directory: join(storageDirectory.path, 'pokemonBox'),
      );
      Query<PokemonBox> query = _store.box<PokemonBox>().query( PokemonBox_.idPokemon.equals( idPokemon ) ).build();
      List<PokemonBox> pokemonModel = query.find();

      return pokemonModel[0];

    }catch(e){
      log( e.toString() );
      return null;
    }
  }

}
