import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

enum ImagePickerStatus { initial, picking, success, failure }

class AddPackageState extends Equatable {
  final List<XFile> images;
  final ImagePickerStatus status;
  final String? errorMessage;
  final List<String>
  selectedInclusions; // Keeping this if it's used elsewhere, but we might overlap with inclusionsList
  final int selectedDay;
  final Map<int, List<XFile>> dayImages;
  final Map<int, String> dayDescriptions;

  final List<String> accommodationList;
  final List<String> mealsList;
  final List<String> tourManagerList;
  final List<String> inclusionsList;
  final List<String> exclusionsList;

  final String categoryName;
  final String packageName;
  final String price;
  final String numberOfDays;
  final String highlights;
  final String? packageNameError;
  final String? priceError;
  final String? numberOfDaysError;
  final String? highlightsError;
  final String? imageError;
  final String? tourManagerError;
  final String? inclusionsError;
  final String? accommodationError;
  final String? mealsError;
  final String? exclusionsError;
  final Map<int, String> itineraryLocationErrors;
  final Map<int, String> itineraryImageErrors;

  final String tourType;
  final bool isSubmitting;
  final bool isSuccess;

  final String? packageId;
  final List<String> existingImageUrls;
  final Map<int, List<String>> existingDayImageUrls;
  final List<String> imagesToDelete;

  const AddPackageState({
    this.packageId,
    this.existingImageUrls = const [],
    this.existingDayImageUrls = const {},
    this.imagesToDelete = const [],
    this.images = const [],
    this.status = ImagePickerStatus.initial,
    this.errorMessage,
    this.selectedInclusions = const [],
    this.selectedDay = 1,
    this.dayImages = const {},
    this.dayDescriptions = const {},
    this.accommodationList = const [],
    this.mealsList = const [],
    this.tourManagerList = const [],
    this.inclusionsList = const [],
    this.exclusionsList = const [],
    this.packageName = '',
    this.categoryName = '',
    this.price = '',
    this.numberOfDays = '',
    this.highlights = '',
    this.tourType = 'Domestic', // Default or empty
    this.isSubmitting = false,
    this.isSuccess = false,
    this.packageNameError,
    this.priceError,
    this.numberOfDaysError,
    this.highlightsError,
    this.imageError,
    this.tourManagerError,
    this.inclusionsError,
    this.accommodationError,
    this.mealsError,
    this.exclusionsError,
    this.itineraryLocationErrors = const {},
    this.itineraryImageErrors = const {},
  });

  AddPackageState copyWith({
    String? packageId,
    List<String>? existingImageUrls,
    Map<int, List<String>>? existingDayImageUrls,
    List<String>? imagesToDelete,
    List<XFile>? images,
    ImagePickerStatus? status,
    String? errorMessage,
    List<String>? selectedInclusions,
    int? selectedDay,
    Map<int, List<XFile>>? dayImages,
    Map<int, String>? dayDescriptions,
    List<String>? accommodationList,
    List<String>? mealsList,
    List<String>? tourManagerList,
    List<String>? inclusionsList,
    List<String>? exclusionsList,
    String? packageName,
    String? categoryName,
    String? price,
    String? numberOfDays,
    String? highlights,
    String? tourType,
    bool? isSubmitting,
    bool? isSuccess,
    String? packageNameError,
    String? priceError,
    String? numberOfDaysError,
    String? highlightsError,
    String? imageError,
    String? tourManagerError,
    String? inclusionsError,
    String? accommodationError,
    String? mealsError,
    String? exclusionsError,
    Map<int, String>? itineraryLocationErrors,
    Map<int, String>? itineraryImageErrors,
  }) {
    return AddPackageState(
      packageId: packageId ?? this.packageId,
      existingImageUrls: existingImageUrls ?? this.existingImageUrls,
      existingDayImageUrls: existingDayImageUrls ?? this.existingDayImageUrls,
      imagesToDelete: imagesToDelete ?? this.imagesToDelete,
      images: images ?? this.images,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedInclusions: selectedInclusions ?? this.selectedInclusions,
      selectedDay: selectedDay ?? this.selectedDay,
      dayImages: dayImages ?? this.dayImages,
      dayDescriptions: dayDescriptions ?? this.dayDescriptions,
      accommodationList: accommodationList ?? this.accommodationList,
      mealsList: mealsList ?? this.mealsList,
      tourManagerList: tourManagerList ?? this.tourManagerList,
      inclusionsList: inclusionsList ?? this.inclusionsList,
      exclusionsList: exclusionsList ?? this.exclusionsList,
      packageName: packageName ?? this.packageName,
      categoryName: categoryName ?? this.categoryName,
      price: price ?? this.price,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      highlights: highlights ?? this.highlights,
      tourType: tourType ?? this.tourType,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      packageNameError: packageNameError,
      priceError: priceError,
      numberOfDaysError: numberOfDaysError,
      highlightsError: highlightsError,
      imageError: imageError,
      tourManagerError: tourManagerError ?? this.tourManagerError,
      inclusionsError: inclusionsError,
      accommodationError: accommodationError ?? this.accommodationError,
      mealsError: mealsError ?? this.mealsError,
      exclusionsError: exclusionsError ?? this.exclusionsError,
      itineraryLocationErrors:
          itineraryLocationErrors ?? this.itineraryLocationErrors,
      itineraryImageErrors: itineraryImageErrors ?? this.itineraryImageErrors,
    );
  }

  int get totalDays {
    if (numberOfDays.isEmpty) return 0;
    try {
      // Assuming format "X D / Y N" or similar, extracting first number
      final daysPart = numberOfDays.split('D').first.trim();
      return int.parse(daysPart);
    } catch (_) {
      return 0;
    }
  }

  @override
  List<Object?> get props => [
    images,
    status,
    errorMessage,
    selectedInclusions,
    selectedDay,
    dayImages,
    dayDescriptions,
    accommodationList,
    mealsList,
    tourManagerList,
    inclusionsList,
    exclusionsList,
    packageName,
    categoryName,
    price,
    numberOfDays,
    highlights,
    packageNameError,
    priceError,
    numberOfDaysError,
    highlightsError,
    imageError,
    tourManagerError,
    inclusionsError,
    accommodationError,
    mealsError,
    exclusionsError,
    itineraryLocationErrors,
    itineraryImageErrors,
    tourType,
    isSubmitting,
    isSuccess,
    packageId,
    existingImageUrls,
    existingDayImageUrls,
    imagesToDelete,
  ];
}
