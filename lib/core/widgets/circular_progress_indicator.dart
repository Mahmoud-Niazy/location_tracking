import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget{
  const CustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(20),
      child: CircularProgressIndicator(),
    ));
  }
}