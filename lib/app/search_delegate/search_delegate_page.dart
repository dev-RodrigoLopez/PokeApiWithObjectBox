import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:object_box_pokeapi/app/search_delegate/widgets/card_pokemon.dart';
import 'package:object_box_pokeapi/data/model/pokemon_model_entity.dart';
import 'package:object_box_pokeapi/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';



class PokemonSearchDelegate extends SearchDelegate{

  @override
    String get searchFieldLabel => 'Buscar pokemon ';

  @override
  List<Widget> buildActions(BuildContext context) {
    return[
      IconButton(
        icon: const Icon( Icons.clear), 
        onPressed: (){
          query = '';
        })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon( Icons.arrow_back ), 
      onPressed: (){
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    if ( query.isEmpty ){

      return emptyPokemon();
    }

    return Container();

  }

  Widget emptyPokemon(){
    return const SizedBox(
      child:  Center(
        child: Icon( Icons.catching_pokemon, color: Colors.black38, size: 200, ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    if( query.isEmpty ){
      return emptyPokemon();
    }

    return pokemonCard( context );
    
  }

  Widget pokemonCard( BuildContext context ){
    return FutureBuilder(
      future: searchPokemonByIdPokemon( int.parse( query) ),
      builder: ( _, AsyncSnapshot snapshot){

        if( !snapshot.hasData ) return  emptyPokemon();

        final PokemonBox pokemon = snapshot.data!;

        return CardPokemon( pokemon: pokemon );

      },
    );
  }
}

Future<dynamic> searchPokemonByIdPokemon( int idPokemon) async{
    try{
      final storageDirectory = await getApplicationDocumentsDirectory();
      final _store = Store(
        getObjectBoxModel(),
        directory: join(storageDirectory.path, 'pokemonBox'),
      );
      Query<PokemonBox> query = _store.box<PokemonBox>().query( PokemonBox_.idPokemon.equals( idPokemon ) ).build();
      List<PokemonBox> pokemonModel = query.find();
      _store.close();

      final _storeImags = Store(
        getObjectBoxModel(),
        directory: join(storageDirectory.path, 'spritesBox'),
      );
      Query<SpritesBox> queryImage = _storeImags.box<SpritesBox>().query( SpritesBox_.idPokemon.equals( idPokemon ) ).build();
      List<SpritesBox> spriteModel = queryImage.find();
      _storeImags.close();
    
      pokemonModel[0].imageURL = spriteModel[0].frontDefault;

      return pokemonModel[0];

    }catch(e){
      log( e.toString() );
      return null;
    }
  } 


