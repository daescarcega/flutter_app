import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;

void main() => runApp(new MarvelApp());

String generateMd5(String input) {
  return crypto.md5.convert(utf8.encode(input)).toString();
}

class MarvelApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(title:
          Text("Marvel Comics!"),),
          body:InfinityDudes()

      ),
    );
  }
}

class InfinityDudes extends StatefulWidget{
  @override
   ListInfinityDudesState createState() =>
      new ListInfinityDudesState();
}

class ListInfinityDudesState
    extends State<InfinityDudes>{

   Future<List<InfinityComic>> getDudes()async{
    var now = new DateTime.now();
    var md5D = generateMd5(now.toString()+"PRIVATE_KEY"+"PUBLIC_KEY");
    var url = "https://gateway.marvel.com:443/v1/public/characters?&ts=" + now.toString()+  "&apikey=PUBLIC_KEY&hash="+md5D;
    print(url);

    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    List<InfinityComic> dudes = [];
    var dataMarvel = jsonData["data"];
    var marvelArray = dataMarvel["results"];
    for(var dude  in marvelArray){
      var thumb = dude["thumbnail"];
      var image = "${thumb["path"]}.jpg";
      InfinityComic infinityComic
      = InfinityComic(dude["name"], image);
      print("DUDE: " + infinityComic.title);
      dudes.add(infinityComic);
    }


    return dudes;

  }

  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     body: Container(
       child: FutureBuilder(
         future: getDudes(),
       ),
     ),
   );
  }

}


class InfinityComic{
  final String title;
  final String cover;
  InfinityComic(this.title, this.cover);
}
class InfinityDetail extends StatelessWidget{
  final InfinityComic infinityComic;
  InfinityDetail(this.infinityComic);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(infinityComic.title),
        ),
        body: Image.network(
          infinityComic.cover,
        )
    );
  }
}
