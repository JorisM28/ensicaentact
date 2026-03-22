import 'package:get_it/get_it.dart';
import 'Model/data/services/alumni_repository.dart';
import 'ViewModel/alumni/directory_view_model.dart';
import 'ViewModel/alumni/add_alumni_viewmodel.dart';
import 'ViewModel/event/event_viewmodel.dart';
import 'ViewModel/event/job_viewmodel.dart';
import 'ViewModel/event/news_viewmodel.dart';
import 'ViewModel/admin/admin_validate_viewmodel.dart';
import 'ViewModel/auth_viewmodel.dart';
import 'Model/data/services/auth_service.dart';
import 'Model/connection/auth_strategy.dart';
import 'Model/connection/ensicaen_auth_adapter.dart';
import 'ViewModel/widget/event_widget_viewmodel.dart';
import 'ViewModel/widget/job_widget_viewmodel.dart';
import 'ViewModel/widget/key_figure_widget_viewmodel.dart';
import 'ViewModel/widget/profile_viewmodel.dart';

final GetIt sl = GetIt.instance;

void setupLocator() {

  sl.registerLazySingleton<AlumniRepository>(() => AlumniRepository());

  sl.registerFactory<DirectoryViewModel>(() => DirectoryViewModel(repository: sl()));
  sl.registerFactory<AddAlumniViewModel>(() => AddAlumniViewModel());
  sl.registerFactory<EventViewModel>(() => EventViewModel());
  sl.registerLazySingleton(() => EventWidgetViewModel());
  sl.registerLazySingleton(() => JobOfferWidgetViewModel());
  sl.registerLazySingleton<ProfileViewModel>(() => ProfileViewModel());
  sl.registerLazySingleton<JobViewModel>(() => JobViewModel());
  sl.registerFactory<NewsViewModel>(() => NewsViewModel());
  sl.registerFactory<AdminValidateViewModel>(() => AdminValidateViewModel());
  sl.registerFactory<AuthViewModel>(() => AuthViewModel());
  sl.registerLazySingleton(() => KeyFiguresViewModel());
  sl.registerLazySingleton<AuthService>(()=>AuthService());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(EnsiCaenAuthAdapter()));
}
