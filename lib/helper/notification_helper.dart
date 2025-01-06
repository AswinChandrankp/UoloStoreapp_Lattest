import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sixam_mart_store/features/advertisement/controllers/advertisement_controller.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/chat/controllers/chat_controller.dart';
import 'package:sixam_mart_store/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixam_mart_store/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sixam_mart_store/features/dashboard/widgets/new_request_dialog_widget.dart';



class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation < AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onDidReceiveNotificationResponse: (NotificationResponse load) async{
      try{
        if(load.payload!.isNotEmpty){
          
          NotificationBodyModel payload = NotificationBodyModel.fromJson(jsonDecode(load.payload!));

          final Map<NotificationType, Function> notificationActions = {
            NotificationType.order: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(payload.orderId, fromNotification: true)),
            NotificationType.advertisement: () => Get.toNamed(RouteHelper.getAdvertisementDetailsScreen(advertisementId: payload.advertisementId, fromNotification: true)),
            NotificationType.block: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
            NotificationType.unblock: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
            NotificationType.withdraw: () => Get.to(const DashboardScreen(pageIndex: 3)),
            NotificationType.campaign: () => Get.toNamed(RouteHelper.getCampaignDetailsRoute(id: payload.campaignId, fromNotification: true)),
            NotificationType.message: () => Get.toNamed(RouteHelper.getChatRoute(notificationBody: payload, conversationId: payload.conversationId, fromNotification: true)),
            NotificationType.subscription: () => Get.toNamed(RouteHelper.getMySubscriptionRoute(fromNotification: true)),
            NotificationType.product_approve: () => Get.offAll(const DashboardScreen(pageIndex: 2)),
            NotificationType.product_rejected: () => Get.toNamed(RouteHelper.getPendingItemRoute(fromNotification: true)),
            NotificationType.general: () => Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true)),
          };

          notificationActions[payload.notificationType]?.call();
        }
      }catch(e){

  print("----------------------------error on playing background --------------showNotification message :${e}----------------------------------------");

      }
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("onMessage message type:${message.data['type']}");
      debugPrint("onMessage message :${message.data}");

      if(message.data['type'] == 'message' && Get.currentRoute.startsWith(RouteHelper.chatScreen)) {
        if(Get.find<AuthController>().isLoggedIn()) {
          Get.find<ChatController>().getConversationList(1);
          if(Get.find<ChatController>().messageModel!.conversation!.id.toString() == message.data['conversation_id'].toString()) {
            Get.find<ChatController>().getMessages(
              1, NotificationBodyModel(
              notificationType: NotificationType.message,
              customerId: message.data['sender_type'] == AppConstants.user ? 0 : null,
              deliveryManId: message.data['sender_type'] == AppConstants.deliveryMan ? 0 : null,
            ),
              null, int.parse(message.data['conversation_id'].toString()),
            );
          }else {
            NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
          }
        }
      }else if(message.data['type'] == 'message' && Get.currentRoute.startsWith(RouteHelper.conversationListScreen)) {
        if(Get.find<AuthController>().isLoggedIn()) {
          Get.find<ChatController>().getConversationList(1);
        }
        NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
      }else {
        NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);

        if (message.data['type'] == 'new_order' || message.data['title'] == 'New order placed') {
          Get.find<OrderController>().getPaginatedOrders(1, true);
          Get.find<OrderController>().getCurrentOrders();

          Get.dialog(NewRequestDialogWidget(orderId: int.parse(message.data['order_id'])));
        }else if(message.data['type'] == 'advertisement') {
          Get.find<AdvertisementController>().getAdvertisementList('1', 'all');
        }
        Get.find<NotificationController>().getNotificationList();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("onOpenApp message type:${message.data['type']}");
      debugPrint("onOpenApp message :${message.data}");

      try{
        NotificationBodyModel notificationBody = convertNotification(message.data);

        final Map<NotificationType, Function> notificationActions = {
          NotificationType.order: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(message.data['order_id']), fromNotification: true)),
          NotificationType.advertisement: () => Get.toNamed(RouteHelper.getAdvertisementDetailsScreen(advertisementId:  notificationBody.advertisementId, fromNotification: true)),
          NotificationType.block: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
          NotificationType.unblock: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
          NotificationType.withdraw: () => Get.to(const DashboardScreen(pageIndex: 3)),
          NotificationType.campaign: () => Get.toNamed(RouteHelper.getCampaignDetailsRoute(id: notificationBody.campaignId, fromNotification: true)),
          NotificationType.message: () => Get.toNamed(RouteHelper.getChatRoute(notificationBody: notificationBody, conversationId: notificationBody.conversationId, fromNotification: true)),
          NotificationType.subscription: () => Get.toNamed(RouteHelper.getMySubscriptionRoute(fromNotification: true)),
          NotificationType.product_approve: () => Get.offAll(const DashboardScreen(pageIndex: 2)),
          NotificationType.product_rejected: () => Get.toNamed(RouteHelper.getPendingItemRoute(fromNotification: true)),
          NotificationType.general: () => Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true)),
        };

        notificationActions[notificationBody.notificationType]?.call();
      }catch (e){
        print("----------------------------error on playing background --------------showNotification message :${e}----------------------------------------");
      }

    });
  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {

    print("----------------------------playing background --------------showNotification message :${message.data}----------------------------------------");
    Get.find<OrderController>().getCurrentOrders();
    if(!GetPlatform.isIOS) {
      String? title;
      String? body;
      String? image;
      NotificationBodyModel notificationBody = convertNotification(message.data);

      title = message.data['title'];
      body = message.data['body'];
      image = (message.data['image'] != null && message.data['image'].isNotEmpty) ? message.data['image'].startsWith('http') ? message.data['image']
        : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' : null;

      if(image != null && image.isNotEmpty) {
        try{

          await showBigPictureNotificationHiddenLargeIcon(title, body, notificationBody, image, fln);
        }catch(e) {
          print("----------------------------error on playing background --------------showNotification message :${e}----------------------------------------");
          await showBigTextNotification(title, body!, notificationBody, fln);
        }
      }else {
        await showBigTextNotification(title, body!, notificationBody, fln);
      }
    }
  }

  static Future<void> showTextNotification(String title, String body, NotificationBodyModel notificationBody, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '6ammart', AppConstants.appName, playSound: true,
      importance: Importance.max, priority: Priority.max, sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(notificationBody.toJson()));
  }

  static Future<void> showBigTextNotification(String? title, String body, NotificationBodyModel notificationBody, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '6ammart', AppConstants.appName, importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(notificationBody.toJson()));
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(String? title, String? body, NotificationBodyModel notificationBody, String image, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: title, htmlFormatContentTitle: true,
      summaryText: body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '6ammart', AppConstants.appName,
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(notificationBody.toJson()));
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static NotificationBodyModel convertNotification(Map<String, dynamic> data) {
    final type = data['type'];

    switch (type) {
      case 'advertisement':
        return NotificationBodyModel(notificationType: NotificationType.advertisement, advertisementId: int.tryParse(data['advertisement_id']));
      case 'block':
        return NotificationBodyModel(notificationType: NotificationType.block);
      case 'unblock':
        return NotificationBodyModel(notificationType: NotificationType.unblock);
      case 'withdraw':
        return NotificationBodyModel(notificationType: NotificationType.withdraw);
      case 'product_approve':
        return NotificationBodyModel(notificationType: NotificationType.product_approve);
      case 'product_rejected':
      return NotificationBodyModel(notificationType: NotificationType.product_rejected);
      case 'campaign':
        return NotificationBodyModel(notificationType: NotificationType.campaign, campaignId: int.tryParse(data['data_id']));
      case 'subscription':
      return NotificationBodyModel(notificationType: NotificationType.subscription);
      case 'new_order':
      case 'New order placed':
      case 'order_status':
        return _handleOrderNotification(data);
      case 'message':
        return _handleMessageNotification(data);
      default:
        return NotificationBodyModel(notificationType: NotificationType.general);
    }
  }

  static NotificationBodyModel _handleOrderNotification(Map<String, dynamic> data) {
    final orderId = data['order_id'];
    return NotificationBodyModel(
      orderId: int.tryParse(orderId) ?? 0,
      notificationType: NotificationType.order,
    );
  }

  static NotificationBodyModel _handleMessageNotification(Map<String, dynamic> data) {
    final orderId = data['order_id'];
    final conversationId = data['conversation_id'];
    final senderType = data['sender_type'];

    return NotificationBodyModel(
      orderId: orderId != null && orderId.isNotEmpty ? int.tryParse(orderId) : null,
      conversationId: conversationId != null && conversationId.isNotEmpty ? int.tryParse(conversationId) : null,
      notificationType: NotificationType.message,
      type: senderType == AppConstants.deliveryMan ? AppConstants.deliveryMan : AppConstants.customer,
    );
  }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint("onBackground: ${message.data}");
}

















// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// class NotificationHelper {
//   static Timer? _notificationTimer;
//   static bool _hasInteracted = false;

//   static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize = const AndroidInitializationSettings('notification_icon');
//     var iOSInitialize = const DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         _hasInteracted = true;
//         _notificationTimer?.cancel();
//         debugPrint("Notification tapped: ${response.payload}");

//         if (response.payload != null && response.payload!.isNotEmpty) {
//           try {
//             NotificationBodyModel payload = NotificationBodyModel.fromJson(jsonDecode(response.payload!));

//             final Map<NotificationType, Function> notificationActions = {
//               NotificationType.order: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(payload.orderId, fromNotification: true)),
//               NotificationType.advertisement: () => Get.toNamed(RouteHelper.getAdvertisementDetailsScreen(advertisementId: payload.advertisementId, fromNotification: true)),
//               NotificationType.block: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
//               NotificationType.unblock: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
//               NotificationType.withdraw: () => Get.to(const DashboardScreen(pageIndex: 3)),
//               NotificationType.campaign: () => Get.toNamed(RouteHelper.getCampaignDetailsRoute(id: payload.campaignId, fromNotification: true)),
//               NotificationType.message: () => Get.toNamed(RouteHelper.getChatRoute(notificationBody: payload, conversationId: payload.conversationId, fromNotification: true)),
//               NotificationType.subscription: () => Get.toNamed(RouteHelper.getMySubscriptionRoute(fromNotification: true)),
//               NotificationType.product_approve: () => Get.offAll(const DashboardScreen(pageIndex: 2)),
//               NotificationType.product_rejected: () => Get.toNamed(RouteHelper.getPendingItemRoute(fromNotification: true)),
//               NotificationType.general: () => Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true)),
//             };

