import 'dart:async';

import 'package:sixam_mart_store/common/widgets/order_card_new.dart';
import 'package:sixam_mart_store/common/widgets/order_shimmer_widget.dart';
import 'package:sixam_mart_store/common/widgets/order_widget.dart';
import 'package:sixam_mart_store/features/menu/screens/menu_screen.dart';
import 'package:sixam_mart_store/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/features/home/widgets/order_button_widget.dart';
import 'package:sixam_mart_store/features/order/widgets/count_widget.dart';
import 'package:sixam_mart_store/features/order/widgets/order_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}




  

  



class _OrderScreenState extends State<OrderScreen> {
  @override

  Timer? _timer;

  @override
  void initState() {
    super.initState();

     if (Get.find<OrderController>().runningOrderList != null) {
         print('--------------------------------------------------------orders--Empty----Fetching orders...-----------------------------------------------');
        Get.find<OrderController>().getCurrentOrders() ;
        
      } else {
        print('--------------------------------------------------------orders--Exists...-----------------------------------------------');
      }

       Future.delayed(Duration(seconds: 120), () {
          //  startTimer(); 
       });
  

  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5
    ), (timer) {
     

     print('--------------------------------------------------------fetching orders in each ${ timer.tick } seconds...-----------------------------------------------');
 Get.find<OrderController>().getCurrentOrders() ;
//  Get.find<OrderController>().getPaginatedOrders(1, true);
    
     
     
   
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    super.dispose();
  }
  Widget build(BuildContext context) {

    
    Get.find<OrderController>().getPaginatedOrders(1, true);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor ,
      appBar:
       AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // leading: Padding(
        //   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        //   child: Text("Uolo"),
        // ),
        titleSpacing: 0,
        surfaceTintColor: Theme.of(context).cardColor,
        shadowColor: Theme.of(context).disabledColor.withOpacity(0.5),
        elevation: 0,
        title: Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Text("Uolo", style: PoppinsRegular.copyWith(color:  Theme.of(context).cardColor, fontSize: 30,fontWeight: FontWeight.w900)),
        ),
        actions: [IconButton(
          icon: GetBuilder<NotificationController>(builder: (notificationController) {
            return Stack(children: [
              Icon(Icons.notifications, size: 25, color: Theme.of(context).cardColor),
              notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
                height: 10, width: 10, decoration: BoxDecoration(
                color: Theme.of(context).cardColor, shape: BoxShape.circle,
                border: Border.all(width: 1, color: Theme.of(context).cardColor),
              ),
              )) : const SizedBox(),
            ]);
          }),
          onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
        ),
        IconButton(
          icon: GetBuilder<NotificationController>(builder: (notificationController) {
            return Stack(children: [
              Icon(Icons.menu, size: 25, color: Theme.of(context).cardColor),
              // notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
              //   height: 10, width: 10, decoration: BoxDecoration(
              //   color: Colors.redAccent, shape: BoxShape.circle,
              //   border: Border.all(width: 1, color: Theme.of(context).cardColor),
                
              // ),
              // )) : const SizedBox(),
            ]);
          }),
          onPressed: () =>    Get.bottomSheet(const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true)),
        
        
        ],
      ),
      //  CustomAppBarWidget(title: 'order_history'.tr, isBackButtonExist: false),
      body: GetBuilder<OrderController>(builder: (orderController) {
        return Get.find<ProfileController>().modulePermission!.order! ? Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: SingleChildScrollView(
            child: Column(children: [
            
              // GetBuilder<ProfileController>(builder: (profileController) {
              //   return profileController.profileModel != null ? Container(
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).primaryColor,
              //       borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              //     ),
              //     child: Row(children: [
              //       CountWidget(title: 'today'.tr, count: profileController.profileModel!.todaysOrderCount),
              //       CountWidget(title: 'this_week'.tr, count: profileController.profileModel!.thisWeekOrderCount),
              //       CountWidget(title: 'this_month'.tr, count: profileController.profileModel!.thisMonthOrderCount),
              //     ]),
              //   ) : const SizedBox();
              // }),
              // const SizedBox(height: Dimensions.paddingSizeLarge),
            
              // Container(
              //   height: 40,
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Theme.of(context).disabledColor, width: 1),
              //     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              //   ),
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: orderController.statusList.length,
              //     itemBuilder: (context, index) {
              //       return OrderButtonWidget(
              //         title: orderController.statusList[index].tr, index: index, orderController: orderController, fromHistory: true,
              //       );
              //     },
              //   ),
              // ),
              // SizedBox(height: orderController.historyOrderList != null ? Dimensions.paddingSizeSmall : 0),
            
              // Expanded(
              //   child: orderController.historyOrderList != null ? orderController.historyOrderList!.isNotEmpty
              //       ? const OrderViewWidget() : Center(child: Text('no_order_found'.tr)) : const Center(child: CircularProgressIndicator()),
              // ),
            
            
              GetBuilder<ProfileController>(builder: (profileController){
                  return GetBuilder<OrderController>(builder: (orderController) {
                      List<OrderModel> orderList = [];
                      if(orderController.runningOrders != null) {
                        orderList = orderController.runningOrders![orderController.orderIndex].orderList;
                      }
                  
                      return profileController.modulePermission != null ? Get.find<ProfileController>().modulePermission!.order! ? Column(children: [
                  
                        orderController.runningOrders != null ? Container(
                          height: 40,
                          decoration: BoxDecoration(
                            // border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: orderController.runningOrders!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 5,right: 5),
                                child: OrderButtonWidget(
                                  title: orderController.runningOrders![index].status.tr, index: index,
                                  orderController: orderController, fromHistory: false,
                                ),
                              );
                            },
                          ),
                        ) : const SizedBox(),
                   SizedBox(  height: 10,),
                        // orderController.runningOrders != null ? Padding(
                        //   padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall),
                        //   child: InkWell(
                        //     onTap: () => orderController.toggleCampaignOnly(),
                        //     child: Row(children: [
                        //       SizedBox(
                        //         height: 24, width: 24,
                        //         child: Checkbox(
                        //           side: BorderSide(color: Theme.of(context).disabledColor, width: 1),
                        //           activeColor: Theme.of(context).primaryColor,
                        //           value: orderController.campaignOnly,
                        //           onChanged: (isActive) => orderController.toggleCampaignOnly(),
                        //         ),
                        //       ),
                        //       const SizedBox(width: Dimensions.paddingSizeSmall),
                  
                        // //       Text(
                        //         'campaign_order'.tr,
                        //         style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        //       ),
                        //     ]),
                        //   ),
                        // ) : const SizedBox(),
                  
                        orderController.runningOrders != null ? orderList.isNotEmpty ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            return OrderWidget(orderModel: orderList[index], hasDivider: index != orderList.length-1, isRunning: true);
                          },
                        ) : Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: Dimensions.paddingSizeLarge),
                          child: Center(child: Text('no_order_found'.tr)),
                        ) : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return OrderShimmerWidget(isEnabled: orderController.runningOrders == null);
                          },
                        ),
                  
                      ]) : Center(child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Text('you_have_no_permission_to_access_this_feature'.tr, style: PoppinsMedium),
                      )) : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return OrderShimmerWidget(isEnabled: orderController.runningOrders == null);
                        },
                      );
                    });
                }
              ),
            
             
             
            ]),
          ),
        ) : Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: PoppinsMedium));
      }),
    );
  }
}

