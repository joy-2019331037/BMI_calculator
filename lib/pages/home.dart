import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:flutter_circular_text/circular_text.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final _feetController = TextEditingController();
  final _inchesController = TextEditingController();

  String _heightText = '';
  String _weightText = '';
  String _selectedWeightType = 'kg';
  String _selectedHeightType='cm';

  double _bmi = 0.0;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
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

  double calculateBMI(double height, double weight) {
    return weight / ((height / 100) * (height / 100));
  }


  void updateBMI() {
    setState(() {
      _bmi = calculateBMI(double.parse(_heightText), _convertWeightToKg());
    });
  }

  double _convertWeightToKg() {
    double weight = double.parse(_weightText);
    if (_selectedWeightType == 'lb') {
      //because 1 pound equals to 0.4535 kg
      weight *= 0.4535;
    }
    else if(_selectedWeightType=='st'){
      //because 1 stone unit equals to 6.35 kg
      weight *= 6.35;
    }
    print(weight);
    return weight;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            title: Text(
              'BMI Calculator',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,

          ),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 30, 0),
              child: Column(
               

                children: [
            
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: Text(
                              'Height',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        ),

                        SizedBox(width: 8.0,),
                        if(_selectedHeightType=='cm')
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _heightController,
                            onChanged: (value) {
                              setState(() {
                                _heightText = value;
                                updateBMI();
                              });
                            },
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.0, letterSpacing: 1.5),
                            decoration: InputDecoration(

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
                                      onChanged: (value) {
                                        updateBMIFromFeetInches();
                                      },
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18.0, letterSpacing: 1.5),
                                      decoration: InputDecoration(

                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.lightBlue),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text('\′',
                                  style: TextStyle(
                                    fontSize: 25.0
                                  ),
                                  ),
                                  SizedBox(width: 20.0),
                                  Expanded(
                                    flex: 1,
                                    child: TextField(
                                      controller: _inchesController,
                                      onChanged: (value) {
                                        updateBMIFromFeetInches();
                                      },
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18.0, letterSpacing: 1.5),
                                      decoration: InputDecoration(

                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.lightBlue),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text('\′\′',
                                  style: TextStyle(
                                  fontSize: 25.0
                                  ),
                                  ),
                                ],
                                                           ),
                              )
                          ),

























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
                          items: <String>['ft', 'cm'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
            
            
            
            
            
                  SizedBox(height: 15),
            




            
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(

                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: Text(
                              'Weight',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _weightController,
                            onChanged: (value) {
                              setState(() {
                                _weightText = value;
                                updateBMI();
                              });
                            },
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.0, letterSpacing: 1.5),
                            decoration: InputDecoration(

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
                          items: <String>['kg', 'lb', 'st'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),



            SizedBox(height: 20.0,),
            
            
            
            
            
                  SfRadialGauge(
                    axes: [
                      RadialAxis(
                        startAngle: 180,
                        endAngle: 0,
                        minimum: 0,
                        maximum: 45,
                        canRotateLabels: true,


                        labelOffset: 65, // Adjust distance between labels and axis line
                        maximumLabels: 3,
                        ranges: [
                          GaugeRange(
                            startWidth: 70,
                            endWidth: 70,
                            startValue: 0,
                            endValue: 15,
                            color: Colors.blueAccent,
            
                            label: 'Underweight',
                            labelStyle: GaugeTextStyle(fontSize: 15, color: Colors.white),
            
                          ),
            
                          GaugeRange(
                            startWidth: 70,
                            endWidth: 70,
                            startValue: 15,
                            endValue: 30,
                            color: Colors.green,
                            label: 'Normal',
                            labelStyle: GaugeTextStyle(fontSize: 15, color: Colors.white),
                          ),
                          GaugeRange(
                            startWidth: 70,
                            endWidth: 70,
                            startValue: 30,
                            endValue: 45,
                            color: Colors.red,
                            label: 'Overweight',
                            labelStyle: GaugeTextStyle(fontSize: 15, color: Colors.white),
                          ),
            
                        ],
                        pointers: [
                          NeedlePointer(
                            value: _bmi,
                            enableAnimation: true,
                            knobStyle: KnobStyle(
                                knobRadius: 0
                            ),
                            needleStartWidth: 1,
                            needleEndWidth: 50,
                            needleLength: 0.7,
                            needleColor: Colors.blue[100],
                            enableDragging: true,
                          ),
                        ],
                        annotations: [
                          GaugeAnnotation(
            
                            widget: Column(
            
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'BMI',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    )
                                ),
                                Text(
                                    '${_bmi.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    )
                                ),
            
                              ],
                            ),
            
                          )
                        ],
                      ),
                    ],
            
                  ),
            

            
            
                ],
              ),
            ),
          ),
        )
    );
  }
}
