import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/routes/app_pages.dart';

const MaterialColor myCustomColor = MaterialColor(
  0xFFF8F8F8,
  <int, Color>{
    50: Color(0xFFFDFDFD),
    100: Color(0xFFF2F2F2),
    200: Color(0xFFEBEBEB),
    300: Color(0xFFE4E4E4),
    400: Color(0xFFDCDCDC),
    500: Color(0xFFF8F8F8),
    600: Color(0xFFCACACA),
    700: Color(0xFFBABABA),
    800: Color(0xFFA8A8A8),
    900: Color(0xFF969696),
  },
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  String supabaseBaseUrl = dotenv.env['SUPABASE_BASE_URL'] ?? '';
  String supabaseBaseKey = dotenv.env['SUPABASE_BASE_KEY'] ?? '';
  await Supabase.initialize(url: supabaseBaseUrl, anonKey: supabaseBaseKey);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: myCustomColor,
        focusColor: AppColors.textcolor,
        // textTheme: GoogleFonts.openSansTextTheme(),
        // colorScheme: ColorScheme.fromSeed(
        //   seedColor: AppColors.textcolor,
        //   brightness: Brightness.light,
        // ),
        //  scaffoldBackgroundColor: myCustomColor,
        //   fontFamily: "Open Sans",
        //GoogleFonts.openSans().fontFamily,
      ),
      title: "PrajaLok",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
