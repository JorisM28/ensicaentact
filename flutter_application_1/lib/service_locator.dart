import 'package:get_it/get_it.dart';
import 'Model/data/services/alumni_repository.dart';
import 'ViewModel/alumni/directory_view_model.dart';
import 'ViewModel/alumni/add_alumni_viewmodel.dart';
import 'ViewModel/event/event_viewmodel.dart';
import 'ViewModel/event/news_viewmodel.dart';
import 'ViewModel/admin/admin_validate_viewmodel.dart';
import 'ViewModel/auth_viewmodel.dart';
import 'Model/data/services/auth_service.dart';
import 'Model/connection/auth_strategy.dart';
import 'Model/connection/ensicaen_auth_adapter.dart';

final GetIt sl = GetIt.instance;

void setupLocator() {

  sl.registerLazySingleton<AlumniRepository>(() => AlumniRepository());

  sl.registerFactory<DirectoryViewModel>(() => DirectoryViewModel(repository: sl()));
  sl.registerFactory<AddAlumniViewModel>(() => AddAlumniViewModel());
  sl.registerFactory<EventViewModel>(() => EventViewModel());
  sl.registerFactory<NewsViewModel>(() => NewsViewModel());
  sl.registerFactory<AdminValidateViewModel>(() => AdminValidateViewModel());
  sl.registerFactory<AuthViewModel>(() => AuthViewModel());

  sl.registerLazySingleton<AuthService>(()=>AuthService());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(EnsiCaenAuthAdapter()));
}
