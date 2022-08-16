
import 'package:objectbox/objectbox.dart';

@Entity()
class PokemonBox{
  PokemonBox({
    this.id = 0,
    required this.baseExperience,
    required this.height,
    required this.idPokemon,
    required this.isDefault,
    required this.locationAreaEncounters,
    required this.name,
    required this.order,
    required this.weight,
    this.imageURL = '',
  });

  int id;
  int baseExperience;
  int height;
  int idPokemon;
  bool isDefault;
  String locationAreaEncounters;
  String name;
  int order;
  int weight;
  dynamic imageURL;

  PokemonBox copyWith({
    int? id,
    int? baseExperience,
    int? height,
    int? idPokemon,
    bool? isDefault,
    String? locationAreaEncounters,
    String? name,
    int? order,
    int? weight,
    String? imageURL,
  }) => 
    PokemonBox(
      baseExperience: baseExperience ?? this.baseExperience,
      height: height ?? this.height,
      idPokemon: idPokemon ?? this.idPokemon,
      isDefault: isDefault ?? this.isDefault,
      locationAreaEncounters: locationAreaEncounters ?? this.locationAreaEncounters,
      name: name ?? this.name,
      order: order ?? this.order,
      weight: weight ?? this.weight,
    );

}

@Entity()
class AbilityBox{
  AbilityBox({
    this.id = 0 ,
    required this.idPokemon,
    required this.idSpecies,
    required this.isHidden,
    required this.slot,
  });
  int id;
  int idPokemon;
  String idSpecies;
  bool isHidden;
  int slot;
}

@Entity()
class SpeciesBox{
  SpeciesBox({
    this.id = 0,
    required this.idPokemon,
    required this.name,
    required this.url,
  });
  int id;
  int idPokemon;
  String name;
  String url;
}

@Entity()
class SpritesBox{
  SpritesBox({
    this.id = 0 ,
    required this.idPokemon,
    required this.backDefault,
    required this.backFemale,
    required this.backShiny,
    required this.backShinyFemale,
    required this.frontDefault,
    required this.frontFemale,
    required this.frontShiny,
    required this.frontShinyFemale,
  });
  int id;
  int idPokemon;
  String backDefault;
  String backFemale;
  String backShiny;
  String backShinyFemale;
  String frontDefault;
  String frontFemale;
  String frontShiny;
  String frontShinyFemale;
}