// // // import 'package:get/get.dart';

// // // import '../models/investigation_model.dart';
// // // import '../services/api_service.dart';
// // // import '../services/apis.dart'; // adjust path as needed
// // // import '../utils/overlay.dart';
// // // import '../utils/snackbar.dart';

// // // class InvestigationController extends GetxController {
// // //   final RxList<InvestigationModel> investigations = <InvestigationModel>[].obs;
// // //   final RxBool isLoading = false.obs;

// // //   /// Fetch investigations by patient MongoDB ID
// // //   Future<void> getInvestigationsByPatientId(String patientMongoId) async {
// // //     try {
// // //       isLoading.value = true;
// // //       // Use the existing API variable (note typo fixed)
// // //       final String url = "$baseUrl/api/investigation/get-by-patient-mongo-id/$patientMongoId";
      
// // //       final helper = NetworkHelper(url: url);
// // //       final response = await helper.get(auth: true);

// // //       if (response['success'] == true) {
// // //         final List data = response['data'] ?? [];
// // //         investigations.value = data.map((e) => InvestigationModel.fromJson(e)).toList();
// // //       } else {
// // //         AppSnackbar.show(
// // //           title: 'Error',
// // //           message: response['message'] ?? 'Failed to load investigations',
// // //           type: AppSnackType.error,
// // //         );
// // //       }
// // //     } catch (e) {
// // //       AppSnackbar.show(
// // //         title: 'Error',
// // //         message: e.toString(),
// // //         type: AppSnackType.error,
// // //       );
// // //     } finally {
// // //       isLoading.value = false;
// // //     }
// // //   }
// // // }

   
// // import 'package:get/get.dart';
// // import '../models/investigation_model.dart';
// // import '../services/api_service.dart'; // Assuming NetworkHelper is here
// // import '../services/apis.dart';
// // import '../utils/snackbar.dart';

// // class InvestigationController extends GetxController {
// //   final RxList<InvestigationModel> investigations = <InvestigationModel>[].obs;
// //   final RxBool isLoading = false.obs;

// //   /// Fetch investigations by patient MongoDB ID
// //   Future<void> getInvestigationsByPatientId(String patientMongoId) async {
// //     try {
// //       isLoading.value = true;
// //       final String url = "$baseUrl/api/investigation/get-by-patient-mongo-id/$patientMongoId";
      
// //       final helper = NetworkHelper(url: url);
// //       final response = await helper.get(auth: true);

// //       if (response['success'] == true) {
// //         final List data = response['data'] ?? [];
// //         investigations.value = data.map((e) => InvestigationModel.fromJson(e)).toList();
// //       } else {
// //         AppSnackbar.show(
// //           title: 'Error',
// //           message: response['message'] ?? 'Failed to load investigations',
// //           type: AppSnackType.error,
// //         );
// //       }
// //     } catch (e) {
// //       AppSnackbar.show(title: 'Error', message: e.toString(), type: AppSnackType.error);
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   /// Create Investigation API Integration
// //   Future<bool> createInvestigation({
// //     required String patientMongoId,
// //     required String patientId,
// //     required Map<String, dynamic> formData,
// //   }) async {
// //     try {
// //       isLoading.value = true;
// //       final String url = "$baseUrl/api/investigation/create";

// //       // Merging your form data with the required Patient IDs
// //       final Map<String, dynamic> body = {
// //         "patientMongoId": patientMongoId,
// //         "patientId": patientId,
// //         ...formData,
// //       };

// //       final helper = NetworkHelper(url: url);
// //       final response = await helper.post(body: body, auth: true);

// //       if (response['success'] == true) {
// //         AppSnackbar.show(
// //           title: 'Success',
// //           message: response['message'] ?? 'Investigation request generated !!',
// //           type: AppSnackType.success,
// //         );
// //         // Refresh the list immediately
// //         await getInvestigationsByPatientId(patientMongoId);
// //         return true;
// //       } else {
// //         AppSnackbar.show(
// //           title: 'Failed',
// //           message: response['message'] ?? 'Check your input',
// //           type: AppSnackType.error,
// //         );
// //         return false;
// //       }
// //     } catch (e) {
// //       AppSnackbar.show(title: 'Error', message: e.toString(), type: AppSnackType.error);
// //       return false;
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// // }


// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../models/investigation_model.dart';
// import '../services/api_service.dart';
// import '../services/apis.dart';
// import '../utils/snackbar.dart';

