import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  final String? title;
  final String? description;

  const Description({Key? key, this.title, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Description')),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  title!,
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (description != null)
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  description!,
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
