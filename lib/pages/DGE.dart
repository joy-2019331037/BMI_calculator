import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_circular_text/circular_text.dart';

class DGE extends StatefulWidget {
  const DGE({super.key});

  @override
  State<DGE> createState() => _DGEState();
}

class _DGEState extends State<DGE> {
  Map<String, String> bmiMaleClasses = {
    'Underweight': '≤ 19.9',
    'Normal': '20.0 - 24.9',
    'Overweight': '25.0 - 29.9',
    'Obese Class I': '30.0 - 34.9',
    'Obese Class II': '35.0 - 39.9',
    'Obese Class III': '≥ 40.0',
  };

  Map<String, String> bmiFemaleClasses = {
    'Underweight': '≤ 18.9',
    'Normal': '19.0 - 23.9',
    'Overweight': '24.0 - 29.9',
    'Obese Class I': '30.0 - 34.9',
    'Obese Class II': '35.0 - 39.9',
    'Obese Class III': '≥ 40.0',
  };

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final _feetController = TextEditingController();
  final _inchesController = TextEditingController();

  String _heightText = '';
  String _weightText = '';
  String _selectedWeightType = 'kg';
  String _selectedHeightType = 'cm';
  String category = "...";
  String weightDifference = '...';

  Color pointerColor = Colors.blue;
  Color malegenderColor = Colors.black45;
  Color femalegenderColor = Colors.black45;

  double _bmi = 0.0;

  double x = 0.0, y = 0.0, z = 0.0;
  String weightLowerBound = '...';
  String weightHigherBound = '...';

  String gender = "male";

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void updateGenderColor() {
    if (gender == "male") {
      malegenderColor = Colors.blue;
      femalegenderColor = Colors.black45;
    } else {
      femalegenderColor = Colors.pinkAccent;
      malegenderColor = Colors.black45;
    }
  }

  void updateBMIClass() {
    if (gender == "male") {
      if (_bmi <= 19.9) {
        category = bmiMaleClasses.keys.elementAt(0);
        pointerColor = Colors.blue;
      } else if (_bmi >= 20.0 && _bmi <= 24.9) {
        category = bmiMaleClasses.keys.elementAt(1);
        pointerColor = Colors.green;
      } else if (_bmi >= 25.0 && _bmi <= 29.9) {
        category = bmiMaleClasses.keys.elementAt(2);
        pointerColor = Colors.red;
      } else if (_bmi >= 30.0 && _bmi <= 34.9) {
        category = bmiMaleClasses.keys.elementAt(3);
        pointerColor = Colors.red;
      } else if (_bmi >= 35.0 && _bmi <= 39.9) {
        category = bmiMaleClasses.keys.elementAt(4);
        pointerColor = Colors.red;
      } else {
        category = bmiMaleClasses.keys.elementAt(5);
        pointerColor = Colors.red;
      }
    } else {
      if (_bmi <= 18.9) {
        category = bmiMaleClasses.keys.elementAt(0);
        pointerColor = Colors.blue;
      } else if (_bmi >= 19.0 && _bmi <= 23.9) {
        category = bmiFemaleClasses.keys.elementAt(1);
        pointerColor = Colors.green;
      } else if (_bmi >= 24.0 && _bmi <= 29.9) {
        category = bmiFemaleClasses.keys.elementAt(2);
        pointerColor = Colors.red;
      } else if (_bmi >= 30.0 && _bmi <= 34.9) {
        category = bmiFemaleClasses.keys.elementAt(3);
        pointerColor = Colors.red;
      } else if (_bmi >= 35.0 && _bmi <= 39.9) {
        category = bmiFemaleClasses.keys.elementAt(4);
        pointerColor = Colors.red;
      } else {
        category = bmiFemaleClasses.keys.elementAt(5);
        pointerColor = Colors.red;
      }
    }

    print(category);
  }

  void updateBMIFromFeetInches() {
    double feet = double.parse(_feetController.text);
    double inches = double.parse(_inchesController.text);
    double totalInches = feet * 12 + inches; // Convert feet to inches
    double height = totalInches * 2.54; // Convert inches to cm
    setState(() {
      _heightText = height.toString();
      updateBMI();
    });
  }

