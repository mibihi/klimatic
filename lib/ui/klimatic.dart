import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../util/utils.dart' as util;

class Klimatic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return KlimaticState();
  }
}

class KlimaticState extends State<Klimatic>{
  String _cityEntered;
  Future _gotoNextScreen(BuildContext context)async{
    Map results = await Navigator.of(context).push(
        MaterialPageRoute<Map>(builder: (BuildContext context){
          return ChangeCity();
        })
    );
    if(results.containsKey('city') && results != null){
      //print('city ::$results');
      _cityEntered = results['city'];
    }
  }
  void showStuff() async {
    Map data = await getWeather(util.defaultCity,util.apiId);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Saadaasha HeerKulka"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              color: Colors.white,
              onPressed: (){ _gotoNextScreen(context);})
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'images/umbrella.png',
              height: 1200.0,
              width: 490.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text("Magaalada: "'${_cityEntered==null?util.defaultCity:_cityEntered}', style: cityStyle()),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ),
          //this is the container for the data
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 310.10, 0.0, 0.0),
            child: updateTempWidget(_cityEntered),
            ),

        ],
      ),
    );
  }
}

Future<Map> getWeather(String city, String appid)async {

  final String apiUrl =
       'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.apiId}&units=imperial';
       http.Response response = await http.get(apiUrl);
       return json.decode(response.body);
}

Widget updateTempWidget(String city){
  
return FutureBuilder(
    future: getWeather(city==null?util.defaultCity:city,util.apiId),
    builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
      //this is where we gte all the jason data in snapshot and set up widgets
      if(snapshot.hasData){
        Map content = snapshot.data;
        return Container(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(content['main']['temp'].toString(),
                style: tempStyle(),
                ),
                subtitle: ListTile(
                  title: Text(
                  "Humidity:${content['main']['humidity'].toString()}\n"
                       "Max:${content['main']['temp_max'].toString()} F\n"
                       "Min:${content['main']['temp_min'].toString()} F",
                    style:  extraData(),

                  ),
                ),
              )
            ],
          ),
        );
      }
      else
       return Container();

});
  
}

TextStyle extraData() {
  return TextStyle(
    color:Colors.white70 ,
    fontSize: 17.0,
    fontStyle:FontStyle.normal ,
  );
}

class ChangeCity extends StatelessWidget {
  final _cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change City'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill ,),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(

                  controller:_cityController ,
                  decoration: InputDecoration(
                      hintText: 'City Name',
                      labelText: 'Enter City'
                  ),
                ),
              ),
              ListTile(
                title: RaisedButton(
                    child: Text('OK'),
                    onPressed: (){
                      print('ok pressed');
                      Navigator.pop(context,{
                        'city': _cityController.text
                      });
                    }

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


TextStyle cityStyle() {
  return TextStyle(
      color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);
}

TextStyle tempStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 38.9,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);
}
