import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:service_crud/screens/add_service.dart';
import 'package:service_crud/utils/show_message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class ServiceList extends StatefulWidget {
  const ServiceList({Key? key}) : super(key: key);

  @override
  State<ServiceList> createState() => _ServiceState();
}

class _ServiceState extends State<ServiceList> {

  final baseApi = dotenv.env['BASE_API_URL'];
  List services = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
        centerTitle: true,
      ),
      body: Visibility(
        visible: !_isLoading,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: RefreshIndicator(
          onRefresh: fetchServices,
          child: Visibility(
            visible: services.isNotEmpty,
            replacement: Center(child: Text("No services", style: Theme.of(context).textTheme.headline5,)),
            child: ListView.builder(
              itemCount: services.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final service = services[index] as Map;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}'),),
                    title: Text(service['title']),
                    subtitle: Text(service['description']),
                    trailing: PopupMenuButton(
                      onSelected: (val) {
                        if(val == 'delete'){
                          deleteService(service['_id']);
                        } else if(val == 'edit'){
                          navigateEditPage(service);
                        }
                      },
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(value: "edit",child: Text("Edit"),),
                          PopupMenuItem(value: "delete",child: Text("Delete"),),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateAddNewPage,
        label: const Text("Add new service")
      ),
    );
  }

  Future<void> navigateAddNewPage () async{
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddService(),
      )
    );
    fetchServices();
  }

  Future<void> navigateEditPage (Map item) async{
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddService(service: item),
        )
    );
    fetchServices();
  }

  Future<void> fetchServices() async{
    setState(() {
      _isLoading = true;
    });
    try{
      final uri = Uri.parse("$baseApi/services");
      final response = await get(uri);

      if(response.statusCode == 200){
        final decoded = jsonDecode(response.body) as Map;
        final dataList = decoded['data'] as List;

        setState(() {
          services = dataList;
        });
      } else{
        ShowMessage.show(context, status: false, msg: "Something went wrong!");
      }

    } catch (e) {
      ShowMessage.show(context, status: false, msg: "Something went wrong!");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> deleteService(id) async{
    setState(() {
      _isLoading = true;
    });
    try{
      final uri = Uri.parse('$baseApi/service/delete/$id');
      final response = await delete(uri);

      if(response.statusCode == 200){
        final filtered = services.where((element) => element['_id'] != id).toList();
        setState(() {
          services = filtered;
        });
        ShowMessage.show(context, status: true, msg: "Service deleted!");
      } else {
        ShowMessage.show(context, status: false, msg: "Something went wrong!");
      }
    } catch (e) {
      ShowMessage.show(context, status: false, msg: "Something went wrong!");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> updateService(id) async{
    try{

    } catch (e) {
      ShowMessage.show(context, status: false, msg: "Something went wrong!");
    }
  }
}
