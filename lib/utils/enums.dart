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
  ipdManagement('Ipd Management'),
  analysis('Analysis'),
  profile('Profile'),
  settings('Settings');

  @override
  final String label;
  const DoctorPanelMenu(this.label);
}

enum ReceptionPanelMenu implements PanelMenu {
  dashboard('Dashboard'),
  inbox('Inbox'),
  appointments('Appointments'),
  patientDirectory('Patient Directory'),
  ipd('IPD'),
  opd('OPD'),
  discharge('Discharge'),
  doctors('Doctors'),
  track_patient('Track Patients'),
  externaldoctor('External Doctor'),
  billing('Billing'),
  analysis('Analysis'),
  settings('Settings');

  @override
  final String label;

  const ReceptionPanelMenu(this.label);
}

enum PatientTabType {
  opd,
  ipd,
  teleconsultation,
}

enum PatientDetailsMenu {
  overview,

  // Monitoring group
  monitoringVitals,
  monitoringSymptoms,
  monitoringFollowUps,
  monitoringPrescription,
  monitoringConsultation,
  monitoringDiagnosis,

  treatment,
  investigation,
  surgicalNotes,
  ePrescription,
  dischargeSummary
}

enum VitalsViewMode {
  table,
  analysis,
}

enum VitalType {
  temperature,
  pulse,
  bp,
  spo2,
  respiration,
  sugar,
  weight,
}

enum TimeRange {
  days7,
  days14,
  days30,
  all,
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

