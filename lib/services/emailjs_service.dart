import 'dart:convert';

import 'package:http/http.dart' as http;

class EmailJsService {
  // TODO: Replace these placeholder values with your actual EmailJS IDs.
  static const String _serviceId = 'service_brozobb';
  static const String _templateId = 'template_nu5jr0l';
  static const String _publicKey = 'c4xY59LnelCEouZXP';

  static const String _apiUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  static Future<bool> sendOtp({
    required String toEmail,
    required String toName,
    required String otpCode,
  }) async {
    final payload = {
      'service_id': _serviceId,
      'template_id': _templateId,
      'user_id': _publicKey,
      'template_params': {
        'to_email': toEmail,
        'to_name': toName,
        'otp_code': otpCode,
      },
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> sendPasswordReset({
    required String toEmail,
    required String resetCode,
  }) async {
    final payload = {
      'service_id': _serviceId,
      'template_id': _templateId,
      'user_id': _publicKey,
      'template_params': {
        'to_email': toEmail,
        'to_name': 'User',
        'otp_code': 'Password Reset Code: $resetCode',
      },
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
