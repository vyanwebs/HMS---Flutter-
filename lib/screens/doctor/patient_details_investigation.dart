// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:intl/intl.dart';

// // import '../../controllers/investigation_controller.dart';
// // import '../../models/investigation_model.dart';
// // import '../../models/patient_model.dart';
// // import '../../utils/buttons.dart';
// // import '../../utils/constants.dart';
// // import '../../utils/text.dart';

// // class PatientDetailsInvestigationPage extends StatefulWidget {
// //   final PatientModel patient;
// //   final VoidCallback? onNewInvestigation;

// //   const PatientDetailsInvestigationPage({
// //     super.key,
// //     required this.patient,
// //     this.onNewInvestigation,
// //   });

// //   @override
// //   State<PatientDetailsInvestigationPage> createState() =>
// //       _PatientDetailsInvestigationPageState();
// // }

// // class _PatientDetailsInvestigationPageState
// //     extends State<PatientDetailsInvestigationPage> {
// //   final InvestigationController _controller = Get.put(InvestigationController());

// //   @override
// //   void initState() {
// //     super.initState();
// //     // Fetch investigations using patient's MongoDB ID
// //     _controller.getInvestigationsByPatientId(widget.patient.id);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isMobile = MediaQuery.of(context).size.width < 900;

// //     return Padding(
// //       padding: const EdgeInsets.all(18),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const AppText(
// //             'Investigation',
// //             fontSize: 20,
// //             fontWeight: FontWeight.w700,
// //           ),
// //           const SizedBox(height: 16),
// //           _PatientInfoCard(patient: widget.patient),
// //           const SizedBox(height: 14),
// //           _InvestigationHeaderCard(
// //             patient: widget.patient,
// //             onNewInvestigation: widget.onNewInvestigation,
// //           ),
// //           const SizedBox(height: 14),
// //           Expanded(
// //             child: Obx(() {
// //               if (_controller.isLoading.value) {
// //                 return const Center(child: CircularProgressIndicator());
// //               }
// //               if (_controller.investigations.isEmpty) {
// //                 return const Center(
// //                   child: AppText('No investigations found'),
// //                 );
// //               }
// //               return _InvestigationTableCard(
// //                 isMobile: isMobile,
// //                 investigations: _controller.investigations,
// //               );
// //             }),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // ///////////////////////////////////////////////////////////////////////////
// // /// ====================== PATIENT INFO ================================
// // ///////////////////////////////////////////////////////////////////////////

// // class _PatientInfoCard extends StatelessWidget {
// //   final PatientModel patient;

