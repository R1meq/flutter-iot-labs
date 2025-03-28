import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const MyHomePage(title: 'Test Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _controller = TextEditingController();
  String _message = '';

  void _processInput() {
    final String input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      if (input == 'Avada Kedavra') {
        _counter = 0;
        _message = 'Calculator Reset.';
      } else if (input == 'Robot boy') {
        _counter *= 2;
        _message = 'Value Doubled.';
      } else {
        final int? value = int.tryParse(input);
        if (value != null) {
          _counter += value;
          _message = 'Added $value to your total.';
        } else {
          _message = 'Enter a valid number,'
              ' \'Avada Kedavra\', or \'Robot boy\'!';
        }
      }
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Your total:'),
              Text(
                '$_counter',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter a number or option name',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _processInput(),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _processInput,
                label: const Text('Send'),
              ),
              const SizedBox(height: 10),
              Text(_message, style: const TextStyle(color: Colors.purple)),
              const SizedBox(height: 20),
              const Text('Available Options:',
                style: TextStyle(fontWeight: FontWeight.bold),),
              const Text('- Avada Kedavra: Reset to zero'),
              const Text('- Robot boy: Double current value'),
            ],
          ),
        ),
      ),
    );
  }
}
