import 'package:flutter/material.dart';
import 'package:flutter/services.dart'

void main() {
  runApp(TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(primarySwatch: const Color.fromARGB(255, 2, 73, 131)),
      home: TemperatureConverterScreen(),
    );
  }
}

enum ConversionType { fToC, cToF }

class TemperatureConverterScreen extends StatefulWidget {
  @override
  _TemperatureConverterScreenState createState() => _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState extends State<TemperatureConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  double? _convertedValue;
  ConversionType _selectedConversion = ConversionType.fToC;
  List<String> _conversionHistory = [];

  void _convertTemperature() {
    final input = double.tryParse(_inputController.text);
    if (input == null) return;

    double result;
    String historyEntry;

    if (_selectedConversion == ConversionType.fToC) {
      result = (input - 32) * 5 / 9;
      historyEntry = "F to C: ${input.toStringAsFixed(1)} ➔ ${result.toStringAsFixed(2)}";
    } else {
      result = input * 9 / 5 + 32;
      historyEntry = "C to F: ${input.toStringAsFixed(1)} ➔ ${result.toStringAsFixed(2)}";
    }

    setState(() {
      _convertedValue = double.parse(result.toStringAsFixed(2));
      _conversionHistory.insert(0, historyEntry);
    });
  }

  Widget _buildConverterUI(BoxConstraints constraints) {
    bool isLandscape = constraints.maxWidth > constraints.maxHeight;

    final inputField = Expanded(
      child: TextField(
        controller: _inputController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
        decoration: InputDecoration(
          labelText: 'Enter Temperature',
          border: OutlineInputBorder(),
        ),
      ),
    );

    final outputField = Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.grey.shade200,
        ),
        child: Text(
          _convertedValue?.toStringAsFixed(2) ?? '',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );

    final historyList = Expanded(
      child: ListView.builder(
        itemCount: _conversionHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_conversionHistory[index]),
          );
        },
      ),
    );

    final convertButton = ElevatedButton(
      onPressed: _convertTemperature,
      child: Text('CONVERT'),
    );

    final radioGroup = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Conversion:"),
        RadioListTile<ConversionType>(
          title: Text('Fahrenheit to Celsius'),
          value: ConversionType.fToC,
          groupValue: _selectedConversion,
          onChanged: (value) {
            setState(() => _selectedConversion = value!);
          },
        ),
        RadioListTile<ConversionType>(
          title: Text('Celsius to Fahrenheit'),
          value: ConversionType.cToF,
          groupValue: _selectedConversion,
          onChanged: (value) {
            setState(() => _selectedConversion = value!);
          },
        ),
      ],
    );

    final horizontalFields = Row(
      children: [
        inputField,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('='),
        ),
        outputField,
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLandscape
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Converter', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      radioGroup,
                      SizedBox(height: 16),
                      horizontalFields,
                      SizedBox(height: 16),
                      convertButton,
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Flexible(child: historyList),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Converter', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                radioGroup,
                SizedBox(height: 16),
                horizontalFields,
                SizedBox(height: 16),
                convertButton,
                SizedBox(height: 16),
                Text('History:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                historyList,
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => _buildConverterUI(constraints),
      ),
    );
  }
}
