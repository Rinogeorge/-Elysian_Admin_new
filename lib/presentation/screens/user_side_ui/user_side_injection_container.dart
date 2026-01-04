import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/bloc/user_category_bloc.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/core/services/cloudinary_service.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/data/datasources/category_remote_datasource.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/data/repositories/category_repository_impl.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/domain/repositories/category_repository.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/domain/usecases/get_categories_usecase.dart';
import 'package:get_it/get_it.dart';

// Create a separate GetIt instance for User Side UI to avoid conflicts with global sl.
final userSl = GetIt.asNewInstance();

Future<void> initUserSide() async {
  // Only register if not already registered (though specific instance should be empty initially).

  // External
  if (!userSl.isRegistered<FirebaseFirestore>()) {
    userSl.registerLazySingleton(() => FirebaseFirestore.instance);
  }

  // Services
  if (!userSl.isRegistered<CloudinaryService>()) {
    userSl.registerLazySingleton(() => CloudinaryService());
  }

  // Data Sources
  if (!userSl.isRegistered<CategoryRemoteDataSource>()) {
    userSl.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(firebaseFirestore: userSl()),
    );
  }

  // Repository
  if (!userSl.isRegistered<CategoryRepository>()) {
    userSl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(remoteDataSource: userSl()),
    );
  }

  // Use Cases
  if (!userSl.isRegistered<GetCategoriesUseCase>()) {
    userSl.registerLazySingleton(() => GetCategoriesUseCase(userSl()));
  }

  // BLoC
  if (!userSl.isRegistered<UserCategoryBloc>()) {
    userSl.registerFactory(
      () => UserCategoryBloc(getCategoriesUseCase: userSl()),
    );
  }
}
