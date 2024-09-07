import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';
import 'package:recipes_with_gen_ai/core/utils/device_info.dart';
import 'package:recipes_with_gen_ai/core/widgets/adaptive_router.dart';
import 'package:recipes_with_gen_ai/features/prompt/logic/prompt_cubit.dart';

late CameraDescription camera;
late BaseDeviceInfo deviceInfo;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  deviceInfo = await DeviceInfo.initialize(DeviceInfoPlugin());
  if (DeviceInfo.isPhysicalDeviceWithCamera(deviceInfo)) {
    final cameras = await availableCameras();
    camera = cameras.first;
  }
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GenerativeModel geminiModel;

  @override
  void initState() {
    const apiKey =
        String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'key not found');
    if (apiKey == 'key not found') {
      throw InvalidApiKey(
        'Key not found in environment. Please add an API key.',
      );
    }

    geminiModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        topK: 32,
        topP: 1,
        maxOutputTokens: 4096,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PromptCubit>(
      create: (context) => PromptCubit(
        model: geminiModel,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        scrollBehavior: const ScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
          },
        ),
        home: const AdaptiveRouter(),
      ),
    );
  }
}
