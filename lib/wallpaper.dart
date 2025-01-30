// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/fullscreen.dart';

class WallPaper extends StatefulWidget {
  const WallPaper({super.key});

  @override
  State<WallPaper> createState() => _WallPaperState();
}

class _WallPaperState extends State<WallPaper> {
  List images = [];
  int page = 1;

  @override
  void initState(){
    super.initState();
    fetchapi();
  }

  fetchapi()async{
    // await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'), 
    await http.get(Uri.parse('https://api.pexels.com/v1/search?query=mobile+wallpaper&per_page=80'),
    headers: {'Authorization' : '2WD4CitEneMN51p1uw2AfnMXiEfhydng178YWh2WyFJEZRGtcc7HEnlh'}).then((value) {
      Map result = jsonDecode(value.body);
      images = result['photos'];
      // print(images[0]);
    },);
  }

  loadmore()async{
    setState(() {
      page = page + 1;
    });
    String url = 'https://api.pexels.com/v1/search?query=mobile+wallpaper&per_page=80&page='+page.toString();
    await http.get(Uri.parse(url),
    headers: {'Authorization' : '2WD4CitEneMN51p1uw2AfnMXiEfhydng178YWh2WyFJEZRGtcc7HEnlh'}).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    },);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("WallPapers", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: GridView.builder(
                  itemCount: images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 2 / 3,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) {
                              return FullScreen(imageurl: images[index]['src']['large2x']);
                            },
                          ),
                        );
                      },
                      child: Container(
                        // color: Colors.amber,
                        child: Image.network(images[index]['src']['tiny'], fit: BoxFit.cover,),
                      ),
                    );
                  },
                ),
              ),
            ),
            InkWell(
              onTap: (){
                loadmore();
              },
              child: Container(
                height: 60,
                // color: Colors.black,
                width: double.infinity,
                child: Center(
                  child: Text("Load More", style: TextStyle(fontSize: 17),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}