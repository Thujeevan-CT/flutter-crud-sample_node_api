import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:service_crud/screens/service_list.dart';

Future main() async{
  await dotenv.load(fileName: ".env");
  runApp(ServicesCrud());
}

class ServicesCrud extends StatefulWidget {
  const ServicesCrud({Key? key}) : super(key: key);

  @override
  State<ServicesCrud> createState() => _TodoAppState();
}

class _TodoAppState extends State<ServicesCrud> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Service CRUD",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ServiceList(),
    );
  }
}
