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
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    userId = decodedToken['sub'];
    return userId;
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print('Local Notifications Initialized');
  }

  Future<void> initNotifications(String roomId) async {
    await _firebaseMessaging.requestPermission();
    userId = await getUserId();
    final fCMToken = await _firebaseMessaging.getToken();
    User user = await userRepository.getUser(userId);
    await userRepository.updateUserAndroidToken(user, fCMToken!);
    await _firebaseMessaging.subscribeToTopic('chat_$roomId');
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
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen(handleMessage);
    print('Push Notifications Initialized');
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
