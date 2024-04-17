import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color _selectedColor = Colors.black; // Initial selection (WHO)
  int genderDependent = 0;

  void updateDependency() {
    if (_selectedColor != Colors.black) {
      setState(() {
        genderDependent = 1;
      });
    } else {
      setState(() {
        genderDependent = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_selectedColor == Colors.black) {
            Navigator.pushReplacementNamed(context, '/home'); // Go to home
          } else {
            Navigator.pushReplacementNamed(context, '/dge'); // Go to dge
          }
          return true; // Allow pop
        },
        child: Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            title: const Text('Settings'),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          body: Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluation',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.redAccent[100]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.deepPurple,
                        // Change this to your desired color
                        width: 1.0, // Change this to your desired border width
                      ),
                    ),
                    child: DropdownButtonFormField<Color>(
                      value: _selectedColor,
                      items: [
                        DropdownMenuItem(
                            value: Colors.black, child: Text('WHO')),
                        DropdownMenuItem(value: Colors.red, child: Text('DGE')),
                      ],
                      onChanged: (Color? newValue) {
                        setState(() {
                          _selectedColor = newValue!;
                          updateDependency();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Version',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent), // Transparent border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent), // Transparent border
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (genderDependent == 1)
                    Text('( Gender Dependent )')
                  else
                    Text('( Gender Independent )'),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'More',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.redAccent[100]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Remove ads',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Help & feddback',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Share this app',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Rate this app',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'More apps',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
        ));
  }
}
