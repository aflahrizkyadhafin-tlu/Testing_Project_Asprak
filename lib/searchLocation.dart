import 'package:mapbox_search/mapbox_search.dart';

SearchBoxAPI searchBoxAPI = SearchBoxAPI(
  apiKey:
      "pk.eyJ1IjoiYWZsYWgtdGVsdSIsImEiOiJjbWlndjZpOXMwYmx0M2NxczFtMXFzM3FkIn0.1PzbFxXk49ob_oqlkygLkg",
  limit: 5,
);

Future<List<Map<String, dynamic>>> searchLocation(String searchSuggest) async {
  List<Map<String, dynamic>> searchResult = [];

  ApiResponse<SuggestionResponse> searchPlace = await searchBoxAPI
      .getSuggestions(searchSuggest);

  if (searchSuggest.isNotEmpty) {
    for (Suggestion i in searchPlace.success!.suggestions) {
      if (i.name.isNotEmpty && i.fullAddress != null && i.mapboxId.isNotEmpty) {
        searchResult.add({
          "name": i.name,
          "address": i.fullAddress,
          "poi": i.poiCategory,
          "coordinat": await detailLocation(
            i.mapboxId,
          ).then((value) => value.geometry.coordinates),
        });
      }
    }
  }

  return searchResult;
}

Future<Feature> detailLocation(String mapboxId) async {
  ApiResponse<RetrieveResonse> searchPlace = await searchBoxAPI.getPlace(
    mapboxId,
  );

  return searchPlace.success!.features[0];
}
