import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Candle> candles = [];
  bool themeIsDark = false;

  @override
  void initState() {
    fetch();
    super.initState();
  }

  Future<Candle> fetchCandles() async {
    final uri = Uri.parse("https://www.goldapi.io/api/XAU/USD");
    final res = await http.get(uri, headers: {
      "x-access-token": "goldapi-xqk5prlqvb2tu9-io",
      "Content-Type": "application/json",
    });
    log(res.body);
    return fromGoldApi(jsonDecode(res.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Candlesticks(
          candles: candles,
        ),
      ),
    );
  }

  fetch() async {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      final candle = await fetchCandles();
      setState(() {
        candles.add(candle);
      });
    });
  }
}
//             1704137547500
// "timestamp":1704136846
// "metal":"XAU"
// "currency":"USD"
// "exchange":"FOREXCOM"
// "symbol":"FOREXCOM:XAUUSD"
// "prev_close_price":2065.62
// "open_price":2065.62
// "low_price":2058.29
// "high_price":2074.86
// "open_time":1703808000
// "price":2062.88
// "ch":-2.74
// "chp":-0.13
// "ask":2063.24
// "bid":2062.53
// "price_gram_24k":66.3231
// "price_gram_22k":60.7962
// "price_gram_21k":58.0327
// "price_gram_20k":55.2693
// "price_gram_18k":49.7423
// "price_gram_16k":44.2154
// "price_gram_14k":38.6885
// "price_gram_10k":27.6346

//   Candle({
//   required this.date,
//   required this.high,
//   required this.low,
//   required this.open,
//   required this.close,
//   required this.volume,
// });

Candle fromGoldApi(Map<String, dynamic> json) {
  return Candle(
    date: DateTime.fromMicrosecondsSinceEpoch((int.parse(json['open_time'].toString()) * 100)),
    high: json['high_price'],
    low: json['low_price'],
    open: json['open_price'],
    close: json['price'],
    volume: 5,
  );
}
