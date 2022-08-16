import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:object_box_pokeapi/data/enums.dart';
import 'package:object_box_pokeapi/data/model/pokemon_model.dart';
import 'package:object_box_pokeapi/data/model/pokemon_model_entity.dart';
import 'package:object_box_pokeapi/data/providers/pokemon/pokemon_rest_provider.dart';
import 'package:object_box_pokeapi/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  late Either<Exception, List<PokemonModel>> response;

  Future<void> getPokemon() async{
    emit( 
      state.copyWith(
        statusHome: statusHomePage.loading,
      )
    );
    try{
      final storageDirectory = await getApplicationDocumentsDirectory();
      final _store = Store(
        getObjectBoxModel(),
        directory: join(storageDirectory.path, 'pokemonBox'),
      );
      List<PokemonBox> listPokemon = _store.box<PokemonBox>().getAll();
      _store.close();
      if( listPokemon.isNotEmpty ) {
        emit( 
          state.copyWith(
            statusHome: statusHomePage.success,
          )
        );
        await getOfPokemonBox();
        return;
      }
      await updatePokemon();

    }catch(e){
      log( 'getPokemon >>  ${e.toString()}' );
      emit( 
        state.copyWith(
          statusHome: statusHomePage.error,
        )
      );
    }
  }

  Future<void> updatePokemon() async{

    emit( 
      state.copyWith(
        statusHome: statusHomePage.loading,
      )
    );
    await deletePokemonBox();
    response = await PokemonRestProvider().getPokemones();
    response.fold(
      (exception){
        log( exception.toString() );
        emit( 
          state.copyWith(
            statusHome: statusHomePage.error,
          )
        );
      }, 
      ( listPokemons )async{
        await saveInPokemonBox( listPokemons );
        // await saveInAbilitynBox( listPokemons );
        // await saveInSpeciesBox( listPokemons );
        await saveInSpritesBox( listPokemons );
      }
    );
    await getOfPokemonBox();
  }

  Future<void> saveInPokemonBox( List<PokemonModel> listPokemons ) async{
    final storageDirectory = await getApplicationDocumentsDirectory();
    final _store = Store(
      getObjectBoxModel(),
      directory: join(storageDirectory.path, 'pokemonBox'),
    );

    for (var pokemon in listPokemons) {
      final pokemonBox = PokemonBox(
        baseExperience : pokemon.baseExperience,
        height : pokemon.height,
        idPokemon : pokemon.id,
        isDefault : pokemon.isDefault,
        locationAreaEncounters : pokemon.locationAreaEncounters,
        name : pokemon.name,
        order : pokemon.order,
        weight : pokemon.weight,
      );
      _store.box<PokemonBox>().put(pokemonBox);
    }
    _store.close();
  }

  Future<void> saveInAbilitynBox( List<PokemonModel> listPokemons ) async{
    final storageDirectory = await getApplicationDocumentsDirectory();
    final _store = Store(
      getObjectBoxModel(),
      directory: join(storageDirectory.path, 'abilityBox'),
    );

    for (var pokemon in listPokemons) {
      for (var abilities in pokemon.abilities) {
        final abilityBox = AbilityBox(
          idPokemon : pokemon.id,
          idSpecies : abilities.ability.name,
          isHidden : abilities.isHidden,
          slot : abilities.slot
        );
        _store.box<AbilityBox>().put(abilityBox);
      }
    }
    _store.close();
  }

  Future<void> saveInSpeciesBox( List<PokemonModel> listPokemons ) async{
    final storageDirectory = await getApplicationDocumentsDirectory();
    final _store = Store(
      getObjectBoxModel(),
      directory: join(storageDirectory.path, 'speciesBox'),
    );

    for (var pokemon in listPokemons) {
      for (var abilities in pokemon.abilities) {
        final speciesBox = SpeciesBox(
          idPokemon : pokemon.id,
          name : abilities.ability.name,
          url : abilities.ability.url,
        );
        _store.box<SpeciesBox>().put(speciesBox);
      }
    }
    _store.close();
  }

  Future<void> saveInSpritesBox( List<PokemonModel> listPokemons ) async{
    final storageDirectory = await getApplicationDocumentsDirectory();
    final _store = Store(
      getObjectBoxModel(),
      directory: join(storageDirectory.path, 'spritesBox'),
    );

    for (var pokemon in listPokemons) {
      final spriteBox = SpritesBox(
        idPokemon: pokemon.id,
        backDefault : pokemon.sprites.backDefault,
        backFemale : pokemon.sprites.backFemale ?? '',
        backShiny : pokemon.sprites.backShiny,
        backShinyFemale : pokemon.sprites.backShinyFemale ?? '',
        frontDefault : pokemon.sprites.frontDefault,
        frontFemale : pokemon.sprites.frontFemale ?? '',
        frontShiny : pokemon.sprites.frontShiny,
        frontShinyFemale : pokemon.sprites.frontShinyFemale ?? '',
      );
      _store.box<SpritesBox>().put(spriteBox);
    }
    _store.close();
  }

  Future<void> getOfPokemonBox() async{
    try{
      final storageDirectory = await getApplicationDocumentsDirectory();
      final _store = Store(
        getObjectBoxModel(),
        directory: join(storageDirectory.path, 'pokemonBox'),
      );
      List<PokemonBox> listPokemon = _store.box<PokemonBox>().getAll();
      _store.close();
      if( listPokemon.isNotEmpty ){
        listPokemon = await getImage( listPokemon );
      }
      emit(
        state.copyWith(
          statusHome: statusHomePage.success,
          listPokemon: listPokemon,
        )
      );
    }catch(e){
      emit( 
        state.copyWith(
          statusHome: statusHomePage.error,
        )
      );
      log( e.toString() );
    }
  }

  Future<void> deletePokemonBox() async{
    try{
      final storageDirectory = await getApplicationDocumentsDirectory();
      final _store = Store(
        getObjectBoxModel(),
        directory: join(storageDirectory.path, 'pokemonBox'),
      );
      // if( _store.box<PokemonBox>().isEmpty()){
      //   _store.close();
      //   return;
      // }
      _store.box<PokemonBox>().removeAll();
      _store.box<AbilityBox>().removeAll();
      _store.box<SpeciesBox>().removeAll();
      _store.box<SpritesBox>().removeAll();
      _store.close();
    }catch(e){
      emit( 
        state.copyWith(
          statusHome: statusHomePage.error,
        )
      );
      log( e.toString() );
    }
  }

  Future<List<PokemonBox>> getImage(List<PokemonBox> listPokemon) async{
    try{
      final storageDirectory = await getApplicationDocumentsDirectory();
      
      final _store = Store(
        getObjectBoxModel(),
        directory: join(storageDirectory.path, 'spritesBox'),
      );
      List<PokemonBox> listPokemonModel= [];
      for (var pokemonModel in listPokemon) {
        Query<SpritesBox> query = _store.box<SpritesBox>().query( SpritesBox_.idPokemon.equals(pokemonModel.idPokemon) ).build();
        List<SpritesBox> spriteModel = query.find();
        pokemonModel.imageURL = spriteModel[0].frontShiny;

        ///
        // final imageInByte = await PokemonRestProvider().getImagekindofByte( spriteModel[0].frontShiny );
        // pokemonModel.imageURL = imageInByte;
        // final _storePokemon = Store(
        //   getObjectBoxModel(),
        //   directory: join(storageDirectory.path, 'pokemonBox'),
        // );
        // _storePokemon.box<PokemonBox>().put(pokemonModel);
        // _storePokemon.close();
        // int i = 0;
        // print( i++ );
        
        listPokemonModel.add(pokemonModel);
      }
      _store.close();
      return listPokemonModel;

    }catch(e){
      log( e.toString() );
      return [];
    }
  } 

}
