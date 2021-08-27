import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  initialize() async {
    print("HERE IS IT Notification start");
    String? to = await FirebaseMessaging.instance.getToken();
    print("HERE IS IT Notification token $to");
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      print("HERE IS IT got message");
      print('Message data: ${message.data}');
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("HERE IS IT got message");
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("HERE IS IT got message");
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }

  triggerNotification() {
    //todo:
  }

  subscribeToId(String topic, {subscribe: true}) async {
    if (subscribe)
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    else
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
