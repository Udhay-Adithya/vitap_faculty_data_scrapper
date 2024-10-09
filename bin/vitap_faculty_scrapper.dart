import 'package:vitap_faculty_scrapper/vitap_faculty_scrapper.dart';

/// The entry point of the application.
///
/// This function initializes the application and calls the
/// [fetchFacultyProfiles] function to retrieve faculty profiles
/// from the specified API endpoint. It accepts a list of
/// command-line arguments, which can be used for further
/// customization if needed in the future.
void main(List<String> arguments) {
  // Fetch faculty profiles from the API
  fetchFacultyProfiles();
}
