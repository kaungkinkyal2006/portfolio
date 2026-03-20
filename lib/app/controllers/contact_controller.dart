import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porfolio/app/data/porfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final nameCtrl    = TextEditingController();
  final emailCtrl   = TextEditingController();
  final messageCtrl = TextEditingController();

  // Reactive states
  final isSending  = false.obs;
  final isSent     = false.obs;

  // ── Validators ─────────────────────────────────────────
  String? validateName(String? val) {
    if (val == null || val.trim().isEmpty) return 'Please enter your name';
    if (val.trim().length < 2) return 'Name is too short';
    return null;
  }

  String? validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return 'Please enter your email';
    if (!GetUtils.isEmail(val.trim())) return 'Please enter a valid email';
    return null;
  }

  String? validateMessage(String? val) {
    if (val == null || val.trim().isEmpty) return 'Please enter a message';
    if (val.trim().length < 10) return 'Message is too short';
    return null;
  }

  // ── Submit ─────────────────────────────────────────────
  Future<void> submit() async {
    // Validate all fields first
    if (!formKey.currentState!.validate()) return;

    isSending.value = true;

    // Build mailto URL with prefilled subject and body
    final subject = Uri.encodeComponent(
      'Portfolio contact from ${nameCtrl.text.trim()}',
    );
    final body = Uri.encodeComponent(
      'Name: ${nameCtrl.text.trim()}\n'
      'Email: ${emailCtrl.text.trim()}\n\n'
      '${messageCtrl.text.trim()}',
    );

    final uri = Uri.parse(
      'mailto:${PortfolioData.email}?subject=$subject&body=$body',
    );

    await Future.delayed(const Duration(milliseconds: 600));

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      isSent.value = true;
      _clearForm();
    } else {
      Get.snackbar(
        'Could not open mail app',
        'Please email me directly at ${PortfolioData.email}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }

    isSending.value = false;

    // Reset success state after 4 seconds
    if (isSent.value) {
      await Future.delayed(const Duration(seconds: 4));
      isSent.value = false;
    }
  }

  void _clearForm() {
    nameCtrl.clear();
    emailCtrl.clear();
    messageCtrl.clear();
    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    messageCtrl.dispose();
    super.onClose();
  }
}