// class InvestigationController extends GetxController {
//   final RxList<InvestigationModel> investigations = <InvestigationModel>[].obs;
//   final RxBool isLoading = false.obs;
//   final Rx<InvestigationModel?> selectedInvestigation = Rx<InvestigationModel?>(null);
//   final RxString errorMessage = ''.obs;

//   /// Fetch investigations by patient MongoDB ID
//   Future<void> getInvestigationsByPatientId(String patientMongoId) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
      
//       final String url = "$baseUrl/api/investigation/get-by-patient-mongo-id/$patientMongoId";
//       print("📤 GET Request URL: $url");
      
//       final helper = NetworkHelper(url: url);
//       final response = await helper.get(auth: true);

//       print("📥 GET Response: $response");

//       if (response['success'] == true) {
//         final List data = response['data'] ?? [];
//         investigations.value = data.map((e) => InvestigationModel.fromJson(e)).toList();
//         print("✅ Loaded ${investigations.length} investigations");
//       } else {
//         errorMessage.value = response['message'] ?? 'Failed to load investigations';
//         AppSnackbar.show(
//           title: 'Error',
//           message: errorMessage.value,
//           type: AppSnackType.error,
//         );
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       print("❌ GET Error: $e");
//       AppSnackbar.show(
//         title: 'Error', 
//         message: e.toString(), 
//         type: AppSnackType.error
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Get single investigation by ID
//   Future<void> getInvestigationById(String investigationId) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
      
//       final String url = "$baseUrl/api/investigation/$investigationId";
//       print("📤 GET Single Request URL: $url");
      
//       final helper = NetworkHelper(url: url);
//       final response = await helper.get(auth: true);

//       print("📥 GET Single Response: $response");

//       if (response['success'] == true) {
//         selectedInvestigation.value = InvestigationModel.fromJson(response['data']);
//         print("✅ Loaded investigation: ${selectedInvestigation.value?.id}");
//       } else {
//         errorMessage.value = response['message'] ?? 'Failed to load investigation';
//         AppSnackbar.show(
//           title: 'Error',
//           message: errorMessage.value,
//           type: AppSnackType.error,
//         );
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       print("❌ GET Single Error: $e");
//       AppSnackbar.show(
//         title: 'Error', 
//         message: e.toString(), 
//         type: AppSnackType.error
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Create Investigation API Integration
//   Future<bool> createInvestigation({
//     required String patientMongoId,
//     required String patientId,
//     required String doctorMongoId,
//     required String investigationType,
//     required String priority,
//     required String scheduledDateAndTime,
//     required String reasonForInvestigation,
//     required String clinicalHistory,
//     required String investigationDetails,
//     required String tags,
//     required String insuranceStatus,
//     String? paymentStatus,
//     bool insuranceCovered = false,
//   }) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
      
//       final String url = "$baseUrl/api/investigation/create";
//       print("📤 POST Request URL: $url");

//       // Validate required fields
//       if (patientMongoId.isEmpty) throw Exception("patientMongoId is required");
//       if (patientId.isEmpty) throw Exception("patientId is required");
//       if (doctorMongoId.isEmpty) throw Exception("doctorMongoId is required");
//       if (investigationType.isEmpty) throw Exception("investigationType is required");
//       if (scheduledDateAndTime.isEmpty) throw Exception("scheduledDateAndTime is required");

//       // Prepare the request body
//       final Map<String, dynamic> body = {
//         "patientMongoId": patientMongoId,
//         "patientId": patientId,
//         "doctorMongoId": doctorMongoId,
//         "investigationType": investigationType,
//         "priority": priority,
//         "scheduledDateAndTime": scheduledDateAndTime,
//         "reasonForInvestigation": reasonForInvestigation,
//         "clinicalHistory": clinicalHistory,
//         "investigationDetails": investigationDetails,
//         "tags": tags,
//         "insuranceStatus": insuranceStatus,
//         "paymentStatus": paymentStatus ?? "Pending",
//         "insuranceCovered": insuranceCovered,
//       };

//       // Print the request body for debugging
//       print("📤 Request Body: ${_maskSensitiveData(body)}");

//       final helper = NetworkHelper(url: url);
//       final response = await helper.post(body: body, auth: true);

//       print("📥 Response Status Code: ${response['statusCode'] ?? 'Unknown'}");
//       print("📥 Response Body: $response");

//       // Check if response is valid
//       if (response == null) {
//         throw Exception("Received null response from server");
//       }

//       if (response['success'] == true) {
//         AppSnackbar.show(
//           title: 'Success',
//           message: response['message'] ?? 'Investigation request generated successfully',
//           type: AppSnackType.success,
//         ); return true;
        
