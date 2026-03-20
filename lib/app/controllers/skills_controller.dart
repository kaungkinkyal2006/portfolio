import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porfolio/app/data/porfolio_data.dart';

class SkillsController extends GetxController
    with GetTickerProviderStateMixin {

  // All skills from data
  final skills = PortfolioData.skills.obs;

  // Active category filter — 'All' shows everything
  final selectedCategory = 'All'.obs;

  // Track if section is visible (triggers bar animation)
  final isVisible = false.obs;

  // One AnimationController per skill bar
  late List<AnimationController> barControllers;
  late List<Animation<double>>   barAnimations;

  // Unique categories built from data
  List<String> get categories {
    final cats = skills.map((s) => s['category'] as String).toSet().toList();
    return ['All', ...cats];
  }

  // Filtered list based on selected category
  List<Map<String, dynamic>> get filteredSkills {
    if (selectedCategory.value == 'All') return skills;
    return skills
        .where((s) => s['category'] == selectedCategory.value)
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _setupBarAnimations();
  }

  void _setupBarAnimations() {
    barControllers = List.generate(
      PortfolioData.skills.length,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600 + (i * 100)),
      ),
    );

    barAnimations = List.generate(
      PortfolioData.skills.length,
      (i) => Tween<double>(
        begin: 0,
        end: PortfolioData.skills[i]['level'] as double,
      ).animate(CurvedAnimation(
        parent: barControllers[i],
        curve: Curves.easeOutCubic,
      )),
    );
  }

  // Called when section scrolls into view
  void onSectionVisible() {
    if (isVisible.value) return; // only animate once
    isVisible.value = true;
    for (final ctrl in barControllers) {
      Future.delayed(const Duration(milliseconds: 200), ctrl.forward);
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  @override
  void onClose() {
    for (final ctrl in barControllers) {
      ctrl.dispose();
    }
    super.onClose();
  }
}