import 'package:flutter/material.dart';
import 'package:website/detailsPage.dart';

import 'Listofwebsite.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(backgroundColor: Colors.indigo.withOpacity(0.3))),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
        '/details': (context) => DetailsPage(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Collection Of Web"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo.withOpacity(0.3),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/details', arguments: web[i]);
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  //  height: 404,
                  child: Column(
                    children: [
                      Container(
                        height: 250 - 120,
                        // width: 250,
                        decoration: BoxDecoration(
                            /* boxShadow: [
                              BoxShadow(
                                  //color: Colors.indigo.withOpacity(0.5),
                                  spreadRadius: 2,
                                  offset: Offset(0, 0),
                                  blurRadius: 3)
                            ],*/
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.indigo.withOpacity(0.1),
                            image: DecorationImage(
                                // fit: BoxFit.cover,
                                scale: 6,
                                image: NetworkImage(web[i].image))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        web[i].name,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: web.length,
          ),
        )));
  }
}
