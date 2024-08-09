import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget stackBacground() => Stack(
      alignment: Alignment.bottomRight,
      children: [
        Lottie.asset(
          'assets/animation/ppmana.json',
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
        Lottie.asset(
          'assets/animation/p2p.json',
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 30),
            child: const SizedBox(),
          ),
        ),
      ],
    );

class BackgroundImageFb1 extends StatelessWidget {
  final Widget child;
  final String imageUrl;
  const BackgroundImageFb1(
      {required this.child, required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Place as the child widget of a scaffold
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
