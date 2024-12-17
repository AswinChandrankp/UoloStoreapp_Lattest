import 'dart:async';

import 'package:sixam_mart_store/common/widgets/order_shimmer_widget.dart';
import 'package:sixam_mart_store/common/widgets/order_widget.dart';
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
    startTimer(); // Call the timer function here
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Fetch orders every 5 seconds
      print('------------------------------------------------------------Fetching orders...-----------------------------------------------');
      Get.find<OrderController>().getCurrentOrders();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
  Widget build(BuildContext context) {

    
    Get.find<OrderController>().getPaginatedOrders(1, true);

    return Scaffold(
      appBar:
       AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Image.asset(Images.logo, height: 30, width: 30),
        ),
        titleSpacing: 0,
        surfaceTintColor: Theme.of(context).cardColor,
        shadowColor: Theme.of(context).disabledColor.withOpacity(0.5),
        elevation: 2,
        title: Text(AppConstants.appName, maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoMedium.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeDefault,
        )),
        actions: [IconButton(
          icon: GetBuilder<NotificationController>(builder: (notificationController) {
            return Stack(children: [
              Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
              notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
                height: 10, width: 10, decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                border: Border.all(width: 1, color: Theme.of(context).cardColor),
              ),
              )) : const SizedBox(),
            ]);
          }),
          onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
        )],
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
                            border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: orderController.runningOrders!.length,
                            itemBuilder: (context, index) {
                              return OrderButtonWidget(
                                title: orderController.runningOrders![index].status.tr, index: index,
                                orderController: orderController, fromHistory: false,
                              );
                            },
                          ),
                        ) : const SizedBox(),
                  
                        orderController.runningOrders != null ? Padding(
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall),
                          child: InkWell(
                            onTap: () => orderController.toggleCampaignOnly(),
                            child: Row(children: [
                              SizedBox(
                                height: 24, width: 24,
                                child: Checkbox(
                                  side: BorderSide(color: Theme.of(context).disabledColor, width: 1),
                                  activeColor: Theme.of(context).primaryColor,
                                  value: orderController.campaignOnly,
                                  onChanged: (isActive) => orderController.toggleCampaignOnly(),
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),
                  
                              Text(
                                'campaign_order'.tr,
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                              ),
                            ]),
                          ),
                        ) : const SizedBox(),
                  
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
                        child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium),
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
        ) : Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium));
      }),
    );
  }
}

