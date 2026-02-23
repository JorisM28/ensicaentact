import 'package:get_it/get_it.dart';
import 'Model/data/services/alumni_repository.dart';
import 'ViewModel/alumni/directory_view_model.dart';

final GetIt sl = GetIt.instance; // sl = Service Locator

void setupLocator() {
  // 1. Repositories (Singleton : une seule instance pour toute l'app)
  sl.registerLazySingleton<AlumniRepository>(() => AlumniRepository());

  // 2. ViewModels (Factory : une nouvelle instance à chaque appel)
  sl.registerFactory<DirectoryViewModel>(() => DirectoryViewModel(repository: sl()));
}