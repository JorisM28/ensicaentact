class ApiConstants {
  static const String baseUrl = 'https://alumni.theo-airey.fr';

  static const String getAlumni = '$baseUrl/alumnis/get_alumni.php';
  static const String addAlumni = '$baseUrl/alumnis/add_alumni.php';
  static const String updateAlumni = '$baseUrl/alumnis/update_alumni.php';
  static const String deleteAlumni = '$baseUrl/alumnis/delete_alumni.php';
  static const String requestAlumni = '$baseUrl/alumnis/request_alumni.php';


  static const String getEvents = '$baseUrl/events/get_events.php';
  static const String editEvent = '$baseUrl/events/update_events.php';
  static const String addEvent = '$baseUrl/events/add_events.php';
  static const String deleteEvent = '$baseUrl/events/delete_events.php';
  static const String requestEvent = '$baseUrl/events/request_events.php';
  static const String validateEvent = '$baseUrl/events/validate_events.php';

  static const String getCompany = '$baseUrl/others/get_company.php';
  static const String getHistory = '$baseUrl/others/get_history.php';

  static const String updatePassword = '$baseUrl/update_password.php';

  static const String getOffer = '$baseUrl/offer/get_offers.php';
  static const String addOffer = '$baseUrl/offer/add_offer.php';
  static const String updateOffer = '$baseUrl/offer/update_offer.php';
  static const String deleteOffer = '$baseUrl/offer/delete_offer.php';
  
  static const String getPendingRequest = '$baseUrl/requests/get_request.php';
  static const String deletePendingRequest = '$baseUrl/requests/delete_request.php';

  static const String addNews = '$baseUrl/actualities/add_actualities.php';
  static const String deleteNews = '$baseUrl/actualities/delete_actualities.php';
  static const String getNews = '$baseUrl/actualities/get_actualities.php';
}