  void updateWeightRange(double height, double weight) {
    if (gender == "male") {
      x = (height / 100) * (height / 100) * 20.0;
      y = (height / 100) * (height / 100) * 24.9;

      weightLowerBound = x.toStringAsFixed((1));
      weightHigherBound = y.toStringAsFixed(1);

      if (weight < x) {
        z = x - weight;
        weightDifference = z.toStringAsFixed(1);
        weightDifference += " kg less";
      } else if (weight > y) {
        z = weight - y;
        weightDifference = z.toStringAsFixed(1);
        weightDifference += " kg more";
      }
    } else {
      x = (height / 100) * (height / 100) * 19.0;
      y = (height / 100) * (height / 100) * 23.9;

      weightLowerBound = x.toStringAsFixed((1));
      weightHigherBound = y.toStringAsFixed(1);

      if (weight < x) {
        z = x - weight;
        weightDifference = z.toStringAsFixed(1);
        weightDifference += " kg less";
      } else if (weight > y) {
        z = weight - y;
        weightDifference = z.toStringAsFixed(1);
        weightDifference += " kg more";
      }
    }
  }

  double calculateBMI(double height, double weight) {
    updateWeightRange(height, weight);
    return weight / ((height / 100) * (height / 100));
  }

  void updateBMI() {
    setState(() {
      _bmi = calculateBMI(double.parse(_heightText), _convertWeightToKg());
      updateBMIClass();
    });
  }

  double _convertWeightToKg() {
    double weight = double.parse(_weightText);
    if (_selectedWeightType == 'lb') {
      //because 1 pound equals to 0.4535 kg
      weight *= 0.4535;
    } else if (_selectedWeightType == 'st') {
      //because 1 stone unit equals to 6.35 kg
      weight *= 6.35;
    }
    print(weight);
    return weight;
  }

