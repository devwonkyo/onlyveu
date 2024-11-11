import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlyveyou/repositories/product_repository.dart';
import 'package:onlyveyou/repositories/search_repositories/recent_search_repository/recent_search_repository_impl.dart';
import 'package:onlyveyou/repositories/search_repositories/suggestion_repository/suggestion_repository_impl.dart';
import 'package:onlyveyou/screens/search/search_home/recent_search/bloc/recent_search_bloc.dart';
import 'package:onlyveyou/screens/search/search_result/search_result_screen.dart';

import 'search_home/search_home_screen.dart';
import 'search_result/bloc/search_result_bloc.dart';
import 'search_suggestion/bloc/search_suggestion_bloc.dart';
import 'search_suggestion/search_suggestion_screen.dart';
import 'search_text_field/bloc/search_text_field_bloc.dart';
import 'search_text_field/search_text_field.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('==========$runtimeType==========');
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchTextFieldBloc>(
          create: (context) => SearchTextFieldBloc(),
        ),
        BlocProvider<RecentSearchBloc>(
          create: (context) => RecentSearchBloc(
            repository: RecentSearchRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => SearchSuggestionBloc(
            suggestionRepository: SuggestionRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => SearchResultBloc(
            productRepository: ProductRepository(),
          ),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: 50.h,
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined,
                    color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!, width: 1.w),
                  ),
                ),
                child: const SearchTextField(),
              ),
              Expanded(
                child: BlocListener<SearchTextFieldBloc, SearchTextFieldState>(
                  listener: (context, state) {
                    if (state is SearchTextFieldTyping) {
                      context
                          .read<SearchSuggestionBloc>()
                          .add(FetchSearchSuggestions(state.text));
                    } else if (state is SearchTextFieldSubmitted) {
                      context
                          .read<SearchResultBloc>()
                          .add(FetchSearchResults(state.text));
                    }
                  },
                  child: BlocBuilder<SearchTextFieldBloc, SearchTextFieldState>(
                    builder: (context, state) {
                      print('$state');
                      if (state is SearchTextFieldEmpty) {
                        return const SearchHomeScreen();
                      } else if (state is SearchTextFieldTyping) {
                        return const SearchSuggestionScreen();
                      } else if (state is SearchTextFieldSubmitted) {
                        return const SearchResultScreen();
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
