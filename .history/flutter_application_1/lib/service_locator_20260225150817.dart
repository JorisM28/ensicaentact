import 'package:get_it/get_it.dart';
import 'Model/data/services/alumni_repository.dart';
import 'ViewModel/alumni/directory_view_model.dart';
import 'Model/data/services/auth_service.dart';

final GetIt sl = GetIt.instance;

void setupLocator() {

  sl.registerLazySingleton<AlumniRepository>(() => AlumniRepository());


  sl.registerFactory<DirectoryViewModel>(() => DirectoryViewModel(repository: sl()));

  sl.registerLazySingleton<AuthService>(()=>AuthService());
}