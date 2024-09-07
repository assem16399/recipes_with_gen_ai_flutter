
# Demo

https://github.com/user-attachments/assets/ae8c77d6-7757-498f-ada0-3f9729d83703

Before running the app:
* Get an API key from [ai.google.dev](ai.google.dev).
Then, pass the API key in with dart define when running the app:

```bash
flutter run --dart-define=API_KEY=your_api_key
```

# Requirements:
### Functional
  - Sending User Pormpt to GEMINI API to Generate a recipe.
  - Allowing the user to add images of ingredients they have with the prompt
  - Displaying the recipe.
 
# Decisions

- This app was not focused on using clean architecture or following the best coding practices but was more focused on getting the functionality done, using, exploring the capabilities of GEMINAI API, and creating an MVP
- This app used BLoC Library for state management

   
# What could be improved
### Functionality
- Sometimes the prompt we get from GEMINAI API is not formatted in the way we want, so we can work on the prompt and processing the response to ensure that it is getting formatted correctly to be parsed successfully.
- Implementing favoriting recipes feature.

### Architecture
- Following BLoC architecture guild lines.
- Following clean code best practices
- Introducing repo design pattern.
- Introducing Service Locator to manage app dependencies.
