abstract class MapStates {}

class MapInitialState extends MapStates{}

class MapLoading extends MapStates{}

class UpdateCurrentLocation extends MapStates{}

class PermissionDenied extends MapStates{}


class MapErrorState extends MapStates{}

class GetPredictionsLoadingState extends MapStates{}
class GetPredictionsSuccessState extends MapStates{}

class GetPlaceDetailsLoadingState extends MapStates{}
class GetPlaceDetailsSuccessState extends MapStates{}

class GetDirectionsLoadingState extends MapStates{}
class GetDirectionsSuccessState extends MapStates{}

class GetJourneyDetailsLoadingState extends MapStates{}
class GetJourneyDetailsSuccessState extends MapStates{}



