import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_cubit.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_states.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => MapCubit()..getCurrentLocation(),
        child: BlocBuilder<MapCubit, MapStates>(
          builder: (context, state) {
            var cubit = context.read<MapCubit>();
            if(state is MapLoading){
              return Center(child: CircularProgressIndicator());
            }
            if(state is PermissionDenied){
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
            return GoogleMap(
              markers: cubit.markers,
              initialCameraPosition: CameraPosition(
                target: cubit.currentPosition!,
                zoom: 20,
              ),
            );
          },
        ),
      ),
    );
  }
}
