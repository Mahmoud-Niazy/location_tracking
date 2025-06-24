import 'package:flutter/material.dart';

import '../../../../../core/utils/app_constance.dart';

class PointsList extends StatelessWidget{
  const PointsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          width: 10,
          height: 15,
          decoration: BoxDecoration(
            color: AppConstance.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 5);
      },
      itemCount: 5,
    );
  }
}