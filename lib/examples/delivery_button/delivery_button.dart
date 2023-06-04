import 'package:flutter/material.dart';
import 'package:simple_examples/examples/delivery_button/widgets/content_button.dart';


class DeliveryButton extends StatelessWidget {
  const DeliveryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(useMaterial3: true),
      child: Scaffold(
        appBar: AppBar(title: const Text("Delivery Button")),
        body: const Center(
          child:  ContentButton(),
        ),
      ),
    );
  }
}
