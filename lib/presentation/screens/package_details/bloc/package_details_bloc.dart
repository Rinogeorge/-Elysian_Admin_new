import 'package:elysian_admin/features/add_package/domain/repositories/package_repository.dart';
import 'package:elysian_admin/presentation/screens/package_details/bloc/package_details_event.dart';
import 'package:elysian_admin/presentation/screens/package_details/bloc/package_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageDetailsBloc
    extends Bloc<PackageDetailsEvent, PackageDetailsState> {
  final PackageRepository _packageRepository;

  PackageDetailsBloc({required PackageRepository packageRepository})
    : _packageRepository = packageRepository,
      super(PackageDetailsInitial()) {
    on<DeletePackageEvent>(_onDeletePackage);
  }

  Future<void> _onDeletePackage(
    DeletePackageEvent event,
    Emitter<PackageDetailsState> emit,
  ) async {
    emit(PackageDetailsLoading());
    try {
      // Assuming 'id' is available in PackageModel, but based on reading it was nullable.
      // We should check if id is null.
      if (event.package.id == null) {
        emit(const PackageDetailsError("Package ID is missing"));
        return;
      }

      await _packageRepository.deletePackage(
        id: event.package.id!,
        type: event.package.type,
      );
      emit(PackageDetailsDeleted());
    } catch (e) {
      emit(PackageDetailsError(e.toString()));
    }
  }
}
