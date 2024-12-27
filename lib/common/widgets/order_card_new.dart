import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sixam_mart_store/features/chat/domain/models/chat_list_model.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/features/order/widgets/order_item_widget.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

// class OrderWidget2 extends StatefulWidget {
//   final OrderModel orderModel;
//   final bool hasDivider;
//   final bool isRunning;
//   final bool showStatus;
//   const OrderWidget2({super.key, required this.orderModel, required this.hasDivider, required this.isRunning, this.showStatus = false});

//   @override
//   State<OrderWidget2> createState() => _OrderWidget2State();
// }



// class _OrderWidget2State extends State<OrderWidget2> {
//   @override

//     List<OrderDetailsModel>?  data;
  
//   @override
//   void initState() {
//     super.initState(); // Always call super.initState() first
//     print("--------------------------------------calling details for ${widget.orderModel.id ?? 0}-------------------------------------------");
//    data =  Get.find<OrderController>().getOrderItemsDetailsIncard(widget.orderModel.id ?? 0) as List<OrderDetailsModel>?;
//   }
   



//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(widget.orderModel.id), /*arguments: OrderDetailsScreen(
//         orderModel: orderModel, isRunningOrder: isRunning,
//       )*/),
//       child: Container(
//           height: 200,
//         child:  Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween ,
//                 children: [
//                    RichText(
//   text: TextSpan(
//     children: [
//       TextSpan(
//         text: "ID: ", 
//         style: TextStyle(
//           fontSize:  Dimensions.fontSizeLarge ,
//           fontWeight: FontWeight.normal, 
//           color: Colors.black, 
//         ),
//       ),
//       TextSpan(
//         text: widget.orderModel.id.toString(), 
//         style: TextStyle(
//            fontSize:  Dimensions.fontSizeLarge,
//           fontWeight: FontWeight.bold, 
//           color: Colors.black,
//         ),
//       ),
//     ],
//   ),
// ),


// Text("${DateFormat.jm().format(DateTime.parse(widget.orderModel.createdAt.toString())).toLowerCase()}")
//                 ],
//               )
//          ,

//          SizedBox(height: 5,),
//               Container(
//                 decoration:  BoxDecoration(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(5)
//                   ),
//                        color: Colors.blue,
//                 ),
           
//                 child:  Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: Text(widget.orderModel.orderStatus.toString().toUpperCase()),
//                 ),
//               )
//           , SizedBox(height: 5,),
//           Divider(),
         

//         //  ListView.builder(
//         //             shrinkWrap: true,
//         //             physics: const NeverScrollableScrollPhysics(),
//         //             itemCount: data!.length,
//         //             itemBuilder: (context, index) {
//         //               return OrderItemWidget(order:widget.orderModel, data![index]: data![index]);
//         //             },
//         //           ),
              
//           ],
//         )
       
     
//       ),
//     );
//   }
// }



class OrderWidget2 extends StatefulWidget {
  final OrderModel orderModel;
  final bool hasDivider;
  final bool isRunning;
  final bool showStatus;

  const OrderWidget2({
    super.key,
    required this.orderModel,
    required this.hasDivider,
    required this.isRunning,
    this.showStatus = false,
  });

  @override
  State<OrderWidget2> createState() => _OrderWidget2State();
}

class _OrderWidget2State extends State<OrderWidget2> {
  List<OrderDetailsModel>? data;
  bool isLoading = true;

  // @override
  // void initState()  {
  //   super.initState();
  //  Future.delayed(Duration(seconds: 0), () {
  //  _loadOrderDetails();
  //     Get.find<OrderController>().getCurrentOrders();
  //  Future.delayed(Duration(seconds: 2), () {
  // //  _loadOrderDetails();
  //    _loadOrderDetails();
  // });
  // });
    
  // }

// @override
// void initState() {
//   super.initState();

//   // Load order details initially.
//   _loadOrderDetails();
//   Get.find<OrderController>().getCurrentOrders();

//   // Set up a periodic timer to update the UI every 5 seconds.
//   Timer.periodic(Duration(seconds: 5), (timer) {
//     if (mounted) {
//       _loadOrderDetails();
//         Get.find<OrderController>().getCurrentOrders();
//     } else {
//       timer.cancel(); // Stop the timer if the widget is no longer in the widget tree.
//     }
//   });
// }

  Future<void> _loadOrderDetails() async {
     print("------------------------------------------------------Fetching details for Order ID: ${widget.orderModel.id ?? 0}-------------------------------------------------------");
    try {

      if (data == null) {
         print("------------------------------------------------------Fetching details for Order ID: ${widget.orderModel.id ?? 0}-------------------------------------------------------");
      final fetchedData =
      
          await Get.find<OrderController>().getOrderItemsDetailsIncard(widget.orderModel.id ?? 0);

        
      setState(() {
        data = fetchedData as List<OrderDetailsModel>;
        isLoading = false;
      });
      }
       print("------------------------------------------------------already have details for Order ID: ${widget.orderModel.id ?? 0}-------------------------------------------------------");
    } catch (e) {
       print("------------------------------------------------------ failed to Fetching details for Order ID: ${widget.orderModel.id ?? 0}-------------------------------------------------------");
      print("Error fetching order details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        RouteHelper.getOrderDetailsRoute(widget.orderModel.id),
      ),
      child: Container(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "ID: ",
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeLarge,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: widget.orderModel.id.toString(),
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${DateFormat.jm().format(DateTime.parse(widget.orderModel.createdAt.toString())).toLowerCase()}",
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(widget.orderModel.orderStatus.toString().toUpperCase()),
              ),
            ),
            const SizedBox(height: 5),
            const Divider(),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : data != null && data!.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: data!.length,
                          itemBuilder: (context, index) {


                            
String variationText = '';
    if(data![index].variation!.isNotEmpty) {
      if(data![index].variation!.isNotEmpty) {
        List<String> variationTypes = data![index].variation![0].type!.split('-');
        if(variationTypes.length == data![index].itemDetails!.choiceOptions!.length) {
          int index = 0;
          for (var choice in data![index].itemDetails!.choiceOptions!) {
            variationText = '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
            index = index + 1;
          }
        }else {
          variationText = data![index].itemDetails!.variations![0].type!;
        }
      }
    }else if(data![index].foodVariation!.isNotEmpty) {
      for(FoodVariation variation in data![index].foodVariation!) {
        variationText += '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
        for(VariationValue value in variation.variationValues!) {
          variationText += '${variationText.endsWith('(') ? '' : ', '}${value.level}';
        }
        variationText += ')';
      }
    }
                            return    RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:  "${data![index].quantity.toString()} x ",
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeLarge,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: data![index].itemDetails!.name,
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                       TextSpan(
                        text: "   ${variationText}",
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
                            
                             
                            
                            // OrderItemWidget(
                            //   order: widget.orderModel,
                            //   data![index]: data![index],
                            // );
                          },
                        ),
                      )
                    : const Text("No order details available."),
          ],
        ),
      ),
    );
  }
}
