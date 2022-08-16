import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:object_box_pokeapi/data/model/pokemon_model_entity.dart';

class CardPokemon extends StatelessWidget {

  // PokemonModel pokemon;
  PokemonBox pokemon;

  CardPokemon({Key? key, required this.pokemon }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of( context ).size;
    double sizeG = size.height * 0.16;

    return Container(
      width: double.infinity,
      height: size.height * 0.16,
      // color: Colors.red,
      margin: EdgeInsets.symmetric( horizontal: size.width * .044 ),
      child: Stack(
        children: [
         
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width * .9,
              height: size.height * 0.13,
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox( width: size.width * 0.32 ),
                  SizedBox(
                    width: size.width * 0.5,
                    height: size.height * 0.1,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          '# ${pokemon.id}',
                          style: TextStyle(
                            fontSize: ( size.height * 0.16 >  110) ? 15 : 12,
                            fontWeight: FontWeight.w700
                          ),
                        ),

                        Text(
                          toBeginningOfSentenceCase( pokemon.name )!,
                          style: TextStyle(
                            fontSize: ( size.height * 0.16 >  110) ? 25 : 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                          ),
                        ),
                       

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          Container(
            height: size.width * 0.3,
            width: size.width * 0.3,
            decoration: BoxDecoration(
              // color: Colors.black,
              borderRadius: BorderRadius.circular(100)
            ),
            child: Hero(
              tag: pokemon.id,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: FadeInImage.assetNetwork(
                    imageScale: 0.5,
                    placeholder: 'assets/loading_pokemon.gif', 
                    image:  pokemon.imageURL,
                    fit: BoxFit.fill,),
              ),
            ),
           
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Icon( Icons.catching_pokemon, color: Colors.white24, size: size.width * 0.25 ),
          ),

        ],
      ),
    );
  }
  
}
