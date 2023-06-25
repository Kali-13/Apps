import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';
import '';

class flash extends StatefulWidget {
  const flash({super.key});

  @override
  State<flash> createState() => _flashState();
}

class _flashState extends State<flash> {
  final controller = TorchController();
  bool isOn = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          isOn ? "assets/Images/on_state.png" : "assets/Images/off_state.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.power_settings_new_outlined),
            onPressed: () {
              isOn = !isOn;
              controller.toggle();
              setState(() {});
            },
          ),
        ),

      ],
    );
  }
}
