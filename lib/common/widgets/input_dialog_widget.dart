import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';

// class InputDialogWidget extends StatefulWidget {
//   final String icon;
//   final String? title;
//   final String description;
//   final Function(String? value) onPressed;
//   const InputDialogWidget({super.key, required this.icon, this.title, required this.description, required this.onPressed});

//   @override
//   State<InputDialogWidget> createState() => _InputDialogWidgetState();
// }

// class _InputDialogWidgetState extends State<InputDialogWidget> {
//   final TextEditingController _textEditingController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
//       insetPadding: const EdgeInsets.all(30),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       child: SizedBox(width: 500, child: Padding(
//         padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//         child: SingleChildScrollView(
//           child: Column(mainAxisSize: MainAxisSize.min, children: [

//             Padding(
//               padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//               child: Image.asset(widget.icon, width: 50, height: 50),
//             ),

//             widget.title != null ? Padding(
//               padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
//               child: Text(
//                 widget.title!, textAlign: TextAlign.center,
//                 style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
//               ),
//             ) : const SizedBox(),

//             Padding(
//               padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//               child: Text(widget.description, style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
//             ),
//             const SizedBox(height: Dimensions.paddingSizeLarge),

//             CustomTextFieldWidget(
//               maxLines: 1,
//               controller: _textEditingController,
//               hintText: 'enter_processing_time'.tr,
//               isEnabled: true,
//               inputType: TextInputType.number,
//               inputAction: TextInputAction.done,
//             ),
//             const SizedBox(height: Dimensions.paddingSizeLarge),

//             GetBuilder<OrderController>(builder: (orderController) {
//               return (orderController.isLoading) ? const Center(child: CircularProgressIndicator()) : Row(children: [

//                 Expanded(child: CustomButtonWidget(
//                   buttonText: 'submit'.tr,
//                   onPressed: () {
//                     if(_textEditingController.text.trim().isEmpty) {
//                       showCustomSnackBar('please_provide_processing_time'.tr);
//                     }else {
//                       widget.onPressed(_textEditingController.text.trim());
//                     }
//                   },
//                   height: 40,
//                 )),

//                 const SizedBox(width: Dimensions.paddingSizeLarge),

//                 Expanded(child: TextButton(
//                   onPressed: ()  => Get.back(),
//                   style: TextButton.styleFrom(
//                     backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
//                   ),
//                   child: Text(
//                     'cancel'.tr, textAlign: TextAlign.center,
//                     style: PoppinsBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
//                   ),
//                 )),

//               ]);
//             }),

//           ]),
//         ),
//       )),
//     );
//   }
// }






// class InputDialogWidget extends StatefulWidget {
//   final icon;
//   final String? title;
//   final String description;
//   final Function(String? value) onPressed;

//   const InputDialogWidget({
//     super.key,
//     this.icon,
//     this.title,
//     required this.description,
//     required this.onPressed,
//   });

//   @override
//   State<InputDialogWidget> createState() => _InputDialogWidgetState();
// }

// class _InputDialogWidgetState extends State<InputDialogWidget> {
//   final TextEditingController _textEditingController = TextEditingController();
//   String? _selectedTimeOption; 
//   bool _useCheckboxAlternative = false;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
//       ),
//       insetPadding: const EdgeInsets.all(30),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       child: SizedBox(
//         width: 400,
//         child: Padding(
//           padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [

//                 Align(
//                   alignment: Alignment.topRight,
//                   child: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close, color: Colors.black))),
//                 // Icon
//                 // widget.icon! != null ? Padding(
//                 //   padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//                 //   child:  Image.asset(widget.icon ?? "", width: 50, height: 50),
//                 // ) : SizedBox(),

//                 // Title
//                 if (widget.title != null)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: Dimensions.paddingSizeLarge),
//                     child: Text(
//                       widget.title?? "",
//                       textAlign: TextAlign.center,
//                       style: PoppinsMedium.copyWith(
//                           fontSize: Dimensions.fontSizeExtraLarge,
//                           color: Colors.red),
//                     ),
//                   ),

//                 // Description
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 10,bottom: 10),
//                     child: Text(
//                       widget.description,
//                       style: PoppinsMedium.copyWith(
//                           fontSize: Dimensions.fontSizeLarge),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),

//                 // const SizedBox(height: Dimensions.paddingSizeLarge),
//             //  Column(
//             //             children: [
//             //               RadioListTile<String>(

