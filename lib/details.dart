import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:dttassessment/home.dart';
import 'package:dttassessment/list/house_item_structure.dart';
import 'package:dttassessment/theme/colors.dart';

void main() {
  final House fakeItem = House(
    id: 1,
    price: 1,
    image: '',
    zip: '',
    bathrooms: 1,
    bedrooms: 1,
    size: 1,
    city: '',
    description: '',
    latitude: 1,
    longitude: 2,
    distance: 0,
  );

  runApp(Sizer(builder: (context, orientation, deviceType) {
    return MaterialApp(
      home: DetailsPage(
        selectedItem: fakeItem,
        distance: '',
      ),
    );
  }));

}


class DetailsPage extends StatelessWidget {
  final House selectedItem;
  final String distance;
  final String baseUrl = 'https://intern.d-tt.nl';
  final appColors = AppColors();

  DetailsPage({required this.selectedItem, required this.distance});


  void _launchMapsApp(double latitude, double longitude) async {
    String mapsUrl;
    if (Platform.isAndroid) {
      mapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    } else if (Platform.isIOS) {
      mapsUrl = 'http://maps.apple.com/?daddr=$latitude,$longitude';
    } else {
      throw 'Platform not supported.';
    }

    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      throw 'Could not launch maps app.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 25.h,
            width: 100.w,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: baseUrl + selectedItem.image,
                  fit: BoxFit.cover,
                  width: 100.w,
                  height: 25.h,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Positioned(
                  top: 3.h,
                  left: 2.w,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              transform: Matrix4.translationValues(0.0, -10.0, 0.0),
              decoration: BoxDecoration(
                color: appColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child:Text(
                            '\$' + selectedItem.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), // Regular Expression for put commas to the amount of money
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'GothamSSm',
                              fontWeight: FontWeight.w400,
                              color: appColors.strong,
                            ),
                          )
                        ),
                        SizedBox(width: 8.4.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              'assets/Icons/ic_bed.svg',
                              width: 2.h,
                              height: 2.h,
                              color: appColors.medium,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              selectedItem.bedrooms.toString(),
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal,
                                color: appColors.medium,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            SvgPicture.asset(
                              'assets/Icons/ic_bath.svg',
                              width: 2.h,
                              height: 2.h,
                              color: appColors.medium,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              selectedItem.bathrooms.toString(),
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal,
                                color: appColors.medium,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            SvgPicture.asset(
                              'assets/Icons/ic_layers.svg',
                              width: 2.h,
                              height: 2.h,
                              color: appColors.medium,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              selectedItem.size.toString(),
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal,
                                color: appColors.medium,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            SvgPicture.asset(
                              'assets/Icons/ic_location.svg',
                              width: 2.h,
                              height: 2.h,
                              color: appColors.medium,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              distance.toString() + ' km',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal,
                                color: appColors.medium,
                              ),
                            ),
                          ]
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: appColors.strong,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      selectedItem.description,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                        color: appColors.medium,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: appColors.strong,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) {

                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(selectedItem.latitude.toDouble(), selectedItem.longitude.toDouble()),
                          zoom: 12,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('targetMarker'),
                            position: LatLng(selectedItem.latitude.toDouble(), selectedItem.longitude.toDouble()),
                            infoWindow: InfoWindow(title: 'House Location'),
                            onTap: () {
                              _launchMapsApp(selectedItem.latitude.toDouble(), selectedItem.longitude.toDouble());
                            }
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
