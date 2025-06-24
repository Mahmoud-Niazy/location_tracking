import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_cubit.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_states.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class CustomSearchBar extends StatelessWidget {
  final String title;
  final void Function(String)? onQueryChanged;
  final FloatingSearchBarController controller;

  const CustomSearchBar(
      {super.key, required this.title, required this.onQueryChanged,required this.controller});

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
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
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
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: cubit.predictions.asMap().entries.map((p){
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                p.value.description
                              ),
                            ),
                            if(p.key < cubit.predictions.length - 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30
                              ),
                              child: Divider(
                                color: Colors.black12,
                              ),
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