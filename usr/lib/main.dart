import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number to Words Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // CRITICAL: initialRoute and routes map must be defined for proper routing
      initialRoute: '/',
      routes: {
        '/': (context) => const NumberToWordScreen(),
      },
    );
  }
}

class NumberToWordScreen extends StatefulWidget {
  const NumberToWordScreen({super.key});

  @override
  State<NumberToWordScreen> createState() => _NumberToWordScreenState();
}

class _NumberToWordScreenState extends State<NumberToWordScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _convertNumber(String value) {
    if (value.isEmpty) {
      setState(() {
        _result = '';
      });
      return;
    }

    try {
      // Parse the string to an integer
      int number = int.parse(value);
      setState(() {
        _result = _numberToWords(number);
      });
    } catch (e) {
      setState(() {
        _result = 'Number is too large or invalid.';
      });
    }
  }

  String _numberToWords(int number) {
    if (number == 0) return "zero";
    if (number < 0) return "minus ${_numberToWords(number.abs())}";

    String words = "";

    if ((number ~/ 1000000000) > 0) {
      words += "${_numberToWords(number ~/ 1000000000)} billion ";
      number %= 1000000000;
    }

    if ((number ~/ 1000000) > 0) {
      words += "${_numberToWords(number ~/ 1000000)} million ";
      number %= 1000000;
    }

    if ((number ~/ 1000) > 0) {
      words += "${_numberToWords(number ~/ 1000)} thousand ";
      number %= 1000;
    }

    if ((number ~/ 100) > 0) {
      words += "${_numberToWords(number ~/ 100)} hundred ";
      number %= 100;
    }

    if (number > 0) {
      if (words != "") words += "and ";

      var unitsMap = [
        "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
        "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
      ];
      var tensMap = ["zero", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"];

      if (number < 20) {
        words += unitsMap[number];
      } else {
        words += tensMap[number ~/ 10];
        if ((number % 10) > 0) {
          words += "-${unitsMap[number % 10]}";
        }
      }
    }

    return words.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number to Words', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter a number to convert it into English words.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(18), // Prevent exceeding 64-bit int limits
                ],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  labelText: 'Numeric Value',
                  hintText: 'e.g. 1234',
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      _convertNumber('');
                    },
                  ),
                ),
                onChanged: _convertNumber,
              ),
              const SizedBox(height: 32),
              const Text(
                'Result:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _result.isEmpty ? 'Start typing to see the words...' : _result,
                      style: TextStyle(
                        fontSize: 28,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        color: _result.isEmpty 
                            ? Colors.black38 
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
