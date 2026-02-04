// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:hms/screens/module_login_screen.dart';
// import 'package:hms/utils/constants.dart';

// class OldMainDashboard extends StatefulWidget {
//   const OldMainDashboard({super.key});

//   @override
//   State<OldMainDashboard> createState() => _OldMainDashboardState();
// }

// class _OldMainDashboardState extends State<OldMainDashboard> {
//   late DateTime _currentTime;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _currentTime = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30)); // Indian Standard Time (IST)
//     _startTimer();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         _currentTime = DateTime.now()
//             .toUtc()
//             .add(const Duration(hours: 5, minutes: 30)); // IST = UTC+5:30
//       });
//     });
//   }

//   String _formatTime(DateTime time) {
//     return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
//   }

//   String _formatDate(DateTime time) {
//     final months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     return '${time.day} ${months[time.month - 1]} ${time.year}';
//   }

//   String _formatDay(DateTime time) {
//     final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//     return days[time.weekday - 1];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentHour = _currentTime.hour;
//     final currentMinute = _currentTime.minute;
//     final currentSecond = _currentTime.second;

//     // Calculate clock hands angles
//     final hourAngle = (currentHour % 12 + currentMinute / 60) * 30 * (pi / 180);
//     final minuteAngle = (currentMinute + currentSecond / 60) * 6 * (pi / 180);
//     final secondAngle = currentSecond * 6 * (pi / 180);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: _buildAppBar(_currentTime),
//       body: Column(
//         children: [
//           _buildStatusBar(),
//           Expanded(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 final width = constraints.maxWidth;
//                 final height = constraints.maxHeight;

//                 // Large desktop - 3 columns
//                 if (width >= 1400) {
//                   return Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // LEFT COLUMN: Brand + Quote (25%)
//                         SizedBox(
//                           width: width * 0.25,
//                           child: Column(
//                             children: [
//                               SizedBox(height: 220, child: _buildBrandCard()),
//                               const SizedBox(height: 16),
//                               Expanded(child: _buildQuoteCard()),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 16),

//                         // CENTER COLUMN: Clock (27%) - Increased height
//                         SizedBox(
//                           width: width * 0.27,
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                   height: 320,
//                                   child: _buildClockCard(_currentTime,
//                                       hourAngle, minuteAngle, secondAngle)),
//                               const SizedBox(height: 16),
//                               Expanded(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(16),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.withValues(alpha: 0.10),
//                                         blurRadius: 12,
//                                         offset: const Offset(0, 4),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       'System Status: All Normal',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.green[700],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 16),

