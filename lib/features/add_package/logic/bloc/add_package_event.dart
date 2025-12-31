import 'package:equatable/equatable.dart';
import 'package:elysian_admin/features/add_package/data/models/package_model.dart';

abstract class AddPackageEvent extends Equatable {
  const AddPackageEvent();

  @override
  List<Object> get props => [];
}

class PickPackageImages extends AddPackageEvent {}

class RemovePackageImage extends AddPackageEvent {
  final int index;

  const RemovePackageImage(this.index);

  @override
  List<Object> get props => [index];
}

class ToggleInclusion extends AddPackageEvent {
  final String inclusion;

  const ToggleInclusion(this.inclusion);

  @override
  List<Object> get props => [inclusion];
}

class SelectItineraryDay extends AddPackageEvent {
  final int day;

  const SelectItineraryDay(this.day);

  @override
  List<Object> get props => [day];
}

class PickDayImage extends AddPackageEvent {
  final int day;

  const PickDayImage(this.day);

  @override
  List<Object> get props => [day];
}

class UpdateDayDescription extends AddPackageEvent {
  final int day;
  final String description;

  const UpdateDayDescription({required this.day, required this.description});

  @override
  List<Object> get props => [day, description];
}

class RemoveDayImage extends AddPackageEvent {
  final int day;
  final int imageIndex;

  const RemoveDayImage({required this.day, required this.imageIndex});

  @override
  List<Object> get props => [day, imageIndex];
}

enum SectionType { accommodation, meals, tourManager, inclusions, exclusions }

class AddSectionItem extends AddPackageEvent {
  final SectionType section;
  final String item;

  const AddSectionItem({required this.section, required this.item});

  @override
  List<Object> get props => [section, item];
}

class RemoveSectionItem extends AddPackageEvent {
  final SectionType section;
  final int index;

  const RemoveSectionItem({required this.section, required this.index});

  @override
  List<Object> get props => [section, index];
}

class UpdateSectionItem extends AddPackageEvent {
  final SectionType section;
  final int index;
  final String item;

  const UpdateSectionItem({
    required this.section,
    required this.index,
    required this.item,
  });

  @override
  List<Object> get props => [section, index, item];
}

class PackageNameChanged extends AddPackageEvent {
  final String packageName;
  const PackageNameChanged(this.packageName);
  @override
  List<Object> get props => [packageName];
}

class CategoryNameChanged extends AddPackageEvent {
  final String categoryName;
  const CategoryNameChanged(this.categoryName);
  @override
  List<Object> get props => [categoryName];
}

class PriceChanged extends AddPackageEvent {
  final String price;
  const PriceChanged(this.price);
  @override
  List<Object> get props => [price];
}

class NumberOfDaysChanged extends AddPackageEvent {
  final String numberOfDays;
  const NumberOfDaysChanged(this.numberOfDays);
  @override
  List<Object> get props => [numberOfDays];
}

class HighlightsChanged extends AddPackageEvent {
  final String highlights;
  const HighlightsChanged(this.highlights);
  @override
  List<Object> get props => [highlights];
}

class ValidateForm extends AddPackageEvent {}

class TourTypeChanged extends AddPackageEvent {
  final String tourType;
  const TourTypeChanged(this.tourType);
  @override
  List<Object> get props => [tourType];
}

class SubmitPackage extends AddPackageEvent {}

class InitializeForm extends AddPackageEvent {
  final PackageModel package;
  const InitializeForm({required this.package});
  @override
  List<Object> get props => [package];
}

class RemoveExistingPackageImage extends AddPackageEvent {
  final String imageUrl;
  const RemoveExistingPackageImage(this.imageUrl);
  @override
  List<Object> get props => [imageUrl];
}

class RemoveExistingDayImage extends AddPackageEvent {
  final int day;
  final String imageUrl;
  const RemoveExistingDayImage({required this.day, required this.imageUrl});
  @override
  List<Object> get props => [day, imageUrl];
}
