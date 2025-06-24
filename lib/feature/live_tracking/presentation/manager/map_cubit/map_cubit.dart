import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/core/location_services/locations_services.dart';
import 'package:live_tracking/feature/live_tracking/data/models/prediction_model.dart';
import 'package:live_tracking/feature/live_tracking/domain/use_cases/get_directions_use_case.dart';
import 'package:live_tracking/feature/live_tracking/domain/use_cases/get_place_details_use_case.dart';
import 'package:live_tracking/feature/live_tracking/domain/use_cases/get_predictions_use_case.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_states.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../../../data/models/direction_model.dart';

class MapCubit extends Cubit<MapStates> {
  final GetPredictionsUseCase getPredictionsUseCase;
  final GetPlaceDetailsUseCase getPlaceDetailsUseCase;
  final GetDirectionsUseCase getDirectionsUseCase;

  MapCubit(
    this.getDirectionsUseCase,
    this.getPlaceDetailsUseCase,
    this.getPredictionsUseCase,
  ) : super(MapInitialState());

  // LatLng endPosition = LatLng(30.956429345130598, 31.25279869884253);

  LatLng? currentPosition;
  double carDegree = 0.0;

  getCurrentLocation() async {
    emit(MapLoading());
    currentPosition = await LocationServices.shared.getCurrentLocation();
    if (currentPosition == null) {
      emit(PermissionDenied());
      return;
    }
    // addMarker(id: '2', position: endPosition);
    await loadMarkerIcon();
    LocationServices.shared.getLocationUpdates();
    FBroadcast.instance().register("update_location", (value, callback) {
      carDegree = LocationServices.calculateDegrees(
        LatLng(currentPosition!.latitude, currentPosition!.longitude),
        LatLng(value.latitude, value.longitude),
      );
      currentPosition = LatLng(value.latitude, value.longitude);
      addMarker(
        position: currentPosition!,
        id: '1',
        icon: carIcon,
        rotation: carDegree,
      );
      emit(UpdateCurrentLocation());
    });
  }

  Set<Marker> markers = {};

  addMarker({
    required String id,
    required LatLng position,
    AssetMapBitmap? icon,
    double? rotation,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId(id),
        rotation: rotation ?? 0,
        position: position,
        icon: icon ?? BitmapDescriptor.defaultMarker,
      ),
    );
  }

  AssetMapBitmap? carIcon;

  Future<void> loadMarkerIcon() async {
    carIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(45, 45)), // Adjust size as needed
      'assets/images/car.png',
    );
  }

  /// Google APIS

  List<PredictionModel> predictions = [];
  FloatingSearchBarController placeSearchController =
      FloatingSearchBarController();

  Future<void> getPredictions() async {
    emit(GetPredictionsLoadingState());
    try {
      predictions = await getPredictionsUseCase.execute(
        placeSearchController.query,
      );
      emit(GetPredictionsSuccessState());
    } catch (error) {
      emit(MapErrorState());
    }
  }

  LatLng? searchedPlaceLocation;

  Future<void> getPlaceDetails(String placeId) async {
    emit(GetPlaceDetailsLoadingState());
    try {
      searchedPlaceLocation = await getPlaceDetailsUseCase.execute(placeId);
      emit(GetPlaceDetailsSuccessState());
    } catch (error) {
      emit(MapErrorState());
    }
  }

  DirectionModel? direction;

  Future<void> getDirections() async {
    emit(GetDirectionsLoadingState());
    try{
      direction = await getDirectionsUseCase.execute(
        origin: "${currentPosition!.latitude},${currentPosition!.longitude}",
        destination: "${searchedPlaceLocation!.latitude},${searchedPlaceLocation!.longitude}",
      );
      emit(GetDirectionsSuccessState());
    }
    catch(error){
      emit(MapErrorState());
    }
  }

  String? from ;
  String? to;
  Future<void> getJourneyDetails()async{
    emit(GetJourneyDetailsLoadingState());
    try{
      from = await LocationServices.getLocationName(currentPosition!);
      to = await LocationServices.getLocationName(searchedPlaceLocation!);
      emit(GetJourneyDetailsSuccessState());
    }
    catch(error){
      emit(MapErrorState());
    }
  }
}
