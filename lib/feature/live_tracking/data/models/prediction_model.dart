class PredictionModel {
  final String description;
  final String placeId;

  PredictionModel({
    required this.description,
    required this.placeId,
});

  factory PredictionModel.fromJson(Map<String,dynamic> json){
    return PredictionModel(description: json['description'], placeId: json['place_id']);
  }
}