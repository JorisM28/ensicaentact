import 'package:get_it/get_it.dart';
import 'Model/data/services/alumni_repository.dart';
import 'ViewModel/alumni/directory_view_model.dart';

final GetIt sl = GetIt.instance; // sl = Service Locator

void setupLocator() {

  sl.registerLazySingleton<AlumniRepository>(() => AlumniRepository());


  sl.registerFactory<DirectoryViewModel>(() => DirectoryViewModel(repository: sl()));
}