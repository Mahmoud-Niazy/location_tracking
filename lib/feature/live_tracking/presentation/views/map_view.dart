import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/core/service_locator/srevice_locator.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_cubit.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_states.dart';
import 'package:live_tracking/feature/live_tracking/presentation/views/widgets/custom_search_bar.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => serviceLocator<MapCubit>()..getCurrentLocation(),
        child: BlocBuilder<MapCubit, MapStates>(
          builder: (context, state) {
            var cubit = context.read<MapCubit>();
            if (state is MapLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is PermissionDenied) {
              return Center(
                child: Text(
                  'Permissions Denied',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return Stack(
              children: [
                GoogleMap(
                  markers: cubit.markers,
                  initialCameraPosition: CameraPosition(
                    target: cubit.currentPosition!,
                    zoom: 20,
                  ),
                ),
                CustomSearchBar(
                  controller: cubit.placeSearchController,
                  title: 'Search',
                  onQueryChanged: (search)async{
                    await cubit.getPredictions();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
