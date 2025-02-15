import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class OrderButtonWidget extends StatelessWidget {
  final String title;
  final int index;
  final OrderController orderController;
  final bool fromHistory;
  const OrderButtonWidget({super.key, required this.title, required this.index, required this.orderController, required this.fromHistory});

  @override
  Widget build(BuildContext context) {
    int selectedIndex;
    int length = 0;
    int titleLength = 0;
    if(fromHistory) {
      selectedIndex = orderController.historyIndex;
      titleLength = orderController.statusList.length;
      length = 0;
    }else {
      selectedIndex = orderController.orderIndex;
      titleLength = orderController.runningOrders!.length;
      length = orderController.runningOrders![index].orderList.length;
    }
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => fromHistory ? orderController.setHistoryIndex(index) : orderController.setOrderIndex(index),
      child: Row(children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtremeLarge + 40),
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: Theme.of(context).disabledColor),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: isSelected ?  ( title == "Pending" &&  length > 0) ? Colors.green :  Theme.of(context).primaryColor : ( title == "Pending" &&  length > 0) ? const Color.fromARGB(255, 165, 18, 8) :    Theme.of(context).cardColor,
          ),
          alignment: Alignment.center,
          child: Text(
            '$title   ${ length >0 ?  "(${  length})" : ""}',
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: PoppinsMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ?  Theme.of(context).cardColor :  ( title == "Pending" &&  length > 0) ?  Theme.of(context).cardColor : Theme.of(context).primaryColor,
            ),
          ),
        ),

        (index != titleLength-1 && index != selectedIndex && index != selectedIndex-1) ? Container(
          height: 15, width: 1, color: Theme.of(context).disabledColor,
        ) : const SizedBox(),

      ]),
    );
  }
}
