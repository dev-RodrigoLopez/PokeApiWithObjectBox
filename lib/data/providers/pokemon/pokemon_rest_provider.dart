
import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:object_box_pokeapi/data/model/pokemon_model.dart';

class PokemonRestProvider{

  List<PokemonModel> listPokemons = [];

  Future<Either<Exception,List<PokemonModel>>> getPokemones()async{
    try{
      for( int i = 1; i <= 600; i++ ){
        
        print( i );
        // Uri url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$i');
        final response = await Dio().get( 'https://pokeapi.co/api/v2/pokemon/$i' );
        // final respData = json.decode( response.data );
        final pokemonResponse = PokemonModel.fromMap( response.data );

        listPokemons.add(pokemonResponse);     
      }

      return Right(listPokemons);
    }catch(e){
      print(e.toString());
      return Left( e as Exception );
    }
  }

  Future<dynamic> getImagekindofByte( String urlImage) async{
    try{
      final response = await Dio().get(
        urlImage,
        options:  Options( responseType: ResponseType.bytes ) 
      );
      return response.data ;
    }catch(e){
      log(e.toString());
      return '';
    }
  }

}