import 'package:get/route_manager.dart';
import 'package:porfolio/app/binding/initial_binding.dart';
import 'package:porfolio/app/view/home/home_view.dart';

abstract class AppRoutes {
  static const home = '/';
  static const about = '/#about';
  static const skills = '/#skills';
  static const projects = '/#projects';
  static const contact = '/#contact';

  static final page = [
    GetPage(
    name: home,
    page: () => HomeView(),
    binding: InitialBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
    ),
  
  ];
}
