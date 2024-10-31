import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // 회원가입 및 이메일 인증 전송
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        await userCredential.user?.sendEmailVerification();

        // Firestore에 사용자 저장
        await _firestore.collection('users').doc(event.email).set({
          'email': event.email,
          'nickname': event.nickname,
          'phone': event.phone,
          'gender': event.gender,
        });

        emit(SignUpSuccess());
      } on FirebaseAuthException catch (e) {
        emit(AuthFailure(e.message ?? '회원가입에 실패했습니다.'));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential userCredential =
            await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        if (userCredential.user?.emailVerified ?? false) {
          // 로그인 성공 시 사용자 ID 포함하여 상태 발행
          emit(LoginSuccess(userId: userCredential.user!.uid));
        } else {
          emit(AuthFailure('이메일 인증을 완료해주세요.'));
          await _firebaseAuth.signOut();
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthFailure(e.message ?? '로그인에 실패했습니다.'));
      }
    });
  }
}
