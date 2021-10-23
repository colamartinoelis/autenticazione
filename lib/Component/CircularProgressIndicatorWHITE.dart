import 'package:flutter/material.dart';



class CircularProgressIndicatorWHITE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: 15,
      height: 15,
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: Colors.white,
        ),
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  }
}
