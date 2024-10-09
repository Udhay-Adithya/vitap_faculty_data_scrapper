import 'dart:convert';
import 'dart:io';

/// This function reads faculty profiles from a JSON file, processes the
/// data to count qualifications, awards, projects, and generates analytics
/// before saving the results to separate JSON files.
Future<void> analytics() async {
  // Path to the input JSON file (replace with your actual file path)
  final inputJsonFilePath = 'faculty_profiles.json'; // Input JSON file path
  final outputJsonFilePath = 'employee_id.json'; // Output JSON file path
  final analyticsJsonFilePath = 'analytics.json'; // Analytics output file path

  // Read the JSON data from the file
  final jsonString = await File(inputJsonFilePath).readAsString();

  // Parse the JSON string into a Map
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);

  // Access the 'data' key to get the list of items
  final List<dynamic> data = jsonData['data'];

  // Mapping of Name to Employee_Id
  final Map<String, double> nameToEmployeeId = {};

  // Initialize analytics variables
  int ugCount = 0; // Count of employees with UG education
  int pgCount = 0; // Count of employees with PG education
  int phdCount = 0; // Count of employees with PhD education
  int awardsCount = 0; // Count of employees with awards
  int projectsCount = 0; // Count of employees with projects
  Map<String, int> ugColleges = {}; // Mapping of UG colleges to counts
  Map<String, int> pgColleges = {}; // Mapping of PG colleges to counts
  Map<String, int> phdColleges = {}; // Mapping of PhD colleges to counts
  int linkedInCount = 0; // Count of employees with LinkedIn profiles
  int personalWebsiteCount = 0; // Count of employees with personal websites

  // Process the data
  for (var item in data) {
    // Safely access the attributes
    if (item.containsKey('attributes')) {
      final attributes = item['attributes'];
      final name = attributes['Name'] ?? 'Unknown'; // Get employee name

      // Employee ID
      final employeeIdRaw = attributes['Employee_Id'];
      double employeeId;
      if (employeeIdRaw is int) {
        employeeId = employeeIdRaw.toDouble(); // Convert int to double
      } else if (employeeIdRaw is double) {
        employeeId = employeeIdRaw; // Use as-is if already double
      } else {
        employeeId = 0.0; // Default value if Employee_Id is invalid
      }

      // Map name to Employee_Id
      nameToEmployeeId[name] = employeeId;

      // Debugging: Print the attributes for each item
      print('Processing: $name, Attributes: $attributes');

      // Count qualifications
      if (attributes['Education_UG'] != null &&
          attributes['Education_UG'].isNotEmpty) {
        ugCount++;
        final ugCollege = attributes['Education_UG_College'] ?? 'Unknown';
        ugColleges[ugCollege] = (ugColleges[ugCollege] ?? 0) + 1;
      }
      if (attributes['Education_PG'] != null &&
          attributes['Education_PG'].isNotEmpty) {
        pgCount++;
        final pgCollege = attributes['Education_PG_College'] ?? 'Unknown';
        pgColleges[pgCollege] = (pgColleges[pgCollege] ?? 0) + 1;
      }
      if (attributes['Education_PHD'] != null &&
          attributes['Education_PHD'].isNotEmpty) {
        phdCount++;
        final phdCollege = attributes['Education_PHD_College'] ?? 'Unknown';
        phdColleges[phdCollege] = (phdColleges[phdCollege] ?? 0) + 1;
      }

      // Count awards and projects
      if (attributes['Awards_and_Recognitions'] != null &&
          attributes['Awards_and_Recognitions'].isNotEmpty) {
        awardsCount++;
      }
      if (attributes['Projects'] != null && attributes['Projects'].isNotEmpty) {
        projectsCount++;
      }

      // Count LinkedIn and personal website
      if (attributes['LinkedIn'] != null) {
        linkedInCount++;
      }
      if (attributes['Website'] != null) {
        personalWebsiteCount++;
      }
    }
  }

  // Determine most common colleges for UG, PG, and PhD
  String ugMostCommonCollege = ugColleges.isNotEmpty
      ? ugColleges.entries.reduce((a, b) => a.value > b.value ? a : b).key
      : 'N/A'; // Default value if no UG colleges

  String pgMostCommonCollege = pgColleges.isNotEmpty
      ? pgColleges.entries.reduce((a, b) => a.value > b.value ? a : b).key
      : 'N/A'; // Default value if no PG colleges

  String phdMostCommonCollege = phdColleges.isNotEmpty
      ? phdColleges.entries.reduce((a, b) => a.value > b.value ? a : b).key
      : 'N/A'; // Default value if no PhD colleges

  // Prepare analytics data
  final analyticsData = {
    'total_employees': nameToEmployeeId.length,
    'ug_count': ugCount,
    'pg_count': pgCount,
    'phd_count': phdCount,
    'awards_count': awardsCount,
    'projects_count': projectsCount,
    'most_common_ug_college': ugMostCommonCollege,
    'most_common_pg_college': pgMostCommonCollege,
    'most_common_phd_college': phdMostCommonCollege,
    'linkedIn_count': linkedInCount,
    'personal_website_count': personalWebsiteCount,
  };

  // Save the mapping to a JSON file
  final jsonFile = File(outputJsonFilePath);
  await jsonFile.writeAsString(jsonEncode(nameToEmployeeId));
  print('\nMapping saved to $outputJsonFilePath');

  // Save the analytics to a JSON file
  final analyticsFile = File(analyticsJsonFilePath);
  await analyticsFile.writeAsString(jsonEncode(analyticsData));
  print('Analytics saved to $analyticsJsonFilePath');
}
