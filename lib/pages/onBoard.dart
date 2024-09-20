import 'package:flutter/material.dart';
import 'package:max_walls/pages/home_screen.dart';
import 'package:max_walls/widgets/custom_button.dart';

var name;
TextEditingController nameController = TextEditingController();

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = nameController.text;
  }

  @override
  Widget build(BuildContext context) {
    const border = InputDecoration(
      contentPadding: EdgeInsets.only(left: 30),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(33))),
      filled: true,
      fillColor: Colors.black,
      hintText: "Name",
      hintStyle: TextStyle(color: Colors.white, fontSize: 15),
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "What's your name ?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: nameController,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                decoration: border,
              ),
              const Spacer(),
              CustomButton(
                text: 'Submit',
                onClick: () {
                  isLoading = true;
                  isLoading == true ? CircularProgressIndicator() : null;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                  debugPrint(nameController.text);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