//             //                 title: const Text('10 min'),
//             //                 value: '10',
//             //                 groupValue: _selectedTimeOption,
//             //                 onChanged: (value) {
//             //                   setState(() {
//             //                     _selectedTimeOption = value;
//             //                      _textEditingController.value = TextEditingValue(text: _selectedTimeOption!);
//             //                   });
//             //                 },
//             //               ),
//             //               RadioListTile<String>(
//             //                 title: const Text('5 min'),
//             //                 value: '5',
//             //                 groupValue: _selectedTimeOption,
//             //                 onChanged: (value) {
//             //                   setState(() {
//             //                     _selectedTimeOption = value;
//             //                      _textEditingController.value = TextEditingValue(text: _selectedTimeOption!);
//             //                   });
//             //                 },
//             //               ),
//             //               RadioListTile<String>(
//             //                 title: const Text('30 min'),
//             //                 value: '30',
//             //                 groupValue: _selectedTimeOption,
//             //                 onChanged: (value) {
//             //                   setState(() {
//             //                     _selectedTimeOption = value;
//             //                     _textEditingController.value = TextEditingValue(text: _selectedTimeOption!);
                                
//             //                   });
//             //                 },
//             //               ),
//             //             ],
//             //           ),
//             //     // Checkbox to toggle between text field and radio buttons



//             Row(
//   mainAxisAlignment: MainAxisAlignment.start,
//   children: [
//     // 10 Minutes Option
//     GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedTimeOption = '5';
//           _textEditingController.value = TextEditingValue(text: _selectedTimeOption!);
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//         decoration: BoxDecoration(
//           color: _selectedTimeOption == '5' ? Colors.blue : Colors.grey[300],
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: _selectedTimeOption == '5' ? Colors.blue : Colors.grey,
//           ),
//         ),
//         child: Text(
//           '5 min',
//           style: TextStyle(
//             color: _selectedTimeOption == '10' ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ),

//     // 5 Minutes Option
//     GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedTimeOption = '10';
//           _textEditingController.value = TextEditingValue(text: _selectedTimeOption!);
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//         decoration: BoxDecoration(
//           color: _selectedTimeOption == '10' ? Colors.blue : Colors.grey[300],
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: _selectedTimeOption == '10' ? Colors.blue : Colors.grey,
//           ),
//         ),
//         child: Text(
//           '10 min',
//           style: TextStyle(
//             color: _selectedTimeOption == '10' ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ),

//     // 30 Minutes Option
//     GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedTimeOption = '15';
//           _textEditingController.value = TextEditingValue(text: _selectedTimeOption!);
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//         decoration: BoxDecoration(
//           color: _selectedTimeOption == '15' ? Colors.blue : Colors.grey[300],
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: _selectedTimeOption == '15' ? Colors.blue : Colors.grey,
//           ),
//         ),
//         child: Text(
//           '15 min',
//           style: TextStyle(
//             color: _selectedTimeOption == '15' ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ),
  
//    GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedTimeOption = '20';
//           _textEditingController.value = TextEditingValue(text: _selectedTimeOption!);
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//         decoration: BoxDecoration(
//           color: _selectedTimeOption == '20' ? Colors.blue : Colors.grey[300],
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: _selectedTimeOption == '20' ? Colors.blue : Colors.grey,
//           ),
//         ),
//         child: Text(
//           '20 min',
//           style: TextStyle(
//             color: _selectedTimeOption == '20' ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ),
  
//   ],
// ),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Checkbox(
//                       value: _useCheckboxAlternative,
//                       onChanged: (bool? value) {
//                         setState(() {
//                           _useCheckboxAlternative = value ?? true;
//                           if (_useCheckboxAlternative) {
//                             _selectedTimeOption = null;
//                           } else {
//                             _textEditingController.clear();
//                           }
//                         });
//                       },
//                     ),
//                     Text(
//                       'Enter Manually',
//                       style: PoppinsMedium.copyWith(
//                           fontSize: Dimensions.fontSizeLarge),
//                     ),
//                   ],
//                 ),

//                 // Input field or radio button selection
//                 !_useCheckboxAlternative
//                     ? SizedBox()
//                     : CustomTextFieldWidget(
//                         maxLines: 1,
//                         controller: _textEditingController,
//                         hintText: 'enter_processing_time'.tr,
//                         isEnabled: true,
//                         inputType: TextInputType.number,
//                         inputAction: TextInputAction.done,
//                       ),

//                 const SizedBox(height: Dimensions.paddingSizeLarge),

