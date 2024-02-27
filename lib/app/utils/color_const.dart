import 'package:flutter/material.dart';

class AppColors {
  static const disableColor = Color(0xFFCFCFCF);
  static const textcolor = Color(0xFFFF5C40);
  static const linearGradient =
      LinearGradient(colors: <Color>[Color(0xFFF12711), Color(0xFFF5AF19)], begin: Alignment.centerLeft, end: Alignment.centerRight);
  static final greenColor = const Color(0xFF1D976C);
  static final invalidColor = Color(0xFFEF1E26);
  static const disablelinearGradient =
      LinearGradient(colors: <Color>[Color(0xFF808080), Color(0xFFCFCFCF)], begin: Alignment.centerLeft, end: Alignment.centerRight);
  static const blacktxtColor = Color(0xFF404040);
  static const blacktxtColor2 = Color(0xFF505050);
  static const greenHalf = Color(0xFFDBEEE7);
  static const hlfgrey = Color(0xFFF8F8F8);
  static const chatSendTextCollor = Color(0xFFFFEDEA);
  static const chatRecivedTextCollor = Color(0xFF2C2C2C);
  static const closeIconColor = Color(0xFF8F8F8F);
  static const searchLawAppBarColors = Color(0xFFDFDFDF);
  static const stausYellowHalfColor = Color(0xFFFDF0DF);
  static const hintColor = Color(0xFFBFBFBF);
  static const grey44 = Color(0xFF707070);
  static const lightShadegrey = Color(0xFFf6f6f6);

  static final gradientOppcityColor = LinearGradient(
    colors: <Color>[const Color(0xFFF5AF19).withOpacity(0.1), const Color(0xFFF12711).withOpacity(0.1)],
    begin: const Alignment(1.00, 0.00),
    end: const Alignment(-1, 0),
  );
}
