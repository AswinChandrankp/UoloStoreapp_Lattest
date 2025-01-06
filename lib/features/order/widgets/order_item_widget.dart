import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderModel? order;
  final OrderDetailsModel orderDetails;
  const OrderItemWidget({super.key, required this.order, required this.orderDetails});
  
  @override
  Widget build(BuildContext context) {
    String addOnText = '';
    for (var addOn in orderDetails.addOns!) {
      addOnText = '$addOnText${(addOnText.isEmpty) ? '' : ',  '}${addOn.name} (${addOn.quantity})';
    }

    String variationText = '';
    if(orderDetails.variation!.isNotEmpty) {
      if(orderDetails.variation!.isNotEmpty) {
        List<String> variationTypes = orderDetails.variation![0].type!.split('-');
        if(variationTypes.length == orderDetails.itemDetails!.choiceOptions!.length) {
          int index = 0;
          for (var choice in orderDetails.itemDetails!.choiceOptions!) {
            variationText = '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
            index = index + 1;
          }
        }else {
          variationText = orderDetails.itemDetails!.variations![0].type!;
        }
      }
    }else if(orderDetails.foodVariation!.isNotEmpty) {
      for(FoodVariation variation in orderDetails.foodVariation!) {
        variationText += '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
        for(VariationValue value in variation.variationValues!) {
          variationText += '${variationText.endsWith('(') ? '' : ', '}${value.level}';
        }
        variationText += ')';
      }
    }
    
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        // orderDetails.itemDetails!.imageFullUrl != null ? ClipRRect(
        //   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        //   child: CustomImageWidget(
        //     height:60, width: 60, fit: BoxFit.cover,
        //     image: '${orderDetails.itemDetails!.imageFullUrl}',
        //   ),
        // ) : const SizedBox(),
        // SizedBox(width: orderDetails.itemDetails!.imageFullUrl != null ? Dimensions.paddingSizeSmall : 0),
   SizedBox(width: 5,),
        Expanded(

          child: Column(crossAxisAlignment: CrossAxisAlignment.start
          
          , children: [
            Row(children: [
              
  // Text('')
              // Icon(Icons.square.dot)
             Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                 border: Border.all(
                  color:  orderDetails.itemDetails!.veg != 0  ||  orderDetails.itemDetails!.unitType == "Veg"  ? Colors.green : Colors.redAccent
                 )  ,
                // color: orderDetails.itemDetails!.veg != 0  ||  orderDetails.itemDetails!.unitType == "Veg"  ? Colors.green : Colors.redAccent
              ),
               child: Padding(
                 padding: const EdgeInsets.all(1),
                 child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                     color:  orderDetails.itemDetails!.veg != 0  ||  orderDetails.itemDetails!.unitType == "Veg"  ? Colors.green : Colors.redAccent,
                     borderRadius: BorderRadius.circular(50)
                  ),
                 
                 ),
               ),
             ),
                SizedBox(width: 5,),
              Expanded(child: Text(
                " ${ orderDetails.quantity}  X ${orderDetails.itemDetails!.name!}",
                
                style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              )),
              // Text('${'quantity'.tr}:', style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              // Text(
              //   orderDetails.quantity.toString(),
              //   style: PoppinsMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
              // ),
            ]),

             variationText.isNotEmpty ? Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ 
          // const SizedBox(width: 60),
          Text('${'variations'.tr}: ', style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).disabledColor )),
          Flexible(child: Text(
              variationText,
              style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,
          ))),
        ]),
      ) : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(children: [
              Expanded(child: Text(
                PriceConverterHelper.convertPrice(orderDetails.price),
                style: PoppinsMedium,
              )),
              // ((Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && orderDetails.itemDetails!.unitType != null)
              // || (Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!)) ? Container(
              //   padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              //     color: Theme.of(context).primaryColor.withOpacity(0.1),
              //   ),
              //   child: Text(
              //     Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! ? orderDetails.itemDetails!.unitType ?? ''
              //         : orderDetails.itemDetails!.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
              //     style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
              //   ),
              // ) : const SizedBox(),
            ]),

          ]),
        ),
      ]),

      addOnText.isNotEmpty ? Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
        child: Row(children: [
          const SizedBox(width: 70),
          Text('${'addons'.tr}: ', style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
          Flexible(child: Text(
              addOnText,
              style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
          ))),
        ]),
      ) : const SizedBox(),

      // variationText.isNotEmpty ? Padding(
      //   padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
      //   child: Row(children: [
      //     const SizedBox(width: 60),
      //     Text('${'variations'.tr}: ', style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
      //     Flexible(child: Text(
      //         variationText,
      //         style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
      //     ))),
      //   ]),
      // ) : const SizedBox(),

      const Divider(height: Dimensions.paddingSizeLarge),
      const SizedBox(height: Dimensions.paddingSizeSmall),
    ]);
  }
}
