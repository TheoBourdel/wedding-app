import 'package:client/model/user.dart';
import 'package:client/repository/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final UserRepository userRepository = UserRepository();
  int userId = 0;

  FirebaseApi() {
    _initializeLocalNotifications();
  }

  Future getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception("Token not found in SharedPreferences");
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    userId = decodedToken['sub'];
    return userId;
  }

  Future<void> initNotifications(String roomId) async {
    await _firebaseMessaging.requestPermission();
    try {
      userId = await getUserId();
    } catch (e) {
      print("Failed to get user ID: $e");
      return;
    }
    final fCMToken = await _firebaseMessaging.getToken();
    if (fCMToken != null) {
      User user = await userRepository.getUser(userId);
      await userRepository.updateUserAndroidToken(user, fCMToken);
      await _firebaseMessaging.subscribeToTopic('chat_$roomId');
    } else {
      print("Failed to get FCM token");
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // handle your logic here
      },
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // handle your logic here
      },
    );
    print('Local Notifications Initialized');
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    print('Message received: ${message.messageId}');
    final notification = message.notification;
    if (notification != null) {
      print('Notification: ${notification.title}, ${notification.body}');
      _showNotification(notification);
    }
  }

  Future<void> _showNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(), // iOS notification details
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
    );
    print('Notification shown');
  }

  Future<void> initPushNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions for iOS
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    print('Push Notifications Initialized');
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