  void reset() {
    _heightText = '';
    _weightText = '';
    _selectedWeightType = 'kg';
    _selectedHeightType = 'cm';
    category = "...";
    weightDifference = '...';

    pointerColor = Colors.blue;
    malegenderColor = Colors.black45;
    femalegenderColor = Colors.black45;

    _bmi = 0.0;

    x = 0.0;
    y = 0.0;
    z = 0.0;
    weightLowerBound = '...';
    weightHigherBound = '...';

    _heightController.text = "";
    _weightController.text = "";
    _feetController.text = "";
    _inchesController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    print('speaking from dge');
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text(
          'BMI Calculator',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              reset();
            });
          },
        ),
        actions: [
          PopupMenuButton<int>(
            // Use a generic type for flexibility
            onSelected: (result) {
              if (result == 0) {
                Navigator.pushNamed(
                    context, '/settings'); // Navigate to settings page
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                // Associate a value with the menu item for selection handling
                child: Row(
                  children: [
                    const Icon(Icons.settings),
                    // Add an icon for visual appeal
                    const SizedBox(width: 10.0),
                    // Add spacing for better readability
                    const Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 20, 0),
          child: Column(
            children: [
              //height field
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(0.0),
                        width: 25.0, //
                        child: IconButton(
                          icon: Icon(
                            Icons.man,
                            size: 40,
                            color: malegenderColor,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              gender = "male";
                              print(gender);
                              updateGenderColor();
                              updateBMI();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Container(
                        padding: const EdgeInsets.all(0.0),
                        width: 25.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.woman,
                            size: 40,
                            color: femalegenderColor,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              gender = "female";
                              print(gender);
                              updateGenderColor();
                              updateBMI();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50.0,
                  ),
                  if (_selectedHeightType == 'cm')
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _heightText = value;
                            updateBMI();
                          });
                        },
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0, letterSpacing: 1.5),
                        decoration: InputDecoration(
                          hintText: 'Height',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                        child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _feetController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                updateBMIFromFeetInches();
                              },
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18.0, letterSpacing: 1.5),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlue),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '\′',
                            style: TextStyle(fontSize: 25.0),
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _inchesController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                updateBMIFromFeetInches();
                              },
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18.0, letterSpacing: 1.5),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlue),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '\′\′',
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ],
                      ),
                    )),
                  SizedBox(width: 40),
                  DropdownButton<String>(
                    value: _selectedHeightType,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedHeightType = newValue!;
                        updateBMI();
                      });
                    },
                    dropdownColor: Colors.blue[100],
                    underline: Container(),
                    items: <String>['ft', 'cm']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),

              SizedBox(height: 15),

              //weight field
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 10,
                    ),
                    // child: Text(
                    //   'Weight',
                    //   style: TextStyle(
                    //       fontSize: 20.0,
                    //       letterSpacing: 1.5,
                    //       fontWeight: FontWeight.bold),
                    // )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _weightText = value;
                          updateBMI();
                        });
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, letterSpacing: 1.5),
                      decoration: InputDecoration(
                        hintText: 'Weight',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  DropdownButton<String>(
                    value: _selectedWeightType,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedWeightType = newValue!;
                        updateBMI();
                      });
                    },
                    dropdownColor: Colors.blue[100],
                    underline: Container(),
                    items: <String>['kg', 'lb', 'st']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),

              SizedBox(
                height: 30.0,
              ),

              //Gauge Pointer
              Align(
                child: SfRadialGauge(
                  axes: [
                    RadialAxis(
                      startAngle: 180,
                      endAngle: 0,
                      minimum: 0,
                      maximum: 45,
                      showLabels: false,
                      canScaleToFit: true,

                      labelOffset: 65,
                      // Adjust distance between labels and axis line
                      maximumLabels: 3,
                      ranges: [
                        GaugeRange(
                          startWidth: 70,
                          endWidth: 70,
                          startValue: 0,
                          endValue: 15,
                          color: Colors.blueAccent,
                        ),
                        GaugeRange(
                          startWidth: 70,
                          endWidth: 70,
                          startValue: 15,
                          endValue: 30,
                          color: Colors.green,
                        ),
                        GaugeRange(
                          startWidth: 70,
                          endWidth: 70,
                          startValue: 30,
                          endValue: 45,
                          color: Colors.red,
                          //   label: 'Overweight',
                          //   labelStyle:
                          //       GaugeTextStyle(fontSize: 15, color: Colors.white),
                          //
                        ),
                      ],
                      pointers: [
                        NeedlePointer(
                          value: _bmi,
                          enableAnimation: true,
                          knobStyle: KnobStyle(knobRadius: 0),
                          needleStartWidth: 1,
                          needleEndWidth: 50,
                          needleLength: 0.7,
                          needleColor: Colors.blue[100],
                          enableDragging: true,
                        ),
                      ],

                      annotations: [
                        //bmivalue
                        GaugeAnnotation(
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('BMI',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Text('${_bmi.toStringAsFixed(1)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: pointerColor)),
                            ],
                          ),
                        ),

                        GaugeAnnotation(
                          axisValue: 0,
                          positionFactor: 0.38,
                          widget: Padding(
                              padding: EdgeInsets.only(right: 60.0),
                              child: Text('16'),
                        ),),
                        GaugeAnnotation(
                          axisValue: 45,
                          positionFactor: 0.7,
                          widget: Padding(
                              padding: EdgeInsets.only(right: 60.0),
                              child: Text('40')),
                        ),
                        GaugeAnnotation(
                          axisValue: 21.5,
                          positionFactor: 0.49,
                          widget: Padding(
                              padding: EdgeInsets.only(right: 60.0),
                              child: gender == "male"
                                  ? Text('20')
                                  : Text('19')),
                        ),
                        GaugeAnnotation(
                          axisValue: 32,
                          positionFactor: 0.62,
                          widget: Padding(
                              padding: EdgeInsets.only(right: 60.0),
                              child: gender == "male"
                                  ? Text('25')
                                  : Text('24')),
                        ),
                        //Normal
                        GaugeAnnotation(
                          axisValue: 36,
                          positionFactor: 0.25,
                          widget: Padding(
                              padding: EdgeInsets.only(right: 60.0),
                              child: CircularText(
                                children: [
                                  TextItem(
                                    text: Text('Normal',
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    space: 6,
                                    startAngle: -103,
                                  )
                                ],
                              )),
                        ),
                        //overweight
                        GaugeAnnotation(
                          axisValue: 42,
                          positionFactor: 0.35,
                          widget: Padding(
                              padding: EdgeInsets.only(right: 60.0),
                              child: CircularText(
                                children: [
                                  TextItem(
                                    text: Text('Overweight',
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    space: 5,
                                    startAngle: -51,
                                  )
                                ],
                              )),
                        ),
                        //underweight
                        GaugeAnnotation(
                          axisValue: 30,
                          positionFactor: 0.13,
                          widget: Padding(
                              padding: EdgeInsets.only(right: 60.0),
                              child: CircularText(
                                children: [
                                  TextItem(
                                    text: Text('Underweight',
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    space: 5,
                                    startAngle: -173,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
                heightFactor: 0.5,
              ),

              SizedBox(
                height: 60.0,
              ),

              //message to user
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        'Category',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 140,
                      ),
                      Text(
                        'Difference',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      if (_bmi == 0.0)
                        Row(
                          children: [
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              '$category',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 110.0,
                            )
                          ],
                        )
                      else if (_bmi <= 18.4)
                        Text(
                          'Underweight',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: pointerColor),
                        )
                      else if (category == 'Normal')
                        Row(
                          children: [
                            SizedBox(width: 20.0),
                            Text(
                              '$category',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: pointerColor),
                            ),
                          ],
                        )
                      else
                        Text(
                          '$category',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: pointerColor),
                        ),
                      SizedBox(
                        width: 130,
                      ),
                      if (category == 'Normal')
                        Row(
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            Icon(
                              Icons.check,
                              color: Colors.green,
                              weight: 10.0,
                              size: 30,
                            )
                          ],
                        )
                      else if (z != 0.0)
                        Text(
                          '$weightDifference',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: pointerColor),
                        )
                      else
                        Text(
                          '...',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                    ],
                  )
                ],
              ),

              Divider(
                color: Colors.blue[200], // Set the color of the divider
                height: 40, // Set the height of the divider
                thickness: 1, // Set the thickness of the divider
              ),

              //class description
              if (gender == "male")
                Row(
                  children: [
                    // Column for keys
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align keys to the start
                      children: bmiMaleClasses.keys.map((key) {
                        return Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            if (category == key)
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_right,
                                    color: pointerColor,
                                    size: 25,
                                  ),
                                  Text(
                                    key,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: pointerColor,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            else
                              Row(
                                children: [
                                  Icon(
                                    Icons.play_arrow,
                                    color: Colors.blue[100],
                                    size: 12,
                                  ),
                                  Text(
                                    key,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  )
                                ],
                              )
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(width: 130),
                    // Add a gap between keys and values
                    // Column for values
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // Align values to the start
                      children: bmiMaleClasses.entries.map((entry) {
                        return Row(
                          children: [
                            if (category == entry.key)
                              Text(
                                entry.value.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: pointerColor,
                                    fontWeight: FontWeight.bold),
                              )
                            else
                              Text(
                                entry.value.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              )
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    // Column for keys
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align keys to the start
                      children: bmiFemaleClasses.keys.map((key) {
                        return Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            if (category == key)
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_right,
                                    color: pointerColor,
                                    size: 25,
                                  ),
                                  Text(
                                    key,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: pointerColor,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            else
                              Row(
                                children: [
                                  Icon(
                                    Icons.play_arrow,
                                    color: Colors.blue[100],
                                    size: 12,
                                  ),
                                  Text(
                                    key,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  )
                                ],
                              )
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(width: 130),
                    // Add a gap between keys and values
                    // Column for values
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // Align values to the start
                      children: bmiFemaleClasses.entries.map((entry) {
                        return Row(
                          children: [
                            if (category == entry.key)
                              Text(
                                entry.value.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: pointerColor,
                                    fontWeight: FontWeight.bold),
                              )
                            else
                              Text(
                                entry.value.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              )
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              Divider(
                color: Colors.blue[200], // Set the color of the divider
                height: 50, // Set the height of the divider
                thickness: 1, // Set the thickness of the divider
              ),

              //Ideal Weight Indicator
              Row(
                children: [
                  Text(
                    'Ideal Weight',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 110,
                  ),
                  if (_bmi == 0.0)
                    Row(
                      children: [
                        SizedBox(
                          width: 60.0,
                        ),
                        Text(
                          '...',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  else if (x == 0)
                    Text(
                      '...',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  else
                    Text(
                      '$weightLowerBound - $weightHigherBound kg',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
