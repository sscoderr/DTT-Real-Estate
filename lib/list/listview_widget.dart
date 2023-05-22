import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:dttassessment/list/house_item_structure.dart';
import 'package:dttassessment/theme/colors.dart';
import 'package:dttassessment/details.dart';

class ListViewWidget extends StatelessWidget {
  final List<House> houseList;
  final String searchText;
  final String baseUrl = 'https://intern.d-tt.nl';
  final appColors = AppColors();
  ListViewWidget({required this.houseList, required this.searchText});

  List<House> get filteredHouseList {
    // Filter the houseList based on searchText
    if (searchText.isEmpty) {
      return houseList;
    } else {
      return houseList.where((house) {
        final cityMatch = house.city.toLowerCase().contains(
            searchText.toLowerCase());
        final postalCodeMatch = house.zip.toLowerCase().contains(
            searchText.toLowerCase());
        return cityMatch || postalCodeMatch;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {

    if (filteredHouseList.isEmpty && searchText.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Images/search_state_empty.png',
              width: 200,
              height: 200,
            ),
            Text(
              'No results found! \nPerhaps try another search?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: appColors.medium),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: filteredHouseList.length,
        itemBuilder: (BuildContext context, int index) {
          final house = filteredHouseList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailsPage(selectedItem: house,distance: house.distance.toString())),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.75.h, horizontal: 4.2.w),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: appColors.lightGray,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: appColors.white,
                ),
                height: 14.1.h,
                child: Padding(
                  padding: EdgeInsets.all(2.1.h),
                  child: Row(
                    children: [
                      Container(
                        child: CachedNetworkImage(
                          imageUrl: baseUrl + house.image,
                          placeholder: (context, url) => Container(
                            width: 22.w,
                            height: 20.h,
                          ),
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                width: 22.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover
                                  ),
                                ),
                              ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$' + house.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),// Regular Expression for put commas to the amount of money
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'GothamSSm',
                                fontWeight: FontWeight.normal,
                                color: appColors.strong,
                              ),
                            ),
                            SizedBox(height: 3.0),
                            Text(
                              house.zip +' '+ house.city,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: appColors.medium,
                              ),
                            ),
                            SizedBox(height: 35.0),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/Icons/ic_bed.svg',
                                  width: 2.h,
                                  height: 2.h,
                                  color: appColors.medium,
                                ),
                                SizedBox(width: 3.0),
                                Text(
                                  house.bedrooms.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: appColors.medium,
                                  ),
                                ),
                                SizedBox(width: 24.0),
                                SvgPicture.asset(
                                  'assets/Icons/ic_bath.svg',
                                  width: 2.h,
                                  height: 2.h,
                                  color: appColors.medium,
                                ),
                                SizedBox(width: 3.0),
                                Text(
                                  house.bathrooms.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: appColors.medium,
                                  ),
                                ),
                                SizedBox(width: 24.0),
                                SvgPicture.asset(
                                  'assets/Icons/ic_layers.svg',
                                  width: 2.h,
                                  height: 2.h,
                                  color: appColors.medium,
                                ),
                                SizedBox(width: 3.0),
                                Expanded(child:Text(
                                  house.size.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: appColors.medium,
                                  ),
                                )
                                ),
                                SvgPicture.asset(
                                  'assets/Icons/ic_location.svg',
                                  width: 2.h,
                                  height: 2.h,
                                  color: appColors.medium,
                                ),
                                SizedBox(width: 3.0),
                                Text(
                                  house.distance.toString() + 'km',
                                  style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                    color: appColors.medium,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}