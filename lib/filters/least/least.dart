import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prcarpolimi/filters/least/leastbutton.dart';
import 'widget/data_range_picker_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const Least());
}

class Least extends StatelessWidget {
  static const String title = 'Date (Range) & Time';

  const Least({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primaryColor: Colors.redAccent),
      home: const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text("Least"),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              })),
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                height: 250,
                child:
                    Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
            const SizedBox(
                height: 50,
                child: Text("Choose for how long are you in need.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 20))),
            const SizedBox(height: 60),
            const DateRangePickerWidget(),
            LeastButton(value: '')
          ])));
}
