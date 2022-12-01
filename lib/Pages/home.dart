import 'dart:io';
import 'user.dart';
import 'dart:async';
import 'dart:convert';
import 'user.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:tcard/tcard.dart';
import 'package:http/http.dart' as http;

Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('https://proyectofinalpdm.run-us-west2.goorm.io/getAll'));
  if (response.statusCode == 200) {
    return decodeUser(response.body);
  } else {
    throw Exception('Unable to fetch data from the REST API');
  }
}

List<User> decodeUser(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<User>((json) => User.fromMap(json)).toList();
}

Future<User> createUser(String nombre, String apellido, String edad, String sexo, String url_foto, String correo, String telefono) async {
  final response = await http.post(
    Uri.parse('https://proyectofinalpdm.run-us-west2.goorm.io/addOne'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'nombre': nombre,
      'apellido': apellido,
      'edad': edad,
      'sexo': sexo,
      'url_foto': url_foto,
      'correo': correo,
      'telefono': telefono,
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return User.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create User.');
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  final Future<List<User>> _futureUser = fetchUsers();
  List img = [
    'https://media.istockphoto.com/photos/self-management-is-a-freelancers-greatest-tool-picture-id1294442411?b=1&k=20&m=1294442411&s=170667a&w=0&h=DzebibUiw8fb056LdMdG5oKURp9LJHfohv_nSG1d764=',
    'https://images.pexels.com/photos/2700587/pexels-photo-2700587.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/2700587/pexels-photo-2700587.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/1777689/pexels-photo-1777689.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/1678829/pexels-photo-1678829.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  ];
  List cellphones = [
    '+525540270556',
    '+525540270556',
    '+525540270556',
    '+525540270556',
    '+525540270556',
  ];
  List texts = [
    'Alfonso - 26',
    'Alfonso - 26',
    'Alfonso - 26',
    'Alfonso - 26',
    'Alfonso - 26',
  ];
  void convert() async {
    List list = await _futureUser;
    img=[];
    cellphones=[];
    texts = [];
    for (var item in list) {
      img.add(item.url_foto);
      cellphones.add(item.telefono);
      texts.add(item.nombre+" "+item.apellido+" - "+item.edad.toString());
      print(texts);
    }
  }

  void _openwhatsapp(String message, String destinatario) async {
    var whatsapp = destinatario;
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=" + message;
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse(message)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no instalado")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }
  void _enviarSMS(String message, List<String> recipents) async {
    String _resultado = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_resultado);
  }

  final Uri _url = Uri.parse('https://proyectofinalpdm.run-us-west2.goorm.io/');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  late TCardController _tcard = TCardController();
  var directionSwip, showInswer;
  var value;
  Future refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _tcard.reset();
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _selectedIndex == 3
            ? PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 0),
              child: AppBar(
                title: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.redAccent),
                    Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text(
                          "Busqueda de Plus One",
                          style: TextStyle(color: Colors.black54),
                        )),
                  ],
                ),
              ),
            ))
            : PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 0),
              child: AppBar(
                // backgroundColor: Colors.white,
                // foregroundColor: Colors.red,
                // backgroundColor :Colors.white,
                // elevation: 18,
                title: Image.asset(
                  "assets/icon/logobar.png",
                  width: 100,
                ),
              ),
            )),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 18,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            // currentIndex: selectedIndex,
            // onTap: (index){print("$index");},
            items: [
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(
                    Icons.wysiwyg,
                    color: Colors.redAccent,
                    size: 27,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: Image.asset(
                    "assets/icon/logo.png",
                    width: 120,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                      try {
                        convert();
                        _tcard.reset();
                      } catch (e) {
                        print("EROR === $e");
                      }
                    });
                  },
                ),
                label: "List",
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(
                    Icons.account_circle,
                    color: Colors.redAccent,
                    size: 27,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                  },
                ),
                label: "Account",
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(
                    Icons.grid_view,
                    color: Colors.redAccent,
                    size: 27,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                ),
                label: "Otro",
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(
                    Icons.plus_one,
                    color: Colors.redAccent,
                    size: 27,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
                label: "Unirse",
              ),
            ]),
        body: _selectedIndex == 0
            ? Center(
          child: RefreshIndicator(
              onRefresh: refresh,
              child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TCard(
                              controller: _tcard,
                              slideSpeed: 20,
                              delaySlideFor: 500,
                              lockYAxis: false,
                              onBack: (val, __) {
                                setState(() {
                                  print(
                                      "===========onBack ($val) ($__)============");
                                });
                              },
                              onForward: (val, __) {
                                setState(() {
                                  print(
                                      "===========onForward ($val) (${__.direction})============");
                                  directionSwip = __.direction;
                                  if (directionSwip == SwipDirection.Right) {
                                    showInswer = "right";
                                    print("************* $showInswer");
                                  } else {
                                    showInswer = "left";
                                    print("************* $showInswer");
                                  }
                                });
                              },
                              onEnd: () {
                                setState(() {
                                  print("===========OnEnd============");
                                });
                              },
                              size: const Size(double.infinity, 550),
                              cards: List.generate(
                                img.length,
                                    (int index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          img[index],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(18.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 17),
                                          blurRadius: 23.0,
                                          spreadRadius: -13.0,
                                          color: Colors.black54,
                                        )
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(vertical: 100),
                                          alignment: Alignment.bottomCenter,
                                            child: Text(
                                                ' '+texts[index],
                                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                            ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundColor:
                                                Colors.orange.shade100,
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                    Colors.orange,
                                                    radius: 20,
                                                    child: IconButton(
                                                      iconSize: 20,
                                                      icon: const Icon(
                                                          Icons.replay),
                                                      onPressed: () async {
                                                        setState(() {
                                                          value = 1;
                                                        });
                                                        // await Future.delayed(const Duration(seconds: 1));
                                                        try {
                                                          _tcard.back();
                                                        } catch (e) {
                                                          print(
                                                              "EROR $e ======");
                                                        }
                                                      },
                                                    )),
                                              ),
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundColor:
                                                Colors.blue.shade100,
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                    Colors.blueAccent,
                                                    radius: 30,
                                                    child: IconButton(
                                                      iconSize: 34,
                                                      icon: const Icon(
                                                          Icons.sms),
                                                      onPressed: () async {
                                                        setState(() {
                                                          value = 1;
                                                        });
                                                        // await Future.delayed(const Duration(seconds: 1));
                                                        try {
                                                          String mensaje = "Hola Sexy";
                                                          List<String> destinatarios = [cellphones[index]];
                                                          _enviarSMS(mensaje, destinatarios);
                                                        } catch (e) {
                                                          print(
                                                              "EROR $e ======");
                                                        }
                                                      },
                                                    )),
                                              ),
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundColor:
                                                Colors.greenAccent,
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                    Colors.green,
                                                    radius: 30,
                                                    child: IconButton(
                                                      iconSize: 34,
                                                      icon: const Icon(
                                                          Icons.whatsapp),
                                                      onPressed: () async {
                                                        setState(() {
                                                          value = 1;
                                                        });
                                                        // await Future.delayed(const Duration(seconds: 1));
                                                        try {
                                                          String mensaje = "Hola Sexy";
                                                          String destinatario = cellphones[index];
                                                          _openwhatsapp(mensaje, destinatario);
                                                        } catch (e) {
                                                          print(
                                                              "EROR $e ======");
                                                        }
                                                      },
                                                    )),
                                              ),
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundColor:
                                                Colors.red.shade100,
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                    Colors.red,
                                                    radius: 20,
                                                    child: IconButton(
                                                      iconSize: 20,
                                                      icon: const Icon(
                                                          Icons.close),
                                                      onPressed: () async {
                                                        setState(() {
                                                          value = 0;
                                                        });
                                                        // await Future.delayed(const Duration(seconds: 1));
                                                        try {
                                                          _tcard.forward(
                                                              direction:
                                                              SwipDirection
                                                                  .Left);
                                                        } catch (e) {
                                                          print(
                                                              "EROR $e ======");
                                                        }
                                                      },
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ))
                  ])),
        )
            : _selectedIndex == 1
            ? Center(
            child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                              color: Color(0xffda4835)),
                          width: double.infinity,
                          height: 250,
                          margin: const EdgeInsets.all(15),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Image.asset(
                                "assets/icon/searchTinder.jpg",
                                fit: BoxFit.fill,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: 80, right: 150),
                                child: const Text(
                                  "Plus One +",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 140, right: 125, left: 10),
                                child: const Text(
                                  "Nunca vuelvas a ir solo a una Fiesta",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 190, right: 230),
                                child: const Text(
                                  "",
                                  style: TextStyle(
                                    color: Color(0xFF858484),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 190, right: 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(18.0),
                                      ),
                                      primary: Colors.white, // background
                                      onPrimary:
                                      Colors.white, // foreground
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'Pruebalo',
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: const Text(
                              "Para ti",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.black),
                            )),
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                                  // alignment: Alignment.center,
                                  margin: const EdgeInsets.all(8),
                                  height: 300,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/icon/amigos.jpg",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 120, left: 45, right: 0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    18.0),
                                              ),
                                              primary:
                                              Colors.white, // background
                                              onPrimary:
                                              Colors.white, // foreground
                                            ),
                                            onPressed: () {},
                                            child: const Text(
                                              'Amigos',
                                              style: TextStyle(
                                                color: Color(0xFF000000),
                                              ),
                                            ),
                                          )),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 220, left: 10),
                                        child: const Text(
                                          "Encuentra Nuevos Amigos",
                                          style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 270, left: 10),
                                        child: const Text(
                                          "",
                                          style: TextStyle(
                                            color: Color(0xFFA1A1A1),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                                child: Container(
                                  // alignment: Alignment.center,
                                  margin: const EdgeInsets.all(8),
                                  height: 300,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/icon/happy-relationship.jpg",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 120, left: 45, right: 0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    18.0),
                                              ),
                                              primary:
                                              Colors.white, // background
                                              onPrimary:
                                              Colors.white, // foreground
                                            ),
                                            onPressed: () {},
                                            child: const Text(
                                              'Aventura',
                                              style: TextStyle(
                                                color: Color(0xFF000000),
                                              ),
                                            ),
                                          )),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 220, left: 10),
                                        child: const Text(
                                          "Talvez algo mas",
                                          style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 270, left: 10),
                                        child: const Text(
                                          "",
                                          style: TextStyle(
                                            color: Color(0xFFA1A1A1),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                                  // alignment: Alignment.center,
                                  margin: const EdgeInsets.all(8),
                                  height: 300,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/icon/amistad.jpeg",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 120, left: 45, right: 0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    18.0),
                                              ),
                                              primary:
                                              Colors.white, // background
                                              onPrimary:
                                              Colors.white, // foreground
                                            ),
                                            onPressed: () {},
                                            child: const Text(
                                              'Compañia',
                                              style: TextStyle(
                                                color: Color(0xFF000000),
                                              ),
                                            ),
                                          )),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 220, left: 10),
                                        child: const Text(
                                          "Te sientes solo",
                                          style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 270, left: 10),
                                        child: const Text(
                                          "",
                                          style: TextStyle(
                                            color: Color(0xFFA1A1A1),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                                child: Container(
                                  // alignment: Alignment.center,
                                  margin: const EdgeInsets.all(8),
                                  height: 300,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/icon/unsplash.jpg",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 120, left: 45, right: 0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    18.0),
                                              ),
                                              primary:
                                              Colors.white, // background
                                              onPrimary:
                                              Colors.white, // foreground
                                            ),
                                            onPressed: () {},
                                            child: const Text(
                                              'Unete',
                                              style: TextStyle(
                                                color: Color(0xFF000000),
                                              ),
                                            ),
                                          )),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 220, left: 10),
                                        child: const Text(
                                          "Y se uno mas con suerte",
                                          style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 270, left: 10),
                                        child: const Text(
                                          "",
                                          style: TextStyle(
                                            color: Color(0xFFA1A1A1),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  )
                ]))
            : _selectedIndex == 2
            ? SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/icon/goldlogo.png",
                      ),
                      fit: BoxFit.fill,
                    ),
                    borderRadius:
                    BorderRadius.all(Radius.circular(12)),
                    color: Color(0xfff8019a)),
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(15),
                child: null,
              ),
              Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 70),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      primary:
                      Colors.amber.shade800, // background
                      onPrimary: Colors.amber, // foreground
                    ),
                    onPressed: () {_launchUrl();},
                    child: const Text(
                      'UNETE CON NOSOTROS LOG IN',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  )),
            ],
          ),
        )
            : _selectedIndex == 3
            ? SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/icon/playhot.png",
                      ),
                      fit: BoxFit.fill,
                    ),
                    borderRadius:
                    BorderRadius.all(Radius.circular(12)),
                    color: Color(0xfff8019a)),
                width: double.infinity,
                height: 170,
                margin: const EdgeInsets.all(15),
                child: null,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 18),
                  child: const Text(
                    "Matches",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.pinkAccent),
                  )),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/icon/recently.png",
                              ),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(12)),
                            color: Color(0xfff8019a)),
                        width: 120,
                        height: 170,
                        margin: const EdgeInsets.all(15),
                        child: null,
                      ),
                      const Text(
                        "Likes",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/icon/gamers.jpeg",
                              ),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(12)),
                            color: Color(0xfff8019a)),
                        width: 120,
                        height: 170,
                        margin: const EdgeInsets.all(15),
                        child: null,
                      ),
                      const Text(
                        "Eventos",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(left: 18),
                  child: const Text(
                    "Mensajes ❶",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.pinkAccent),
                  )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )
            : _selectedIndex == 4
            ? SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const CircleAvatar(
                    radius: 55,
                    backgroundImage:
                    AssetImage("assets/icon/avatar.jpg"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text("Nicole Salandra, 21",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight:
                                FontWeight.bold,
                                color: Colors.black)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.verified_outlined)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                          const Color(0xFFD1D1D1),
                          radius: 25,
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Configuracion"),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          radius: 35,
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.photo_camera,
                                color: Colors.white,
                                size: 30,
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Media"),
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                          const Color(0xFFD1D1D1),
                          radius: 25,
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                  Icons.shield,
                                  color: Colors.white)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Seguridad"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(120),
                          topRight: Radius.circular(120)),
                      color: Color(0xFFDDDDDD),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 90),
                          // color: Colors.red,
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: ListTile(
                            title: const Text(
                                "Se UNO MAS!"),
                            leading: Image.asset(
                              "assets/icon/goldtinder.png",
                              width: 40,
                            ),
                          ),
                        ),
                        const Text(
                            "Informacion de tu usario"),
                      ],
                    ))
              ],
            ),
          ),
        )
            : null);
  }

}