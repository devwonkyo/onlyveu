import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'search_textfield_event.dart';
part 'search_textfield_state.dart';

class SearchTextFieldBloc
    extends Bloc<SearchTextFieldEvent, SearchTextFieldState> {
  SearchTextFieldBloc() : super(SearchTextFieldEmpty()) {
    on<TextChanged>((event, emit) {
      if (event.text.isEmpty) {
        return emit(SearchTextFieldEmpty());
      } else {
        return emit(SearchTextFieldTyping(event.text));
      }
    });

    on<TextSubmitted>((event, emit) {
      return emit(SearchTextFieldSubmitted(event.text));
    });

    on<TextDeleted>((event, emit) {
      return emit(SearchTextFieldEmpty());
    });
  }

  @override
  void onChange(Change<SearchTextFieldState> change) {
    super.onChange(change);
    print(
        'Current state: ${change.currentState}, Next state: ${change.nextState}');
  }

  @override
  Future<void> close() {
    debugPrint('SearchTextFieldBloc disposed');
    return super.close();
  }
}
