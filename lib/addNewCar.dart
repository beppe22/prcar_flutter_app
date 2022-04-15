// ignore_for_file: file_names
import 'package:flutter/material.dart';

class AddNewCar extends StatelessWidget {
  const AddNewCar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController model = TextEditingController();
    TextEditingController color = TextEditingController();
    TextEditingController seats = TextEditingController();

    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title: const Text('PrCar'),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Add car informations",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 50.8,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 44.0),
                  TextField(
                      controller: model,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: "Car Model")),
                  const SizedBox(height: 44.0),
                  TextField(
                      controller: color,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: "Car color")),
                  const SizedBox(height: 44.0),
                  TextField(
                      controller: model,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(hintText: "Number of seats")),
                  SizedBox(
                      width: double.infinity,
                      child: RawMaterialButton(
                          fillColor: const Color(0xFFB74093),
                          onPressed: () async {
                            /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(userModel)));*/
                          },
                          child: const Text("Add new car",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0))))
                ])));
  }
}
