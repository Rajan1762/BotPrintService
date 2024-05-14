import 'dart:async';
import 'package:dummy/common_values.dart';
import 'package:dummy/print_log/print_log.dart';
import 'package:dummy/service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();
  bool ipEditStatus = true;
  bool portEditStatus = true;

  void saveData(String ipaddress1, int portNumber1) async
  {
    ipAddress = ipaddress1;
    portNumber = portNumber1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ip', ipaddress1);
    await prefs.setInt('port', portNumber);
    network();
  }
  
  @override
  void initState() {
    ipController.text = ipAddress;
    portController.text = portNumber.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        appBar: AppBar(
          backgroundColor: appThemeColor,
            title: const Text('Bros One Tech',style: TextStyle(color: Colors.white),),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const PrintLogScreen()));
            },
              child: const Icon(Icons.sticky_note_2_outlined)
          )
        ],),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage('assets/bros_logo.png')),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: appThemeColor),
                        borderRadius: const BorderRadius.all(Radius.circular(5))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ip Address',style: TextStyle(color: appThemeColor)),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  ipEditStatus = !ipEditStatus;
                                });
                              },
                                child: Icon(!ipEditStatus ? Icons.keyboard_alt_outlined : Icons.edit,color: appThemeColor,))
                          ],
                        ),
                        IpPortFields(controller: ipController,label: ipAddress, editStatus: ipEditStatus),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Port Number',style: TextStyle(color: appThemeColor)),
                            GestureDetector(
                                onTap: (){
                                  setState(() {
                                    portEditStatus = !portEditStatus;
                                  });
                                },
                                child: Icon(!portEditStatus ? Icons.keyboard_alt_outlined : Icons.edit,color: appThemeColor,))
                          ],
                        ),
                        IpPortFields(controller: portController,label: portNumber.toString(), editStatus: portEditStatus),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appThemeColor
                              ),
                                onPressed: (){
                                  if(ipController.value.text.isNotEmpty && portController.value.text.isNotEmpty)
                                    {
                                      saveData(ipController.value.text, int.parse(portController.value.text));
                                      setState(() {
                                        ipEditStatus = true;
                                        portEditStatus = true;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text('Service Started SuccessFully'),
                                      ));
                                    }else{
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Fills cannot be Empty'),
                                    ));
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 50),
                                  child: Text('Start Service',style: TextStyle(color: Colors.white),),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("App Version 1.0.0")
                ],
              ),
            ),
          ),
        ));
  }
}

class IpPortFields extends StatelessWidget {
  final String label;
  final bool editStatus;
  final TextEditingController controller;
  const IpPortFields({
    super.key, required this.controller, required this.label, required this.editStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        readOnly: editStatus,
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(),
          disabledBorder: OutlineInputBorder(),
        ),
      ),
    );
  }
}
