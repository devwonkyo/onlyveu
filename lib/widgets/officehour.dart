// import 'package:flutter/cupertino.dart';
//
// 오피스 아워 물어볼것
//
// 1 매장 재고가 있는지 데이터를 업데이트하는걸 관리자측에서 할건지 엘리스측에서 하는건지 파이어베이스에서 직접 실시간으로 데이터를 넣어 줘야하는지
//
// 2.인앱결제 결제 어떻게 할지 키워드 같은거
// 네이버 페이는 가능
//
// 3우리가 정한 기능 우선순위에 대해 어떻게 생각하시는지 여쭤보기(서비스에 대해 자세히 설명 필요)
//
// 4블록과 클린 아키텍쳐를 고려해서 폴더구조를 했는데
// 제대로 된게 맞나요?
//
// ////////////////////////////////////////////////////
// 1
// 화장품 재고에 대한 DB 있어야 한다
// 수량도 표기
//
// 화장품 컬렉션 이외의 컬렉션?
// 재고 확인하고 그쪽에 찾아갈 수 있게
// 매장에 대한 객체를 데이터 베이스에 넣기
// 화장품 종류 여러개
//
// 인벤토리에 컬렉션 하나 더 있어야 한다
// 어느 화장품인지 어느 매장인지 몇개인지
//
// 매장 컬렉션 하나 있어야 하고 도큐먼트 3개라 치고 화장품 2개 있다 치면
//
// 화장품 컬렉션에는 도큐먼트 두개
// 인벤토리 컬렉션에는 총 6개 \
// 매장 이 가 나 다 있다
// 화장 품이 A,B
//
// 가 매장에 A가 2개 있다 B가 1개 있다   -6개가 필요하다
// A누르면 가 매장이 나오도록
//
// //////////////////
// 등록할때 관리자 페이지 필요없다 파이어베이스에 직접 넣으면 된다
// 인벤토리는 가상으로 집어넣기만 하고 보여주는 데이터는 어디 몇개 있다로 할까?OK
//
// 화장품 컬렉셔녿 따로 있나? 있다.
//
// 화장품 자체의 데이터는 어디에? 파이어베이스 콘솔에서 모든 정보를 저장할 수 있다
//
//
// 인트라넷에 등록해야 되지 않나? 그래야 재고 추가 보여줄 수 있으니깐
// 단순 도큐먼트 수정이 아닌 다른 방법 하고 싶음
//
// 회원을 두개로 나눠서 관리자는 매장에 등록
// 한페이지만 더 만들면 가능하다
//
// Q그러면 인벤토리가 필요가 있나?
// 관련없이 무조건 있어야 한다.
//
// 상품 컬렉션에 필드로 가 매장 재고 나 매장 재고 인트값을 준다
// 이러면 재고 개수만 알고 *올리브영이 잘되서 매장 늘어나면 필드값을 수정해야한다
// 필드 구조는 안바꾸는게 좋다
//
// 매장 컬렉션안에 재고도 필드값 계속 고민하게 된다
//
// 그러면 결국 인벤토리 값이 필요하게 된다.
// 인벤토리 값이 없이 되나 해봐라
//
// 그러면 인벤토리가 화장개수 * 매장 개수만큼 생긴다
//
// //////////////////////////////////////////////////
// 2
// 인앱은 절차때문에 일단 빼두기
//
// //////////////////////
// 3
// AI가 어디까지 가능할지 API
//
// 검색은 그냥 가능
// 상품 안에 데이터가 많아야 한다
// 안에 태그가 많이 있어야 한다
//
// 아마존 퍼스널라이즈 쓰면 활용하면 될까?
// 뺴는걸 추천한다.
// 나중에 해도 되는 기능이다
//
// 맞춤형도 간단히 추천은 쉽지만 1000개중에 고르기는 어렵다
// DB가 많이 있어야 한다 태그가 다 있어야 한다.
// 추천 검색어도 일단은 최근 검색어로 하라
//
// AI가 나중에 독립적으로 넣을 수 있다.
//
// 결제도 가상으로 해야 실제로 하지 말고.
//
// 필터 검색어도 데이터베이스가 많아야 하는거 아닐까?
// 태그로 하면 할 수 있다
//
// 재고가 있는 매장에서 주문할때 예약을 일단 해둔다
// 지금은 일률적으로 3시간 뒤로 정해두는게 좋다
//
// ///////////////////////////
// 하단 광고 - 구글 애드몹
// 직접광고 도 가능
// 커뮤니티 오릴브영 셔터-AI 기능 끝나고 나중에
//
// 채널톡 - 자주물어보는 질문? 금방 가능, 채팅도 어렵지는 않다
// 채널톡 APi 는 심사과정이 있다-근데 있는게 이상하다
// ///////////////////
// AI 를 어디에 넣을지
// 화장품 데이터베이스를 넣어야 한다.
// 50개 정도 가상으로 넣을 수 있고 실제 데이터로 넣을 수 있고
// 크롤릴 10페이지
//
// 제품명 가격 특성 카테고리 태그
//
// 협업 필터링
// -유저 정보가 많아야함
// -태그가 많아야 한다
//
// 사람들이 가장 좋아하는건 인기순위다
// 일단 추천 페이지는 인기순위 최신순으로!
//
//
// 좀 더 비슷한 추천으로는
//
// 유저 정보를 넣고 어떤 타입인지 피부가
// 특정 상품을 고르러 갈때마다 GPT로 API가 간다
// *그래서 나는 이런데 너의 답변이 상품으로 나오면 꽤 좋아 보일것!
// 이게 더 만들기 쉬워보인다.
//
// //////////////
// 4
// 모델 레퍼지토리 두개나 되는거
// 보통 동일하게 나온다
//
// 클린아키텍쳐쓴다는거는 집착일뿐
// 뭐가 좋은 코드일까를 고민하다 끝까지 간거,,
//
// 도메인 왜 있어야 하는가..
// 프론트에서 사용할 디비
// 서브코드 바뀔땐 데이터만 바꾸는걸로
//
// 플러터는 결국 MVVM을 많이 쓴다
// MVC 와의 차이는 공부해 보자
//
// 꼭 엄격히 따를 필요는 없다
//
// MVVM과 블록이 비슷한데
// 클린은 가볍게, 블록을 쓰는게 좋을까?
// 블록을 써보자!
//
// //////////////////////
// 5
// 테스트 중심 TDD 방식 어떻게 시작할 것인가?
// 하면 좋은데 약간 욕심이다...
// 지금 TDD 하기 어렵다 경험이 있어야 되는거고
// 프론트 쪽은 UI쪽 테스팅 코드 테스팅등등
// 혼란스러울 수 있다
//
// TDD제끼고 한 파일에서 테스트 하나는 하자!
// 이걸 목표로 하기
//
// TDD하려면 머리속에 다 있어야 한다
// 아주 쬐끔 해보자 테스트 코드 짜보기 그정도 느낌으로
//
// ////
// 해줄말
// 지피티 여기서 요구
// 디비 구조를 결정하면 그 후엔 쉽다
//
// /////////////////////////////////////////////////////////
// 끝!!!
//
//
//
//
//
//
//
////////////////////////////////////////////////////
// 카테고리 별로 10개씩 올리브영에서 만들어두기 100개정도
// 뒤에 백 연결 잘하면 될것..
// 배너 팁? 긴 이미지 어떻게 얻어오지?
// 이미지 저장해서 가져오는 수밖에...
// 붙여서 하는 방법밖에 없음
// 블록을 화면당 하나씩 하기는 한다.
// 탭 별로 해도 좋다
// 추천 상품, 인기상품
// 블록을 위젯별로 쓰는건 어떤지?
// 그러면 추천상품 불러오는것과 인기상품 블록 을  따로 불러내기....
// A와 B리스트를 불러낼때 상태는 한개니깐
// 스테이트를 나누니깐 가능할듯.
/////////////
// api키 같은게 민감한 부분 하드코딩으로 관리안함
// env 파일이라는 환경설정 이라는 파일 만들어 관리하는데
// 그게 일반적인지 = API키 관련한 부분
//
// API 관련해서 =
// api키가 왜 중요하지?
// 무료인것도 있는데 쓰다보면 유료로 될 수 있다.
// 앱이랑 카카오에서 쓸수 있게 해주는 인증같은거
//
// 민감한 부분이라서 공개적인 장소에 올라가면 안된다.
///////////////////
// 머지하는 과정?
//
// 제 로컬에서 피처 마이페이지에서 푸쉬한번하기
// 디벨롭 브랜치가서 풀 하고 자기 브랜치랑 로컬에서 머지하고 에드커밋 후에 푸쉬
