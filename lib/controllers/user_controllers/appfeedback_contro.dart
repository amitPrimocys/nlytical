import 'package:get/get.dart';

class AppfeedbackContro extends GetxController {
  // Make sliderValue reactive
  var sliderValue = 3.0.obs; // Start with the middle emoji

  // Emojis and their labels remain unchanged
  final List<String> emojis = ['😞', '😟', '🙂', '😎', '😍'];
  final List<String> emojiLabels = ['Bad', 'Sad', 'Okay', 'Nice', 'Love'];
}
