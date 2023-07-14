import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flip Book'),
        ),
        body: const Center(
          child: BentBook(),
        ),
      ),
    );
  }
}

class BentBook extends StatelessWidget {
  const BentBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.5,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(40 / 180 * pi),
              child: const FlipWidget(),
            ),
          ),
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.5,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(-40 / 180 * pi),
              child: const FlipWidget(),
            ),
          ),
        ),
      ],
    );
  }
}

class FlipWidget extends StatelessWidget {
  const FlipWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.yellow,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(
            'https://images.unsplash.com/photo-1607049582438-65ae840d8dfe?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80',
            // scale: 0.0005,
          ),
        ),
      ),
      child: const Text(
        '123',
        style: TextStyle(
          fontSize: 150,
        ),
      ),
    );
  }
}
