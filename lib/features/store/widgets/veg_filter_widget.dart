import 'package:sixam_mart_store/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class VegFilterWidget extends StatelessWidget {
//   final String? type;
//   final Function(String value)? onSelected;
//   const VegFilterWidget({super.key, required this.type, required this.onSelected});

//   @override
//   Widget build(BuildContext context) {
//     final bool ltr = Get.find<LocalizationController>().isLtr;

//     return (Get.find<SplashController>().configModel!.toggleVegNonVeg!
//     && Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg!) ? Align(alignment: Alignment.center, child: Container(
//       height: 30,
//       margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
//         border: Border.all(color: Theme.of(context).primaryColor),
//       ),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: Get.find<StoreController>().itemTypeList.length,
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () => onSelected!(Get.find<StoreController>().itemTypeList[index]),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.horizontal(
//                   left: Radius.circular(
//                     ltr ? index == 0 ? Dimensions.radiusSmall : 0
//                         : index == Get.find<StoreController>().itemTypeList.length-1
//                         ? Dimensions.radiusSmall : 0,
//                   ),
//                   right: Radius.circular(
//                     ltr ? index == Get.find<StoreController>().itemTypeList.length-1
//                         ? Dimensions.radiusSmall : 0 : index == 0
//                         ? Dimensions.radiusSmall : 0,
//                   ),
//                 ),
//                 color: Get.find<StoreController>().itemTypeList[index] == type ? Theme.of(context).primaryColor
//                     : Theme.of(context).cardColor,
//               ),
//               child: Text(
//                 Get.find<StoreController>().itemTypeList[index].tr,
//                 style: Get.find<StoreController>().itemTypeList[index] == type
//                     ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor)
//                     : robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
//               ),
//             ),
//           );
//         },
//       ),
//     )) : const SizedBox();
//   }
// }


class VegFilterWidget extends StatelessWidget {
  final String? type;
  final Function(String value)? onSelected;

  const VegFilterWidget({
    super.key,
    required this.type,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> itemTypeList = Get.find<StoreController>().itemTypeList;

    return (Get.find<SplashController>().configModel!.toggleVegNonVeg! &&
            Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg!)
        ? Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                onSelected?.call(value);
              },
              itemBuilder: (context) {
                return itemTypeList.map((item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(
                      item.tr,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: item == type
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  );
                }).toList();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: Dimensions.paddingSizeSmall,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        type ?? "Select Filter",
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColor),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
