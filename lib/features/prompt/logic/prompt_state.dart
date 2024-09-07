part of 'prompt_cubit.dart';

sealed class PromptState {
  PromptState({required this.promptModel});
  final PromptModel promptModel;
}

final class PromptInitial extends PromptState {
  PromptInitial({required super.promptModel});
}

final class EditingPrompt extends PromptState {
  EditingPrompt({required super.promptModel});
}

final class PromptLoading extends PromptState {
  PromptLoading({required super.promptModel});
}

final class PromptLoaded extends PromptState {
  PromptLoaded({required this.recipe, required super.promptModel});
  final Recipe recipe;
}

final class PromptError extends PromptState {
  PromptError({required this.message, required super.promptModel});
  final String message;
}