//         // Refresh the list immediately
//         await getInvestigationsByPatientId(patientMongoId);
//         return true;
//       } else {
//         errorMessage.value = response['message'] ?? 'Failed to create investigation';
        
//         // Show more specific error message
//         String errorMsg = errorMessage.value;
//         if (response['errors'] != null) {
//           errorMsg += '\n${response['errors']}';
//         }
        
//         AppSnackbar.show(
//           title: 'Failed',
//           message: errorMsg,
//           type: AppSnackType.error,
//         );
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       print("❌ POST Error: $e");
//       print("❌ Stack trace: ${StackTrace.current}");
      
//       AppSnackbar.show(
//         title: 'Error', 
//         message: e.toString(), 
//         type: AppSnackType.error
//       );
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Update Investigation
//   Future<bool> updateInvestigation({
//     required String investigationId,
//     required String patientMongoId,
//     Map<String, dynamic>? updateData,
//   }) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
      
//       final String url = "$baseUrl/api/investigation/update/$investigationId";
//       print("📤 PATCH Request URL: $url");
//       print("📤 Update Data: $updateData");
      
//       final helper = NetworkHelper(url: url);
//       final response = await helper.patch(body: updateData ?? {}, auth: true);

//       print("📥 PATCH Response: $response");

//       if (response['success'] == true) {
//         AppSnackbar.show(
//           title: 'Success',
//           message: response['message'] ?? 'Investigation updated successfully',
//           type: AppSnackType.success,
//         );
        
//         // Refresh the list
//         await getInvestigationsByPatientId(patientMongoId);
//         return true;
//       } else {
//         errorMessage.value = response['message'] ?? 'Failed to update investigation';
//         AppSnackbar.show(
//           title: 'Failed',
//           message: errorMessage.value,
//           type: AppSnackType.error,
//         );
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       print("❌ PATCH Error: $e");
//       AppSnackbar.show(
//         title: 'Error', 
//         message: e.toString(), 
//         type: AppSnackType.error
//       );
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Delete Investigation
//   Future<bool> deleteInvestigation({
//     required String investigationId,
//     required String patientMongoId,
//   }) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
      
//       final String url = "$baseUrl/api/investigation/delete/$investigationId";
//       print("📤 DELETE Request URL: $url");
      
//       final helper = NetworkHelper(url: url);
//       final response = await helper.delete(auth: true);

//       print("📥 DELETE Response: $response");

//       if (response['success'] == true) {
//         AppSnackbar.show(
//           title: 'Success',
//           message: response['message'] ?? 'Investigation deleted successfully',
//           type: AppSnackType.success,
//         );
        
//         // Remove from local list
//         investigations.removeWhere((inv) => inv.id == investigationId);
//         return true;
//       } else {
//         errorMessage.value = response['message'] ?? 'Failed to delete investigation';
//         AppSnackbar.show(
//           title: 'Failed',
//           message: errorMessage.value,
//           type: AppSnackType.error,
//         );
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       print("❌ DELETE Error: $e");
//       AppSnackbar.show(
//         title: 'Error', 
//         message: e.toString(), 
//         type: AppSnackType.error
//       );
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Helper method to mask sensitive data in logs
//   Map<String, dynamic> _maskSensitiveData(Map<String, dynamic> data) {
//     final masked = Map<String, dynamic>.from(data);
//     // Mask patientId partially for privacy
//     if (masked['patientId'] != null && masked['patientId'].length > 4) {
//       final id = masked['patientId'] as String;
//       masked['patientId'] = '${id.substring(0, 4)}****';
//     }
//     return masked;
//   }

//   /// Clear selected investigation
//   void clearSelectedInvestigation() {
//     selectedInvestigation.value = null;
//   }

//   /// Clear all investigations
//   void clearInvestigations() {
//     investigations.clear();
//   }

//   /// Get error message
//   String getErrorMessage() => errorMessage.value;

//   /// Check if there's an error
//   bool hasError() => errorMessage.value.isNotEmpty;
// }
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/investigation_model.dart';
import '../services/api_service.dart';
import '../services/apis.dart';
import '../utils/snackbar.dart';

class InvestigationController extends GetxController {
  final RxList<InvestigationModel> investigations = <InvestigationModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<InvestigationModel?> selectedInvestigation = Rx<InvestigationModel?>(null);
  final RxString errorMessage = ''.obs;
  
  // Track if a delete operation is in progress
  final RxBool isDeleting = false.obs;
  
  // Track IDs being deleted to show per-item loading
  final RxSet<String> deletingIds = <String>{}.obs;

