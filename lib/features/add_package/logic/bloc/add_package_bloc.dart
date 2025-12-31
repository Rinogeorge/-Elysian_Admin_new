import 'package:elysian_admin/features/add_package/logic/bloc/add_package_event.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_state.dart';
import 'package:elysian_admin/core/services/cloudinary_service.dart';
import 'package:elysian_admin/features/add_package/data/repositories/package_repository_impl.dart';
import 'package:elysian_admin/features/add_package/domain/repositories/package_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddPackageBloc extends Bloc<AddPackageEvent, AddPackageState> {
  final ImagePicker _picker = ImagePicker();
  final CloudinaryService _cloudinaryService;
  final PackageRepository _packageRepository;

  AddPackageBloc({
    CloudinaryService? cloudinaryService,
    PackageRepository? packageRepository,
  }) : _cloudinaryService = cloudinaryService ?? CloudinaryService(),
       _packageRepository = packageRepository ?? PackageRepositoryImpl(),
       super(const AddPackageState()) {
    on<PickPackageImages>(_onPickPackageImages);
    on<RemovePackageImage>(_onRemovePackageImage);
    on<ToggleInclusion>(_onToggleInclusion);
    on<SelectItineraryDay>(_onSelectItineraryDay);
    on<RemoveDayImage>(_onRemoveDayImage);
    on<PickDayImage>(_onPickDayImage);
    on<UpdateDayDescription>(_onUpdateDayDescription);
    on<PackageNameChanged>(_onPackageNameChanged);
    on<CategoryNameChanged>(_onCategoryNameChanged);
    on<PriceChanged>(_onPriceChanged);
    on<NumberOfDaysChanged>(_onNumberOfDaysChanged);
    on<HighlightsChanged>(_onHighlightsChanged);
    on<ValidateForm>(_onValidateForm);
    on<AddSectionItem>(_onAddSectionItem);
    on<RemoveSectionItem>(_onRemoveSectionItem);
    on<UpdateSectionItem>(_onUpdateSectionItem);
    on<TourTypeChanged>(_onTourTypeChanged);
    on<SubmitPackage>(_onSubmitPackage);
    on<InitializeForm>(_onInitializeForm);
    on<RemoveExistingPackageImage>(_onRemoveExistingPackageImage);
    on<RemoveExistingDayImage>(_onRemoveExistingDayImage);
  }

  void _onInitializeForm(InitializeForm event, Emitter<AddPackageState> emit) {
    print("InitializeForm called with package: ${event.package.packageName}");
    final pkg = event.package;
    final Map<int, String> dayDescriptions = {};
    final Map<int, List<String>> existingDayImages = {};

    pkg.itinerary.forEach((key, value) {
      final day = int.tryParse(key) ?? 0;
      if (day > 0) {
        dayDescriptions[day] = value.description;
        existingDayImages[day] = value.images;
      }
    });

    emit(
      state.copyWith(
        packageId: pkg.id,
        packageName: pkg.packageName,
        categoryName: pkg.categoryName,
        tourType: pkg.type,
        price: pkg.price.toString(),
        numberOfDays: pkg.duration,
        highlights: pkg.highlights,
        existingImageUrls: pkg.images,
        selectedInclusions: pkg.standardInclusions,
        inclusionsList: pkg.inclusions,
        exclusionsList: pkg.exclusions,
        accommodationList: pkg.accommodation,
        mealsList: pkg.meals,
        tourManagerList: pkg.tourManager,
        dayDescriptions: dayDescriptions,
        existingDayImageUrls: existingDayImages,
        status: ImagePickerStatus.success, // To indicate data is loaded
      ),
    );
  }

  void _onRemoveExistingPackageImage(
    RemoveExistingPackageImage event,
    Emitter<AddPackageState> emit,
  ) {
    final updatedUrls = List<String>.from(state.existingImageUrls);
    updatedUrls.remove(event.imageUrl);
    final imagesToDelete = List<String>.from(state.imagesToDelete);
    // imagesToDelete.add(event.imageUrl); // Optional: if we want to delete from Cloudinary
    emit(
      state.copyWith(
        existingImageUrls: updatedUrls,
        imagesToDelete: imagesToDelete,
      ),
    );
  }

  void _onRemoveExistingDayImage(
    RemoveExistingDayImage event,
    Emitter<AddPackageState> emit,
  ) {
    if (state.existingDayImageUrls.containsKey(event.day)) {
      final updatedUrls = List<String>.from(
        state.existingDayImageUrls[event.day]!,
      );
      updatedUrls.remove(event.imageUrl);
      final updatedMap = Map<int, List<String>>.from(
        state.existingDayImageUrls,
      );
      updatedMap[event.day] = updatedUrls;
      emit(state.copyWith(existingDayImageUrls: updatedMap));
    }
  }

  void _onPackageNameChanged(
    PackageNameChanged event,
    Emitter<AddPackageState> emit,
  ) {
    emit(
      state.copyWith(packageName: event.packageName, packageNameError: null),
    );
  }

  void _onCategoryNameChanged(
    CategoryNameChanged event,
    Emitter<AddPackageState> emit,
  ) {
    emit(state.copyWith(categoryName: event.categoryName));
  }

  void _onPriceChanged(PriceChanged event, Emitter<AddPackageState> emit) {
    emit(state.copyWith(price: event.price, priceError: null));
  }

  void _onNumberOfDaysChanged(
    NumberOfDaysChanged event,
    Emitter<AddPackageState> emit,
  ) {
    emit(
      state.copyWith(numberOfDays: event.numberOfDays, numberOfDaysError: null),
    );
  }

  void _onHighlightsChanged(
    HighlightsChanged event,
    Emitter<AddPackageState> emit,
  ) {
    emit(state.copyWith(highlights: event.highlights, highlightsError: null));
  }

  void _onValidateForm(ValidateForm event, Emitter<AddPackageState> emit) {
    final packageNameError =
        state.packageName.trim().isEmpty ? 'Please enter package name' : null;
    final numberOfDaysError =
        state.numberOfDays.isEmpty ? 'Please select number of days' : null;
    final priceError =
        state.price.isEmpty
            ? 'Please enter price'
            : (double.tryParse(state.price) == null
                ? 'Please enter a valid price'
                : null);

    final highlightsError =
        state.highlights.trim().isEmpty ? 'Please enter highlights' : null;
    final imageError =
        (state.images.isEmpty && state.existingImageUrls.isEmpty)
            ? 'Please select at least one package image'
            : null;
    final inclusionsError =
        state.inclusionsList.isEmpty
            ? 'Please add at least one inclusion'
            : null;
    final accommodationError =
        state.accommodationList.isEmpty
            ? 'Please add at least one accommodation'
            : null;
    final mealsError =
        state.mealsList.isEmpty ? 'Please add at least one meal' : null;
    final exclusionsError =
        state.exclusionsList.isEmpty
            ? 'Please add at least one exclusion'
            : null;

    final Map<int, String> itineraryLocationErrors = {};
    final Map<int, String> itineraryImageErrors = {};

    if (state.numberOfDays.isNotEmpty) {
      final days = int.tryParse(state.numberOfDays.split('D').first) ?? 0;
      for (int i = 1; i <= days; i++) {
        if (state.dayDescriptions[i]?.trim().isEmpty ?? true) {
          itineraryLocationErrors[i] = 'Please enter location for Day $i';
        }
        // Check for images: either existing or new images must be present
        final hasExisting =
            (state.existingDayImageUrls[i]?.isNotEmpty ?? false);
        final hasNew = (state.dayImages[i]?.isNotEmpty ?? false);

        if (!hasExisting && !hasNew) {
          itineraryImageErrors[i] = 'Please select images for Day $i';
        }
      }
    }

    emit(
      state.copyWith(
        packageNameError: packageNameError,
        priceError: priceError,
        numberOfDaysError: numberOfDaysError,
        highlightsError: highlightsError,
        imageError: imageError,
        inclusionsError: inclusionsError,
        accommodationError: accommodationError,
        mealsError: mealsError,
        exclusionsError: exclusionsError,
        itineraryLocationErrors: itineraryLocationErrors,
        itineraryImageErrors: itineraryImageErrors,
      ),
    );
  }

  void _onAddSectionItem(AddSectionItem event, Emitter<AddPackageState> emit) {
    List<String> currentList;
    switch (event.section) {
      case SectionType.accommodation:
        currentList = List.from(state.accommodationList);
        currentList.add(event.item);
        emit(
          state.copyWith(
            accommodationList: currentList,
            accommodationError: null,
          ),
        );
        break;
      case SectionType.meals:
        currentList = List.from(state.mealsList);
        currentList.add(event.item);
        emit(state.copyWith(mealsList: currentList, mealsError: null));
        break;
      case SectionType.inclusions:
        currentList = List.from(state.inclusionsList);
        currentList.add(event.item);
        emit(
          state.copyWith(inclusionsList: currentList, inclusionsError: null),
        );
        break;
      case SectionType.exclusions:
        currentList = List.from(state.exclusionsList);
        currentList.add(event.item);
        emit(
          state.copyWith(exclusionsList: currentList, exclusionsError: null),
        );
        break;
      case SectionType.tourManager:
        currentList = List.from(state.tourManagerList);
        currentList.add(event.item);
        emit(
          state.copyWith(tourManagerList: currentList, tourManagerError: null),
        );
        break;
    }
  }

  void _onRemoveSectionItem(
    RemoveSectionItem event,
    Emitter<AddPackageState> emit,
  ) {
    List<String> currentList;
    switch (event.section) {
      case SectionType.accommodation:
        currentList = List.from(state.accommodationList);
        if (event.index >= 0 && event.index < currentList.length) {
          currentList.removeAt(event.index);
          emit(state.copyWith(accommodationList: currentList));
        }
        break;
      case SectionType.meals:
        currentList = List.from(state.mealsList);
        if (event.index >= 0 && event.index < currentList.length) {
          currentList.removeAt(event.index);
          emit(state.copyWith(mealsList: currentList));
        }
        break;
      case SectionType.inclusions:
        currentList = List.from(state.inclusionsList);
        if (event.index >= 0 && event.index < currentList.length) {
          currentList.removeAt(event.index);
          emit(state.copyWith(inclusionsList: currentList));
        }
        break;
      case SectionType.exclusions:
        currentList = List.from(state.exclusionsList);
        if (event.index >= 0 && event.index < currentList.length) {
          currentList.removeAt(event.index);
          emit(state.copyWith(exclusionsList: currentList));
        }
        break;
      case SectionType.tourManager:
        currentList = List.from(state.tourManagerList);
        if (event.index >= 0 && event.index < currentList.length) {
          currentList.removeAt(event.index);
          emit(state.copyWith(tourManagerList: currentList));
        }
        break;
    }
  }

  void _onUpdateSectionItem(
    UpdateSectionItem event,
    Emitter<AddPackageState> emit,
  ) {
    List<String> currentList;
    switch (event.section) {
      case SectionType.accommodation:
        currentList = List.from(state.accommodationList);
        if (event.index >= 0 && event.index < currentList.length) {
          currentList[event.index] = event.item;
          emit(state.copyWith(accommodationList: currentList));
        }
        break;
      case SectionType.meals:
        currentList = List.from(state.mealsList);
        if (event.index >= 0 && event.index < currentList.length) {
          currentList[event.index] = event.item;
          emit(state.copyWith(mealsList: currentList));
        }
        break;
      case SectionType.inclusions:
        currentList = List.from(state.inclusionsList);
        if (event.index >= 0 && event.index < currentList.length) {
          currentList[event.index] = event.item;
          emit(state.copyWith(inclusionsList: currentList));
        }
        break;
      case SectionType.exclusions:
        currentList = List.from(state.exclusionsList);
        if (event.index >= 0 && event.index < currentList.length) {
          currentList[event.index] = event.item;
          emit(state.copyWith(exclusionsList: currentList));
        }
        break;
      case SectionType.tourManager:
        currentList = List.from(state.tourManagerList);
        if (event.index >= 0 && event.index < currentList.length) {
          currentList[event.index] = event.item;
          emit(state.copyWith(tourManagerList: currentList));
        }
        break;
    }
  }

  void _onRemoveDayImage(RemoveDayImage event, Emitter<AddPackageState> emit) {
    if (state.dayImages.containsKey(event.day)) {
      final List<XFile> updatedImages = List.from(state.dayImages[event.day]!);
      if (event.imageIndex >= 0 && event.imageIndex < updatedImages.length) {
        updatedImages.removeAt(event.imageIndex);
        final Map<int, List<XFile>> updatedDayImages = Map.from(
          state.dayImages,
        );
        updatedDayImages[event.day] = updatedImages;
        emit(state.copyWith(dayImages: updatedDayImages));
      }
    }
  }

  void _onUpdateDayDescription(
    UpdateDayDescription event,
    Emitter<AddPackageState> emit,
  ) {
    final Map<int, String> updatedDescriptions = Map.from(
      state.dayDescriptions,
    );
    updatedDescriptions[event.day] = event.description;
    final Map<int, String> updatedErrors = Map.from(
      state.itineraryLocationErrors,
    );
    updatedErrors.remove(event.day);
    emit(
      state.copyWith(
        dayDescriptions: updatedDescriptions,
        itineraryLocationErrors: updatedErrors,
      ),
    );
  }

  void _onSelectItineraryDay(
    SelectItineraryDay event,
    Emitter<AddPackageState> emit,
  ) {
    emit(state.copyWith(selectedDay: event.day));
  }

  Future<void> _onPickDayImage(
    PickDayImage event,
    Emitter<AddPackageState> emit,
  ) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        final Map<int, List<XFile>> updatedDayImages = Map.from(
          state.dayImages,
        );
        final List<XFile> currentImages =
            updatedDayImages[event.day] != null
                ? List.from(updatedDayImages[event.day]!)
                : [];
        currentImages.addAll(pickedFiles);
        updatedDayImages[event.day] = currentImages;
        final Map<int, String> updatedErrors = Map.from(
          state.itineraryImageErrors,
        );
        updatedErrors.remove(event.day);
        emit(
          state.copyWith(
            dayImages: updatedDayImages,
            itineraryImageErrors: updatedErrors,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onToggleInclusion(
    ToggleInclusion event,
    Emitter<AddPackageState> emit,
  ) {
    final List<String> updatedInclusions = List.from(state.selectedInclusions);
    if (updatedInclusions.contains(event.inclusion)) {
      updatedInclusions.remove(event.inclusion);
    } else {
      updatedInclusions.add(event.inclusion);
    }
    emit(
      state.copyWith(
        selectedInclusions: updatedInclusions,
        inclusionsError: null,
      ),
    );
  }

  Future<void> _onPickPackageImages(
    PickPackageImages event,
    Emitter<AddPackageState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ImagePickerStatus.picking));
      final List<XFile> pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        final List<XFile> updatedImages = List.from(state.images)
          ..addAll(pickedFiles);
        emit(
          state.copyWith(
            images: updatedImages,
            status: ImagePickerStatus.success,
            imageError: null,
          ),
        );
      } else {
        emit(state.copyWith(status: ImagePickerStatus.initial));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ImagePickerStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onRemovePackageImage(
    RemovePackageImage event,
    Emitter<AddPackageState> emit,
  ) {
    final List<XFile> updatedImages = List.from(state.images);
    if (event.index >= 0 && event.index < updatedImages.length) {
      updatedImages.removeAt(event.index);
      emit(state.copyWith(images: updatedImages));
    }
  }

  void _onTourTypeChanged(
    TourTypeChanged event,
    Emitter<AddPackageState> emit,
  ) {
    emit(state.copyWith(tourType: event.tourType));
  }

  Future<List<String>> _uploadNewImages(
    List<XFile> images,
    String folder,
  ) async {
    final uploadFutures = images.map(
      (image) =>
          _cloudinaryService.uploadImage(imagePath: image.path, folder: folder),
    );
    return Future.wait(uploadFutures);
  }

  Future<void> _onSubmitPackage(
    SubmitPackage event,
    Emitter<AddPackageState> emit,
  ) async {
    // 1. Validate Form
    add(ValidateForm());

    // Quick blocking validation check
    if (state.packageName.trim().isEmpty ||
        (state.images.isEmpty && state.existingImageUrls.isEmpty) ||
        state.price.trim().isEmpty ||
        state.numberOfDays.isEmpty) {
      // Double check critical fields
      bool isValid = true;
      if (state.packageName.trim().isEmpty) isValid = false;
      if (state.images.isEmpty && state.existingImageUrls.isEmpty)
        isValid = false;

      if (!isValid) {
        emit(state.copyWith(errorMessage: "Please fix validation errors"));
        return;
      }
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      // 2. Upload Main Package Images (Parallel)
      final List<String> packageImageUrls = List.from(state.existingImageUrls);
      final newPackageUrls = await _uploadNewImages(
        state.images,
        'packages/${state.tourType}',
      );
      packageImageUrls.addAll(newPackageUrls);

      // 3. Upload Itinerary Day Images (Parallel)
      final Map<String, List<String>> dayImageUrls = {};

      // Initialize with existing day images
      state.dayDescriptions.keys.forEach((dayIndex) {
        if (state.existingDayImageUrls.containsKey(dayIndex)) {
          dayImageUrls[dayIndex.toString()] = List.from(
            state.existingDayImageUrls[dayIndex]!,
          );
        } else {
          dayImageUrls[dayIndex.toString()] = [];
        }
      });

      // Prepare parallel uploads for all days
      final dayUploadFutures = state.dayImages.entries.map((entry) async {
        final dayIndex = entry.key;
        final images = entry.value;
        final folder = 'packages/${state.tourType}/day_$dayIndex';
        final urls = await _uploadNewImages(images, folder);
        return MapEntry(dayIndex.toString(), urls);
      });

      // Execute all day uploads
      final newDayImageResults = await Future.wait(dayUploadFutures);

      // Merge results
      for (final result in newDayImageResults) {
        if (!dayImageUrls.containsKey(result.key)) {
          dayImageUrls[result.key] = [];
        }
        dayImageUrls[result.key]!.addAll(result.value);
      }

      // 4. Construct Data Object for Firestore
      final packageData = {
        'packageName': state.packageName,
        'categoryName': state.categoryName,
        'type': state.tourType,
        'price': double.tryParse(state.price) ?? 0.0,
        'duration': state.numberOfDays,
        'highlights': state.highlights,
        'images': packageImageUrls,
        'inclusions': state.inclusionsList,
        'standardInclusions': state.selectedInclusions,
        'exclusions': state.exclusionsList,
        'accommodation': state.accommodationList,
        'meals': state.mealsList,
        'tourManager': state.tourManagerList,
        'itinerary': state.dayDescriptions.map(
          (key, value) => MapEntry(key.toString(), {
            'description': value,
            'images': dayImageUrls[key.toString()] ?? [],
          }),
        ),
        'createdAt': DateTime.now().toIso8601String(),
      };

      print(
        'Ready to save/update to Firestore (${state.tourType}): $packageData',
      );

      if (state.packageId != null) {
        await _packageRepository.updatePackage(
          id: state.packageId!,
          packageData: packageData,
        );
      } else {
        await _packageRepository.addPackage(packageData);
      }

      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to upload/update package: $e',
        ),
      );
    }
  }
}
