import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class FcmV1Service {
  // --- SERVICE ACCOUNT DATA (Embedded for maximum simplicity) ---
  // Since you wanted no complications and a single function, we are putting this back.
  // This allows the app to send notifications directly without needing a separate backend server!
  static const Map<String, dynamic> _serviceAccount = {
    "type": "service_account",
    "project_id": "taskmanagment-d25b4",
    "private_key_id": "9840f9bb3021b9fe55389e7b69c396f192c56179",
    "private_key": "-----BEGIN PRIVATE KEY-----\n" +
        "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC5rrCQpUInyTgE" +
        "oAJk3YL47VAxsvu9OdfhKdqU3T7exdWnUkYPM5bXY2aroYmdlYaJyPZevzeDW3MT" +
        "OmwHst8+HvWyHqzgtkueQaa3wHTsyywZxo00dnr0dI0ynQxypIGFM/ptoa1y/gIU" +
        "5oaYLcbYQeI3nVzQMpyW3edZ37SyZwe/FjyLpmqh1sOecgqqoVHJ2EEwSPLhFV/5" +
        "plWsPxjzZR664bTwqwy/jgDk0T0UvcQ7xm/FNy9Jr8zUjng4so/yooEk3tOfrbDK" +
        "q2lO4oZCXdbKrTtxkB78AQreixBMDQsI2qK416kEWZnFQQTfLBiP5UOOcBjdh4a/" +
        "qeEocI6JAgMBAAECggEAWULqLE7Vc6zemhKVtAlsmd/zakDhlcDFz79ADcoiHBO8" +
        "ttftSAeD3v0w8RcRwciMyZXrIfcIZ8RBmJ/AKR9LBGD7uenXL5tS1Lw4uiLx0peF" +
        "FssFPJAsYXHaIteukToV7YPkQmmzqREEzSlY0LVI3tMlPZkPciKydjAstF6/Tfc5" +
        "V2dQKm0qwHwm3UA8ZfBspnQaiZKiNssJVBROyXKtJZdZENBqVwkSDtqJwJWXD/xG" +
        "//jwg9wdnrX0wDU0O3t99adcOjXxRPfgVIxZHxPmaaHcaV7XBZLklnPA2C3GYsuR" +
        "3451WXdXbHbSXyyJO1+GBa5Jo2rdqu/wDxVbKu3UhQKBgQDrrTdK/w0PJ4XW8Xz6" +
        "6eDe7YxmUH38Gb3XSrHJMZEaTUc77eVI7Oc+bTiONq7IGRO/IpuPl2aE2yM6BNXG" +
        "17TLT2qO2danuG2W/97wEN6QrjodWp+dAJRMXzqcGzIeRLABsQSgFeVnnp4S8/HK" +
        "DGu97EwvN8IW9WGaWlLCBsw/awKBgQDJsc24d+RfTs3F4VnW2OcbHsp2JICXWu1I" +
        "Br13O4XjvALvkJuzVqCazBWXYgr12AF+PgSbm5zLqMHExmS+JZpSgL0WQLX+ESdG" +
        "OmhiTMmthhibqczrQAsW7jEauDXQPuDnKEP1t57e16kwMp+hVnZ2wqsI3hUKYi7a" +
        "hOe/sVxq2wKBgAihb0Tv0iqb5+rXLRyDNBj12g5lJDf3OVyI/7m+dvHfopwvOhZR" +
        "lqZSmZ+boQry4CY/vjKj+L0kyUV2p92ASL6pSd2xXIsH1fuRozhnZb8mojow92do" +
        "fgXN9veAh3VUTp3BPcofAyeoR2GqTVB44/kwjhmskQ8GLWzZoe45EYHBAoGBAK2A" +
        "Pi9JMzKpX2mxiM7Al01FF3S5wcRxe1xSL/m5Qlu9B+l8w/NpuY5vsMMgm70Pq3kl" +
        "cGFLY33uFYFoCJFpV29RP1c9I1EDAH3xEIo+895JVDHTx2s3FFMNY0BQ5jnVXTJ7" +
        "+LoO0qNvcSL86USoVA+lNevS3tanzxY67gCAWbexAoGBALj7Mt1jMkqQdZSuZhow" +
        "cY3fpzEAwS9+cxWxB8ZH3evHSGcmiZHGs6kP+XhM9RosL+za7ElrSwUcKErXYh1I" +
        "pwpz7O1N2hd+1F7wwF4nCvd4yZspCquuXcoDID0g9Nv45LaAL8FsuGotkbLU986h" +
        "vcvC9OaHatNa1n0oz9pdP4XZ\n" +
        "-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-fbsvc@taskmanagment-d25b4.iam.gserviceaccount.com",
    "client_id": "100455002443442713031",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40taskmanagment-d25b4.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  static final _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  static Future<String> getAccessToken() async {
    final credentials = auth.ServiceAccountCredentials.fromJson(_serviceAccount);
    final client = await auth.clientViaServiceAccount(credentials, _scopes);
    return client.credentials.accessToken.data;
  }

  static Future<void> sendNotification({
    required String recipientUid,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      // 1. Get recipient's FCM token from Firestore
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(recipientUid).get();
      final token = userDoc.data()?['fcmToken'];

      if (token == null) {
        print('Error: No FCM token for user $recipientUid');
        return;
      }

      // 2. Get OAuth2 Access Token
      final accessToken = await getAccessToken();

      // 3. Construct FCM V1 Payload (Includes the data map for deep linking)
      final payload = {
        "message": {
          "token": token,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": data ?? {},
          "android": {
            "priority": "high",
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK"
            }
          }
        }
      };

      // 4. Send POST request to FCM V1 API
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/${_serviceAccount['project_id']}/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully directly from app');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending FCM V1 notification: $e');
    }
  }
}
