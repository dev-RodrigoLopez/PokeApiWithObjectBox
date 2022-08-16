import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_box_pokeapi/app/search_delegate/cubit/search_delegate_cubit.dart';
import 'package:object_box_pokeapi/app/search_delegate/search_delegate_page.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchDelegateCubit(),
      child: const SearchWidgetLogic(),
    );
  }
}

class SearchWidgetLogic extends StatelessWidget {
  const SearchWidgetLogic({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10  ),
      width: size.width * 1,
      height: size.height * 0.25,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox( height: size.height * 0.05),
          // const Text( 'Pokédex', style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white  ), ),
          const Text( 
            'Busca un pokemon por su nombre o por el Id Pokemon', 
            style: 
              TextStyle( 
                fontSize: 18,
                color: Colors.black  
              ), 
            maxLines: 2,
          ),

          SizedBox( height: size.height * 0.015 ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => showSearch( context: context, delegate: PokemonSearchDelegate()),
                child: Container(
                  width: size.width * 0.8,
                  height: size.height * 0.05,
                  decoration: BoxDecoration( 
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      children: const [
                        SizedBox( width: 5 ),
                        Icon( Icons.search , color: Colors.white),
                        SizedBox( width: 5 ),
                        Text( 'Nombre o Identificador', style: TextStyle( color: Colors.white, fontSize: 18 ))
                      ],
                    ),
                ),
              ),

              GestureDetector(
                onTap: () => showSearch( context: context, delegate: PokemonSearchDelegate()),
                child: Container(
                  width: size.width * 0.12,
                  height: size.height * 0.05,
                  decoration: BoxDecoration(
                      color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Center(
                    child: Icon( Icons.search, color: Colors.white, size: 30, ),
                  ),
                ),
              )

            ],
          )

        ],
      ),
      // color: Colors.red,
    );
  }
}