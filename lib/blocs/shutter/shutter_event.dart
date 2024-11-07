import 'package:equatable/equatable.dart';

abstract class ShutterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TagSelected extends ShutterEvent {
  final String tag;

  TagSelected(this.tag);

  @override
  List<Object> get props => [tag];
}