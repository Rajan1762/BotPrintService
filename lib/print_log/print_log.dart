import 'dart:async';

import 'package:flutter/material.dart';

import '../common_values.dart';

class PrintLogScreen extends StatefulWidget {
  const PrintLogScreen({super.key});

  @override
  State<PrintLogScreen> createState() => _PrintLogScreenState();
}

class _PrintLogScreenState extends State<PrintLogScreen> {

  @override
  void dispose() {
    logStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(appBar: AppBar(
      title: const Text('Print Log Data'),
    ),
      body: StreamBuilder<String>(
        stream: logStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
                itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(snapshot.data!,style: const TextStyle(color: Colors.black),),
              );
            });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ));
  }
}
