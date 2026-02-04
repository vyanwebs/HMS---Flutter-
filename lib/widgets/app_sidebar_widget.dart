// import 'package:flutter/material.dart';

// import '../models/sidebar_model.dart';
// import '../utils/constants.dart';
// import '../utils/text.dart';

// class AppSidebar extends StatelessWidget {
//   final String appName;
//   final String logo;
//   final String selectedId;
//   final ValueChanged<String> onItemSelected;
//   final VoidCallback onBack;
//   final List<AppSidebarSection> sections;

//   const AppSidebar({
//     super.key,
//     required this.appName,
//     required this.logo,
//     required this.selectedId,
//     required this.onItemSelected,
//     required this.onBack,
//     required this.sections,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _header(),
//                 ...sections.map(_buildSection),
//               ],
//             ),
//           ),
//         ),
//         _footer(),
//       ],
//     );
//   }

//   // ================= HEADER =================

//   Widget _header() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.asset(logo, width: 40, height: 40),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             appName,
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ================= SECTION =================

//   Widget _buildSection(AppSidebarSection section) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (section.header != null) ...[
//           const Divider(height: 35),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Text(
//               section.header!,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFFA0AEC0),
//                 letterSpacing: 1,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//         ],
//         ...section.items.map(_itemTile),
//       ],
//     );
//   }

//   // ================= ITEM =================

//   Widget _itemTile(AppSidebarItem item) {
//     final isSelected = selectedId == item.id;

//     return InkWell(
//       onTap: () => onItemSelected(item.id),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
//         margin: const EdgeInsets.all(2),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF2383E2) : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             item.type == SidebarItemType.icon
//                 ? Icon(
//                     item.icon,
//                     color:
//                         isSelected ? Colors.white : const Color(0xFF718096),
//                   )
//                 : Image.asset(
//                     item.imagePath!,
//                     scale: 20,
//                     color:
//                         isSelected ? Colors.white : const Color(0xFF718096),
//                   ),
//             const SizedBox(width: 12),
//             Text(
//               item.title,
//               style: TextStyle(
//                 color:
//                     isSelected ? Colors.white : const Color(0xFF4A5568),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= FOOTER =================

//   Widget _footer() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         border: Border(top: BorderSide(color: Colors.grey.shade200)),
//       ),
//       child: InkWell(
//         onTap: onBack,
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.arrow_back, color: AppColors.doctor),
//             SizedBox(width: 10),
//             AppText(
//               'Back',
//               fontSize: 15,
//               color: AppColors.doctor,
//               fontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
