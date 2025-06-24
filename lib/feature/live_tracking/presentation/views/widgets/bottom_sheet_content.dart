import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/utils/app_styles.dart';
import 'package:live_tracking/core/widgets/circular_progress_indicator.dart';
import 'package:live_tracking/core/widgets/custom_button.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_cubit.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_states.dart';
import 'package:live_tracking/feature/live_tracking/presentation/views/widgets/points_list.dart';

class BottomSheetContent extends StatelessWidget {
  const BottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapStates>(
      builder: (context, state) {
        var cubit = context.read<MapCubit>();
        if (state is GetPredictionsLoadingState) {
          return CustomCircularProgressIndicator();
        }
        return Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(cubit.from ?? '', style: AppStyles.style15),
              SizedBox(height: 10),
              SizedBox(
                width: 10,
                height: 100,
                child: PointsList(),
              ),
              SizedBox(height: 10),
              Text(cubit.to ?? '', style: AppStyles.style15),
              SizedBox(height: 30),
              CustomButton(title: "تأكيد الرحلة", onPressed: () {}),
            ],
          ),
        );
      },
    );
  }
}
