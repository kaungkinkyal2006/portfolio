import 'package:get/get.dart';
import 'package:porfolio/app/data/porfolio_data.dart';

class ProjectsController extends GetxController {
  final projects = PortfolioData.projects.obs;
  final selectedTag = 'All'.obs;

  // All unique tags across all projects
  List<String> get tags {
    final allTags = projects
        .expand((p) => (p['tags'] as List).cast<String>())
        .toSet()
        .toList();
    return ['All', ...allTags];
  }

  // Filtered projects based on selected tag
  List<Map<String, dynamic>> get filteredProjects {
    if (selectedTag.value == 'All') return projects;
    return projects.where((p) {
      final tags = (p['tags'] as List).cast<String>();
      return tags.contains(selectedTag.value);
    }).toList();
  }

  void selectTag(String tag) => selectedTag.value = tag;
}