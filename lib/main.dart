// import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ooriba_s3/firebase_options.dart';
import 'package:ooriba_s3/HR/hr_dashboard_page.dart';
import 'package:ooriba_s3/hr_login_page.dart';
import 'package:ooriba_s3/services/auth_service.dart';
import 'package:ooriba_s3/services/dark_mode.dart';
import 'package:ooriba_s3/signup_page.dart';
import 'package:provider/provider.dart';
// List<CameraDescription>? cameras;
Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  // cameras = await availableCameras();
  runApp( const OoribaApp());
}

class OoribaApp extends StatelessWidget {
  const OoribaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DarkModeService(),
      child: Consumer<DarkModeService>(
        builder: (context, darkModeService, _) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
            title: 'OORIBA_S3',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
            ),
            themeMode: darkModeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: LoginPage(),
          );
        },
      ),
    );
  }

  }
class LoginPage extends StatelessWidget {

  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final darkModeService = Provider.of<DarkModeService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('OORIBA_S3'),
                actions: [
          IconButton(
            icon: Icon(darkModeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              darkModeService.toggleDarkMode();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400, // Limit the width for larger screens
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // ......................................
                        const Text(
                          'Welcome To OORIBA-S3',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: _emailController,
                          decoration:const InputDecoration(
                            filled: true,
                            labelText: 'Email ID',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password functionality
                              Navigator.push(
                              context,
                              //.........................................................................
                              // MaterialPageRoute(builder: (context) =>DatePickerButton()),
                              MaterialPageRoute(builder: (context) =>HRDashboardPage()),
                            //   MaterialPageRoute(builder: (context) =>LLMyHomePage(cameras: cameras!) ),
                            );
                            },
                            child: const Text('Forgot Password'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            await AuthService().signin(
                              email: _emailController.text,
                              password: _passwordController.text,
                              role:"employee",
                              context: context
                            );
                          },
                          child: const Text('Sign In'),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            //..........................................................
                            text: "Don't have an account? ",
                            style:TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                            children: [
                              TextSpan(
                                text: 'Sign Up here',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HRLoginPage()),
                            );
                          },
                          child: const Text('HR sign-in here'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}