//             notificationActions[payload.notificationType]?.call();
//           } catch (e) {
//             debugPrint("Error handling notification interaction: $e");
//           }
//         }
//       },
//     );

//     // Handle iOS permissions explicitly
//     if (flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>() !=
//         null) {
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//             alert: true,
//             badge: true,
//             sound: true,
//           );
//     }

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("onMessage message type: ${message.data['type']}");
//       debugPrint("onMessage message: ${message.data}");

//       if (message.data['type'] == 'message' && Get.currentRoute.startsWith(RouteHelper.chatScreen)) {
//         if (Get.find<AuthController>().isLoggedIn()) {
//           Get.find<ChatController>().getConversationList(1);
//           if (Get.find<ChatController>().messageModel?.conversation?.id.toString() == message.data['conversation_id'].toString()) {
//             Get.find<ChatController>().getMessages(
//               1,
//               NotificationBodyModel(
//                 notificationType: NotificationType.message,
//                 customerId: message.data['sender_type'] == AppConstants.user ? 0 : null,
//                 deliveryManId: message.data['sender_type'] == AppConstants.deliveryMan ? 0 : null,
//               ),
//               null,
//               int.parse(message.data['conversation_id'].toString()),
//             );
//           } else {
//             showNotification(message, flutterLocalNotificationsPlugin);
//             _startNotificationTimer(message, flutterLocalNotificationsPlugin);
//           }
//         }
//       } else {
//         showNotification(message, flutterLocalNotificationsPlugin);
//         _startNotificationTimer(message, flutterLocalNotificationsPlugin);
//       }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint("onOpenApp message type: ${message.data['type']}");
//       debugPrint("onOpenApp message: ${message.data}");

//       try {
//         NotificationBodyModel notificationBody = convertNotification(message.data);

//         final Map<NotificationType, Function> notificationActions = {
//           NotificationType.order: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(message.data['order_id']), fromNotification: true)),
//           NotificationType.advertisement: () => Get.toNamed(RouteHelper.getAdvertisementDetailsScreen(advertisementId: notificationBody.advertisementId, fromNotification: true)),
//           NotificationType.block: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
//           NotificationType.unblock: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
//           NotificationType.withdraw: () => Get.to(const DashboardScreen(pageIndex: 3)),
//           NotificationType.campaign: () => Get.toNamed(RouteHelper.getCampaignDetailsRoute(id: notificationBody.campaignId, fromNotification: true)),
//           NotificationType.message: () => Get.toNamed(RouteHelper.getChatRoute(notificationBody: notificationBody, conversationId: notificationBody.conversationId, fromNotification: true)),
//           NotificationType.subscription: () => Get.toNamed(RouteHelper.getMySubscriptionRoute(fromNotification: true)),
//           NotificationType.product_approve: () => Get.offAll(const DashboardScreen(pageIndex: 2)),
//           NotificationType.product_rejected: () => Get.toNamed(RouteHelper.getPendingItemRoute(fromNotification: true)),
//           NotificationType.general: () => Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true)),
//         };

