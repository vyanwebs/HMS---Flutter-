import 'package:get/get.dart';

class LabOrderController extends GetxController {

  final selectedCategory = "All".obs;
  final search = "".obs;

  final priority = "ROUTINE".obs;
  final notes = "".obs;

  final tests = <LabTestModel>[].obs;

  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    loadTests();
  }

  void loadTests() {
    tests.assignAll([

      /// ================= HEMATOLOGY =================
      LabTestModel(
        id: "1",
        name: "Complete Blood Count (CBC)",
        category: "Hematology",
        price: 250,
      ),
      LabTestModel(
        id: "2",
        name: "ESR (Erythrocyte Sedimentation Rate)",
        category: "Hematology",
        price: 150,
      ),
      LabTestModel(
        id: "3",
        name: "Hemoglobin",
        category: "Hematology",
        price: 100,
      ),
      LabTestModel(
        id: "4",
        name: "Platelet Count",
        category: "Hematology",
        price: 120,
      ),

      /// ================= BIOCHEMISTRY =================
      LabTestModel(
        id: "5",
        name: "Lipid Profile",
        category: "Biochemistry",
        price: 500,
      ),
      LabTestModel(
        id: "6",
        name: "Liver Function Test (LFT)",
        category: "Biochemistry",
        price: 600,
      ),
      LabTestModel(
        id: "7",
        name: "Kidney Function Test (KFT)",
        category: "Biochemistry",
        price: 550,
      ),
      LabTestModel(
        id: "8",
        name: "Blood Glucose (Fasting)",
        category: "Biochemistry",
        price: 80,
      ),
      LabTestModel(
        id: "9",
        name: "HbA1c",
        category: "Biochemistry",
        price: 400,
      ),

      /// ================= CARDIAC MARKERS =================
      LabTestModel(
        id: "10",
        name: "Troponin I",
        category: "Cardiac Markers",
        price: 800,
      ),
      LabTestModel(
        id: "11",
        name: "Troponin T",
        category: "Cardiac Markers",
        price: 800,
      ),
      LabTestModel(
        id: "12",
        name: "CK-MB",
        category: "Cardiac Markers",
        price: 450,
      ),
      LabTestModel(
        id: "13",
        name: "BNP (B-type Natriuretic Peptide)",
        category: "Cardiac Markers",
        price: 1200,
      ),
      LabTestModel(
        id: "14",
        name: "D-Dimer",
        category: "Cardiac Markers",
        price: 650,
      ),

      /// ================= RADIOLOGY =================
      LabTestModel(
        id: "15",
        name: "Chest X-Ray",
        category: "Radiology",
        price: 400,
      ),
      LabTestModel(
        id: "16",
        name: "ECG (Electrocardiogram)",
        category: "Radiology",
        price: 300,
      ),
      LabTestModel(
        id: "17",
        name: "Echocardiography",
        category: "Radiology",
        price: 2000,
      ),
      LabTestModel(
        id: "18",
        name: "Stress Test",
        category: "Radiology",
        price: 2500,
      ),
    ]);
  }

  /// ================= SELECT =================
  void toggleTest(LabTestModel test) {
    test.selected.toggle();
    tests.refresh();
  }

  /// ================= FILTER =================
  List<LabTestModel> get filteredTests {
    return tests.where((t) {

      final matchCategory = selectedCategory.value == "All" || t.category == selectedCategory.value;

      final matchSearch = t.name.toLowerCase().contains(search.value.toLowerCase());

      return matchCategory && matchSearch;
    }).toList();
  }

  /// ================= SUMMARY =================
  List<LabTestModel> get selectedTests => tests.where((t) => t.selected.value).toList();

  double get totalCost => selectedTests.fold(0, (sum, t) => sum + t.price);
}

class LabTestModel {
  final String id;
  final String name;
  final String category;
  final double price;

  RxBool selected = false.obs;

  LabTestModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
  });
}