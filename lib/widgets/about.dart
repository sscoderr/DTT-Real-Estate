import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dttassessment/utils/constants.dart';
import 'package:dttassessment/theme/colors.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Greetings I am Sabahattin, a mobile app developer with four years of extensive experience in the field. I am also the person who developed DTT Real Estate app. Discover a new way to navigate the market with DTT Real Estate. '
                        'Effortlessly browse properties, access comprehensive info, and schedule viewings with ease. Stay ahead with regular updates driven by DTT\'s passion for innovation.'
                        ' Embrace the future of real estate today. With DTT Real Estate, you can effortlessly explore a vast range of properties, browse through stunning images, and access comprehensive information.'
                        ' Experience the ease of browsing stunning visuals, exploring detailed descriptions, and accessing crucial information such as pricing, location, and amenities. '
                        'DTT Real Estate goes beyond just listing properties. It embraces the essence of the Netherlands, highlighting the vibrant neighborhoods, cultural landmarks, and unique lifestyle offerings that make each location special. ',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                      color: AppColors.medium,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  const Text(
                    "Design and Development",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.strong,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                      children: [
                        Image.asset('assets/Images/dtt_banner.png'),
                        SizedBox(width: 6.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "by DTT",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                                color: AppColors.strong,
                              ),
                            ),
                            SizedBox(height: 0.3.h),
                            Center(
                              child: InkWell(
                                  child: const Text(
                                    "d-tt.nl",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  onTap: () => launchUrl(Uri.parse(Constants.dttHomeUrl))
                              ),
                            )
                          ],
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ),
        ]
    );
  }
}