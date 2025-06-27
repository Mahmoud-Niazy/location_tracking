import 'dart:async';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/core/location_services/locations_services.dart';
import 'package:live_tracking/core/utils/app_constance.dart';
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
  late GoogleMapController mapController;

  Future<void> zoomToFitPolyline(
    List<LatLng> polylinePoints, {
    double padding = 100.0,
  }) async {
    if (polylinePoints.isEmpty) return;

    double minLat = polylinePoints.first.latitude;
    double maxLat = polylinePoints.first.latitude;
    double minLng = polylinePoints.first.longitude;
    double maxLng = polylinePoints.first.longitude;

    for (LatLng point in polylinePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, padding);

    await mapController.animateCamera(cameraUpdate);
  }

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

  void addMarker({
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
  Set<Polyline> polylines = {};

  Future<void> getDirections() async {
    emit(GetDirectionsLoadingState());
    try {
      direction = await getDirectionsUseCase.execute(
        origin: "${currentPosition!.latitude},${currentPosition!.longitude}",
        destination:
            "${searchedPlaceLocation!.latitude},${searchedPlaceLocation!.longitude}",
      );
      if (direction != null) {
        polylines = getPolyline(direction!.polylinePoints);
      }
      addMarker(id: '2', position: searchedPlaceLocation!);
      emit(GetDirectionsSuccessState());
    } catch (error) {
      emit(MapErrorState());
    }
  }

  Set<Polyline> getPolyline(String points) {
    Set<Polyline> polylines = {};
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints.decodePolyline(points);
    List<LatLng> pointsAsLatLng = [];
    for (var p in result) {
      pointsAsLatLng.add(LatLng(p.latitude, p.longitude));
    }
    polylines.add(
      Polyline(
        polylineId: PolylineId('1'),
        points: pointsAsLatLng,
        width: 5,
        color: AppConstance.primaryColor,
      ),
    );
    zoomToFitPolyline(pointsAsLatLng);
    return polylines;
  }

  String? from;

  String? to;

  Future<void> getJourneyDetails() async {
    emit(GetJourneyDetailsLoadingState());
    try {
      from = await LocationServices.getLocationName(currentPosition!);
      to = await LocationServices.getLocationName(searchedPlaceLocation!);
      emit(GetJourneyDetailsSuccessState());
    } catch (error) {
      emit(MapErrorState());
    }
  }
}
