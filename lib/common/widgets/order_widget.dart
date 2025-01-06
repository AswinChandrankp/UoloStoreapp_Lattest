import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool hasDivider;
  final bool isRunning;
  final bool showStatus;
  const OrderWidget({super.key, required this.orderModel, required this.hasDivider, required this.isRunning, this.showStatus = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(orderModel.id), /*arguments: OrderDetailsScreen(
          orderModel: orderModel, isRunningOrder: isRunning,
        )*/),
        child: Container(
           decoration: BoxDecoration(
             color: Theme.of(context).cardColor,
             borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
             border: Border.all(width: 1, color: Theme.of(context).disabledColor),
             
           ),
          child: Column(children: [
          
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Text('${'order_id'.tr}: #${orderModel.id}', style: TextStyle(
                  //   fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold
                  // )),

                  RichText(
  text: TextSpan(
    text: '${'order_id'.tr} : ',
    style: TextStyle(
      fontSize: Dimensions.fontSizeLarge,
      color: Theme.of(context).disabledColor,
      fontWeight: FontWeight.bold,
    ),
    children: [
      TextSpan(
        text: '#${orderModel.id}',
        style: TextStyle(
          fontSize: Dimensions.fontSizeExtraLarge + 2,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  ),
),

 const SizedBox(height: 10),
                  Text(
                          orderModel.customer!.fName!.tr,
                          style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                        ),
                  const SizedBox(height: 50),
                   Row(
                     children: [
                       Text("Payment Status  : ".tr, style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                       Text(
                          orderModel.paymentStatus!.tr,
                          style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        ),
                     ],
                   ),
                  Row(children: [
                    Text(
                      DateConverterHelper.dateTimeStringToDateTime(orderModel.createdAt!),
                      style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    ),
                    Container(
                      height: 10, width: 1, color: Theme.of(context).disabledColor,
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    ),

                   
                    Text(
                      orderModel.orderType!.tr,
                      style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                    ),
                  ]),
                ])),
          
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
      
                    Row(
                      children: [

                        Icon(Icons.payments, size: 25, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 5),
                        Text(orderModel.orderAmount.toString(), style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 80),
                  
                    !showStatus ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault + 5, vertical: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color:  orderModel.orderStatus!.toLowerCase() == 'Pending'.toLowerCase() ? const Color.fromARGB(255, 165, 18, 8): Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      alignment: Alignment.center,
                      child: Builder(
                        builder: (context) {
                          return Text(
                            orderModel.orderStatus!.tr,
                            style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color:   orderModel.orderStatus!.toLowerCase() == 'Pending'.toLowerCase() ? Colors.white : Theme.of(context).primaryColor),
                          );
                        }
                      ),
                    ) : Text(
                      '${orderModel.detailsCount} ${orderModel.detailsCount! < 2 ? 'item'.tr : 'items'.tr}',
                      style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    ),
                  ],
                ),
          
                // showStatus ? const SizedBox() : Icon(Icons.keyboard_arrow_right, size: 30, color: Theme.of(context).primaryColor),
          
              ]),
            ),
          
            // hasDivider ? Divider(color: Theme.of(context).disabledColor) : const SizedBox(),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(
                     color: Theme.of(context).primaryColor,
                     borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                width: double.infinity,
             
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child:   Center(child: Text(  "${ orderModel.orderStatus!.toLowerCase() == 'Pending'.toLowerCase() ? 'View Order' : 'View Order'}".tr, style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor))),
                
              ),
            )
          
          ]),
        ),
      ),
    );
  }
}