//                         // RIGHT COLUMN: Apps + Discover + Features (48%)
//                         Expanded(
//                           child: SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _buildApplicationsHeader(),
//                                 const SizedBox(height: 12),
//                                 SizedBox(
//                                   height: height * 0.40, // Increased height
//                                   child: _buildApplicationsGrid(context),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 _buildDiscoverStrip(),
//                                 const SizedBox(height: 12),
//                                 SizedBox(
//                                   height: 360, // INCREASED HEIGHT
//                                   child: _buildFeaturesGrid(),
//                                 ),
//                                 const SizedBox(height: 16), // Bottom padding
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 // Medium screens - 2 columns
//                 if (width >= 900) {
//                   return Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // LEFT COLUMN (55%)
//                         Expanded(
//                           flex: 5,
//                           child: Column(
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: SizedBox(
//                                       height: 220,
//                                       child: _buildBrandCard(),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: SizedBox(
//                                       height: 320,
//                                       child: _buildClockCard(_currentTime,
//                                           hourAngle, minuteAngle, secondAngle),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                               Expanded(child: _buildQuoteCard()),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 16),

//                         // RIGHT COLUMN (45%) - With Scroll
//                         Expanded(
//                           flex: 4,
//                           child: SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _buildApplicationsHeader(),
//                                 const SizedBox(height: 12),
//                                 SizedBox(
//                                   height: height * 0.35,
//                                   child: _buildApplicationsGrid(context),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 _buildDiscoverStrip(),
//                                 const SizedBox(height: 12),
//                                 SizedBox(
//                                   height: 360, // INCREASED HEIGHT
//                                   child: _buildFeaturesGrid(),
//                                 ),
//                                 const SizedBox(height: 16), // Bottom padding
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 // Tablet - Single column with adjusted heights
//                 if (width >= 600) {
//                   return SingleChildScrollView(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: SizedBox(
//                                 height: 200,
//                                 child: _buildBrandCard(),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               flex: 1,
//                               child: SizedBox(
//                                 height: 280,
//                                 child: _buildClockCard(_currentTime, hourAngle,
//                                     minuteAngle, secondAngle),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         _buildQuoteCard(),
//                         const SizedBox(height: 16),
//                         _buildApplicationsHeader(),
//                         const SizedBox(height: 12),
//                         SizedBox(
//                           height: 380, // Increased height
//                           child: _buildApplicationsGrid(
//                             context,
//                             shrinkForSmall: true,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildDiscoverStrip(),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           height: 380, // INCREASED HEIGHT
//                           child: _buildFeaturesGrid(crossAxisForSmall: 2),
//                         ),
//                         const SizedBox(height: 16), // Bottom padding
//                       ],
//                     ),
//                   );
//                 }

//                 // Mobile - Compact single column
//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 170, child: _buildBrandCard()),
//                       const SizedBox(height: 12),
//                       SizedBox(
//                           height: 260,
//                           child: _buildClockCard(_currentTime, hourAngle,
//                               minuteAngle, secondAngle)),
//                       const SizedBox(height: 12),
//                       _buildQuoteCard(),
//                       const SizedBox(height: 16),
//                       _buildApplicationsHeader(),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         height: 380, // Increased height
//                         child: _buildApplicationsGrid(
//                           context,
//                           shrinkForSmall: true,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       _buildDiscoverStrip(),
//                       const SizedBox(height: 12),
//                       SizedBox(
//                         height: 440, // INCREASED HEIGHT
//                         child: _buildFeaturesGrid(crossAxisForSmall: 1),
//                       ),
//                       const SizedBox(height: 16), // Bottom padding
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // APP BAR -------------------------------------------------------------------
//   PreferredSizeWidget _buildAppBar(DateTime currentTime) {
//     return AppBar(
//       backgroundColor: const Color(0xFF2D3748),
//       elevation: 0,
//       titleSpacing: 16,
//       title: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.medical_services,
//               color: Color(0xFF3182CE),
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 AppConstants.appName,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 AppConstants.appTagline,
//                 style: TextStyle(
//                   fontSize: 9,
//                   color: Colors.white70,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         Container(
//           margin: const EdgeInsets.only(right: 12),
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: Colors.green,
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: const Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.circle, size: 8, color: Colors.white),
//               SizedBox(width: 4),
//               Text(
//                 'Online',
//                 style: TextStyle(fontSize: 11, color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(right: 16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 _formatTime(currentTime),
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 _formatDate(currentTime),
//                 style: const TextStyle(fontSize: 11, color: Colors.white70),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // TOP STATUS BAR ------------------------------------------------------------
//   Widget _buildStatusBar() {
//     return Container(
//       color: const Color(0xFFEDF2F7),
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: const Center(
//         child: Text(
//           '© v4.1 | NRAX Complaint • Explore',
//           style: TextStyle(
//             fontSize: 11,
//             color: Color(0xFF718096),
//           ),
//         ),
//       ),
//     );
//   }

//   // BRAND CARD ----------------------------------------------------------------
//   Widget _buildBrandCard() {
//     return Container(
//       clipBehavior: Clip.hardEdge,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.12),
//             blurRadius: 16,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withValues(alpha: 0.15),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.asset(
//                 'assets/images/splash_logo.png',
//                 fit: BoxFit.contain,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   color: const Color(0xFF3182CE),
//                   child: const Icon(
//                     Icons.medical_services,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'DocNex.care',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1A202C),
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 2),
//           const Text(
//             '24x7 Healthcare System',
//             style: TextStyle(
//               fontSize: 12,
//               color: Color(0xFF718096),
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const Spacer(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF48BB78).withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.circle, size: 8, color: Color(0xFF48BB78)),
//                     SizedBox(width: 4),
//                     Text(
//                       'Online',
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Color(0xFF2F855A),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 6),
//               const Text(
//                 'All services operational',
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: Color(0xFF718096),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           const Text(
//             'v2.4.1 | HIPAA Compliant',
//             style: TextStyle(
//               fontSize: 9,
//               color: Color(0xFFA0AEC6),
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   // CLOCK CARD ----------------------------------------------------------------
//   Widget _buildClockCard(DateTime currentTime, double hourAngle,
//       double minuteAngle, double secondAngle) {
//     return Container(
//       clipBehavior: Clip.hardEdge,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.12),
//             blurRadius: 16,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             'DocNex.care',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1A202C),
//             ),
//           ),
//           const SizedBox(height: 12),

//           // REAL-TIME CLOCK
//           SizedBox(
//             height: 140,
//             child: Center(
//               child: Container(
//                 width: 140,
//                 height: 140,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: const Color(0xFF3182CE),
//                     width: 8,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF3182CE).withValues(alpha: 0.3),
//                       blurRadius: 16,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Hour hand
//                     Transform.rotate(
//                       angle: hourAngle,
//                       child: Container(
//                         width: 4,
//                         height: 40,
//                         color: const Color(0xFF2B6CB0),
//                       ),
//                     ),
//                     // Minute hand
//                     Transform.rotate(
//                       angle: minuteAngle,
//                       child: Container(
//                         width: 3,
//                         height: 50,
//                         color: const Color(0xFFED8936),
//                       ),
//                     ),
//                     // Second hand (thin red hand)
//                     Transform.rotate(
//                       angle: secondAngle,
//                       child: Container(
//                         width: 1,
//                         height: 55,
//                         color: Colors.red,
//                       ),
//                     ),
//                     // Center dot
//                     Container(
//                       width: 10,
//                       height: 10,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF3182CE),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     // Clock numbers
//                     ..._buildClockNumbers(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             _formatTime(currentTime),
//             style: const TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             '${_formatDay(currentTime)}, ${_formatDate(currentTime)}',
//             style: const TextStyle(
//               fontSize: 12,
//               color: Color(0xFF718096),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'IST (UTC+5:30)',
//             style: TextStyle(
//               fontSize: 10,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to build clock numbers
//   List<Widget> _buildClockNumbers() {
//     List<Widget> numbers = [];
//     for (int i = 1; i <= 12; i++) {
//       final angle = (i * 30) * (pi / 180);
//       final radius = 48.0;
//       final offsetX = radius * sin(angle);
//       final offsetY = -radius * cos(angle);

//       numbers.add(
//         Transform.translate(
//           offset: Offset(offsetX, offsetY),
//           child: Text(
//             i.toString(),
//             style: const TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF4A5568),
//             ),
//           ),
//         ),
//       );
//     }
//     return numbers;
//   }

//   // QUOTE CARD ----------------------------------------------------------------
//   Widget _buildQuoteCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.10),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(24),
//       child: const Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'TODAY\'S QUOTE',
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF4A5568),
//               letterSpacing: 1,
//             ),
//           ),
//           SizedBox(height: 12),
//           Text(
//             '"Take a break and fuel by happy thoughts."',
//             style: TextStyle(
//               fontSize: 18,
//               fontStyle: FontStyle.italic,
//               color: Color(0xFF2D3748),
//               height: 1.4,
//             ),
//           ),
//           SizedBox(height: 8),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               '- Wellness Journal',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color(0xFF718096),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // DISCOVER STRIP ------------------------------------------------------------
//   Widget _buildDiscoverStrip() {
//     return Container(
//       height: 70,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF3182CE), Color(0xFF805AD5)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF3182CE).withValues(alpha: 0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//       child: const Row(
//         children: [
//           Icon(Icons.star, color: Colors.white, size: 20),
//           SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               'Discover What\'s Inside\nWe Provide You With The Best',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.white,
//                 height: 1.3,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           SizedBox(width: 12),
//           Chip(
//             label: Text(
//               'PREMIUM',
//               style: TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2D3748),
//               ),
//             ),
//             backgroundColor: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }

