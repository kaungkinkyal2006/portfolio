import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porfolio/app/data/porfolio_data.dart';

class HeroController extends GetxController
    with GetTickerProviderStateMixin {

  // ── Typed text effect state ────────────────────────────
  final displayedText  = ''.obs;
  final currentStringIndex = 0.obs;
  bool _isDeleting = false;

  Timer? _typingTimer;

  // ── Entrance animation ─────────────────────────────────
  late AnimationController entranceController;
  late Animation<double>   fadeAnim;
  late Animation<Offset>   slideAnim;

  @override
  void onInit() {
    super.onInit();
    _setupEntranceAnimation();
    _startTyping();
  }

  void _setupEntranceAnimation() {
    entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fadeAnim = CurvedAnimation(
      parent: entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));

    // Start entrance after first frame
    entranceController.forward();
  }

  void _startTyping() {
    _scheduleNext(isInitial: true);
  }

  void _scheduleNext({bool isInitial = false}) {
    final delay = isInitial
        ? const Duration(milliseconds: 1200)
        : _isDeleting
            ? const Duration(milliseconds: 50)
            : const Duration(milliseconds: 120);

    _typingTimer = Timer(delay, _tick);
  }

  void _tick() {
    final strings  = PortfolioData.typedStrings;
    final target   = strings[currentStringIndex.value];
    final current  = displayedText.value;

    if (!_isDeleting) {
      // Type one character
      if (current.length < target.length) {
        displayedText.value = target.substring(0, current.length + 1);
        _scheduleNext();
      } else {
        // Pause at full word then start deleting
        _typingTimer = Timer(const Duration(milliseconds: 1800), () {
          _isDeleting = true;
          _scheduleNext();
        });
      }
    } else {
      // Delete one character
      if (current.isNotEmpty) {
        displayedText.value = current.substring(0, current.length - 1);
        _scheduleNext();
      } else {
        // Move to next string
        _isDeleting = false;
        currentStringIndex.value =
            (currentStringIndex.value + 1) % strings.length;
        _scheduleNext();
      }
    }
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    entranceController.dispose();
    super.onClose();
  }
}