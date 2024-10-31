part of 'filtered_tags_cubit.dart';

class FilteredTagsState extends Equatable {
  final List<Tag> filteredTags;
  const FilteredTagsState({
    required this.filteredTags,
  });

  factory FilteredTagsState.initial() {
    return const FilteredTagsState(filteredTags: []);
  }

  @override
  List<Object> get props => [filteredTags];

  @override
  String toString() => 'FilteredTagsState(filteredTags: $filteredTags)';

  FilteredTagsState copyWith({
    List<Tag>? filteredTags,
  }) {
    return FilteredTagsState(
      filteredTags: filteredTags ?? this.filteredTags,
    );
  }
}