//                 // Submit and Cancel Buttons
//                 GetBuilder<OrderController>(builder: (orderController) {
//                   return orderController.isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : Row(
//                           children: [
//                             Expanded(
//                               child: CustomButtonWidget(
//                                 buttonText: 'submit'.tr,
//                                 onPressed: () {
//                                   if (_useCheckboxAlternative) {
//                                     if (_selectedTimeOption == null) {
//                                       showCustomSnackBar(
//                                           'please_select_processing_time'.tr);
//                                     } else {
//                                       widget.onPressed(_selectedTimeOption);
//                                     }
//                                   } else {
//                                     if (_textEditingController.text
//                                         .trim()
//                                         .isEmpty) {
//                                       showCustomSnackBar(
//                                           'please_provide_processing_time'.tr);
//                                     } else {
//                                       widget.onPressed(
//                                           _textEditingController.text.trim());
//                                     }
//                                   }
//                                 },
//                                 height: 40,
//                               ),
//                             ),
//                             // const SizedBox(
//                             //     width: Dimensions.paddingSizeLarge),
//                             // // Expanded(
//                             // //   child: TextButton(
//                             // //     onPressed: () => Get.back(),
//                             // //     style: TextButton.styleFrom(
//                             // //       backgroundColor: Theme.of(context)
//                             // //           .disabledColor
//                             // //           .withOpacity(0.3),
//                             // //       minimumSize: const Size(1170, 40),
//                             // //       padding: EdgeInsets.zero,
//                             // //       shape: RoundedRectangleBorder(
//                             // //         borderRadius: BorderRadius.circular(
//                             // //             Dimensions.radiusSmall),
//                             // //       ),
//                             // //     ),
//                             // //     child: Text(
//                             // //       'cancel'.tr,
//                             // //       textAlign: TextAlign.center,
//                             // //       style: PoppinsBold.copyWith(
//                             // //           color: Theme.of(context)
//                             // //               .textTheme
//                             // //               .bodyLarge!
//                             // //               .color),
//                             // //     ),
//                             // //   ),
//                             // // ),
                        
//                           ],
//                         );
//                 }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


class InputDialogWidget extends StatefulWidget {
  final icon;
  final String? title;
  final String description;
  final Function(String? value) onPressed;

  const InputDialogWidget({
    super.key,
    this.icon,
    this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  State<InputDialogWidget> createState() => _InputDialogWidgetState();
}

class _InputDialogWidgetState extends State<InputDialogWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  String? _selectedTimeOption; 
  bool _useCheckboxAlternative = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
                if (widget.title != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: Text(
                      widget.title ?? "",
                      textAlign: TextAlign.center,
                      style: PoppinsMedium.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: Colors.red),
                    ),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                      widget.description,
                      style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 5 Minutes Option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeOption = '5';
                          _textEditingController.clear(); // Clear manual input
                        });
                      },
                      child: _buildTimeOption('5 min', '5'),
                    ),
                    // 10 Minutes Option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeOption = '10';
                          _textEditingController.clear(); // Clear manual input
                        });
                      },
                      child: _buildTimeOption('10 min', '10'),
                    ),
                    // 15 Minutes Option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeOption = '15';
                          _textEditingController.clear(); // Clear manual input
                        });
                      },
                      child: _buildTimeOption('15 min', '15'),
                    ),
                    // 20 Minutes Option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeOption = '20';
                          _textEditingController.clear(); // Clear manual input
                        });
                      },
                      child: _buildTimeOption('20 min', '20'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _useCheckboxAlternative,
                      onChanged: (bool? value) {
                        setState(() {
                          _useCheckboxAlternative = value ?? false;
                          if (_useCheckboxAlternative) {
                            _selectedTimeOption =  _selectedTimeOption ; // Clear selected time option
                          } else {
                            _textEditingController.clear(); // Clear manual input
                          }
                        });
                      },
                    ),
                    Text(
                      'Enter Manually',
                      style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                  ],
                ),
                // Input field for manual entry
                _useCheckboxAlternative
                    ? CustomTextFieldWidget(
                        maxLines : 1,
                        controller: _textEditingController,
                        hintText: 'enter_processing_time'.tr,
                        isEnabled: true,
                        inputType: TextInputType.number,
                        inputAction: TextInputAction.done,
                      )
                    : SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                // Submit and Cancel Buttons
                GetBuilder<OrderController>(builder: (orderController) {
                  return orderController.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          children: [
                            Expanded(
                              child: CustomButtonWidget(
                                buttonText: 'submit'.tr,
                                onPressed: () {
                                  String? timeToSubmit;
                                  if (_useCheckboxAlternative) {
                                    timeToSubmit = _textEditingController.text.trim();
                                    if (timeToSubmit.isEmpty) {
                                      showCustomSnackBar('please_provide_processing_time'.tr);
                                      return;
                                    }
                                  } else {
                                    timeToSubmit = _selectedTimeOption;
                                    if (timeToSubmit == null) {
                                      showCustomSnackBar('please_select_processing_time'.tr);
                                      return;
                                    }
                                  }
                                  widget.onPressed(timeToSubmit);
                                },
                                height: 40,
                              ),
                            ),
                          ],
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeOption(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: _selectedTimeOption == value ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _selectedTimeOption == value ? Colors.blue : Colors.grey,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _selectedTimeOption == value ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}