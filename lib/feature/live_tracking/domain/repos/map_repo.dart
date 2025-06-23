abstract class MapRepo {
  // Auto Complete API
  Future<List<Map<String, dynamic>>> getPredictions(String place);

  // Place Details API
  Future<Map<String, dynamic>> getPlaceDetails(String placeId);

  // Directions API
  Future<Map<String, dynamic>> getDirections({
    required String origin,
    required String destination,
});
}
