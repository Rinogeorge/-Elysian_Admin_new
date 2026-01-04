import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elysian_admin/core/services/cloudinary_service.dart';
import 'package:elysian_admin/core/validation/input_validator.dart';
import 'package:elysian_admin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:elysian_admin/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:elysian_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:elysian_admin/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:elysian_admin/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:elysian_admin/features/auth/domain/usecases/login_usecase.dart';
import 'package:elysian_admin/features/auth/domain/usecases/logout_usecase.dart';
import 'package:elysian_admin/features/auth/domain/usecases/signup_usecase.dart';
import 'package:elysian_admin/features/auth/logic/bloc/drawer/drawer_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/login/login_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/profile/profile_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/signup/signup_bloc.dart';
import 'package:elysian_admin/features/add_package/data/repositories/package_repository_impl.dart';
import 'package:elysian_admin/features/add_package/domain/repositories/package_repository.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/category/data/datasources/category_remote_datasource.dart';
import 'package:elysian_admin/features/category/data/repositories/category_repository_impl.dart';
import 'package:elysian_admin/features/category/domain/repositories/category_repository.dart';
import 'package:elysian_admin/features/category/domain/usecases/add_category_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/update_category_usecase.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_bloc.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/bloc/user_category_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));
  sl.registerFactory(() => SignupBloc(signupUseCase: sl()));
  sl.registerFactory(
    () => ProfileBloc(getCurrentUserUseCase: sl(), logoutUseCase: sl()),
  );
  sl.registerFactory(
    () => DrawerBloc(getCurrentUserUseCase: sl(), logoutUseCase: sl()),
  );
  sl.registerFactory(() => ForgotPasswordBloc(forgotPasswordUseCase: sl()));
  sl.registerFactory(
    () => CategoryBloc(
      addCategoryUseCase: sl(),
      getCategoriesUseCase: sl(),
      deleteCategoryUseCase: sl(),
      updateCategoryUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => AddPackageBloc(cloudinaryService: sl(), packageRepository: sl()),
  );
  sl.registerFactory(() => UserCategoryBloc(getCategoriesUseCase: sl()));

  // Use Cases - Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));

  // Use Cases - Category
  sl.registerLazySingleton(() => AddCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCategoryUseCase(sl()));

  // Repository - Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Repository - Category
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: sl()),
  );

  // Repository - Package
  sl.registerLazySingleton<PackageRepository>(
    () => PackageRepositoryImpl(firestore: sl()),
  );

  // Data Sources - Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firebaseFirestore: sl()),
  );

  // Data Sources - Category
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(
      firebaseFirestore: sl(),
      cloudinaryService: sl(),
    ),
  );

  // Services
  sl.registerLazySingleton(() => CloudinaryService());

  // Validators
  sl.registerLazySingleton<InputValidator<String>>(
    () => CategoryNameValidator(),
    instanceName: 'categoryNameValidator',
  );
  sl.registerLazySingleton<InputValidator<String>>(
    () => ImagePathValidator(),
    instanceName: 'imagePathValidator',
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
}
