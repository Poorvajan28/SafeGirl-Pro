import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class TelephonyService {
  Future<bool> sendSms({required String phone, required String body}) async {
    final uri = Uri(scheme: 'sms', path: phone, queryParameters: {'body': body});
    try {
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(uri);
        return launched;
      }
    } catch (e) {
      debugPrint('TelephonyService SMS error: $e');
    }
    return false;
  }

  Future<bool> makeCall({required String phone}) async {
    final uri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(uri);
        return launched;
      }
    } catch (e) {
      debugPrint('TelephonyService Call error: $e');
    }
    return false;
  }
}
