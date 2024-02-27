import 'package:get/get.dart';

import '../modules/analysis/bindings/analysis_binding.dart';
import '../modules/analysis/views/analysis_view.dart';
import '../modules/chats/bindings/chats_binding.dart';
import '../modules/chats/views/chats_view.dart';
import '../modules/contract_Analysis/bindings/contract_analysis_binding.dart';
import '../modules/contract_Analysis/views/contract_analysis_view.dart';
import '../modules/document_analyser/bindings/document_analysis_binding.dart';
import '../modules/document_analyser/views/document_analysis_view.dart';
import '../modules/document_chat/bindings/document_chat_binding.dart';
import '../modules/document_chat/views/document_chat_view.dart';
import '../modules/document_transalator/bindings/document_transalator_binding.dart';
import '../modules/document_transalator/views/document_transalator_view.dart';
import '../modules/document_writer/bindings/document_write_binding.dart';
import '../modules/document_writer/views/document_write_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/legalIssueSpotter/bindings/legal_issue_spotter_binding.dart';
import '../modules/legalIssueSpotter/views/legal_issue_spotter_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/searchlaw/bindings/searchlaw_binding.dart';
import '../modules/searchlaw/views/searchlaw_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.DOCUMENT_ANALYSIS,
      page: () => DocumentAnalysisView(),
      binding: DocumentAnalysisBinding(),
    ),
    GetPage(
      name: _Paths.DOCUMENT_WRITE,
      page: () => DocumentWriteView(),
      binding: DocumentWriteBinding(),
    ),
    GetPage(
      name: _Paths.CHATS,
      page: () => const ChatsView(),
      binding: ChatsBinding(),
    ),
    GetPage(
      name: _Paths.SEARCHLAW,
      page: () => SearchlawView(),
      binding: SearchlawBinding(),
    ),
    GetPage(
      name: _Paths.DOCUMENT_CHAT,
      page: () => DocumentChatView(),
      binding: DocumentChatBinding(),
    ),
    GetPage(
      name: _Paths.DOCUMENT_TRANSALATOR,
      page: () => DocumentTransalatorView(),
      binding: DocumentTransalatorBinding(),
    ),
    GetPage(
      name: _Paths.ANALYSIS,
      page: () => AnalysisView(),
      binding: AnalysisBinding(),
    ),
    GetPage(
      name: _Paths.CONTRACT_ANALYSIS,
      page: () => ContractAnalysisView(),
      binding: ContractAnalysisBinding(),
    ),
    GetPage(
      name: _Paths.LEGAL_ISSUE_SPOTTER,
      page: () => LegalIssueSpotterView(),
      binding: LegalIssueSpotterBinding(),
    ),
  ];
}