//         notificationActions[notificationBody.notificationType]?.call();
//       } catch (e) {
//         debugPrint("Error handling notification on app open: $e");
//       }
//     });
//   }

//   static void _startNotificationTimer(RemoteMessage message, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
//     _hasInteracted = false;
//     _notificationTimer?.cancel();

//     _notificationTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
//       if (_hasInteracted) {
//         debugPrint("User interacted with notification, stopping timer.");
//         timer.cancel();
//       } else {
//         debugPrint("Showing notification after timer period.");
//         await showNotification(message, flutterLocalNotificationsPlugin);
//       }
//     });
//   }

//   static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Playing notification with data: ${message.data}");
//     String? title = message.data['title'];
//     String? body = message.data['body'];
//     String? image = message.data['image'];

//     NotificationBodyModel notificationBody = convertNotification(message.data);

//     if (image != null && image.isNotEmpty) {
//       await showBigPictureNotificationHiddenLargeIcon(title, body, notificationBody, image, fln);
//     } else {
//       await showBigTextNotification(title, body ?? '', notificationBody, fln);
//     }
//   }

//   static Future<void> showBigTextNotification(String? title, String body, NotificationBodyModel notificationBody, FlutterLocalNotificationsPlugin fln) async {
//     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(body);
//     AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       importance: Importance.max,
//       styleInformation: bigTextStyleInformation,
//       priority: Priority.high,
//     );
//     NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//     await fln.show(0, title, body, platformDetails, payload: jsonEncode(notificationBody.toJson()));
//   }

//   static Future<void> showBigPictureNotificationHiddenLargeIcon(String? title, String? body, NotificationBodyModel notificationBody, String image, FlutterLocalNotificationsPlugin fln) async {
//     final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
//     final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');

//     BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath),
//       largeIcon: FilePathAndroidBitmap(largeIconPath),
//     );

//     AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       styleInformation: bigPictureStyleInformation,
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//     await fln.show(0, title, body, platformDetails, payload: jsonEncode(notificationBody.toJson()));
//   }

//   static Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }

//   static NotificationBodyModel convertNotification(Map<String, dynamic> data) {
//     switch (data['type']) {
//       case 'order':
//         return NotificationBodyModel(orderId: int.tryParse(data['order_id']), notificationType: NotificationType.order);
//       default:
//         return NotificationBodyModel(notificationType: NotificationType.general);
//     }
//   }
// }

// Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
//   debugPrint("Background message received: ${message.data}");
// }







// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';

// class NotificationHelper {
//   static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize = const AndroidInitializationSettings('notification_icon');
//     var iOSInitialize = const DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

