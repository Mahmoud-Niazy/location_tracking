class DirectionModel {
  final String duration;
  final String distance;
  final String polylinePoints;

  DirectionModel({
    required this.duration,
    required this.distance,
    required this.polylinePoints,
});

  factory DirectionModel.fomJson(Map<String,dynamic> json){
    return DirectionModel(
        distance: json['legs'][0]['distance']['text'],
        duration: json['legs'][0]['duration']['text'],
        polylinePoints: json['overview_polyline'],
    );
  }
}