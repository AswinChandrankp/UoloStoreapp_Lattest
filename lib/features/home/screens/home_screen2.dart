
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/home/widgets/ads_section_widget.dart';
import 'package:sixam_mart_store/features/home/widgets/order_button_widget.dart';
import 'package:sixam_mart_store/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/order/widgets/count_widget.dart';
import 'package:sixam_mart_store/features/order/widgets/order_view_widget.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Get.find<ProfileController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();
    await Get.find<NotificationController>().getNotificationList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
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

      body: RefreshIndicator(
        onRefresh: () async {
          await _loadData();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          physics: const AlwaysScrollableScrollPhysics(),
          child: GetBuilder<ProfileController>(builder: (profileController) {
            return GetBuilder<OrderController>(builder: (orderController) {
                return Column(children: [
                
                  Get.find<ProfileController>().modulePermission != null && Get.find<ProfileController>().modulePermission!.storeSetup! ? Row(children: [
                    Expanded(child: Text(
                      Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'restaurant_temporarily_closed'.tr : 'store_temporarily_closed'.tr, style: robotoMedium,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    )),
                    profileController.profileModel != null ? GetBuilder<OrderController>(builder: (orderController) {
                
                      bool isEnableTemporarilyClosed = false;
                
                      if(orderController.runningOrders != null) {
                        for(int i = 0; i < orderController.runningOrders!.length; i++) {
                          if(orderController.runningOrders?[i].status == 'confirmed' || orderController.runningOrders?[i].status == 'cooking'
                              || orderController.runningOrders?[i].status == 'ready_for_handover' || orderController.runningOrders?[i].status == 'food_on_the_way') {
                            if(orderController.runningOrders![i].orderList.isNotEmpty) {
                              isEnableTemporarilyClosed = true;
                              break;
                            }else {
                              isEnableTemporarilyClosed = false;
                            }
                          }
                        }
                      }
                
                      return Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: !profileController.profileModel!.stores![0].active!,
                          activeColor: Theme.of(context).primaryColor,
                          trackColor: Theme.of(context).primaryColor.withOpacity(0.5),
                          onChanged: (bool isActive) {
                            bool? showRestaurantText = Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText;
                            isEnableTemporarilyClosed ? Get.dialog(ConfirmationDialogWidget(
                              icon: Images.warning,
                              isOnNoPressedShow: false,
                              onYesButtonText: 'ok'.tr,
                              description: showRestaurantText! ? 'you_can_not_close_the_store_because_you_already_have_running_orders'.tr : 'you_can_not_close_the_store_because_you_already_have_running_orders'.tr,
                              onYesPressed: () {
                                Get.back();
                              },
                            )) : Get.dialog(ConfirmationDialogWidget(
                              icon: Images.warning,
                              description: isActive ? showRestaurantText! ? 'are_you_sure_to_close_restaurant'.tr : 'are_you_sure_to_close_store'.tr
                                : showRestaurantText! ? 'are_you_sure_to_open_restaurant'.tr : 'are_you_sure_to_open_store'.tr,
                              onYesPressed: () {
                                Get.back();
                                Get.find<AuthController>().toggleStoreClosedStatus();
                              },
                            ));
                          },
                        ),
                      );
                
                    }) : Shimmer(duration: const Duration(seconds: 2), child: Container(height: 30, width: 50, color: Colors.grey[300])),
                  ]) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                
                  profileController.modulePermission != null && profileController.modulePermission!.wallet! ? Row(children: [
                    Expanded(
                      child: Container(
                        height: 200,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                
                          Image.asset(Images.wallet, width: 70, height: 70),
                          const Spacer(),
                
                          Text(
                            'today'.tr,
                            style: robotoRegular.copyWith(color: Theme.of(context).cardColor.withOpacity(0.7)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(
                            profileController.profileModel != null ? PriceConverterHelper.convertPrice(profileController.profileModel!.todaysEarning) : '0',
                            style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
                          ),
                
                        ]),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity, height: 95,
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).primaryColor.withOpacity(0.8),
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                
                              Text(
                                'this_week'.tr,
                                style: robotoRegular.copyWith(color: Theme.of(context).cardColor.withOpacity(0.7)),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Text(
                                profileController.profileModel != null ? PriceConverterHelper.convertPrice(profileController.profileModel!.thisWeekEarning) : '0',
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                              ),
                
                            ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                
                          Container(
                            width: double.infinity, height: 95,
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                
                              Text(
                                'this_month'.tr,
                                style: robotoRegular.copyWith(color: Theme.of(context).cardColor.withOpacity(0.7)),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Text(
                                profileController.profileModel != null ? PriceConverterHelper.convertPrice(profileController.profileModel!.thisMonthEarning) : '0',
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                              ),
                
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ]) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                
                  const AdsSectionWidget(),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                
                GetBuilder<ProfileController>(builder: (profileController) {
                  return profileController.profileModel != null ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Row(children: [
                      CountWidget(title: 'today'.tr, count: profileController.profileModel!.todaysOrderCount),
                      CountWidget(title: 'this_week'.tr, count: profileController.profileModel!.thisWeekOrderCount),
                      CountWidget(title: 'this_month'.tr, count: profileController.profileModel!.thisMonthOrderCount),
                    ]),
                  ) : const SizedBox();
                }),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                           
                
                 
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: orderController.statusList.length,
                    itemBuilder: (context, index) {
                      return OrderButtonWidget(
                        title: orderController.statusList[index].tr, index: index, orderController: orderController, fromHistory: true,
                      );
                    },
                  ),
                ),



                 SizedBox(height: orderController.historyOrderList != null ? Dimensions.paddingSizeSmall : 0),

            orderController.historyOrderList != null ? orderController.historyOrderList!.isNotEmpty
                ? Container(
                  width: Get.width,
                  height: Get.height * 0.7,
                  child: const OrderViewWidget()) : Center(child: Text('no_order_found'.tr)) : const Center(child: CircularProgressIndicator()),

                ]);
              }
            );
          }),
        ),
      ),

    );
  }
}
