
import 'package:dttassessment/utils/constants.dart';
import 'package:dttassessment/widgets/empty_list.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:dttassessment/models/house_model.dart';
import 'package:dttassessment/theme/colors.dart';
import 'package:dttassessment/pages/details.dart';

class ListViewWidget extends StatelessWidget {
  final List<House> houseList;
  final String searchText;
  final bool distanceCanBeVisible;
  const ListViewWidget({super.key, required this.houseList, required this.searchText, required this.distanceCanBeVisible});

  List<House> get filteredHouseList {
    // Filter the houseList based on searchText
    if (searchText.isEmpty) {
      return houseList;
    } else {
      return houseList.where((house) {
        //We are splitting our search query with white spaces(" ") to be able to search via the city name and/or postal code
        List<String> searchTextArr = searchText.toLowerCase().split(RegExp(r'(?<=\D)\s'));
        //If we have three or more values in our splitted array that means the city name entered is more than one word, so we need combine them in to one value
        if(searchTextArr.length >= 3){
          List<String> tempList = [];
          String cityName = "";
          for(String text in searchTextArr){
            if(text.isNotEmpty) {
              if (isIncludeNumber(text)) {
                tempList.add(text);
              } else {
                cityName = "$cityName$text ";
              }
            }
          }
          tempList.add(cityName.trimRight());
          searchTextArr = tempList;
        }

        //If our searching query is just one part then search only with city name or postal code
        if(searchTextArr.length == 1){
          final cityMatch = house.city.toLowerCase().contains(searchTextArr[0].toLowerCase());
          final postalCodeMatch = house.zip.toLowerCase().contains(searchTextArr[0].toLowerCase());
          return cityMatch || postalCodeMatch;
        }
        //If our searching query is more then one part then search with postal code and city name at the same time
        else{
          //To understand which is zip code we are making a simple regex operation
          if(isIncludeNumber(searchTextArr[0])) {
            final cityMatch = house.city.toLowerCase().contains(searchTextArr[1].toLowerCase());
            final postalCodeMatch = house.zip.toLowerCase().contains(searchTextArr[0].toLowerCase());
            return cityMatch && postalCodeMatch;
          }else{
            final cityMatch = house.city.toLowerCase().contains(searchTextArr[0].toLowerCase());
            final postalCodeMatch = house.zip.toLowerCase().contains(searchTextArr[1].toLowerCase());
            return cityMatch && postalCodeMatch;
          }
        }
      }).toList();
    }
  }

  bool isIncludeNumber(String str) {
    RegExp regex = RegExp(r'\d');
    return regex.hasMatch(str);
  }

  @override
  Widget build(BuildContext context) {

    if (filteredHouseList.isEmpty && searchText.isNotEmpty) {
      return const EmptyListWarning();
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
                    color: AppColors.lightGray,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: AppColors.white,
                ),
                height: 14.1.h,
                child: Padding(
                  padding: EdgeInsets.all(2.1.h),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: Constants.baseAPIUrl + house.image,
                        placeholder: (context, url) => SizedBox(
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
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${house.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',// Regular Expression for put commas to the amount of money
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'GothamSSm',
                                fontWeight: FontWeight.normal,
                                color: AppColors.strong,
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Text(
                              '${house.zip} ${house.city}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.medium,
                              ),
                            ),
                            const SizedBox(height: 33.0),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/Icons/ic_bed.svg',
                                  width: 2.h,
                                  height: 2.h,
                                  color: AppColors.medium,
                                ),
                                const SizedBox(width: 3.0),
                                Text(
                                  house.bedrooms.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.medium,
                                  ),
                                ),
                                const SizedBox(width: 24.0),
                                SvgPicture.asset(
                                  'assets/Icons/ic_bath.svg',
                                  width: 2.h,
                                  height: 2.h,
                                  color: AppColors.medium,
                                ),
                                const SizedBox(width: 3.0),
                                Text(
                                  house.bathrooms.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.medium,
                                  ),
                                ),
                                const SizedBox(width: 24.0),
                                SvgPicture.asset(
                                  'assets/Icons/ic_layers.svg',
                                  width: 2.h,
                                  height: 2.h,
                                  color: AppColors.medium,
                                ),
                                const SizedBox(width: 3.0),
                                Expanded(child:Text(
                                  house.size.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.medium,
                                  ),
                                )
                                ),
                                Visibility(
                                  visible: distanceCanBeVisible,
                                    child:SvgPicture.asset(
                                      'assets/Icons/ic_location.svg',
                                      width: 2.h,
                                      height: 2.h,
                                      color: AppColors.medium,
                                    ),
                                ),
                                const SizedBox(width: 3.0),
                                Visibility(
                                  visible: distanceCanBeVisible,
                                    child: Text(
                                      '${house.distance}km',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.medium,
                                      ),
                                    ),
                                )
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