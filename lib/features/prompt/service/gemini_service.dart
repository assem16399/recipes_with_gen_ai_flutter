import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:recipes_with_gen_ai/features/prompt/models/prompt_model.dart';

class GeminiService {
  static Future<GenerateContentResponse> generateContent(
    GenerativeModel model,
    PromptModel prompt,
  ) async {
    if (prompt.images.isEmpty) {
      return GeminiService.generateContentFromText(model, prompt);
    } else {
      return GeminiService.generateContentFromMultiModal(model, prompt);
    }
  }

  static Future<GenerateContentResponse> generateContentFromMultiModal(
    GenerativeModel model,
    PromptModel prompt,
  ) async {
    final mainText = TextPart(prompt.textInput);
    final additionalTextParts = prompt.additionalTextInputs.map(TextPart.new);
    final imagesParts = <DataPart>[];

    for (final f in prompt.images) {
      final bytes = await f.readAsBytes();
      imagesParts.add(DataPart('image/jpeg', bytes));
    }

    final input = [
      Content.multi([...imagesParts, mainText, ...additionalTextParts]),
    ];

    return model.generateContent(input);
  }

  static Future<GenerateContentResponse> generateContentFromText(
    GenerativeModel model,
    PromptModel prompt,
  ) async {
    final mainText = TextPart(prompt.textInput);
    final additionalTextParts =
        prompt.additionalTextInputs.map(TextPart.new).join('\n');

    return model.generateContent([
      Content.text(
        '${mainText.text} \n $additionalTextParts',
      ),
    ]);
  }
}
