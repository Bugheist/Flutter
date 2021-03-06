import 'package:bugheist/providers/authstate_provider.dart';
import 'package:bugheist/routes/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            color: Color(0xFFDC4654),
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height * 0.35,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.125 * size.width,
                      vertical: 0.075 * size.height,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/logo_white.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width,
                  height: size.height * 0.65,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              height: size.height * 0.65,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 50,
                  )
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Center(
                child: LoginForm(
                  size: size,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LoginForm extends ConsumerStatefulWidget {
  final Size size;
  const LoginForm({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  bool showPassword = false;
  bool isShowVisible = false;
  late TextEditingController _userController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  Future<void> login(
    String username,
    String email,
    String password,
    BuildContext parentContext,
  ) async {
    await ref.read(authStateNotifier.notifier).userLogin(
      {
        "username": username,
        "email": email,
        "password": password,
      },
      parentContext,
    );
  }

  buildAuthenticating() {}

  @override
  void initState() {
    super.initState();

    _userController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 0.8 * widget.size.width,
            child: TextFormField(
              controller: _userController,
              decoration: InputDecoration(
                hintText: "Username",
                prefixIcon: Icon(Icons.person),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                fillColor: Colors.white.withOpacity(0.35),
              ),
            ),
          ),
          SizedBox(
            height: 0.025 * widget.size.height,
          ),
          SizedBox(
            width: 0.8 * widget.size.width,
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.mail),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                fillColor: Colors.white.withOpacity(0.35),
              ),
            ),
          ),
          SizedBox(
            height: 0.025 * widget.size.height,
          ),
          SizedBox(
            width: 0.8 * widget.size.width,
            child: TextFormField(
              controller: _passwordController,
              onChanged: (val) {
                if (!val.isEmpty) {
                  setState(() {
                    isShowVisible = true;
                  });
                } else {
                  setState(() {
                    isShowVisible = false;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.key_rounded),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Color(0xFF737373),
                  ),
                ),
                fillColor: Colors.white.withOpacity(0.35),
              ),
              obscureText: !showPassword,
            ),
          ),
          SizedBox(
            height: 0.025 * widget.size.height,
          ),
          SizedBox(
            width: 0.8 * widget.size.width,
            height: 50,
            child: TextButton(
              onPressed: () async {
                await login(
                  _userController.text,
                  _emailController.text,
                  _passwordController.text,
                  context,
                );
              },
              child: Text(
                "Login",
                style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 17.5,
                  ),
                ),
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(8),
                shadowColor: MaterialStateProperty.all(
                  Colors.black.withOpacity(0.5),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  Color(0xFFDC4654),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                RouteManager.forgotPage,
              );
            },
            child: Text("Forgot Password?"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "New User?",
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    RouteManager.signupPage,
                  );
                },
                child: Text("Sign Up"),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
