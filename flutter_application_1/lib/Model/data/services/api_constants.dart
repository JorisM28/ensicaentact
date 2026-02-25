class ApiConstants {
  static const String baseUrl = 'https://alumni.theo-airey.fr';
  static const String getAlumni = '$baseUrl/get_alumni.php';
  static const String addAlumni = '$baseUrl/add_alumni.php';
  static const String updateAlumni = '$baseUrl/update_alumni.php';
  static const String deleteAlumni = '$baseUrl/delete_alumni.php';
  static const String requestAlumni = '$baseUrl/request_alumni.php';

  static const String getHistory = '$baseUrl/get_history.php';
  static const String getEvents = '$baseUrl/events/get_events.php';
  static const String getCompany = '$baseUrl/get_company.php';
  static const String updatePassword = '$baseUrl/update_password.php';

  static const String getOffer = '$baseUrl/offer/get_offers.php';
  static const String addOffer = '$baseUrl/offer/add_offer.php';
  static const String deleteOffer = '$baseUrl/offer/delete_offer.php';
  
  static const String getPendingRequest = '$baseUrl/get_request.php';
  static const String deletePendingRequest = '$baseUrl/delete_request.php';
}