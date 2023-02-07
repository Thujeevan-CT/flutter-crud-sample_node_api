import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_crud/utils/show_message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddService extends StatefulWidget {
  final Map? service;
  const AddService({super.key, this.service});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {

  final baseApi = dotenv.env['BASE_API_URL'];
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool _isLoading= false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    final service = widget.service;
    if(service != null){
      _isEdit = true;
      titleController.text = service['title'];
      descriptionController.text = service['description'];
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isEdit ? const Text("Update Service") : const Text("Add Service"),
        centerTitle: true,
      ),
      body: _isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) : ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: "Title",
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
                hintText: "Description"
            ),
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox( height: 25),
          ElevatedButton(
            onPressed: _isEdit ? updateService : addService,
            child: _isEdit ? const Text("Update") : const Text("Submit"),
          )
        ],
      ),
    );
  }

  Future<void> addService () async {
    setState(() {
      _isLoading = true;
    });
    try{
      final title = titleController.text;
      final description = descriptionController.text;

      var bodyMap = {
        "title": title,
        "description": description,
      };

      final uri = Uri.parse('$baseApi/service/new');
      final response = await http.post(
        uri,
        body: jsonEncode(bodyMap),
        headers: {"Content-Type": "application/json"},
      );

      if(response.statusCode == 200){
        titleController.text = '';
        descriptionController.text = '';
        ShowMessage.show(context, status: true, msg: "Service Added");
      } else {
        ShowMessage.show(context,  status: false, msg: "Something went wrong!");
      }

    } catch (e) {
      ShowMessage.show(context,  status: false, msg: "Something went wrong!");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> updateService() async {
    try{
      final bodyObj = {
        "title": titleController.text,
        "description": descriptionController.text,
      };

      final service = widget.service;
      if(service == null){
        ShowMessage.show(context,  status: false, msg: "Something went wrong!");
        return;
      }
      final id = service!['_id'];
      final uri = Uri.parse("$baseApi/service/update/$id");
      final response = await http.put(
        uri,
        body: jsonEncode(bodyObj),
        headers: {"Content-Type": "application/json"},
      );

      if(response.statusCode == 200){
        titleController.text = '';
        descriptionController.text = '';
        ShowMessage.show(context, status: true, msg: "Service updated");
      } else {
        ShowMessage.show(context,  status: false, msg: "Something went wrong!");
      }
    } catch (e) {
      ShowMessage.show(context,  status: false, msg: "Something went wrong!");
    }
  }

}
