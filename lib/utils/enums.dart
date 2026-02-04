import 'panel_menu.dart';

enum UserPanel {
  doctor,
  reception,
  nurse,
  pharmacy,
  laboratory,
  admin,
  patient,
  insurance,
  diagnostics,
  dialysis,
  externalDoctor,
}

enum DoctorPanelMenu implements PanelMenu {
  inbox('Inbox'),
  dashboard('Dashboard'),
  assignedPatients('Assigned patients'),
  telecommunication('Telecommunication'),
  labResults('Laboratory results'),
  patientDatabase('Patients Database'),
  broadcasting('Broadcasting'),
  analysis('Analysis'),
  profile('Profile'),
  settings('Settings');

  @override
  final String label;
  const DoctorPanelMenu(this.label);
}

enum PatientDetailsMenu implements PanelMenu {
  overview('Overview'),
  monitoring('Monitoring'),
  treatment('Treatment'),
  investigation('Investigation'),
  surgicalNotes('Surgical notes');

  @override
  final String label;
  const PatientDetailsMenu(this.label);
}

enum PatientTabType {
  opd,
  ipd,
  teleconsultation,
}

enum TeleconsultationStatus {
  ongoing,
  cancelled,
}

extension TeleconsultationStatusX on TeleconsultationStatus {
  String get value {
    switch (this) {
      case TeleconsultationStatus.ongoing:
        return 'ONGOING';
      case TeleconsultationStatus.cancelled:
        return 'CANCELLED';
    }
  }
}

