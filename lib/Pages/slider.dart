import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  Color bgcolor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: bgcolor,
            appBar: AppBar(
              title: const Text('Información General'),
              backgroundColor: Colors.green,
            ),
            body: ListView(
                padding: EdgeInsets.all(15),
                children: [
                  const SizedBox(height: 20),
                  const Text('SushiRoll 😋', style: const TextStyle(fontSize: 50)),
                  const SizedBox(height: 20),
                  const Text('Comprometidos con la innovación y la calidad ofrecemos a nuestros clientes un espacio diferente donde el sabor y el servicio generan una experiencia de emociones y sensaciones únicas.',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Image(
                      image: new ExactAssetImage("assets/img1.jpg"),
                      width: 200,
                      height: 200,
                      alignment: FractionalOffset.center),
                  const SizedBox(height: 20),
                  const Text('Visión', style: const TextStyle(fontSize: 40)),
                  const Text('Ser reconocidos como la marca líder en comida japonesa por su excelencia en servicio, innovación y calidad, gracias a nuestros colaboradores y valores institucionales lo que nos perfila a mercados internacionales.',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Image(
                      image: new ExactAssetImage("assets/img2.png"),
                      width: 200,
                      height: 200,
                      alignment: FractionalOffset.center),
                  const SizedBox(height: 20),
                ]
            )
        )
    );
  }
}