import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:library_management_system/Screens/application_screen.dart';
import 'package:library_management_system/authorization/registration.dart';
import 'package:library_management_system/authorization/login.dart';
import 'package:library_management_system/authorization/enter_details.dart';
import 'package:library_management_system/Screens/welcome_screen.dart';
import 'package:library_management_system/Screens/search_screen.dart';
import 'package:library_management_system/Screens/home_screen.dart';
import 'package:library_management_system/Screens/admin_screen.dart';
import 'package:library_management_system/Screens/issued_books_screen.dart';
import 'package:library_management_system/Screens/add_books_screen.dart';

// This is the Main Dart File which contains the Route to all the screens except the book screen since it requires arguments to passed to it.
// This also contains the Firebase Core which is required to use the Firebase Authenticator and FireStore.
// The initial route is set to welcome screen which is the first screen to be build.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        Login.id: (context) => Login(),
        Registration.id: (context) => Registration(),
        EnterDetails.id: (context) => EnterDetails(),
        SearchScreen.id: (context) => SearchScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        AdminScreen.id: (context) => AdminScreen(),
        ApplicationScreen.id: (context) => ApplicationScreen(),
        IssuedBooks.id: (context) => IssuedBooks(),
        AddBooks.id:(context) => AddBooks(),
      }
    ),
  );
}

