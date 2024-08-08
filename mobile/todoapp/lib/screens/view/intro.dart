import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:todoapp/auth/login.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 18.0,
      color: Colors.black,
    );

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: bodyStyle,
      titlePadding: EdgeInsets.only(top: 50),
      bodyPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      imagePadding: EdgeInsets.only(top: 20),
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.white, // showDoneButton: true,
      allowImplicitScrolling: true,
      autoScrollDuration: 6500,
      infiniteAutoScroll: true,
      globalHeader: const Align(
        alignment: Alignment.center,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 0, right: 0),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, //! Set the background color to cyan
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Set border radius to zero
            ),
          ),
          child: const Text(
            'هيا بنا لتجربة مختلفة',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Cario',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),

      pages: [
        PageViewModel(
          title: '👋 مرحبا بك',
          body:
              "hello Weclome to Todo App, this app is a simple todo app that allows you to add, edit, delete and view your todos",
          image: Lottie.asset(
            'assets/animation/ppmana.json',
            fit: BoxFit.cover,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'من نحن؟؟',
          body: "اهلا وسهلا",
          image: Lottie.asset(
            'assets/animation/ppmana.json',
            fit: BoxFit.cover,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'مرحبا بك',
          body:
              "رفع الوعي الرقمي وإنشاء مجتمعات تقنية تطوعية تساهم لتحقيق رؤية 2030 , الريادة في التمكين الرقمي المجتمعي",
          image: Lottie.asset(
            'assets/animation/ppmana.json',
            fit: BoxFit.cover,
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(
        Icons.rocket_launch_rounded,
        color: Colors.white,
      ),
      skip: const Text(
        'تخطي',
        style: TextStyle(
            fontFamily: 'Cario',
            fontWeight: FontWeight.w600,
            color: Colors.white),
      ),
      next: const Icon(
        Icons.rocket_launch_rounded,
        color: Colors.white,
      ),
      done: const Text(
        'تم',
        style: TextStyle(
          fontFamily: 'Cario',
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.white,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          side:
              BorderSide(color: Colors.black), // Set the border color to orange
        ),
        activeColor: Colors.white, // Set the active color to orange
      ),

      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          side: BorderSide(
            color: Colors.black,
          ), //حواف
        ),
      ),
    );
  }
}
