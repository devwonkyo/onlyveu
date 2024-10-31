import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlyveyou/blocs/home/home_bloc.dart';
import 'package:onlyveyou/blocs/mypage/profile_edit/profile_edit_bloc.dart';
import 'package:onlyveyou/blocs/search/tag_search/tag_search_cubit.dart';
import 'package:onlyveyou/cubit/category/category_cubit.dart';

import 'blocs/history/history_bloc.dart';
import 'blocs/search/filtered_tags/filtered_tags_cubit.dart';
import 'blocs/search/tag_list/tag_list_cubit.dart';
import 'core/router.dart';
import 'firebase_options.dart';

void main() async {
  // Flutter 바인딩 초기화 (반드시 필요)
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(),
            ),
            BlocProvider<HistoryBloc>(
              create: (context) => HistoryBloc(
                  // FirebaseFirestore.instance, // Firebase를 사용하는 경우
                  ),
            ),
            BlocProvider(
              create: (context) => ProfileEditBloc(),
            ),
            BlocProvider<CategoryCubit>(
              create: (context) => CategoryCubit()..loadCategories(),
            ),
            BlocProvider<TagSearchCubit>(
              create: (context) => TagSearchCubit(),
            ),
            BlocProvider<TagListCubit>(
              create: (context) => TagListCubit(),
            ),
            BlocProvider<FilteredTagsCubit>(
              create: (context) => FilteredTagsCubit(
                initialTags: context.read<TagListCubit>().state.tags,
                tagSearchCubit: context.read<TagSearchCubit>(),
              ),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                fontFamily: 'Pretendard'),
            routerConfig: router,
          ),
        );
      },
    );
  }
}
