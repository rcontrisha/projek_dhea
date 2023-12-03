import 'package:flutter/material.dart';
import 'time.dart';

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {

  TextEditingController amountController = TextEditingController();
  String selectedFromCurrency = 'USD';
  String selectedToCurrency = 'EUR';
  String convertedResult = '';

  Map<String, double> conversionRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'JPY': 110.13,
    'CAD': 1.25,
    'AUD': 1.34,
    'IDR': 14247.50,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Currency Converter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TimeConverter()));
              },
              icon: Icon(Icons.access_time_outlined, color: Colors.white, size: 28,)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Amount',
                        labelStyle: TextStyle(
                          color: Colors.grey[700],
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                      ),
                      cursorColor: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 16.0), // Add spacing between text fields
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: TextField(
                      controller: TextEditingController(text: convertedResult),
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Result',
                        hintStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w200
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                      ),
                      cursorColor: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildCurrencyDropdown(selectedFromCurrency, true),
                Text('to', style: TextStyle(color: Colors.grey[700])),
                buildCurrencyDropdown(selectedToCurrency, false),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.indigoAccent[100]!),
              ),
              onPressed: () {
                convertCurrency();
              },
              child: Text(
                'Convert',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget buildCurrencyDropdown(String selectedValue, bool isFrom) {
    return DropdownButton<String>(
      value: selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          if (isFrom) {
            selectedFromCurrency = newValue!;
          } else {
            selectedToCurrency = newValue!;
          }
        });
      },
      icon: Icon(Icons.arrow_drop_down,
          color: Colors.grey[700]), // Set the color to white
      items: conversionRates.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void convertCurrency() {
    final double amount = double.tryParse(amountController.text) ?? 0.0;

    final double fromRate = conversionRates[selectedFromCurrency] ?? 1.0;
    final double toRate = conversionRates[selectedToCurrency] ?? 1.0;

    final double result = amount * (toRate / fromRate);

    setState(() {
      convertedResult = result.toStringAsFixed(2);
    });
  }
}