import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Fetches faculty profiles from the specified API endpoint.
///
/// This function constructs a GET request to the faculty profiles API,
/// optionally filtering by the given [employeeId]. If the request is successful,
/// it prints the response data to the console and writes it to a JSON file.
///
/// [employeeId] is an optional parameter that specifies the employee ID to filter the results.
///
/// Throws an [Exception] if the request fails or if the server returns an error response.
Future<void> fetchFacultyProfiles({String? employeeId}) async {
  // Base URL and endpoint
  final String baseUrl = "https://cms.vitap.ac.in";
  String endpoint =
      "/api/faculty-profiles?populate[Patents][populate]=*&populate[Awards_and_Recognitions][populate]=*&populate[Projects][populate]=*&populate[Photo][populate]=*";

  // Add filter if employeeId is provided
  if (employeeId != null) {
    endpoint += "&filters[Employee_Id][\$eq]=$employeeId";
  }

  final Uri url = Uri.parse("$baseUrl$endpoint");

  // Authorization token for the API
  final String authToken =
      "3e602eb0ea823444179f1baf562a6e3ef4b260b83908ba8ada025e67f8f279493f69268174f966c8cfabcf50396a50cb59db8f12cb369a5d5e86aa253551c030c98e1f0f940efb018185dd359a5461a8b472c1bca7b0da7b04ebd60b33019c22afe8a5ffdd05450b11e059a342ff9711c17a5e30bda15e120a895d9786ac254f";

  // Sending GET request
  final response = await http.get(url, headers: {
    "Authorization": "Bearer $authToken",
  });

  // Check the response status
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data); // Print the data to the console
    await writeJsonToFile(data, 'faculty_profiles.json'); // Write to JSON file
  } else {
    throw Exception('Failed to load faculty profiles: ${response.statusCode}');
  }
}

/// Writes the given JSON data to a file in a formatted manner.
///
/// This function takes a [jsonData] map and a [fileName] string,
/// converts the JSON data to a formatted string, and writes it
/// to the specified file. If the write operation is successful,
/// a success message is printed to the console.
///
/// [jsonData] is a map containing the JSON data to be written to the file.
/// [fileName] is the name of the file where the JSON data will be saved.
Future<void> writeJsonToFile(
    Map<String, dynamic> jsonData, String fileName) async {
  final file = File(fileName);

  // Convert JSON data to a formatted string
  final String jsonString = JsonEncoder.withIndent('  ').convert(jsonData);

  // Write the JSON string to the file
  await file.writeAsString(jsonString);
  log('Data written to $fileName successfully.');
}
