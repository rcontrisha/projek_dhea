import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'currency.dart';

class TimeConverter extends StatefulWidget {
  @override
  _TimeConverterState createState() => _TimeConverterState();
}

class _TimeConverterState extends State<TimeConverter> {
  late DateTime _currentTime;
  DateTime _selectedTime = DateTime.now();
  String _selectedTimeZone = 'UTC';

  String _formatTime(DateTime time, String timeZone) {
    return DateFormat('HH:mm:ss', 'en_US')
        .add_jm()
        .format(time.toUtc())
        .toString() +
        ' $timeZone';
  }

  @override
  void initState() {
    super.initState();
    // Initialize _currentTime and start the timer
    _currentTime = DateTime.now();
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Converter'),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyConverter()),
              );
            },
            icon: Icon(Icons.currency_exchange, size: 28),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 400,
            width: 380,
            child: Card(
              color: Colors.blueAccent[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Waktu UTC:',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _formatTime(_currentTime, 'UTC'),
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedTime =
                                _currentTime.toUtc().add(Duration(hours: 7));
                            _selectedTimeZone = 'WIB';
                          });
                        },
                        child: Text(
                          'WIB',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo[400]!),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedTime =
                                _currentTime.toUtc().add(Duration(hours: 8));
                            _selectedTimeZone = 'WITA';
                          });
                        },
                        child: Text(
                          'WITA',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo[400]!),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedTime =
                                _currentTime.toUtc().add(Duration(hours: 9));
                            _selectedTimeZone = 'WIT';
                          });
                        },
                        child: Text(
                          'WIT',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo[400]!),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Set London time as UTC
                            _selectedTime = _currentTime.toUtc();
                            _selectedTimeZone = 'London';
                          });
                        },
                        child: Text(
                          'London',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo[400]!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Waktu Konversi:',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _formatTime(_selectedTime, _selectedTimeZone),
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
