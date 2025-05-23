# Article App - Flutter

A Flutter application that fetches articles from a public API, allows search and filtering, and lets users mark articles as favorites. Built using BLoC, Dio, Hive, and Clean UI practices.

---

## Features

-  Fetch articles from public API
-  Search articles by title or body (with throttling)
-  Mark articles as favorites
-  Persist favorites using Hive
-  Pull-to-refresh support
-  Scrollbar to show scroll position
-  Responsive and clean UI

---

## Tech Stack

 Technology   _  Description                  
--------------_-------------------------------
 Flutter 3+   _  App Framework                
 BLoC         _  State Management             
 Dio          _  API Client                   
 Hive         _  Local Storage for Favorites  

---

##  Dependencies

Added these to  `pubspec.yaml`:

```yaml
flutter_bloc: ^8.1.1
dio: ^5.3.2
hive: ^2.2.3
hive_flutter: ^1.1.0

---

## State Management Explanation
In this project, I have used BLoC (Business Logic Component) for state management. I chose BLoC because it provides a clear separation between business logic and UI, making the codebase easier to understand, maintain, and test. The structured approach of BLoC improves scalability and promotes a clean architecture, especially for medium to large applications.


## Known Issues / Limitations
- Occasionally, articles may not fetch properly due to network issues.
- There are some UI layout problems when users use larger font sizes or have smaller screen sizes. In such cases, parts of the article content may appear hidden, but users can still access it by scrolling.


## Folder Structure
lib/
│
├── Model/
│   └── article_model.dart
│
├── View/
│   ├── home_screen.dart
│   ├── favorite_articles_screen.dart
│   └── full_article_screen.dart
│
├── Common/
│   ├── color_class.dart
│   └── custom_search_bar.dart
│
├── Controller/
│   ├── bloc/
│   │   ├── article_bloc.dart
│   │   ├── article_event.dart
│   │   └── article_state.dart
│   │
│   └── network/
│       └── article_api_call.dart


 
 