//     final androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//     if (androidImplementation != null) {
//       await androidImplementation.requestNotificationsPermission();
//     }

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         if (response.payload != null && response.payload!.isNotEmpty) {
//           debugPrint("Notification tapped with payload: ${response.payload}");
//           _handleNotificationClick(response.payload!);
//         } else {
//           debugPrint("Notification dismissed without interaction.");
//         }
//       },
//     );

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("Firebase onMessage: ${message.data}");
//       _handleForegroundMessage(message, flutterLocalNotificationsPlugin);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint("Firebase onMessageOpenedApp: ${message.data}");
//       _handleNotificationClick(jsonEncode(message.data));
//     });
//   }

//   static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Show notification: ${message.data}");
//     String? title = message.notification?.title;
//     String? body = message.notification?.body;
//     String? imageUrl = message.data['image'];

//     NotificationBodyModel notificationBody = convertNotification(message.data);

//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       debugPrint("Notification contains an image: $imageUrl");
//       try {
//         await _showBigPictureNotification(title, body, notificationBody, imageUrl, fln);
//       } catch (e) {
//         debugPrint("Error showing image notification: $e");
//         await _showTextNotification(title, body, notificationBody, fln);
//       }
//     } else {
//       debugPrint("Notification contains text only.");
//       await _showTextNotification(title, body, notificationBody, fln);
//     }
//   }

//   static Future<void> _showTextNotification(String? title, String? body, NotificationBodyModel notificationBody, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Preparing text notification...");
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       '6ammart',
//       'App Notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//     await fln.show(0, title, body, platformDetails, payload: jsonEncode(notificationBody.toJson()));
//     debugPrint("Text notification displayed.");
//   }

//   static Future<void> _showBigPictureNotification(String? title, String? body, NotificationBodyModel notificationBody, String imageUrl, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Downloading image for notification: $imageUrl");
//     final String largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
//     final String bigPicturePath = await _downloadAndSaveFile(imageUrl, 'bigPicture');
//     debugPrint("Image downloaded successfully.");

//     final BigPictureStyleInformation bigPictureStyle = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath),
//       largeIcon: FilePathAndroidBitmap(largeIconPath),
//       contentTitle: title,
//       summaryText: body,
//     );

//     final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       '6ammart',
//       'App Notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//       styleInformation: bigPictureStyle,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );

//      NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//     await fln.show(0, title, body, platformDetails, payload: jsonEncode(notificationBody.toJson()));
//     debugPrint("Big picture notification displayed.");
//   }

//   static Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     debugPrint("Starting file download: $url");
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     debugPrint("File downloaded and saved to: $filePath");
//     return filePath;
//   }

//   static NotificationBodyModel convertNotification(Map<String, dynamic> data) {
//     try {
//       debugPrint("Converting notification data: $data");
//       final type = data['type'];
//       switch (type) {
//         case 'advertisement':
//           return NotificationBodyModel(notificationType: NotificationType.advertisement, advertisementId: int.tryParse(data['advertisement_id'] ?? ''));
//         case 'order':
//           return NotificationBodyModel(notificationType: NotificationType.order, orderId: int.tryParse(data['order_id'] ?? ''));
//         default:
//           return NotificationBodyModel(notificationType: NotificationType.general);
//       }
//     } catch (e) {
//       debugPrint("Error converting notification data: $e");
//       return NotificationBodyModel(notificationType: NotificationType.general);
//     }
//   }

//   static void _handleNotificationClick(String payload) {
//     debugPrint("Handling notification click with payload: $payload");
//     try {
//       NotificationBodyModel notificationBody = NotificationBodyModel.fromJson(jsonDecode(payload));
//       final Map<NotificationType, Function> notificationActions = {
//         NotificationType.order: () => Get.toNamed('/order-details', arguments: notificationBody.orderId),
//         NotificationType.advertisement: () => Get.toNamed('/advertisement-details', arguments: notificationBody.advertisementId),
//         NotificationType.general: () => Get.toNamed('/notifications'),
//       };

//       notificationActions[notificationBody.notificationType]?.call();
//       debugPrint("Notification action executed for type: ${notificationBody.notificationType}");
//     } catch (e) {
//       debugPrint("Error handling notification click: $e");
//     }
//   }

//   static void _handleForegroundMessage(RemoteMessage message, FlutterLocalNotificationsPlugin fln) {
//     debugPrint("Handling foreground message: ${message.data}");
//     if (message.data['type'] == 'message') {
//       debugPrint("In-app message detected: ${message.data}");
//     } else {
//       showNotification(message, fln);
//     }
//   }
// }

// Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
//   debugPrint("Handling background message: ${message.data}");
// }








// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';

// class NotificationHelper {
//   static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize = const AndroidInitializationSettings('notification_icon');
//     var iOSInitialize = const DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

//     final androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//     if (androidImplementation != null) {
//       await androidImplementation.requestNotificationsPermission();
//     }

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         if (response.payload != null && response.payload!.isNotEmpty) {
//           debugPrint("Notification tapped with payload: ${response.payload}");
//           _handleNotificationClick(response.payload!);
//         } else {
//           debugPrint("Notification dismissed without interaction.");
//           // Log when the notification is closed (dismissed) by the user
//           _logNotificationClosed();
//         }
//       },
//     );

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("Firebase onMessage: ${message.data}");
//       _handleForegroundMessage(message, flutterLocalNotificationsPlugin);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint("Firebase onMessageOpenedApp: ${message.data}");
//       _handleNotificationClick(jsonEncode(message.data));
//     });
//   }

//   static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Show notification: ${message.data}");
//     String? title = message.notification?.title;
//     String? body = message.notification?.body;
//     String? imageUrl = message.data['image'];

//     NotificationBodyModel notificationBody = convertNotification(message.data);

//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       debugPrint("Notification contains an image: $imageUrl");
//       try {
//         await _showBigPictureNotification(title, body, notificationBody, imageUrl, fln);
//       } catch (e) {
//         debugPrint("Error showing image notification: $e");
//         await _showTextNotification(title, body, notificationBody, fln);
//       }
//     } else {
//       debugPrint("Notification contains text only.");
//       await _showTextNotification(title, body, notificationBody, fln);
//     }
//   }

//   static Future<void> _showTextNotification(String? title, String? body, NotificationBodyModel notificationBody, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Preparing text notification...");
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       '6ammart',
//       'App Notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//     await fln.show(0, title, body, platformDetails, payload: jsonEncode(notificationBody.toJson()));
//     debugPrint("Text notification displayed.");
//   }

//   static Future<void> _showBigPictureNotification(String? title, String? body, NotificationBodyModel notificationBody, String imageUrl, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Downloading image for notification: $imageUrl");
//     final String largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
//     final String bigPicturePath = await _downloadAndSaveFile(imageUrl, 'bigPicture');
//     debugPrint("Image downloaded successfully.");

//     final BigPictureStyleInformation bigPictureStyle = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath),
//       largeIcon: FilePathAndroidBitmap(largeIconPath),
//       contentTitle: title,
//       summaryText: body,
//     );

//     final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       '6ammart',
//       'App Notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//       styleInformation: bigPictureStyle,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );

//      NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//     await fln.show(0, title, body, platformDetails, payload: jsonEncode(notificationBody.toJson()));
//     debugPrint("Big picture notification displayed.");
//   }

//   static Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     debugPrint("Starting file download: $url");
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     debugPrint("File downloaded and saved to: $filePath");
//     return filePath;
//   }

//   static NotificationBodyModel convertNotification(Map<String, dynamic> data) {
//     try {
//       debugPrint("Converting notification data: $data");
//       final type = data['type'];
//       switch (type) {
//         case 'advertisement':
//           return NotificationBodyModel(notificationType: NotificationType.advertisement, advertisementId: int.tryParse(data['advertisement_id'] ?? ''));
//         case 'order':
//           return NotificationBodyModel(notificationType: NotificationType.order, orderId: int.tryParse(data['order_id'] ?? ''));
//         default:
//           return NotificationBodyModel(notificationType: NotificationType.general);
//       }
//     } catch (e) {
//       debugPrint("Error converting notification data: $e");
//       return NotificationBodyModel(notificationType: NotificationType.general);
//     }
//   }

//   static void _handleNotificationClick(String payload) {
//     debugPrint("Handling notification click with payload: $payload");
//     try {
//       NotificationBodyModel notificationBody = NotificationBodyModel.fromJson(jsonDecode(payload));
//       final Map<NotificationType, Function> notificationActions = {
//         NotificationType.order: () => Get.toNamed('/order-details', arguments: notificationBody.orderId),
//         NotificationType.advertisement: () => Get.toNamed('/advertisement-details', arguments: notificationBody.advertisementId),
//         NotificationType.general: () => Get.toNamed('/notifications'),
//       };

//       notificationActions[notificationBody.notificationType]?.call();
//       debugPrint("Notification action executed for type: ${notificationBody.notificationType}");
//     } catch (e) {
//       debugPrint("Error handling notification click: $e");
//     }
//   }

//   static void _handleForegroundMessage(RemoteMessage message, FlutterLocalNotificationsPlugin fln) {
//     debugPrint("Handling foreground message: ${message.data}");
//     if (message.data['type'] == 'message') {
//       debugPrint("In-app message detected: ${message.data}");
//     } else {
//       showNotification(message, fln);
//     }
//   }

//   static void _logNotificationClosed() {
//     debugPrint("Notification closed by the user (not tapped).");
//   }
// }

// Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
//   debugPrint("Handling background message: ${message.data}");
// }


// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';

// class NotificationHelper {
//   static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize = const AndroidInitializationSettings('notification_icon');
//     var iOSInitialize = const DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

//     final androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//     if (androidImplementation != null) {
//       await androidImplementation.requestNotificationsPermission();
//     }

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         if (response.payload != null && response.payload!.isNotEmpty) {
//           debugPrint("Notification tapped with payload: ${response.payload}");
//           _handleNotificationClick(response.payload!);
//         } else {
//           debugPrint("Notification dismissed without interaction.");
//           _logNotificationClosed(); // Enhanced log function
//         }
//       },
//     );

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("Firebase onMessage: ${message.data}");
//       _handleForegroundMessage(message, flutterLocalNotificationsPlugin);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint("Firebase onMessageOpenedApp: ${message.data}");
//       _handleNotificationClick(jsonEncode(message.data));
//     });
//   }

//   static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Show notification: ${message.data}");
//     String? title = message.notification?.title;
//     String? body = message.notification?.body;
//     String? imageUrl = message.data['image'];

//     NotificationBodyModel notificationBody = convertNotification(message.data);

//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       debugPrint("Notification contains an image: $imageUrl");
//       try {
//         await _showBigPictureNotification(title, body, notificationBody, imageUrl, fln);
//       } catch (e) {
//         debugPrint("Error showing image notification: $e");
//         await _showTextNotification(title, body, notificationBody, fln);
//       }
//     } else {
//       debugPrint("Notification contains text only.");
//       await _showTextNotification(title, body, notificationBody, fln);
//     }
//   }

//   static Future<void> _showTextNotification(String? title, String? body, NotificationBodyModel notificationBody, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Preparing text notification...");
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       '6ammart',
//       'App Notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//     await fln.show(0, title, body, platformDetails, payload: jsonEncode(notificationBody.toJson()));
//     debugPrint("Text notification displayed.");
//   }

//   static Future<void> _showBigPictureNotification(String? title, String? body, NotificationBodyModel notificationBody, String imageUrl, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Downloading image for notification: $imageUrl");
//     final String largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
//     final String bigPicturePath = await _downloadAndSaveFile(imageUrl, 'bigPicture');
//     debugPrint("Image downloaded successfully.");

//     final BigPictureStyleInformation bigPictureStyle = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath),
//       largeIcon: FilePathAndroidBitmap(largeIconPath),
//       contentTitle: title,
//       summaryText: body,
//     );

//     final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       '6ammart',
//       'App Notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//       styleInformation: bigPictureStyle,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );

//     NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//     await fln.show(0, title, body, platformDetails, payload: jsonEncode(notificationBody.toJson()));
//     debugPrint("Big picture notification displayed.");
//   }

//   static Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     debugPrint("Starting file download: $url");
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     debugPrint("File downloaded and saved to: $filePath");
//     return filePath;
//   }

//   static NotificationBodyModel convertNotification(Map<String, dynamic> data) {
//     try {
//       debugPrint("Converting notification data: $data");
//       final type = data['type'];
//       switch (type) {
//         case 'advertisement':
//           return NotificationBodyModel(notificationType: NotificationType.advertisement, advertisementId: int.tryParse(data['advertisement_id'] ?? ''));
//         case 'order':
//           return NotificationBodyModel(notificationType: NotificationType.order, orderId: int.tryParse(data['order_id'] ?? ''));
//         default:
//           return NotificationBodyModel(notificationType: NotificationType.general);
//       }
//     } catch (e) {
//       debugPrint("Error converting notification data: $e");
//       return NotificationBodyModel(notificationType: NotificationType.general);
//     }
//   }

//   static void _handleNotificationClick(String payload) {
//     debugPrint("Handling notification click with payload: $payload");
//     try {
//       NotificationBodyModel notificationBody = NotificationBodyModel.fromJson(jsonDecode(payload));
//       final Map<NotificationType, Function> notificationActions = {
//         NotificationType.order: () => Get.toNamed('/order-details', arguments: notificationBody.orderId),
//         NotificationType.advertisement: () => Get.toNamed('/advertisement-details', arguments: notificationBody.advertisementId),
//         NotificationType.general: () => Get.toNamed('/notifications'),
//       };

//       notificationActions[notificationBody.notificationType]?.call();
//       debugPrint("Notification action executed for type: ${notificationBody.notificationType}");
//     } catch (e) {
//       debugPrint("Error handling notification click: $e");
//     }
//   }

//   static void _handleForegroundMessage(RemoteMessage message, FlutterLocalNotificationsPlugin fln) {
//     debugPrint("Handling foreground message: ${message.data}");
//     if (message.data['type'] == 'message') {
//       debugPrint("In-app message detected: ${message.data}");
//     } else {
//       showNotification(message, fln);
//     }
//   }

//   static void _logNotificationClosed({String? notificationId}) {
//     final timestamp = DateTime.now().toIso8601String();
//     debugPrint("Notification dismissed at $timestamp. ID: ${notificationId ?? 'unknown'}");
//   }
// }

// Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {






//   debugPrint("Handling background message: ${message.data}");

 


// }



// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';

// class NotificationHelper {
//   static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize = const AndroidInitializationSettings('notification_icon');
//     var iOSInitialize = const DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

//     final androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//     if (androidImplementation != null) {
//       await androidImplementation.requestNotificationsPermission();
//     }

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         if (response.payload != null && response.payload!.isNotEmpty) {
//           debugPrint("Notification tapped with payload: ${response.payload}");
//           _handleNotificationClick(response.payload!);
//         } else {
//           debugPrint("Notification dismissed without interaction.");
//           _logNotificationClosed(); // Enhanced log function
//         }
//       },
//     );

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("Firebase onMessage: ${message.data}");
//       _handleForegroundMessage(message, flutterLocalNotificationsPlugin);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint("Firebase onMessageOpenedApp: ${message.data}");
//       _handleNotificationClick(jsonEncode(message.data));
//     });
//   }

//   static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Show notification: ${message.data}");
//     String? title = message.notification?.title;
//     String? body = message.notification?.body;
//     String? imageUrl = message.data['image'];

//     NotificationBodyModel notificationBody = convertNotification(message.data);

//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       debugPrint("Notification contains an image: $imageUrl");
//       try {
//         await _showBigPictureNotification(title, body, notificationBody, imageUrl, fln);
//       } catch (e) {
//         debugPrint("Error showing image notification: $e");
//         await _showTextNotification(title, body, notificationBody, fln);
//       }
//     } else {
//       debugPrint("Notification contains text only.");
//       await _showTextNotification(title, body, notificationBody, fln);
//     }
//   }

//   static Future<void> _showTextNotification(String? title, String? body, NotificationBodyModel notificationBody, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Preparing text notification...");
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       '6ammart',
//       'App Notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//     await fln.show(0, title, body, platformDetails, payload: jsonEncode(notificationBody.toJson()));
//     debugPrint("Text notification displayed.");
//   }

//   static Future<void> _showBigPictureNotification(String? title, String? body, NotificationBodyModel notificationBody, String imageUrl, FlutterLocalNotificationsPlugin fln) async {
//     debugPrint("Downloading image for notification: $imageUrl");
//     final String largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
//     final String bigPicturePath = await _downloadAndSaveFile(imageUrl, 'bigPicture');
//     debugPrint("Image downloaded successfully.");

//     final BigPictureStyleInformation bigPictureStyle = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath),
//       largeIcon: FilePathAndroidBitmap(largeIconPath),
//       contentTitle: title,
//       summaryText: body,
//     );

//     final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       '6ammart',
//       'App Notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//       styleInformation: bigPictureStyle,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );

//     NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//     await fln.show(0, title, body, platformDetails, payload: jsonEncode(notificationBody.toJson()));
//     debugPrint("Big picture notification displayed.");
//   }

//   static Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     debugPrint("Starting file download: $url");
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     debugPrint("File downloaded and saved to: $filePath");
//     return filePath;
//   }

//   static Future<void> showRepeatingNotification(
//       FlutterLocalNotificationsPlugin fln, String title, String body) async {
//     debugPrint("Scheduling repeating notification...");
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'repeating_channel',
//       'Repeating Notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//     );
//     const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

//     await fln.periodicallyShow(
//       1, // Notification ID
//       title,
//       body,
//       RepeatInterval.everyMinute, // Set the interval
//       platformDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Required parameter
//     );
//     debugPrint("Repeating notification scheduled.");
//   }

//   static NotificationBodyModel convertNotification(Map<String, dynamic> data) {
//     try {
//       debugPrint("Converting notification data: $data");
//       final type = data['type'];
//       switch (type) {
//         case 'advertisement':
//           return NotificationBodyModel(notificationType: NotificationType.advertisement, advertisementId: int.tryParse(data['advertisement_id'] ?? ''));
//         case 'order':
//           return NotificationBodyModel(notificationType: NotificationType.order, orderId: int.tryParse(data['order_id'] ?? ''));
//         default:
//           return NotificationBodyModel(notificationType: NotificationType.general);
//       }
//     } catch (e) {
//       debugPrint("Error converting notification data: $e");
//       return NotificationBodyModel(notificationType: NotificationType.general);
//     }
//   }

//   static void _handleNotificationClick(String payload) {
//     debugPrint("Handling notification click with payload: $payload");
//     try {
//       NotificationBodyModel notificationBody = NotificationBodyModel.fromJson(jsonDecode(payload));
//       final Map<NotificationType, Function> notificationActions = {
//         NotificationType.order: () => Get.toNamed('/order-details', arguments: notificationBody.orderId),
//         NotificationType.advertisement: () => Get.toNamed('/advertisement-details', arguments: notificationBody.advertisementId),
//         NotificationType.general: () => Get.toNamed('/notifications'),
//       };

//       notificationActions[notificationBody.notificationType]?.call();
//       debugPrint("Notification action executed for type: ${notificationBody.notificationType}");
//     } catch (e) {
//       debugPrint("Error handling notification click: $e");
//     }
//   }

//   static void _handleForegroundMessage(RemoteMessage message, FlutterLocalNotificationsPlugin fln) {
//     debugPrint("Handling foreground message: ${message.data}");
//     if (message.data['type'] == 'message') {
//       debugPrint("In-app message detected: ${message.data}");
//     } else {
//       showNotification(message, fln);
//     }
//   }

//   static void _logNotificationClosed({String? notificationId}) {
//     final timestamp = DateTime.now().toIso8601String();
//     debugPrint("Notification dismissed at $timestamp. ID: ${notificationId ?? 'unknown'}");
//   }
// }

// Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
//   debugPrint("Handling background message: ${message.data}");
// }

