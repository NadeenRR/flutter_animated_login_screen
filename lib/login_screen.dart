import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'animation_enum.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtboard;

  late RiveAnimationController controllerIdel;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookDownLeft;
  late RiveAnimationController controllerlookidle;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String testEmail = "nadeen@gmail.com";
  String testPassword = "24680";
  final passwordFocusNode = FocusNode();

  bool isLookingLeft = false;
  bool isLookingRight = false;

  void removeAllControllers() {
    riveArtboard?.artboard.removeController(controllerIdel);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerLookDownRight);
    riveArtboard?.artboard.removeController(controllerLookDownLeft);
    riveArtboard?.artboard.removeController(controllerlookidle);
    riveArtboard?.artboard.removeController(controllerFail);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerIdel);
    debugPrint("Idel");
  }

  void addHandUpController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsUp);
    debugPrint("Hands Up");
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsDown);
    debugPrint("Hands Down");
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerSuccess);
    debugPrint("Success");
  }

  void addLookDownRightController() {
    removeAllControllers();
    isLookingRight = true;
    riveArtboard?.artboard.addController(controllerLookDownRight);
    debugPrint("Look Down Right");
  }

  void addLookDownleftController() {
    removeAllControllers();
    isLookingLeft = true;
    riveArtboard?.artboard.addController(controllerLookDownLeft);
    debugPrint("Look Down left");
  }

  void addLookDownlookidleController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerlookidle);
    debugPrint("Look Idle");
  }

  void addFailController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerFail);
    debugPrint("Fail");
  }

  void checkForPasswordNodeToChange() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandUpController();
      } else if (!passwordFocusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdel = SimpleAnimation(AnimationEnum.idel.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerLookDownRight =
        SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerLookDownLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerlookidle = SimpleAnimation(AnimationEnum.look_idle.name);

    rootBundle.load('assets/animated_login_character.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      //علشان احدد الحالة الافتراضية اللي بيفتح فيها التطبيق
      artboard.addController(controllerIdel);
      setState(() {
        riveArtboard = artboard;
      });
    });

    checkForPasswordNodeToChange();
  }

  void validateEmailAndPasword() {
    Future.delayed(const Duration(seconds: 1), () {
      if (formKey.currentState!.validate()) {
        addSuccessController();
      } else {
        addFailController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Animated Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 15,
            vertical: MediaQuery.of(context).size.height / 40,
          ),
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: riveArtboard == null
                      ? const SizedBox.shrink()
                      : Rive(artboard: riveArtboard!)),
              SizedBox(
                height: MediaQuery.of(context).size.height / 35,
              ),
              Form(
                key: formKey,
                child: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) =>
                        value != testEmail ? "Wrong Email" : null,
                    onChanged: (value) {
                      if (value.isNotEmpty &&
                          value.length < 15 &&
                          !isLookingLeft) {
                        addLookDownleftController();
                      } else if (value.isNotEmpty &&
                          value.length > 15 &&
                          !isLookingRight) {
                        addLookDownRightController();
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    focusNode: passwordFocusNode,
                    validator: (value) =>
                        value != testPassword ? "Wrong Password" : null,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 8),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        passwordFocusNode.unfocus();
                        validateEmailAndPasword();
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
