bool isProd = true;

String baseUrl = isProd ? "https://docnex-hms.onrender.com" : "https://docnex-hms.onrender.com";

// ============== Doctor Panel ===============

String getStatCardApi = "$baseUrl/api/dashboard/doctor";
String doctorLoginApi = "$baseUrl/api/doctor/login";
String getRecentPatientsApi = "$baseUrl/api/doctor/get-patients";
String getTodaysPatientsApi = "$baseUrl/api/doctor/get-today-patients";
String getTaskApi = "$baseUrl/api/task/get-all";
String getTeleQueueApi = "$baseUrl/api/doctor/teleconsultation-patients";
String getIPDVitalsApi = "$baseUrl/api/doctor/get-ipd-vitals";
String getOPDPatientsApi = "$baseUrl/api/doctor/opd-patients";
String getIPDPatientsApi = "$baseUrl/api/doctor/ipd-patients";
String getTelePatientsApi = "$baseUrl/api/doctor/teleconsultation-patients";
String makeAdmitRequestApi = "$baseUrl/api/doctor/make-admit-request";
String makeDischargeRequestApi = "$baseUrl/api/doctor/make-discharge-request";