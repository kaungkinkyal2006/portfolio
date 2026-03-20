import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/hero_controller.dart';
import '../controllers/skills_controller.dart';
import '../controllers/projects_controller.dart';
import '../controllers/contact_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController(), fenix: true);
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    Get.lazyPut<HeroController>(() => HeroController(), fenix: true);
    Get.lazyPut<SkillsController>(() => SkillsController(), fenix: true);
    Get.lazyPut<ProjectsController>(() => ProjectsController(), fenix: true);
    Get.lazyPut<ContactController>(() => ContactController(), fenix: true);
  }
}