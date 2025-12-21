import 'package:elysian_admin/features/add_package/domain/repositories/package_repository.dart';
import 'package:elysian_admin/features/package_list/logic/bloc/package_list_event.dart';
import 'package:elysian_admin/features/package_list/logic/bloc/package_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageListBloc extends Bloc<PackageListEvent, PackageListState> {
  final PackageRepository _packageRepository;

  PackageListBloc({required PackageRepository packageRepository})
    : _packageRepository = packageRepository,
      super(PackageListInitial()) {
    on<FetchPackages>(_onFetchPackages);
  }

  Future<void> _onFetchPackages(
    FetchPackages event,
    Emitter<PackageListState> emit,
  ) async {
    emit(PackageListLoading());
    try {
      final packages = await _packageRepository.getPackages(type: event.type);
      emit(PackageListLoaded(packages: packages));
    } catch (e) {
      emit(PackageListError(message: e.toString()));
    }
  }
}
