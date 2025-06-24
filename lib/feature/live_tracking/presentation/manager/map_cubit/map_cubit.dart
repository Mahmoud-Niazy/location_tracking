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
  FloatingSearchBarController placeSearchController = FloatingSearchBarController();
  Future<void> getPredictions() async {
    emit(GetPredictionsLoadingState());
    try{
      predictions = await getPredictionsUseCase.execute(placeSearchController.query);
      emit(GetPredictionsSuccessState());
    }
    catch(error){
      emit(MapErrorState());
    }
  }
}