  /// Fetch investigations by patient MongoDB ID
  Future<void> getInvestigationsByPatientId(String patientMongoId) async {
    // Don't show loader if we're just refreshing after delete
    // Only show loader for initial load
    if (investigations.isEmpty) {
      isLoading.value = true;
    }
    
    try {
      errorMessage.value = '';
      
      final String url = "$baseUrl/api/investigation/get-by-patient-mongo-id/$patientMongoId";
      print("📤 GET Request URL: $url");
      
      final helper = NetworkHelper(url: url);
      final response = await helper.get(auth: true);

      print("📥 GET Response: $response");

      if (response['success'] == true) {
        final List data = response['data'] ?? [];
        investigations.value = data.map((e) => InvestigationModel.fromJson(e)).toList();
        print("✅ Loaded ${investigations.length} investigations");
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load investigations';
        AppSnackbar.show(
          title: 'Error',
          message: errorMessage.value,
          type: AppSnackType.error,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("❌ GET Error: $e");
      AppSnackbar.show(
        title: 'Error', 
        message: e.toString(), 
        type: AppSnackType.error
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get single investigation by ID
  Future<void> getInvestigationById(String investigationId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final String url = "$baseUrl/api/investigation/$investigationId";
      print("📤 GET Single Request URL: $url");
      
      final helper = NetworkHelper(url: url);
      final response = await helper.get(auth: true);

      print("📥 GET Single Response: $response");

      if (response['success'] == true) {
        selectedInvestigation.value = InvestigationModel.fromJson(response['data']);
        print("✅ Loaded investigation: ${selectedInvestigation.value?.id}");
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load investigation';
        AppSnackbar.show(
          title: 'Error',
          message: errorMessage.value,
          type: AppSnackType.error,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("❌ GET Single Error: $e");
      AppSnackbar.show(
        title: 'Error', 
        message: e.toString(), 
        type: AppSnackType.error
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Create Investigation using individual parameters (legacy)
  Future<bool> createInvestigation({
    required String patientMongoId,
    required String patientId,
    required String doctorMongoId,
    required String investigationType,
    required String priority,
    required String scheduledDateAndTime,
    required String reasonForInvestigation,
    required String clinicalHistory,
    required String investigationDetails,
    required String tags,
    required String insuranceStatus,
    String? paymentStatus,
    bool insuranceCovered = false,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final String url = "$baseUrl/api/investigation/create";
      print("📤 POST Request URL: $url");

      // Validate required fields
      if (patientMongoId.isEmpty) throw Exception("patientMongoId is required");
      if (patientId.isEmpty) throw Exception("patientId is required");
      if (doctorMongoId.isEmpty) throw Exception("doctorMongoId is required");
      if (investigationType.isEmpty) throw Exception("investigationType is required");
      if (scheduledDateAndTime.isEmpty) throw Exception("scheduledDateAndTime is required");

      // Prepare the request body
      final Map<String, dynamic> body = {
        "patientMongoId": patientMongoId,
        "patientId": patientId,
        "doctorMongoId": doctorMongoId,
        "investigationType": investigationType,
        "priority": priority,
        "scheduledDateAndTime": scheduledDateAndTime, // Should be local ISO string (with offset)
        "reasonForInvestigation": reasonForInvestigation,
        "clinicalHistory": clinicalHistory,
        "investigationDetails": investigationDetails,
        "tags": tags,
        "insuranceStatus": insuranceStatus,
        "paymentStatus": paymentStatus ?? "Pending",
        "insuranceCovered": insuranceCovered,
      };

      // Print the request body for debugging
      print("📤 Request Body: ${_maskSensitiveData(body)}");

      final helper = NetworkHelper(url: url);
      final response = await helper.post(body: body, auth: true);

      print("📥 Response Status Code: ${response['statusCode'] ?? 'Unknown'}");
      print("📥 Response Body: $response");

      // Check if response is valid
      if (response == null) {
        throw Exception("Received null response from server");
      }

      if (response['success'] == true) {
        AppSnackbar.show(
          title: 'Success',
          message: response['message'] ?? 'Investigation request generated successfully',
          type: AppSnackType.success,
        );
        
        // Refresh the list immediately
        await getInvestigationsByPatientId(patientMongoId);
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Failed to create investigation';
        
        // Show more specific error message
        String errorMsg = errorMessage.value;
        if (response['errors'] != null) {
          errorMsg += '\n${response['errors']}';
        }
        
        AppSnackbar.show(
          title: 'Failed',
          message: errorMsg,
          type: AppSnackType.error,
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("❌ POST Error: $e");
      print("❌ Stack trace: ${StackTrace.current}");
      
      AppSnackbar.show(
        title: 'Error', 
        message: e.toString(), 
        type: AppSnackType.error
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// NEW: Create Investigation using InvestigationModel (preferred)
  Future<bool> createInvestigationFromModel(InvestigationModel investigation) async {
    return createInvestigation(
      patientMongoId: investigation.patientMongoId ?? '',
      patientId: investigation.patientId ?? '',
      doctorMongoId: investigation.doctorMongoId ?? '',
      investigationType: investigation.investigationType,
      priority: investigation.priority,
      scheduledDateAndTime: investigation.scheduledDateAndTime.toIso8601String(), // local ISO
      reasonForInvestigation: investigation.reasonForInvestigation,
      clinicalHistory: investigation.clinicalHistory,
      investigationDetails: investigation.investigationDetails,
      tags: investigation.tags,
      insuranceStatus: investigation.insuranceStatus,
      paymentStatus: investigation.paymentStatus,
      insuranceCovered: investigation.insuranceCovered,
    );
  }

  /// Update Investigation
  Future<bool> updateInvestigation({
    required String investigationId,
    required String patientMongoId,
    Map<String, dynamic>? updateData,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final String url = "$baseUrl/api/investigation/update/$investigationId";
      print("📤 PATCH Request URL: $url");
      print("📤 Update Data: $updateData");
      
      final helper = NetworkHelper(url: url);
      final response = await helper.patch(body: updateData ?? {}, auth: true);

      print("📥 PATCH Response: $response");

      if (response['success'] == true) {
        AppSnackbar.show(
          title: 'Success',
          message: response['message'] ?? 'Investigation updated successfully',
          type: AppSnackType.success,
        );
        
        // Refresh the list
        await getInvestigationsByPatientId(patientMongoId);
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Failed to update investigation';
        AppSnackbar.show(
          title: 'Failed',
          message: errorMessage.value,
          type: AppSnackType.error,
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("❌ PATCH Error: $e");
      AppSnackbar.show(
        title: 'Error', 
        message: e.toString(), 
        type: AppSnackType.error
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete Investigation - OPTIMIZED VERSION
  Future<bool> deleteInvestigation({
    required String investigationId,
    required String patientMongoId,
    bool refreshList = false, // Add option to control refresh
  }) async {
    try {
      // Add ID to deleting set for per-item loading indicator
      deletingIds.add(investigationId);
      
      final String url = "$baseUrl/api/investigation/delete-by-id/$investigationId";
      print("📤 DELETE Request URL: $url");
      
      final helper = NetworkHelper(url: url);
      final response = await helper.delete(auth: true);

      print("📥 DELETE Response: $response");

      if (response['success'] == true) {
        AppSnackbar.show(
          title: 'Success',
          message: response['message'] ?? 'Investigation deleted successfully',
          type: AppSnackType.success,
        );
        
        // Remove from local list immediately - NO LOADER SHOWN
        investigations.removeWhere((inv) => inv.id == investigationId);
        
        // Optionally refresh from server in background without showing loader
        if (refreshList) {
          // Use a microtask to avoid blocking UI
          Future.microtask(() => getInvestigationsByPatientId(patientMongoId));
        }
        
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Failed to delete investigation';
        AppSnackbar.show(
          title: 'Failed',
          message: errorMessage.value,
          type: AppSnackType.error,
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("❌ DELETE Error: $e");
      AppSnackbar.show(
        title: 'Error', 
        message: e.toString(), 
        type: AppSnackType.error
      );
      return false;
    } finally {
      // Remove ID from deleting set
      deletingIds.remove(investigationId);
    }
  }

  /// Helper method to mask sensitive data in logs
  Map<String, dynamic> _maskSensitiveData(Map<String, dynamic> data) {
    final masked = Map<String, dynamic>.from(data);
    // Mask patientId partially for privacy
    if (masked['patientId'] != null && masked['patientId'].length > 4) {
      final id = masked['patientId'] as String;
      masked['patientId'] = '${id.substring(0, 4)}****';
    }
    return masked;
  }

  /// Clear selected investigation
  void clearSelectedInvestigation() {
    selectedInvestigation.value = null;
  }

  /// Clear all investigations
  void clearInvestigations() {
    investigations.clear();
  }

  /// Get error message
  String getErrorMessage() => errorMessage.value;

  /// Check if there's an error
  bool hasError() => errorMessage.value.isNotEmpty;
  
  /// Check if a specific investigation is being deleted
  bool isDeletingInvestigation(String investigationId) {
    return deletingIds.contains(investigationId);
  }
}