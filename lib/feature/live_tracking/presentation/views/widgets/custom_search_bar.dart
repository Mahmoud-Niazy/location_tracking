import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/service_locator/srevice_locator.dart';
import 'package:live_tracking/core/utils/app_styles.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_cubit.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_states.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../../../../../core/widgets/circular_progress_indicator.dart';
import 'bottom_sheet_content.dart';

class CustomSearchBar extends StatelessWidget {
  final String title;
  final void Function(String)? onQueryChanged;
  final FloatingSearchBarController controller;

  const CustomSearchBar({
    super.key,
    required this.title,
    required this.onQueryChanged,
    required this.controller,
  });

  Future<void> onPressOnPrediction({
    required MapCubit cubit,
    required String placeId,
    required BuildContext context,
  }) async {
    await cubit.getPlaceDetails(placeId);
    controller.close();
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return BlocProvider.value(
            value: serviceLocator<MapCubit>(),
            child: BottomSheetContent(),
          );
        },
      );
      await cubit.getJourneyDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: controller,
      hint: title,
      scrollPadding: const EdgeInsets.only(
        top: 16,
        bottom: 56,
        right: 15,
        left: 15,
      ),
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: onQueryChanged,
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(showIfClosed: false),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: BlocBuilder<MapCubit, MapStates>(
              builder: (context, state) {
                var cubit = context.read<MapCubit>();
                if (state is GetPredictionsLoadingState) {
                  return CustomCircularProgressIndicator();
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: cubit.predictions.asMap().entries.map((p) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await onPressOnPrediction(
                                  cubit: cubit,
                                  placeId: p.value.placeId,
                                  context: context,
                                );
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        p.value.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.style16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (p.key < cubit.predictions.length - 1)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
                                child: Divider(color: Colors.black12),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
