import 'package:flutter/material.dart';

// class BottomNavItemWidget extends StatelessWidget {
//   final IconData iconData;
//   final Function? onTap;
//   final bool isSelected;
//   const BottomNavItemWidget({super.key, required this.iconData, this.onTap, this.isSelected = false});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: IconButton(

//         icon: Icon(iconData, color: isSelected ? Theme.of(context).primaryColor : Colors.grey, size: 25),
//         onPressed: onTap as void Function()?,
//       ),
      
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BottomNavItemWidget extends StatelessWidget {
  final IconData iconData;
  final String name; // Added name parameter
  final Function? onTap;
  final bool isSelected;

  const BottomNavItemWidget({
    super.key,
    required this.iconData,
    required this.name, // Make name required
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector( // Use GestureDetector to handle taps
        onTap: onTap as void Function()?,
        child: Container(
          color: isSelected ? Colors.transparent : Colors.transparent,
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            children: [
          
              Stack(
                children: [
          
              // Lottie.asset('assets/image/animations/Animation - 1734685956987.json')
              //  ,
                    Icon(
                iconData,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                size: 25,
              ),
          
                ],
              )
            ,
              const SizedBox(height: 4), // Add some space between icon and text
              Text(
                name,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                  fontSize: 12, // Adjust font size as needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}