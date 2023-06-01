import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dttassessment/theme/colors.dart';

class EmptyListWarning extends StatelessWidget {
  const EmptyListWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/Images/search_state_empty.png',
            width: 100.w,
            height: 25.h,
          ),
          const Text(
            'No results found! \nPerhaps try another search?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.w300,
                color: AppColors.medium),
          ),
        ],
      ),
    );
  }
}