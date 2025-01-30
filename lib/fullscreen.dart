import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
// import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class FullScreen extends StatefulWidget {
  final String imageurl;

  const FullScreen({super.key, required this.imageurl});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  bool isLoading  = false;

  Future<void> setWallpaper()async{
    setState(() {
      isLoading = true;
    });
    try{
      int location = WallpaperManager.HOME_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(widget.imageurl);
      final result = await WallpaperManager.setWallpaperFromFile(file.path, location);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text(result ? "WallPaper Set Successfully" : "Failed to set WallPaper. Please try again later")))); 
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    }
    finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  child: Image.network(widget.imageurl),
                ),
              ),
              InkWell(
                onTap: (){
                  setWallpaper();
                },
                child: Container(
                  // color: Colors.black,
                  height: 60,
                  width: double.infinity,
                  child: Center(child: Text("Set As WallPaper", style: TextStyle(fontSize: 17),)),
                ),
              ),
            ],
          ),
          Center(child: isLoading ? CircularProgressIndicator() : null),
        ]
      ),
    );
  }
}