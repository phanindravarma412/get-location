import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Location',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Location'),
        centerTitle: true,
      ),
      body: BodyPage(),
    );
  }
}

class BodyPage extends StatefulWidget {
  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  void getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    getCity(position.latitude, position.longitude);
  }

  void getCity(lat, long) async {
    final coordinates = new Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(first);
    print('address is ${first.locality}');
    setState(() {
      location = first.locality;
      loadWidget = true;
      addControllerText(first.locality);
    });
    // print("${first.featureName} : ${first.addressLine}");
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    // if(location.isNotEmpty){

    // controller =  TextEditingController(text: location);
    // }else{
    //   return;
    // }
  }

  void addControllerText(location){
    if(location.isEmpty){
      return ;
    }else{
      controller =  TextEditingController(text: location);
    }
  }

  TextEditingController controller;
  
  String location = '';
  bool loadWidget = false;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: loadWidgetFunction(loadWidget),
      ),
    );
  }

  Widget loadWidgetFunction(loadWidget) {
    if (loadWidget) {
      return Column(
        children: [
          Text('User Location is $location'),
          TextFormField(
            // initialValue: location,
            controller: controller,
          ),
          RaisedButton(child: Text('Location'), color: Colors.green, onPressed: (){
            print(controller.text);
          },)
        ],
      );
    } else {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
