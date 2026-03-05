import 'package:screen_protector/screen_protector.dart';
import '../../utils/colors.dart';

class ProtectScreenController {
  static void protectDataLeakageOn() async {
    await ScreenProtector.preventScreenshotOn();
    await ScreenProtector.protectDataLeakageOn();
    await ScreenProtector.protectDataLeakageWithBlur();
    // await ScreenProtector.protectDataLeakageWithImage('LaunchImage');
    await ScreenProtector.protectDataLeakageWithColor(AppColors.whiteColor);
  }
}
