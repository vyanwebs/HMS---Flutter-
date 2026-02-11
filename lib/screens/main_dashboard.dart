import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper_resposive_class/responsive_layout.dart';
import '../models/hospital_panel_model.dart';
import '../models/operation_step_model.dart';
import '../utils/buttons.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/images.dart';
import '../utils/text.dart';
import '../utils/url_launchers.dart';
import '../widgets/arrow_step_card.dart';
import '../widgets/helper_widgets.dart';
import '../widgets/info_card.dart';
import '../widgets/panel_card.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 900;

            return isDesktop ? desktopHero(constraints) : mobileHero();
          },
        ),
      ),
    );
  }

  // ================= DESKTOP =================

  Widget desktopHero(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppColors.solitude,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            children: [
              topContent(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  Expanded(flex: 5, child: leftContent()),
                  const SizedBox(width: 40),
                  Expanded(flex: 4, child: rightImage()),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 50,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: fieldOfOperationsDesktopLayout(),
        ),
        const SizedBox(height: 60,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: hospitalPanel(),
        ),
        const SizedBox(height: 60,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: coreSystem(),
        ),
        const SizedBox(height: 60,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: usp(constraints),
        ),
        const SizedBox(height: 60,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: problemsSolves(constraints),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }

  // ================= MOBILE/TABLET =================

  Widget mobileHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        topContent(),
        rightImage(),
        const SizedBox(height: 30),
        leftContent(center: true),
      ],
    );
  }

  // ============== Top Content =================

  Widget topContent() {
    return Row(
      children: [
        Image.asset(appLogo, scale: 12,),
        const SizedBox(width: 12,),
        const Text(
          'Docnex',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // ================= LEFT SIDE =================

  Widget leftContent({bool center = false}) {
    return Column(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 100),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Docnex",
                style: GoogleFonts.poppins(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: const Color(0xff2383E2)
                ),
              ),
              TextSpan(
                text: " Healthcare\nEcosystem",
                style: GoogleFonts.poppins(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: const Color(0xff7EA839)
                )
              )
            ]
          )
        ),

        const SizedBox(height: 20),

        Text(
          "Reinventing Hospitals with Intelligence, Speed & Automation\n\nA complete hospital operating system designed for Indian healthcare realities — where doctors are overloaded, staff is undertrained, documentation is weak, and revenue leaks silently.",
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.greyText,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 30),

        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: center ? WrapAlignment.center : WrapAlignment.start,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                backgroundColor: AppColors.info
              ),
              onPressed: () {},
              child: const Text("Join for free"),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent
              ),
              icon: const Icon(Icons.play_circle, color: Colors.black, size: 30,),
              onPressed: () {},
              label: const Text(
                "Watch how it works",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= RIGHT SIDE =================

  Widget rightImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(doctorImage)
              ),
            ),
          ),
        ),
        Positioned(
          left: -200,
          bottom: 150,
          child: InfoCard(
            title: "150+ Hospitals Digitized",
            subtitle: "Across India",
            leading: imageAvatar("https://images.unsplash.com/photo-1586773860418-d37222d8fce3"),
            buttonText: "Join Now",
            onPressed: () {},
          )
        ),
        Positioned(
          top: 100,
          left: -40,
          child: InfoCard(
            title: "1,200+ Doctors Using Docnex",
            subtitle: "Across Multi-Speciality Hospitals",
            leading: imageAvatar("https://images.unsplash.com/photo-1559839734-2b71ea197ec2"),
          )
        ),
        Positioned(
          top: 180,
          right: -20,
          child: InfoCard(
            title: "4x Faster Clinical Documentation",
            subtitle: "With AI + Voice Automation",
            leading: featureIcon(Icons.auto_awesome, Colors.orange),
            trailing: const Icon(Icons.verified, color: Colors.green, size: 18),
          )
        ),
      ],
    );
  }

  // ================== Field Of Operations ==============

  final List<OperationStep> steps = [
    OperationStep(
      number: "01",
      title: "Registration",
      imagePath: step1,
      icon: step1Overlay
    ),
    OperationStep(
      number: "02",
      title: "Documentation",
      imagePath: step2,
      icon: step2Overlay
    ),
    OperationStep(
      number: "03",
      title: "Hospital Control",
      imagePath: step3,
      icon: step3Overlay
    ),
    OperationStep(
      number: "04",
      title: "Dashboard Access",
      imagePath: step4,
      icon: step4Overlay
    ),
  ];

  Widget fieldOfOperationsDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // LEFT TEXT
        SizedBox(
          width: 320,
          child: leftText(),
        ),

        // RIGHT STEPS
        Wrap(
          spacing: 0,
          runSpacing: 30,
          alignment: WrapAlignment.spaceBetween,
          children: steps.map((e) => ArrowStepCard(step: e)).toList(),
        ),
      ],
    );
  }

  // ================= MOBILE / TABLET =================

  Widget fieldOfOperationsMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leftText(center: true),
        const SizedBox(height: 40),

        Wrap(
          spacing: 24,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: steps.map((e) => ArrowStepCard(step: e)).toList(),
        ),
      ],
    );
  }

  // ================= LEFT TEXT =================

  Widget leftText({bool center = false}) {
    return Column(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          "How Docnex Operates?",
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xff1E88FF),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "Seeing, Understanding, Acting: How this works in 4 steps",
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  final List<HospitalPanel> panels = [
    HospitalPanel(
      title: "External Doctor Panel",
      image: externalDoctor,
      totalRegistrations: 16,
      rating: 4,
      panel: UserPanel.externalDoctor,
    ),
    HospitalPanel(
      title: "Reception Panel",
      image: receptionPanel,
      totalRegistrations: 16,
      rating: 3,
      panel: UserPanel.reception,
    ),
    HospitalPanel(
      title: "Doctor Panel",
      image: doctorPanel,
      totalRegistrations: 16,
      rating: 3,
      panel: UserPanel.doctor,
    ),
    HospitalPanel(
      title: "Nurse Panel",
      image: nursePanel,
      totalRegistrations: 16,
      rating: 3,
      panel: UserPanel.nurse,
    ),
    HospitalPanel(
      title: "Pharmacy Panel",
      image: pharmacyPanel,
      totalRegistrations: 16,
      rating: 3,
      panel: UserPanel.pharmacy,
    ),
    HospitalPanel(
      title: "Patient Panel",
      image: patientPanel,
      totalRegistrations: 16,
      rating: 3,
      panel: UserPanel.patient,
    ),
    HospitalPanel(
      title: "Admin Panel",
      image: adminPanel,
      totalRegistrations: 16,
      rating: 3,
      panel: UserPanel.admin,
    ),
    HospitalPanel(
      title: "Insurance Panel",
      image: insurancePanel,
      totalRegistrations: 16,
      rating: 3,
      panel: UserPanel.insurance,
    ),
    HospitalPanel(
      title: "Laboratory Panel",
      image: laboratoryPanel,
      totalRegistrations: 16,
      rating: 3,
      panel: UserPanel.laboratory,
    ),
    HospitalPanel(
      title: "Diagnostic Panel",
      image: diagnosticPanel,
      totalRegistrations: 16,
      rating: 3,
      panel: UserPanel.diagnostics,
    ),
    HospitalPanel(
      title: "Dialysis Panel",
      image: dialysisPanel,
      totalRegistrations: 16,
      rating: 3,
      panel: UserPanel.dialysis,
    ),
  ];

  Widget hospitalPanel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;

        if (constraints.maxWidth < 1200) crossAxisCount = 3;
        if (constraints.maxWidth < 800) crossAxisCount = 2;
        if (constraints.maxWidth < 450) crossAxisCount = 1;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            children: [
              const Text(
                "Complete Hospital Ecosystem",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1E88FF),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "11 Integrated Panels for Every Department",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 40),

              GridView.builder(
                shrinkWrap: true,
                itemCount: panels.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.89,
                ),
                itemBuilder: (context, index) {
                  return HospitalPanelCard(panel: panels[index]);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget coreSystem() {
    return ResponsiveLayout(
      mobile: mobileViewCoreSystem(),
      tablet: tabViewCoreSystem(),
      desktop: desktopViewCoreSystem(),
    );
  }

  Widget mobileViewCoreSystem() {
    return Container();
  }

  Widget tabViewCoreSystem() {
    return Container();
  }

  Widget desktopViewCoreSystem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        children: [
          const Text(
            "Core System Features",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xff1E88FF),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Advanced capabilities that power the entire ecosystem",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(coreFeatures, width: MediaQuery.of(context).size.width*0.4,),
              const SizedBox(width: 100,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.22,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // MAIN CONTENT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "What's coming next",
                          style: TextStyle(
                            fontSize: 28,
                            color: AppColors.doctor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Docnex brings efficiency, intelligence, and reliability to hospitals.",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.greyText,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // BUTTON
                        AppButton(
                          onPressed: () => openWebsite("https://docnex.care/"),
                          text: 'Discover',
                          fontSize: 12,
                          icon: Icons.arrow_forward_ios_rounded,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                          borderRadius: 8,
                          iconSize: 12,
                        ),
                      ],
                    ),

                    // ================= FLOATING ARROW =================
                    Positioned(
                      right: 140,
                      bottom: 0,
                      child: Image.asset(
                        arrowImage,
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),

                    // ================= FLOATING PILL =================
                    Positioned(
                      right: 100,
                      bottom: 20,
                      child: Image.asset(
                        pillShapeImage,
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget usp(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "OUR USP ",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: "(Why Docnex is Different)",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.sushi,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            const AppText(
              "Docnex Is Not Just Software —\nIt Is the Operating System of Your Hospital",
              fontSize: 14,
              color: AppColors.greyText,
            ),

            const SizedBox(height: 30),

            const AppText(
              "Benefits :",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 18),

            uspPoint("Ultra-Fast Clinical Workflow (Quick Bars + Voice + AI)"),
            uspPoint("100% Documentation Accuracy & Zero Data Loss"),
            uspPoint("Built for Indian Hospitals"),
            uspPoint("Single Connected Ecosystem"),
            uspPoint("High Intelligence, Low Effort System"),

            const Padding(
              padding: EdgeInsets.only(left: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubPoint("AI lab report reading"),
                  SubPoint("AI diagnosis suggestions"),
                  SubPoint("AI RMO clinical automation"),
                  SubPoint("Voice command workflows"),
                ],
              ),
            ),
          ],
        ),
        SizedBox(width: constraints.maxWidth*0.1),
        Image.asset(uspSectionImage, width: constraints.maxWidth*0.4,),
      ],
    );
  }

  Widget uspPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.sushi, size: 20),
          const SizedBox(width: 10),
          AppText(
            text,
            fontSize: 14,
            color: AppColors.greyText,
          ),
        ],
      ),
    );
  }

  Widget problemsSolves(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              "What problems Docnex Solves",
              fontSize: 28,
              color: AppColors.doctor,
            ),
            SizedBox(height: 15,),
            AppText(
              "Docnex Is Not Just Software —\nIt Is the Operating System of Your Hospital",
              fontSize: 14,
              color: AppColors.greyText,
            ),
          ],
        ),
        SizedBox(width: constraints.maxWidth*0.1),
        Image.asset(problemSolvesImage, width: constraints.maxWidth*0.4,)
      ],
    );
  }

}

class SubPoint extends StatelessWidget {
  final String text;
  const SubPoint(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppText(
        "• $text",
        fontSize: 13,
        color: AppColors.greyText,
      ),
    );
  }
}