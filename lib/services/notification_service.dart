import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
    final FirebaseMessaging _messaging = FirebaseMessaging.instance;

    Future<void> initialize() async{
        await _messaging.requestPermission(
            alert: true,
            badge: true,
            sound: true,
        );
        
        if(!kIsWeb) {
            await _messaging.subscribeToTopic('notices');
        }

        final token = await _messaging.getToken();
        print('FCM Token: $token');
    }
}