import 'package:flutter/material.dart';
import 'package:library_management_system/Screens/book_screen.dart';

// BookWidget takes the bookContent fetched by firestore for each book that matches search.
// It then pushes to the book_screen.
class BookWidget extends StatelessWidget {

  BookWidget({this.bookContent});
  final bookContent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // GestureDetector detects whenever the widget is pressed.
      // Then it passes the current book content to the next screen.
      // Due to the passing of data we can't use Navigator.pushNamed().
      onTap: (){
        //Navigator.pushNamed(context,BookScreen.id,arguments: bookContent);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context){
                return BookScreen(bookContent: bookContent);}
          ),
        );
      },
      child: Text('${bookContent['Book Name']} with code ${bookContent['Book Code']}'),
    );
  }
}