//   // APPLICATIONS HEADER -------------------------------------------------------
//   Widget _buildApplicationsHeader() {
//     return Row(
//       children: const [
//         Text(
//           'APPLICATIONS',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF4A5568),
//             letterSpacing: 1,
//           ),
//         ),
//         Spacer(),
//         Chip(
//           label: Text(
//             'Premium',
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF744210),
//             ),
//           ),
//           backgroundColor: Color(0xFFFEEBC8),
//         ),
//       ],
//     );
//   }

//   // APPLICATIONS GRID ---------------------------------------------------------
//   Widget _buildApplicationsGrid(BuildContext context,
//       {bool shrinkForSmall = false}) {
//     final crossAxisCount = shrinkForSmall ? 2 : 3;

//     return SingleChildScrollView(
//       physics: const AlwaysScrollableScrollPhysics(),
//       child: GridView.count(
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         crossAxisCount: crossAxisCount,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: shrinkForSmall ? 2.1 : 3.5,
//         children: [
//           _buildPremiumCard(context, 'External Doctor', Icons.people_alt_outlined,
//               AppColors.externalDoctor),
//           _buildPremiumCard(context, 'Reception', Icons.desktop_mac_outlined,
//               AppColors.reception),
//           _buildPremiumCard(
//               context, 'Doctor', Icons.person_outline, AppColors.doctor),
//           _buildPremiumCard(context, 'Nurses', Icons.medical_services_outlined,
//               AppColors.nurses),
//           _buildPremiumCard(context, 'Pharmacy', Icons.local_pharmacy_outlined,
//               AppColors.pharmacy),
//           _buildPremiumCard(context, 'Laboratory', Icons.science_outlined,
//               AppColors.laboratory),
//           _buildPremiumCard(
//               context, 'Insurance', Icons.security_outlined, AppColors.insurance),
//           _buildPremiumCard(context, 'Diagnostics', Icons.monitor_heart_outlined,
//               AppColors.diagnostics),
//           _buildPremiumCard(
//               context, 'Dialysis', Icons.water_drop_outlined, AppColors.dialysis),
//           _buildPremiumCard(
//               context, 'Patient', Icons.accessible_outlined, AppColors.patient),
//           _buildPremiumCard(context, 'Admin', Icons.admin_panel_settings_outlined,
//               AppColors.admin),
//         ],
//       ),
//     );
//   }