// //   const _PatientInfoCard({required this.patient});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: AppColors.solitude,
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       child: Row(
// //         children: [
// //           CircleAvatar(
// //             radius: 26,
// //             backgroundColor: AppColors.info.withOpacity(0.1),
// //             child: const Icon(
// //               Icons.person,
// //               color: AppColors.info,
// //               size: 28,
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 AppText(
// //                   patient.name,
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //                 const SizedBox(height: 4),
// //                 AppText(
// //                   'ID: ${patient.patientId} • Age: ${patient.age} • ${patient.gender}',
// //                   fontSize: 12,
// //                   color: AppColors.greyText,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // ///////////////////////////////////////////////////////////////////////////
// // /// ====================== HEADER CARD ================================
// // ///////////////////////////////////////////////////////////////////////////

// // class _InvestigationHeaderCard extends StatelessWidget {
// //   final PatientModel patient;
// //   final VoidCallback? onNewInvestigation;

// //   const _InvestigationHeaderCard({
// //     required this.patient,
// //     this.onNewInvestigation,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final isMobile = MediaQuery.of(context).size.width < 700;

// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: AppColors.solitude,
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       child: isMobile ? _mobileLayout() : _desktopLayout(),
// //     );
// //   }

// //   Widget _desktopLayout() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Row(
// //           children: [
// //             Container(
// //               height: 42,
// //               width: 42,
// //               decoration: BoxDecoration(
// //                 color: AppColors.info.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: const Icon(
// //                 Icons.description,
// //                 color: AppColors.info,
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const AppText(
// //                   'Investigation request',
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //                 const SizedBox(height: 2),
// //                 AppText(
// //                   'Admission ID : ${patient.currentAdmissionCode}',
// //                   fontSize: 11,
// //                   color: AppColors.greyText,
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //         Row(
// //           children: [
// //             AppButton(
// //               text: 'New investigation',
// //               backgroundColor: AppColors.info,
// //               textColor: Colors.white,
// //               fontSize: 12,
// //               onPressed: onNewInvestigation ?? () {},
// //             ),
// //             const SizedBox(width: 10),
// //             AppButton(
// //               text: 'Print',
// //               backgroundColor: Colors.red,
// //               textColor: Colors.white,
// //               fontSize: 12,
// //               onPressed: () {},
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _mobileLayout() => _desktopLayout();
// // }

// // ///////////////////////////////////////////////////////////////////////////
// // /// ====================== TABLE CARD ================================
// // ///////////////////////////////////////////////////////////////////////////

// // class _InvestigationTableCard extends StatelessWidget {
// //   final bool isMobile;
// //   final List<InvestigationModel> investigations;

// //   const _InvestigationTableCard({
// //     required this.isMobile,
// //     required this.investigations,
    
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         const _TableHeaderRow(),
// //         const Divider(height: 1),
// //         Expanded(
// //           child: ListView.builder(
// //             itemCount: investigations.length,
// //             itemBuilder: (context, index) {
// //               return _TableDataRow(
// //                 index: index + 1,
// //                 investigation: investigations[index],
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // ///////////////////////////////////////////////////////////////////////////
// // /// ====================== TABLE HEADER ================================
// // ///////////////////////////////////////////////////////////////////////////

// // class _TableHeaderRow extends StatelessWidget {
// //   const _TableHeaderRow();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// //       color: const Color(0xFFB9B8B8),
// //       child: Row(
// //         children: const [
// //           _HeaderCell('Number', 1),
// //           _HeaderCell('Investigation', 3),
// //           _HeaderCell('Tags', 2),
// //           _HeaderCell('Date & Time', 3),
// //           _HeaderCell('Status', 2),
// //           _HeaderCell('Action', 2),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // ///////////////////////////////////////////////////////////////////////////
// // /// ====================== TABLE ROW ================================
// // ///////////////////////////////////////////////////////////////////////////

// // class _TableDataRow extends StatelessWidget {
// //   final int index;
// //   final InvestigationModel investigation;

// //   const _TableDataRow({
// //     required this.index,
// //     required this.investigation,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final date = DateFormat('dd-MM-yyyy').format(investigation.scheduledDateAndTime);
// //     final time = DateFormat('hh:mm a').format(investigation.scheduledDateAndTime);

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// //       child: Row(
// //         children: [
// //           _DataCell('$index.', 1),

// //           /// Investigation
// //           Expanded(
// //             flex: 3,
// //             child: Row(
// //               children: [
// //                 const Icon(
// //                   Icons.medical_services_outlined,
// //                   size: 18,
// //                   color: AppColors.info,
// //                 ),
// //                 const SizedBox(width: 6),
// //                 AppText(investigation.investigationType, fontSize: 13),
// //               ],
// //             ),
// //           ),

// //           /// Tag
// //           Expanded(
// //             flex: 2,
// //             child: Center(
// //               child: _TagChip(
// //                 text: investigation.tags.isNotEmpty ? investigation.tags : '—',
// //                 color: Colors.teal,
// //               ),
// //             ),
// //           ),

// //           /// Date
// //           Expanded(
// //             flex: 3,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 AppText(date, fontSize: 12),
// //                 const SizedBox(height: 2),
// //                 AppText(
// //                   time,
// //                   fontSize: 11,
// //                   color: AppColors.greyText,
// //                 ),
// //               ],
// //             ),
// //           ),

// //           /// Status
// //           Expanded(
// //             flex: 2,
// //             child: Center(
// //               child: _TagChip(
// //                 text: investigation.insuranceStatus,
// //                 color: _getStatusColor(investigation.insuranceStatus),
// //               ),
// //             ),
// //           ),

// //           /// Actions
// //           Expanded(
// //             flex: 2,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: const [
// //                 _ActionIcon(Icons.visibility),
// //                 _ActionIcon(Icons.edit),
// //                 _ActionIcon(Icons.delete, color: Colors.red),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Color _getStatusColor(String status) {
// //     switch (status.toLowerCase()) {
// //       case 'scheduled':
// //         return Colors.orange;
// //       case 'completed':
// //         return Colors.green;
// //       case 'cancelled':
// //         return Colors.red;
// //       default:
// //         return Colors.grey;
// //     }
// //   }
// // }

// // ///////////////////////////////////////////////////////////////////////////
// // /// ====================== SMALL WIDGETS ================================
// // ///////////////////////////////////////////////////////////////////////////

// // class _HeaderCell extends StatelessWidget {
// //   final String text;
// //   final int flex;

// //   const _HeaderCell(this.text, this.flex);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Expanded(
// //       flex: flex,
// //       child: Center(
// //         child: AppText(
// //           text,
// //           fontSize: 13,
// //           fontWeight: FontWeight.w600,
// //           color: AppColors.greyText,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _DataCell extends StatelessWidget {
// //   final String text;
// //   final int flex;

// //   const _DataCell(this.text, this.flex);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Expanded(
// //       flex: flex,
// //       child: AppText(text, fontSize: 13),
// //     );
// //   }
// // }

// // ///////////////////////////////////////////////////////////////////////////
// // /// ====================== CHIP ================================
// // ///////////////////////////////////////////////////////////////////////////

// // class _TagChip extends StatelessWidget {
// //   final String text;
// //   final Color color;

// //   const _TagChip({
// //     required this.text,
// //     required this.color,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.15),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: AppText(
// //         text,
// //         fontSize: 11,
// //         color: color,
// //       ),
// //     );
// //   }
// // }

// // class _ActionIcon extends StatelessWidget {
// //   final IconData icon;
// //   final Color? color;

// //   const _ActionIcon(this.icon, {this.color});

// //   @override
// //   Widget build(BuildContext context) {
// //     return IconButton(
// //       icon: Icon(
// //         icon,
// //         size: 18,
// //         color: color ?? AppColors.greyText,
// //       ),
// //       onPressed: () {},
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../../controllers/investigation_controller.dart';
// import '../../models/investigation_model.dart';
// import '../../models/patient_model.dart';
// import '../../utils/buttons.dart';
// import '../../utils/constants.dart';
// import '../../utils/text.dart';

// class PatientDetailsInvestigationPage extends StatefulWidget {
//   final PatientModel patient;
//   final VoidCallback? onNewInvestigation;

//   const PatientDetailsInvestigationPage({
//     super.key,
//     required this.patient,
//     this.onNewInvestigation,
//   });

//   @override
//   State<PatientDetailsInvestigationPage> createState() =>
//       _PatientDetailsInvestigationPageState();
// }

// class _PatientDetailsInvestigationPageState
//     extends State<PatientDetailsInvestigationPage> {
//   final InvestigationController _controller = Get.put(InvestigationController());

//   @override
//   void initState() {
//     super.initState();
//     _controller.getInvestigationsByPatientId(widget.patient.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = MediaQuery.of(context).size.width < 900;

//     return Padding(
//       padding: const EdgeInsets.all(18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const AppText(
//             'Investigation',
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//           const SizedBox(height: 16),

//           _PatientInfoCard(patient: widget.patient),

//           const SizedBox(height: 14),

//           _InvestigationHeaderCard(
//             patient: widget.patient,
//             onNewInvestigation: widget.onNewInvestigation,
//           ),

//           const SizedBox(height: 14),

//           Expanded(
//             child: Obx(() {
//               if (_controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (_controller.investigations.isEmpty) {
//                 return const Center(
//                   child: AppText('No investigations found'),
//                 );
//               }

//               return _InvestigationTableCard(
//                 isMobile: isMobile,
//                 investigations: _controller.investigations,
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ////////////////////////////////////////////////////////////////////////
// /// PATIENT INFO
// ////////////////////////////////////////////////////////////////////////

// class _PatientInfoCard extends StatelessWidget {
//   final PatientModel patient;

//   const _PatientInfoCard({required this.patient});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.solitude,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 26,
//             backgroundColor: AppColors.info.withOpacity(0.1),
//             child: const Icon(
//               Icons.person,
//               color: AppColors.info,
//               size: 28,
//             ),
//           ),

//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   patient.name,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),

//                 const SizedBox(height: 4),

//                 AppText(
//                   'ID: ${patient.patientId} • Age: ${patient.age} • ${patient.gender}',
//                   fontSize: 12,
//                   color: AppColors.greyText,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ////////////////////////////////////////////////////////////////////////
// /// HEADER
// ////////////////////////////////////////////////////////////////////////

// class _InvestigationHeaderCard extends StatelessWidget {
//   final PatientModel patient;
//   final VoidCallback? onNewInvestigation;

//   const _InvestigationHeaderCard({
//     required this.patient,
//     this.onNewInvestigation,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.solitude,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: _desktopLayout(),
//     );
//   }

//   Widget _desktopLayout() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [

//         Row(
//           children: [

//             Container(
//               height: 42,
//               width: 42,
//               decoration: BoxDecoration(
//                 color: AppColors.info.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.description,
//                 color: AppColors.info,
//               ),
//             ),

//             const SizedBox(width: 12),

//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const AppText(
//                   'Investigation request',
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),

//                 const SizedBox(height: 2),

//                 AppText(
//                   'Admission ID : ${patient.currentAdmissionCode}',
//                   fontSize: 11,
//                   color: AppColors.greyText,
//                 ),
//               ],
//             ),
//           ],
//         ),

//         Row(
//           children: [

//             AppButton(
//               text: 'New investigation',
//               backgroundColor: AppColors.info,
//               textColor: Colors.white,
//               fontSize: 12,
//               onPressed: onNewInvestigation ?? () {},
//             ),

//             const SizedBox(width: 10),

//             AppButton(
//               text: 'Print',
//               backgroundColor: Colors.red,
//               textColor: Colors.white,
//               fontSize: 12,
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// ////////////////////////////////////////////////////////////////////////
// /// TABLE
// ////////////////////////////////////////////////////////////////////////

// class _InvestigationTableCard extends StatelessWidget {
//   final bool isMobile;
//   final List<InvestigationModel> investigations;

//   const _InvestigationTableCard({
//     required this.isMobile,
//     required this.investigations,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [

//         const _TableHeaderRow(),

//         const Divider(height: 1),

//         Expanded(
//           child: ListView.builder(
//             itemCount: investigations.length,
//             itemBuilder: (context, index) {
//               return _TableDataRow(
//                 index: index + 1,
//                 investigation: investigations[index],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// ////////////////////////////////////////////////////////////////////////
// /// HEADER ROW
// ////////////////////////////////////////////////////////////////////////

// class _TableHeaderRow extends StatelessWidget {
//   const _TableHeaderRow();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       color: const Color(0xFFB9B8B8),
//       child: Row(
//         children: const [
//           _HeaderCell('Number', 1),
//           _HeaderCell('Investigation', 3),
//           _HeaderCell('Tags', 2),
//           _HeaderCell('Date & Time', 3),
//           _HeaderCell('Status', 2),
//           _HeaderCell('Action', 2),
//         ],
//       ),
//     );
//   }
// }

// ////////////////////////////////////////////////////////////////////////
// /// DATA ROW
// ////////////////////////////////////////////////////////////////////////

// class _TableDataRow extends StatelessWidget {
//   final int index;
//   final InvestigationModel investigation;

//   const _TableDataRow({
//     required this.index,
//     required this.investigation,
//   });

//   @override
//   Widget build(BuildContext context) {

//     final date = DateFormat('dd-MM-yyyy')
//         .format(investigation.scheduledDateAndTime);

//     final time = DateFormat('hh:mm a')
//         .format(investigation.scheduledDateAndTime);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       child: Row(
//         children: [

//           _DataCell('$index.', 1),

//           Expanded(
//             flex: 3,
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.medical_services_outlined,
//                   size: 18,
//                   color: AppColors.info,
//                 ),

//                 const SizedBox(width: 6),

//                 AppText(
//                   investigation.investigationType,
//                   fontSize: 13,
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             flex: 2,
//             child: Center(
//               child: _TagChip(
//                 text: investigation.tags.isNotEmpty
//                     ? investigation.tags
//                     : '—',
//                 color: Colors.teal,
//               ),
//             ),
//           ),

//           Expanded(
//             flex: 3,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(date, fontSize: 12),

//                 const SizedBox(height: 2),

//                 AppText(
//                   time,
//                   fontSize: 11,
//                   color: AppColors.greyText,
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             flex: 2,
//             child: Center(
//               child: _TagChip(
//                 text: investigation.insuranceStatus,
//                 color: _getStatusColor(
//                   investigation.insuranceStatus,
//                 ),
//               ),
//             ),
//           ),

//           Expanded(
//             flex: 2,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [

//                 _ActionIcon(
//                   Icons.visibility,
//                   onTap: () {
//                     _showInvestigationDialog(context, investigation);
//                   },
//                 ),

//                 _ActionIcon(Icons.edit),

//                 _ActionIcon(
//                   Icons.delete,
//                   color: Colors.red,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'scheduled':
//         return Colors.orange;
//       case 'completed':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// ////////////////////////////////////////////////////////////////////////
// /// SMALL WIDGETS
// ////////////////////////////////////////////////////////////////////////

// class _HeaderCell extends StatelessWidget {
//   final String text;
//   final int flex;

//   const _HeaderCell(this.text, this.flex);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: flex,
//       child: Center(
//         child: AppText(
//           text,
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//           color: AppColors.greyText,
//         ),
//       ),
//     );
//   }
// }

// class _DataCell extends StatelessWidget {
//   final String text;
//   final int flex;

//   const _DataCell(this.text, this.flex);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: flex,
//       child: AppText(text, fontSize: 13),
//     );
//   }
// }

// class _TagChip extends StatelessWidget {
//   final String text;
//   final Color color;

//   const _TagChip({
//     required this.text,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: AppText(
//         text,
//         fontSize: 11,
//         color: color,
//       ),
//     );
//   }
// }

// class _ActionIcon extends StatelessWidget {
//   final IconData icon;
//   final Color? color;
//   final VoidCallback? onTap;

//   const _ActionIcon(
//     this.icon, {
//     this.color,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(
//         icon,
//         size: 18,
//         color: color ?? AppColors.greyText,
//       ),
//       onPressed: onTap,
//     );
//   }
// }

// ////////////////////////////////////////////////////////////////////////
// /// DIALOG
// ////////////////////////////////////////////////////////////////////////
// void _showInvestigationDialog(
//   BuildContext context,
//   InvestigationModel investigation,
// ) {
//   final date = DateFormat('dd-MM-yyyy')
//       .format(investigation.scheduledDateAndTime);

//   final time = DateFormat('hh:mm a')
//       .format(investigation.scheduledDateAndTime);

//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Container(
//           width: 850,
//           padding: const EdgeInsets.all(24),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [

//                 /// TITLE
//                 const AppText(
//                   'View Investigation Request',
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),

//                 const SizedBox(height: 20),

//                 /// MAIN ROW
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [

//                     /// BASIC INFO
//                     _infoCard(
//                       title: 'Basic Information',
//                       items: {
//                         'Patient Name':
//                             investigation.doctorName,
//                         'Patient ID':
//                             investigation.patientId ?? '-',
//                         'Doctor':
//                             investigation.doctorId,
//                         'Order Date': date,
//                         'Time': time,
//                       },
//                     ),

//                     const SizedBox(width: 16),

//                     /// INVESTIGATION INFO
//                     _infoCard(
//                       title: 'Investigation Details',
//                       items: {
//                         'Type': investigation.investigationType,
//                         'Reason':
//                             investigation.reasonForInvestigation,
//                         'Priority': investigation.priority,
//                         'Clinical History':
//                             investigation.clinicalHistory,
//                         'Details':
//                             investigation.investigationDetails,
//                         'Tags': investigation.tags,
//                       },
//                     ),

//                     const SizedBox(width: 16),

//                     /// BILLING INFO
//                     _infoCard(
//                       title: 'Billing Information',
//                       items: {
//                         'Payment Status':
//                             investigation.paymentStatus,
//                         'Insurance Status':
//                             investigation.insuranceStatus,
//                         'Insurance Covered':
//                             investigation.insuranceCovered
//                                 ? 'Yes'
//                                 : 'No',
//                       },
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 25),

//                 /// BUTTONS
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [

//                     AppButton(
//                       text: 'Back',
//                       backgroundColor: Colors.grey,
//                       textColor: Colors.white,
//                       onPressed: () => Navigator.pop(context),
//                     ),

//                     const SizedBox(width: 12),

//                     AppButton(
//                       text: 'Edit',
//                       backgroundColor: AppColors.info,
//                       textColor: Colors.white,
//                       onPressed: () {
//                         // TODO: Edit Logic
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// Widget _infoCard({
//   required String title,
//   required Map<String, String?> items,
// }) {
//   return Expanded(
//     child: Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [

//           AppText(
//             title,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),

//           const SizedBox(height: 12),

//           ...items.entries.map(
//             (e) => Padding(
//               padding: const EdgeInsets.only(bottom: 6),
//               child: AppText(
//                 '${e.key} : ${e.value ?? '-'}',
//                 fontSize: 12,
//                 color: AppColors.greyText,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../../controllers/investigation_controller.dart';
// import '../../models/investigation_model.dart';
// import '../../models/patient_model.dart';
// import '../../utils/buttons.dart';
// import '../../utils/constants.dart';
// import '../../utils/snackbar.dart';
// import '../../utils/text.dart';
// import 'investigation_request_dialog.dart';

// class PatientDetailsInvestigationPage extends StatefulWidget {
//   final PatientModel patient;
//   final String? doctorMongoId;
//   final VoidCallback? onNewInvestigation;

//   const PatientDetailsInvestigationPage({
//     super.key,
//     required this.patient,
//     this.doctorMongoId,
//     this.onNewInvestigation,
//   });

//   @override
//   State<PatientDetailsInvestigationPage> createState() =>
//       _PatientDetailsInvestigationPageState();
// }

// class _PatientDetailsInvestigationPageState
//     extends State<PatientDetailsInvestigationPage> {
//   // Don't use Get.find() directly - we'll initialize it properly
//   late final InvestigationController _controller;
  
//   // Flag to track if controller is initialized
//   bool _isControllerInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeController();
//   }

//   void _initializeController() {
//     try {
//       // Try to find existing controller first
//       _controller = Get.find<InvestigationController>();
//     } catch (e) {
//       // If not found, put it
//       _controller = Get.put(InvestigationController(), permanent: true);
//     }
    
//     _isControllerInitialized = true;
    
//     // Now fetch data
//     _controller.getInvestigationsByPatientId(widget.patient.id);
//   }

//   // Method to show the investigation request dialog
//   void _showNewInvestigationDialog() {
//     // Get doctor ID from widget parameter or use fallback
//     final String? doctorMongoId = widget.doctorMongoId ?? 
//                                    _getDoctorIdFromOtherSource();
    
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => InvestigationRequestDialog(
//         patient: widget.patient,
//         doctorMongoId: doctorMongoId,
//       ),
//     ).then((_) {
//       // Refresh the list when dialog is closed
//       if (_isControllerInitialized) {
//         _controller.getInvestigationsByPatientId(widget.patient.id);
//       }
//     });
//   }

//   // Helper method to try getting doctor ID from various sources
//   String? _getDoctorIdFromOtherSource() {
//     // Try to get from Get.parameters if using named routes
//     try {
//       final doctorId = Get.parameters['doctorId'];
//       if (doctorId != null && doctorId.isNotEmpty) {
//         return doctorId;
//       }
//     } catch (e) {
//       // Ignore errors
//     }
//     return null;
//   }

//   @override
//   void dispose() {
//     // Don't delete the controller if it's meant to be permanent
//     // Only remove if you want to clean up
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = MediaQuery.of(context).size.width < 900;

//     return Padding(
//       padding: const EdgeInsets.all(18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const AppText(
//             'Investigation',
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//           const SizedBox(height: 16),

//           _PatientInfoCard(patient: widget.patient),

//           const SizedBox(height: 14),

//           _InvestigationHeaderCard(
//             patient: widget.patient,
//             onNewInvestigation: _showNewInvestigationDialog,
//           ),

//           const SizedBox(height: 14),

//           Expanded(
//             child: _isControllerInitialized 
//                 ? Obx(() {
//                     if (_controller.isLoading.value) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     if (_controller.investigations.isEmpty) {
//                       return const Center(
//                         child: AppText('No investigations found'),
//                       );
//                     }

//                     return _InvestigationTableCard(
//                       isMobile: isMobile,
//                       investigations: _controller.investigations,
//                     );
//                   })
//                 : const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PatientInfoCard extends StatelessWidget {
//   final PatientModel patient;

//   const _PatientInfoCard({required this.patient});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.solitude,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 26,
//             backgroundColor: AppColors.info.withOpacity(0.1),
//             child: const Icon(
//               Icons.person,
//               color: AppColors.info,
//               size: 28,
//             ),
//           ),

//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   patient.name,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),

//                 const SizedBox(height: 4),

//                 AppText(
//                   'ID: ${patient.patientId} • Age: ${patient.age} • ${patient.gender}',
//                   fontSize: 12,
//                   color: AppColors.greyText,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InvestigationHeaderCard extends StatelessWidget {
//   final PatientModel patient;
//   final VoidCallback onNewInvestigation;

//   const _InvestigationHeaderCard({
//     required this.patient,
//     required this.onNewInvestigation,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.solitude,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [

//           Row(
//             children: [
//               Container(
//                 height: 42,
//                 width: 42,
//                 decoration: BoxDecoration(
//                   color: AppColors.info.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.description,
//                   color: AppColors.info,
//                 ),
//               ),

//               const SizedBox(width: 12),

//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const AppText(
//                     'Investigation request',
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),

//                   const SizedBox(height: 2),

//                   AppText(
//                     'Admission ID : ${patient.currentAdmissionCode ?? "N/A"}',
//                     fontSize: 11,
//                     color: AppColors.greyText,
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           Row(
//             children: [
//               AppButton(
//                 text: 'New investigation',
//                 backgroundColor: AppColors.info,
//                 textColor: Colors.white,
//                 fontSize: 12,
//                 onPressed: onNewInvestigation,
//               ),

//               const SizedBox(width: 10),

//               AppButton(
//                 text: 'Print',
//                 backgroundColor: Colors.red,
//                 textColor: Colors.white,
//                 fontSize: 12,
//                 onPressed: () {
//                   AppSnackbar.show(
//                     title: "Info",
//                     message: "Print functionality coming soon",
//                     type: AppSnackType.info,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InvestigationTableCard extends StatelessWidget {
//   final bool isMobile;
//   final List<InvestigationModel> investigations;

//   const _InvestigationTableCard({
//     required this.isMobile,
//     required this.investigations,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const _TableHeaderRow(),
//         const Divider(height: 1),
//         Expanded(
//           child: ListView.builder(
//             itemCount: investigations.length,
//             itemBuilder: (context, index) {
//               return _TableDataRow(
//                 index: index + 1,
//                 investigation: investigations[index],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _TableHeaderRow extends StatelessWidget {
//   const _TableHeaderRow();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       color: const Color(0xFFB9B8B8),
//       child: Row(
//         children: const [
//           _HeaderCell('Number', 1),
//           _HeaderCell('Investigation', 3),
//           _HeaderCell('Tags', 2),
//           _HeaderCell('Date & Time', 3),
//           _HeaderCell('Status', 2),
//           _HeaderCell('Action', 2),
//         ],
//       ),
//     );
//   }
// }

// class _TableDataRow extends StatelessWidget {
//   final int index;
//   final InvestigationModel investigation;

//   const _TableDataRow({
//     required this.index,
//     required this.investigation,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final date = DateFormat('dd-MM-yyyy')
//         .format(investigation.scheduledDateAndTime);

//     final time = DateFormat('hh:mm a')
//         .format(investigation.scheduledDateAndTime);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       child: Row(
//         children: [
//           _DataCell('$index.', 1),

//           Expanded(
//             flex: 3,
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.medical_services_outlined,
//                   size: 18,
//                   color: AppColors.info,
//                 ),

//                 const SizedBox(width: 6),

//                 AppText(
//                   investigation.investigationType,
//                   fontSize: 13,
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             flex: 2,
//             child: Center(
//               child: _TagChip(
//                 text: investigation.tags.isNotEmpty
//                     ? investigation.tags
//                     : '—',
//                 color: Colors.teal,
//               ),
//             ),
//           ),

//           Expanded(
//             flex: 3,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(date, fontSize: 12),
//                 const SizedBox(height: 2),
//                 AppText(
//                   time,
//                   fontSize: 11,
//                   color: AppColors.greyText,
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             flex: 2,
//             child: Center(
//               child: _TagChip(
//                 text: investigation.insuranceStatus,
//                 color: _getStatusColor(investigation.insuranceStatus),
//               ),
//             ),
//           ),

//           Expanded(
//             flex: 2,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _ActionIcon(
//                   Icons.visibility,
//                   onTap: () {
//                     _showInvestigationDialog(context, investigation);
//                   },
//                 ),
//                 _ActionIcon(
//                   Icons.edit,
//                   onTap: () {
//                     AppSnackbar.show(
//                       title: "Info",
//                       message: "Edit functionality coming soon",
//                       type: AppSnackType.info,
//                     );
//                   },
//                 ),
//                 _ActionIcon(
//                   Icons.delete,
//                   color: Colors.red,
//                   onTap: () {
//                     _showDeleteConfirmation(context, investigation);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'scheduled':
//         return Colors.orange;
//       case 'completed':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       case 'approved':
//         return Colors.blue;
//       case 'pending':
//         return Colors.amber;
//       default:
//         return Colors.grey;
//     }
//   }

//   void _showDeleteConfirmation(BuildContext context, InvestigationModel investigation) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const AppText('Delete Investigation'),
//         content: AppText(
//           'Are you sure you want to delete this investigation for ${investigation.investigationType}?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const AppText('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               AppSnackbar.show(
//                 title: "Info",
//                 message: "Delete functionality coming soon",
//                 type: AppSnackType.info,
//               );
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const AppText('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _HeaderCell extends StatelessWidget {
//   final String text;
//   final int flex;

//   const _HeaderCell(this.text, this.flex);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: flex,
//       child: Center(
//         child: AppText(
//           text,
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//           color: AppColors.greyText,
//         ),
//       ),
//     );
//   }
// }

// class _DataCell extends StatelessWidget {
//   final String text;
//   final int flex;

//   const _DataCell(this.text, this.flex);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: flex,
//       child: AppText(text, fontSize: 13),
//     );
//   }
// }

// class _TagChip extends StatelessWidget {
//   final String text;
//   final Color color;

//   const _TagChip({
//     required this.text,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: AppText(
//         text,
//         fontSize: 11,
//         color: color,
//         fontWeight: FontWeight.w500,
//       ),
//     );
//   }
// }

// class _ActionIcon extends StatelessWidget {
//   final IconData icon;
//   final Color? color;
//   final VoidCallback? onTap;

//   const _ActionIcon(
//     this.icon, {
//     this.color,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(
//         icon,
//         size: 18,
//         color: color ?? AppColors.greyText,
//       ),
//       onPressed: onTap,
//       constraints: const BoxConstraints(
//         minWidth: 32,
//         minHeight: 32,
//       ),
//       padding: EdgeInsets.zero,
//     );
//   }
// }

// void _showInvestigationDialog(
//   BuildContext context,
//   InvestigationModel investigation,
// ) {
//   final date = DateFormat('dd-MM-yyyy')
//       .format(investigation.scheduledDateAndTime);

//   final time = DateFormat('hh:mm a')
//       .format(investigation.scheduledDateAndTime);

//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Container(
//           width: 850,
//           padding: const EdgeInsets.all(24),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const AppText(
//                   'View Investigation Request',
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),

//                 const SizedBox(height: 20),

//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _infoCard(
//                       title: 'Basic Information',
//                       items: {
//                         'Patient Name': investigation.patientName ?? '-',
//                         'Patient ID': investigation.patientId ?? '-',
//                         'Doctor': investigation.doctorName ?? '-',
//                         'Order Date': date,
//                         'Time': time,
//                       },
//                     ),

//                     const SizedBox(width: 16),

//                     _infoCard(
//                       title: 'Investigation Details',
//                       items: {
//                         'Type': investigation.investigationType,
//                         'Reason': investigation.reasonForInvestigation,
//                         'Priority': investigation.priority,
//                         'Clinical History': investigation.clinicalHistory,
//                         'Details': investigation.investigationDetails,
//                         'Tags': investigation.tags,
//                       },
//                     ),

//                     const SizedBox(width: 16),

//                     _infoCard(
//                       title: 'Billing Information',
//                       items: {
//                         'Payment Status': investigation.paymentStatus ?? '-',
//                         'Insurance Status': investigation.insuranceStatus,
//                         'Insurance Covered': investigation.insuranceCovered ? 'Yes' : 'No',
//                       },
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 25),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     AppButton(
//                       text: 'Close',
//                       backgroundColor: Colors.grey.shade600,
//                       textColor: Colors.white,
//                       onPressed: () => Navigator.pop(context),
//                     ),

//                     const SizedBox(width: 12),

//                     AppButton(
//                       text: 'Edit',
//                       backgroundColor: AppColors.info,
//                       textColor: Colors.white,
//                       onPressed: () {
//                         Navigator.pop(context);
//                         AppSnackbar.show(
//                           title: "Info",
//                           message: "Edit functionality coming soon",
//                           type: AppSnackType.info,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// Widget _infoCard({
//   required String title,
//   required Map<String, String> items,
// }) {
//   return Expanded(
//     child: Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AppText(
//             title,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),

//           const SizedBox(height: 12),

//           ...items.entries.map(
//             (e) => Padding(
//               padding: const EdgeInsets.only(bottom: 6),
//               child: AppText(
//                 '${e.key} : ${e.value}',
//                 fontSize: 12,
//                 color: AppColors.greyText,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/investigation_controller.dart';
import '../../models/investigation_model.dart';
import '../../models/patient_model.dart';
import '../../utils/buttons.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar.dart';
import '../../utils/text.dart';
import 'investigation_request_dialog.dart';

class PatientDetailsInvestigationPage extends StatefulWidget {
  final PatientModel patient;
  final String? doctorMongoId;
  final VoidCallback? onNewInvestigation;

  const PatientDetailsInvestigationPage({
    super.key,
    required this.patient,
    this.doctorMongoId,
    this.onNewInvestigation,
  });

  @override
  State<PatientDetailsInvestigationPage> createState() =>
      _PatientDetailsInvestigationPageState();
}

class _PatientDetailsInvestigationPageState
    extends State<PatientDetailsInvestigationPage> {
  late final InvestigationController _controller;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    try {
      _controller = Get.find<InvestigationController>();
    } catch (e) {
      _controller = Get.put(InvestigationController(), permanent: true);
    }
    
    _isControllerInitialized = true;
    
    // Fetch data
    _controller.getInvestigationsByPatientId(widget.patient.id);
  }

  void _showNewInvestigationDialog() {
    final String? doctorMongoId = widget.doctorMongoId ?? 
                                   _getDoctorIdFromOtherSource();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InvestigationRequestDialog(
        patient: widget.patient,
        doctorMongoId: doctorMongoId,
      ),
    ).then((_) {
      if (_isControllerInitialized) {
        _controller.getInvestigationsByPatientId(widget.patient.id);
      }
    });
  }

  String? _getDoctorIdFromOtherSource() {
    try {
      final doctorId = Get.parameters['doctorId'];
      if (doctorId != null && doctorId.isNotEmpty) {
        return doctorId;
      }
    } catch (e) {
      // Ignore errors
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Investigation',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),

          _PatientInfoCard(patient: widget.patient),

          const SizedBox(height: 14),

          _InvestigationHeaderCard(
            patient: widget.patient,
            onNewInvestigation: _showNewInvestigationDialog,
          ),

          const SizedBox(height: 14),

          Expanded(
            child: _isControllerInitialized 
                ? Obx(() {
                    // Show only ONE loader for initial load
                    if (_controller.isLoading.value && _controller.investigations.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (_controller.investigations.isEmpty) {
                      return const Center(
                        child: AppText('No investigations found'),
                      );
                    }

                    return _InvestigationTableCard(
                      isMobile: isMobile,
                      investigations: _controller.investigations,
                      patientMongoId: widget.patient.id,
                      controller: _controller,
                    );
                  })
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PatientInfoCard extends StatelessWidget {
  final PatientModel patient;

  const _PatientInfoCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.solitude,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.info.withOpacity(0.1),
            child: const Icon(
              Icons.person,
              color: AppColors.info,
              size: 28,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  patient.name,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),

                const SizedBox(height: 4),

                AppText(
                  'ID: ${patient.patientId} • Age: ${patient.age} • ${patient.gender}',
                  fontSize: 12,
                  color: AppColors.greyText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvestigationHeaderCard extends StatelessWidget {
  final PatientModel patient;
  final VoidCallback onNewInvestigation;

  const _InvestigationHeaderCard({
    required this.patient,
    required this.onNewInvestigation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.solitude,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description,
                  color: AppColors.info,
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'Investigation request',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),

                  const SizedBox(height: 2),

                  AppText(
                    'Admission ID : ${patient.currentAdmissionCode ?? "N/A"}',
                    fontSize: 11,
                    color: AppColors.greyText,
                  ),
                ],
              ),
            ],
          ),

          Row(
            children: [
              AppButton(
                text: 'New investigation',
                backgroundColor: AppColors.info,
                textColor: Colors.white,
                fontSize: 12,
                onPressed: onNewInvestigation,
              ),

              const SizedBox(width: 10),

              AppButton(
                text: 'Print',
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 12,
                onPressed: () {
                  AppSnackbar.show(
                    title: "Info",
                    message: "Print functionality coming soon",
                    type: AppSnackType.info,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InvestigationTableCard extends StatelessWidget {
  final bool isMobile;
  final List<InvestigationModel> investigations;
  final String patientMongoId;
  final InvestigationController controller;

  const _InvestigationTableCard({
    required this.isMobile,
    required this.investigations,
    required this.patientMongoId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TableHeaderRow(),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: investigations.length,
            itemBuilder: (context, index) {
              return _TableDataRow(
                index: index + 1,
                investigation: investigations[index],
                patientMongoId: patientMongoId,
                controller: controller,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TableHeaderRow extends StatelessWidget {
  const _TableHeaderRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      color: const Color(0xFFB9B8B8),
      child: Row(
        children: const [
          _HeaderCell('Number', 1),
          _HeaderCell('Investigation', 3),
          _HeaderCell('Tags', 2),
          _HeaderCell('Date & Time', 3),
          _HeaderCell('Status', 2),
          _HeaderCell('Action', 2),
        ],
      ),
    );
  }
}

class _TableDataRow extends StatelessWidget {
  final int index;
  final InvestigationModel investigation;
  final String patientMongoId;
  final InvestigationController controller;

  const _TableDataRow({
    required this.index,
    required this.investigation,
    required this.patientMongoId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd-MM-yyyy')
        .format(investigation.scheduledDateAndTime);

    final time = DateFormat('hh:mm a')
        .format(investigation.scheduledDateAndTime);

    // Check if this specific investigation is being deleted
    final bool isDeleting = controller.isDeletingInvestigation(investigation.id);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      // Add opacity for items being deleted
      color: isDeleting ? Colors.grey.withOpacity(0.1) : null,
      child: Row(
        children: [
          _DataCell('$index.', 1),

          Expanded(
            flex: 3,
            child: Row(
              children: [
                const Icon(
                  Icons.medical_services_outlined,
                  size: 18,
                  color: AppColors.info,
                ),

                const SizedBox(width: 6),

                AppText(
                  investigation.investigationType,
                  fontSize: 13,
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Center(
              child: _TagChip(
                text: investigation.tags.isNotEmpty
                    ? investigation.tags
                    : '—',
                color: Colors.teal,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(date, fontSize: 12),
                const SizedBox(height: 2),
                AppText(
                  time,
                  fontSize: 11,
                  color: AppColors.greyText,
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Center(
              child: _TagChip(
                text: investigation.insuranceStatus,
                color: _getStatusColor(investigation.insuranceStatus),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionIcon(
                  Icons.visibility,
                  onTap: isDeleting ? null : () {
                    _showInvestigationDialog(context, investigation);
                  },
                ),
                _ActionIcon(
                  Icons.edit,
                  onTap: isDeleting ? null : () {
                    AppSnackbar.show(
                      title: "Info",
                      message: "Edit functionality coming soon",
                      type: AppSnackType.info,
                    );
                  },
                ),
                
                // Show loader or delete icon based on deletion state
                isDeleting
                    ? const SizedBox(
                        width: 32,
                        height: 32,
                        child: Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                    : _ActionIcon(
                        Icons.delete,
                        color: Colors.red,
                        onTap: () {
                          _showDeleteConfirmation(context, investigation, patientMongoId, controller);
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'approved':
        return Colors.blue;
      case 'pending':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteConfirmation(
    BuildContext context, 
    InvestigationModel investigation,
    String patientMongoId,
    InvestigationController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText('Delete Investigation'),
        content: AppText(
          'Are you sure you want to delete this investigation for ${investigation.investigationType}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const AppText('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              
              // Call the delete API - NO SEPARATE LOADER DIALOG
              // The per-item loader will show automatically
              await controller.deleteInvestigation(
                investigationId: investigation.id,
                patientMongoId: patientMongoId,
                refreshList: false, // Don't refresh full list
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const AppText('Delete'),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const _HeaderCell(this.text, this.flex);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: AppText(
          text,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.greyText,
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String text;
  final int flex;

  const _DataCell(this.text, this.flex);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: AppText(text, fontSize: 13),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  final Color color;

  const _TagChip({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppText(
        text,
        fontSize: 11,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const _ActionIcon(
    this.icon, {
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        size: 18,
        color: onTap == null ? Colors.grey.shade300 : (color ?? AppColors.greyText),
      ),
      onPressed: onTap,
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
      padding: EdgeInsets.zero,
    );
  }
}

void _showInvestigationDialog(
  BuildContext context,
  InvestigationModel investigation,
) {
  final date = DateFormat('dd-MM-yyyy')
      .format(investigation.scheduledDateAndTime);

  final time = DateFormat('hh:mm a')
      .format(investigation.scheduledDateAndTime);

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 850,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'View Investigation Request',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),

                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoCard(
                      title: 'Basic Information',
                      items: {
                        'Patient Name': investigation.patientName ?? '-',
                        'Patient ID': investigation.patientId ?? '-',
                        'Doctor': investigation.doctorName ?? '-',
                        'Order Date': date,
                        'Time': time,
                      },
                    ),

                    const SizedBox(width: 16),

                    _infoCard(
                      title: 'Investigation Details',
                      items: {
                        'Type': investigation.investigationType,
                        'Reason': investigation.reasonForInvestigation,
                        'Priority': investigation.priority,
                        'Clinical History': investigation.clinicalHistory,
                        'Details': investigation.investigationDetails,
                        'Tags': investigation.tags,
                      },
                    ),

                    const SizedBox(width: 16),

                    _infoCard(
                      title: 'Billing Information',
                      items: {
                        'Payment Status': investigation.paymentStatus ?? '-',
                        'Insurance Status': investigation.insuranceStatus,
                        'Insurance Covered': investigation.insuranceCovered ? 'Yes' : 'No',
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: 'Close',
                      backgroundColor: Colors.grey.shade600,
                      textColor: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),

                    const SizedBox(width: 12),

                    AppButton(
                      text: 'Edit',
                      backgroundColor: AppColors.info,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                        AppSnackbar.show(
                          title: "Info",
                          message: "Edit functionality coming soon",
                          type: AppSnackType.info,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _infoCard({
  required String title,
  required Map<String, String> items,
}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 12),

          ...items.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: AppText(
                '${e.key} : ${e.value}',
                fontSize: 12,
                color: AppColors.greyText,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}