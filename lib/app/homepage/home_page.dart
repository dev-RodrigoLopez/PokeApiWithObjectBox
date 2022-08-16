import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_box_pokeapi/app/homepage/cubit/home_cubit.dart';
import 'package:object_box_pokeapi/app/homepage/widgets/search_widget.dart';
import 'package:object_box_pokeapi/data/enums.dart';

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const HomePageLogic(),
    );
  }
}


class HomePageLogic extends StatefulWidget {
  const HomePageLogic({ Key? key }) : super(key: key);

  @override
  State<HomePageLogic> createState() => _HomePageLogicState();
}

class _HomePageLogicState extends State<HomePageLogic> {

  ConnectivityResult connectivity =  ConnectivityResult.none;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await context.read<HomeCubit>().getPokemon();
    });
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        connectivity = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          if( connectivity !=  ConnectivityResult.none){
            await context.read<HomeCubit>().updatePokemon();
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Accede a una conexion con Internet para poder actualizar los datos'),
            ));
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: ((context, state){
            if( state.statusHome == statusHomePage.loading ){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if( state.statusHome == statusHomePage.error ){
              return const Center(
                child: Text(
                  'ERROR',
                  style: TextStyle(
                    color: Colors.red, 
                    fontSize: 25
                  ),
                ),
              );
            }
            return Column(
              children: [
                SizedBox(
                  height:  MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 1,
                  child: const SearchWidget(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 1,
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    primary: false,
                    itemCount: state.listPokemon.length,
                    itemBuilder: ((context, int index){
                      return SizedBox(
                        child: Stack(
                          children: [
                            Center(
                              child: Icon( 
                                Icons.catching_pokemon_outlined ,
                                size: MediaQuery.of(context).size.width * 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            Center(
                              child: (connectivity !=  ConnectivityResult.none)
                                ? ClipRRect(
                                    // child: Image.memory( state.listPokemon[index].imageURL )
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/loading_pokemon.gif', 
                                      image: state.listPokemon[index].imageURL,
                                      imageScale: 0.5,
                                    ),
                                  )
                                : Image.asset('assets/loading_pokemon.gif')
                            ),
                          ],
                        ),
                      );
                    }),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                  ),
                ),
              ],
            );
          })
        ),
      ),
    );
  }
}