//   // FEATURES GRID - PERFECTLY FIXED WITH INCREASED HEIGHTS -------------------
//   Widget _buildFeaturesGrid({int? crossAxisForSmall}) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final width = constraints.maxWidth;
//         int crossAxisCount;

//         if (crossAxisForSmall != null) {
//           crossAxisCount = crossAxisForSmall;
//         } else if (width > 900) {
//           crossAxisCount = 3;
//         } else if (width > 600) {
//           crossAxisCount = 2;
//         } else {
//           crossAxisCount = 1;
//         }

//         // PERFECT childAspectRatio for 5 items to show ALL properly
//         double childAspectRatio;
//         if (crossAxisCount == 1) {
//           childAspectRatio = 4.8; // Perfect for mobile single column
//         } else if (crossAxisCount == 2) {
//           childAspectRatio = 4.0; // Perfect for 2 columns (2+3 layout)
//         } else {
//           childAspectRatio = 3.2; // Perfect for 3 columns (2+2+1 layout)
//         }

//         return Container(
//           height: double.infinity,
//           child: GridView.count(
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: crossAxisCount,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: childAspectRatio,
//             children: [
//               _buildFeatureCard(
//                 'AI Diagnostics',
//                 'Coming Soon',
//                 'Robot powered medical diagnostics',
//                 Icons.psychology_outlined,
//                 const Color(0xFF4299E1),
//               ),
//               _buildFeatureCard(
//                 'Mobile App',
//                 'Online',
//                 'Access records from smartphones',
//                 Icons.phone_android_outlined,
//                 const Color(0xFF48BB78),
//               ),
//               _buildFeatureCard(
//                 'Smart Reports',
//                 'Advanced',
//                 'Advanced insights & analytics',
//                 Icons.analytics_outlined,
//                 const Color(0xFFED8936),
//               ),
//               _buildFeatureCard(
//                 'Cloud Backup',
//                 'Secure',
//                 'Automatic data backup & recovery',
//                 Icons.cloud_outlined,
//                 const Color(0xFF9F7AEA),
//               ),
//               _buildFeatureCard(
//                 'Telemedicine',
//                 'Go Digital',
//                 'Connect with patients virtually',
//                 Icons.video_call_outlined,
//                 const Color(0xFFF56565),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // FEATURE CARD - PERFECTLY FIXED VERSION ------------------------------------
//   Widget _buildFeatureCard(String title, String status, String description,
//       IconData icon, Color color) {
//     return Container(
//       margin: const EdgeInsets.all(2),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.10),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16), // Increased padding
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 44, // Slightly larger icon
//               height: 44,
//               margin: const EdgeInsets.only(right: 12, top: 2),
//               decoration: BoxDecoration(
//                 color: color.withValues(alpha: 0.12),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: color, size: 24), // Larger icon
//             ),
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title row with status badge
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           title,
//                           style: const TextStyle(
//                             fontSize: 15, // Slightly larger
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF2D3748),
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         constraints: const BoxConstraints(minWidth: 55),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: color.withValues(alpha: 0.15),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: color.withValues(alpha: 0.3)),
//                         ),
//                         child: Text(
//                           status,
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: color,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   // Description with proper spacing
//                   Expanded(
//                     child: Text(
//                       description,
//                       style: const TextStyle(
//                         fontSize: 12, // Slightly larger
//                         color: Color(0xFF718096),
//                         height: 1.3,
//                       ),
//                       maxLines: 4, // Increased lines
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // PREMIUM CARD --------------------------------------------------------------
//   Widget _buildPremiumCard(
//       BuildContext context, String title, IconData icon, Color color) {
//     return GestureDetector(
//       onTap: () => _navigateToModule(context, title),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [color.withValues(alpha: 0.9), color],
//           ),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: color.withValues(alpha: 0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha: 0.2),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: Colors.white, size: 20),
//             ),
//             const SizedBox(width: 8),
//             Flexible(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Flexible(
//                     child: Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 6,
//                       vertical: 2,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withValues(alpha: 0.2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Text(
//                       'PREMIUM',
//                       style: TextStyle(
//                         fontSize: 9,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // NAVIGATION ----------------------------------------------------------------
//   void _navigateToModule(BuildContext context, String module) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ModuleLoginScreen(module: module),
//       ),
//     );
//   }
// }