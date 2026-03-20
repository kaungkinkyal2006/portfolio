import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final currentIndex   = 0.obs;
  final isMenuOpen     = false.obs;  // mobile drawer state
  final isScrolled     = false.obs;  // true when page scrolled down

  final scrollController = ScrollController();
  final sectionKeys = List.generate(4, (_) => GlobalKey());
  final sections = ['Home', 'Skills', 'Projects', 'Contact'];

  @override
  void onInit() {
    super.onInit();
    // Listen to scroll to add shadow/bg to navbar when scrolled
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    isScrolled.value = scrollController.offset > 10;
  }

  void toggleMenu() => isMenuOpen.value = !isMenuOpen.value;

  void closeMenu() => isMenuOpen.value = false;

  void scrollToSection(int index) {
    currentIndex.value = index;
    closeMenu(); // always close drawer on navigation

    final context = sectionKeys[index].currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }
}